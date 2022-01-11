--[[
* Ashita - Copyright (c) 2014 - 2016 atom0s [atom0s@live.com]
*
* This work is licensed under the Creative Commons Attribution-NonCommercial-NoDerivatives 4.0 International License.
* To view a copy of this license, visit http://creativecommons.org/licenses/by-nc-nd/4.0/ or send a letter to
* Creative Commons, PO Box 1866, Mountain View, CA 94042, USA.
*
* By using Ashita, you agree to the above license and its terms.
*
*      Attribution - You must give appropriate credit, provide a link to the license and indicate if changes were
*                    made. You must do so in any reasonable manner, but not in any way that suggests the licensor
*                    endorses you or your use.
*
*   Non-Commercial - You may not use the material (Ashita) for commercial purposes.
*
*   No-Derivatives - If you remix, transform, or build upon the material (Ashita), you may not distribute the
*                    modified material. You are, however, allowed to submit the modified works back to the original
*                    Ashita project in attempt to have it added to the original project.
*
* You may not apply legal terms or technological measures that legally restrict others
* from doing anything the license permits.
*
* No warranties are given.
]]--

----------------------------------------------------------------------------------------------------
-- Variables
----------------------------------------------------------------------------------------------------
local bluemage          = {};   -- The overall table this library uses.
bluemage.queue          = {};   -- The queue to handle events this library does.
bluemage.delay          = 0.65; -- The delay to prevent spamming packets.
bluemage.timer          = 0;    -- The current time used for delaying packets.
bluemage.mem            = {};   -- The table holding memory specific data.
bluemage.mem.offset1    = 0;    -- The value for the current set blue spells.
bluemage.mem.offset2    = 0;    -- The memory location for the current blue magic point info.

----------------------------------------------------------------------------------------------------
-- func: msg
-- desc: Prints out a message with the addon tag at the front.
----------------------------------------------------------------------------------------------------
function msg(s)
    local txt = '\31\200[\31\05' .. _addon.name .. '\31\200]\31\130 ' .. s;
    print(txt);
end

----------------------------------------------------------------------------------------------------
-- func: err
-- desc: Prints out an error message with the addon tag at the front.
----------------------------------------------------------------------------------------------------
function err(s)
    local txt = '\31\200[\31\05' .. _addon.name .. '\31\200]\31\39 ' .. s;
    print(txt);
end

----------------------------------------------------------------------------------------------------
-- func: initialize
-- desc: Prepares this library for usage.
----------------------------------------------------------------------------------------------------
function bluemage.initialize()
    -- Locate the pointers needed for this library..
    local pointer1 = ashita.memory.findpattern('FFXiMain.dll', 0, 'C1E1032BC8B0018D????????????B9????????F3A55F5E5B', 10, 0);
    local pointer2 = ashita.memory.findpattern('FFXiMain.dll', 0, 'A1????????33C98A4E5E33D28A565D5F5E8950148948185B83C414C20400', 1, 0);

    -- Ensure the patterns were found..
    if (pointer1 == 0 or pointer2 == 0) then
        err('Failed to locate required pattern(s).');
        return false;
    end
    
    -- Read the first pointers value..
    local offset1 = ashita.memory.read_uint32(pointer1);
    if (offset1 == 0) then
        err('Failed to read required pointer value. (1)');
        return false;
    end
    
    -- Read the first pointers value..
    local offset2 = ashita.memory.read_uint32(pointer2);
    if (offset2 == 0) then
        err('Failed to read required pointer value. (2)');
        return false;
    end

    -- Store the values..
    bluemage.mem.offset1 = offset1;
    bluemage.mem.offset2 = offset2;
end

----------------------------------------------------------------------------------------------------
-- func: is_blue_main
-- desc: Determines if the players main job is blue mage.
----------------------------------------------------------------------------------------------------
function bluemage.is_blue_main()
    return (AshitaCore:GetDataManager():GetPlayer():GetMainJob() == 16);
end

----------------------------------------------------------------------------------------------------
-- func: is_blue_sub
-- desc: Determines if the players sub job is blue mage.
----------------------------------------------------------------------------------------------------
function bluemage.is_blue_sub()
    return (AshitaCore:GetDataManager():GetPlayer():GetSubJob() == 16);
end

----------------------------------------------------------------------------------------------------
-- func: get_spent_points
-- desc: Obtains the current spent blue magic points.
----------------------------------------------------------------------------------------------------
function bluemage.get_spent_points()
    -- Determine if the blue points offset is valid..
    if (bluemage.mem.offset2 == 0) then
        err('Cannot read blue spell points; pointer is invalid.');
        return -1;
    end

    -- Read the pointer..
    local pointer = ashita.memory.read_uint32(bluemage.mem.offset2);
    if (pointer == 0) then
        return -1;
    end

    -- Return the spent count..
    return ashita.memory.read_uint8(pointer + 0x14);
end

----------------------------------------------------------------------------------------------------
-- func: get_max_points
-- desc: Obtains the max available blue magic points.
----------------------------------------------------------------------------------------------------
function bluemage.get_max_points()
    -- Determine if the blue points offset is valid..
    if (bluemage.mem.offset2 == 0) then
        err('Cannot read blue spell points; pointer is invalid.');
        return -1;
    end

    -- Read the pointer..
    local pointer = ashita.memory.read_uint32(bluemage.mem.offset2);
    if (pointer == 0) then
        return -1;
    end

    -- Return the spent count..
    return mem.ashita.memory.read_uint8(pointer + 0x18);
end

----------------------------------------------------------------------------------------------------
-- func: get_spells
-- desc: Obtains the current blue mage spells that are set.
----------------------------------------------------------------------------------------------------
function bluemage.get_spells()
    local spells = {};
    local offset = 0x04;

    -- Determine if the blue spell offset is valid..
    if (bluemage.mem.offset1 == 0) then
        err('Cannot read blue spells; pointer is invalid.');
        return {};
    end

    -- Offset shifts 0xA0 if player is subbed blue..
    if (bluemage.is_blue_sub()) then
        offset = 0xA0;
    end

    -- Read the inventory pointer..    
    local pointer = ashita.memory.read_uint32(AshitaCore:GetPointerManager():GetPointer('inventory'));
    if (pointer == 0) then
        return {};
    end

    -- Read the inventory pointer..
    pointer = ashita.memory.read_uint32(pointer);
    if (pointer == 0) then
        return {};
    end

    -- Read the spell data..
    return ashita.memory.read_array((pointer + bluemage.mem.offset1) + offset, 0x14);
end

----------------------------------------------------------------------------------------------------
-- func: get_spell_names
-- desc: Obtains the current blue mage spells that are set. (Names)
----------------------------------------------------------------------------------------------------
function bluemage.get_spell_names()
    -- Obtain the current spell list..
    local spells = bluemage.get_spells();
    if (spells == nil or #spells == 0) then
        return {};
    end

    -- Loop the spells and obtain their names..
    local names = {};
    for k, v in pairs(spells) do
        -- Obtain only valid set spells..
        if (v ~= 0) then
            -- Obtain the spell..
            local spell = AshitaCore:GetResourceManager():GetSpellById(v + 512);
            if (spell == nil) then
                err(string.format('Failed to obtain spell name for spell id: %d', v + 512));
            else
                table.insert(names, spell.Name[0]);
            end
        end
    end

    return names;
end

----------------------------------------------------------------------------------------------------
-- func: reset_all_spells
-- desc: Resets all current set spells to nothing.
----------------------------------------------------------------------------------------------------
function bluemage.reset_all_spells()
    -- Obtain the current spells..
    local spells = bluemage.get_spells();
    if (spells == nil or #spells == 0) then
        return;
    end

    -- Prepare some packet variables..
    local isSubBlu = 0;
    if (bluemage.is_blue_sub() == 16) then
        isSubBlu = 1;
    end

    -- Build the packet..
    local packet = string.char(0x02, 0x53, 0x00, 0x00) .. string.char(0x00, 0x00, 0x00, 0x00, 0x10, isSubBlu, 0x00, 0x00);
    for x = 1, 20 do
        packet = packet .. string.char(spells[x]);
    end
    packet = packet .. string.rep(string.char(0x00), 0x84);
    packet = packet:totable();

    -- Add the packet to our queue..
    table.insert(bluemage.queue, { 0x102, packet });
end

----------------------------------------------------------------------------------------------------
-- func: set_spell
-- desc: Sets a blue mage spell. (Or removes one if the id is 0.)
----------------------------------------------------------------------------------------------------
function bluemage.set_spell(id, index)
    -- Determine if the blue spell offset is valid..
    if (bluemage.mem.offset1 == 0) then
        err('Cannot set blue spell; pointer is invalid.');
        return false;
    end

    -- Obtain the current spells..
    local spells = bluemage.get_spells();
    if (spells == nil or #spells == 0) then
        return false;
    end

    -- If the id is 0, we want to remove the spell in the given slot..
    if (id == 0) then
        -- Obtain the current spell at the given index..
        local spell = spells[index];
        if (spell == nil or spell == 0) then
            return true;
        end

        -- Prepare some packet variables..
        local isSubBlu = 0;
        if (bluemage.is_blue_sub() == true) then
            isSubBlu = 1;
        end

        -- Build the packet..
        local packet = string.char(0x02, 0x53, 0x00, 0x00) .. string.char(0x00, 0x00, 0x00, 0x00, 0x10, isSubBlu, 0x00, 0x00);
        packet = packet .. string.rep(string.char(0x00), index - 1) .. string.char(spell);
        packet = packet .. string.rep(string.char(0x00), 0x98 - index);
        packet = packet:totable();

        -- Add the packet to our queue..
        table.insert(bluemage.queue, { 0x102, packet });
    else
        -- Calculate the spell id..
        local spell = id - 512;
        if (spell < 0) then
            err(string.format('Cannot set blue spell; invalid spell id given. (%d)', spell));
            return false;
        end

        -- Prepare some packet variables..
        local isSubBlu = 0;
        if (bluemage.is_blue_sub() == true) then
            isSubBlu = 1;
        end

        -- Build the packet..
        local packet = string.char(0x02, 0x53, 0x00, 0x00) .. string.char(spell, 0x00, 0x00, 0x00, 0x10, isSubBlu, 0x00, 0x00);
        packet = packet .. string.rep(string.char(0x00), index - 1) .. string.char(spell);
        packet = packet .. string.rep(string.char(0x00), 0x98 - index);
        packet = packet:totable();

        -- Add the packet to our queue..
        table.insert(bluemage.queue, { 0x102, packet });
    end
end

----------------------------------------------------------------------------------------------------
-- func: set_spell_by_name
-- desc: Sets a blue mage spell by name. (Or removes one if the name is empty.)
----------------------------------------------------------------------------------------------------
function bluemage.set_spell_by_name(name, index)
    -- Remove the spell if the name is null or empty..
    if (name == nil or name == '') then
        return bluemage.set_spell(0, index);
    end

    -- Obtain the spells information by its name..
    local spell = AshitaCore:GetResourceManager():GetSpellByName(name, 0);
    if (spell == nil) then
        err('Failed to obtain spell information for spell: ' .. name);
        return;
    end

    -- Ensure this is a blue mage spell..
    if (spell.Index < 512 or spell.Index > 1024) then
        err('Failed to set spell: ' .. name .. ' - Spell is invalid or not a blue mage spell.');
        return;
    end

    -- Set the spell..
    bluemage.set_spell(spell.Index, index);
end

----------------------------------------------------------------------------------------------------
-- func: process_queue
-- desc: Processes the packet queue to be sent.
----------------------------------------------------------------------------------------------------
function bluemage.process_queue()
    if  (os.time() >= (bluemage.timer + bluemage.delay)) then
        bluemage.timer = os.time();

        -- Ensure the queue has something to process..
        if (#bluemage.queue > 0) then
            -- Obtain the first queue entry..
            local data = table.remove(bluemage.queue, 1);

            -- Send the queued object..
            AddOutgoingPacket(data[1], data[2]);
        end
    end
end

----------------------------------------------------------------------------------------------------
-- Returns the blue mage table.
----------------------------------------------------------------------------------------------------
return bluemage;