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

_addon.author   = 'atom0s';
_addon.name     = 'lotomatic';
_addon.version  = '3.0.0';

require 'common'
require 'profiles'

---------------------------------------------------------------------------------------------------
-- desc: Main Lotomatic table.
---------------------------------------------------------------------------------------------------
local Lotomatic =
{
    -- Main enabled flag..
    enabled     = false,
    
    -- Debug mode..
    debug_mode  = false,
    
    -- Force-modes..
    loot_all    = false,
    pass_all    = false,
    
    -- Auto sorting..
    auto_sort   = true,
    last_sort   = os.clock(),
    
    -- Default rules..
    rules       = { loot = { }, pass = { } }
};

---------------------------------------------------------------------------------------------------
-- func: bool_to_string
-- desc: Converts a boolean to an enabled/disabled string.
---------------------------------------------------------------------------------------------------
local function bool_to_string(b)
    if (b == true or b == 1 or b == 'true') then
        return 'Enabled';
    else
        return 'Disabled';
    end
end

---------------------------------------------------------------------------------------------------
-- func: load
-- desc: First called when our addon is loaded.
---------------------------------------------------------------------------------------------------
ashita.register_event('load', function()
end );

---------------------------------------------------------------------------------------------------
-- func: Command
-- desc: Called when our addon receives a command.
---------------------------------------------------------------------------------------------------
ashita.register_event('command', function(cmd, nType)
    -- Ensure we should handle this command..
    local args = cmd:args();
    if (#args <= 1 or args[1] ~= '/lotomatic') then
        return false;
    end
    
    -- User wants to enable or disable Lotomatic..
    if (#args >= 2 and args[2] == 'on' or args[2] == 'off') then
        if (args[2] == 'on') then
            Lotomatic.enabled = true;
        else
            Lotomatic.enabled = false;
        end
        print(string.format('[Lotomatic] Lotomatic is now: %s', bool_to_string(Lotomatic.enabled)));
    end
    
    -- User wants to turn on or off loot-all mode..
    if (#args >= 2 and args[2] == 'lootall') then
        if (#args >= 3) then
            Lotomatic.loot_all = (args[3] == 'true' or args[3] == '1');
        else
            Lotomatic.loot_all = not Lotomatic.loot_all;
        end
        
        -- Disable passall mode..
        if (Lotomatic.loot_all == true) then
            Lotomatic.pass_all = false;
        end
        print(string.format('[Lotomatic] Loot-all is now: %s', bool_to_string(Lotomatic.loot_all)));
        return true;
    end
    
    -- User wants to turn on or off pass-all mode..
    if (#args >= 2 and args[2] == 'passall') then
        if (#args >= 3) then
            Lotomatic.pass_all = (args[3] == 'true' or args[3] == '1');
        else
            Lotomatic.pass_all = not Lotomatic.pass_all;
        end
        
        -- Disable loot_all mode..
        if (Lotomatic.pass_all == true) then
            Lotomatic.loot_all = false;
        end
        print(string.format('[Lotomatic] Pass-all is now: %s', bool_to_string(Lotomatic.pass_all)));
        return true;
    end
    
    -- User wants to turn on or off auto-sorting..
    if (#args >= 2 and args[2] == 'sort') then
        if (#args >= 3) then
            Lotomatic.auto_sort = (args[3] == 'true' or args[3] == '1');
        else
            Lotomatic.auto_sort = not Lotomatic.auto_sort;
        end
        print(string.format('[Lotomatic] Auto-sorting is now: %s', bool_to_string(Lotomatic.auto_sort)));
        return true;
    end
    
    -- User wants to loot all items currently in the pool..
    if (#args >= 2 and args[2] == 'loot') then
        for x = 0, 9 do
            local lootItem = struct.pack("bbbbbbb", 0x41, 0x04, 0x00, 0x00, x, 0x00, 0x00, 0x00):totable();
            AddOutgoingPacket(0x41, lootItem);
        end
        return true;
    end
    
    -- User wants to pass all items currently in the pool..
    if (#args >= 2 and args[2] == 'pass') then
        for x = 0, 9 do
            local passItem = struct.pack("bbbbbbb", 0x42, 0x04, 0x00, 0x00, x, 0x00, 0x00, 0x00):totable();
            AddOutgoingPacket(0x42, passItem);
        end
        return true;
    end
    
    -- User wants to load a profile..
    if (#args >= 3 and args[2] == 'profile') then
        if (args[3] == nil or #args[3] == 0) then
            print('[Lotomatic] Invalid profile name given.');
            return true;
        end
        
        -- Ensure the profile exists..
        if (not ashita.file.file_exists(_addon.path .. '\\profiles\\' .. args[3] .. '.xml')) then
            print('[Lotomatic] Invalid profile name given. File not found!');
            return true;
        end
        
        -- Attempt to load the profile..
        local ret, rules = load_profile(_addon.path .. '\\profiles\\' .. args[3] .. '.xml');
        if (ret == true) then
            print(string.format('[Lotomatic] Loaded profile: \'%s\'!', args[3]));
        else
            print(string.format('[Lotomatic] Failed to load profile: \'%s\'!', args[3]));
        end
        Lotomatic.rules = rules;
        return true;
    end
    
    -- User wants to enable or disable debug mode..
    if (#args >= 2 and args[2] == 'debug' or args[2] == 'verbose') then
        Lotomatic.debug_mode = not Lotomatic.debug_mode;
        print(string.format('[Lotomatic] Debug mode is now: %s', bool_to_string(Lotomatic.debug_mode)));
        return true;
    end
    
    return true;
end );

---------------------------------------------------------------------------------------------------
-- func: incoming_packet
-- desc: Called when our addon receives an incoming packet.
---------------------------------------------------------------------------------------------------
ashita.register_event('incoming_packet', function(id, size, packet)
    -- Do nothing if we are not enabled..
    if (Lotomatic.enabled == false) then
        return false;
    end

    -----------------------------------------------------------------------------------------------
    -- Handles incoming treasure pool packets.
    -- 0x10 = item id
    -- 0x14 = item slot
    -----------------------------------------------------------------------------------------------
    if (id == 0x00D2) then
        local itemId    = struct.unpack('h', packet, 0x10 + 1);
        local itemSlot  = struct.unpack('b', packet, 0x14 + 1);
        
        -- Debug mode print-out..
        if (Lotomatic.debug_mode == true) then
            print(string.format('[Lotomatic] Incoming treasure packet, slot: %02d -- item: %d', itemSlot, itemId));
        end
        
        -- Do we want to auto-loot everything..
        if (Lotomatic.loot_all == true) then
            local lootItem = struct.pack("bbbbbbb", 0x41, 0x04, 0x00, 0x00, itemSlot, 0x00, 0x00, 0x00):totable();
            AddOutgoingPacket(0x41, lootItem);
            return false;
        end
        
        -- Do we want to auto-pass everything..
        if (Lotomatic.pass_all == true) then
            local passItem = struct.pack("bbbbbbb", 0x42, 0x04, 0x00, 0x00, itemSlot, 0x00, 0x00, 0x00):totable();
            AddOutgoingPacket(0x42, passItem);
            return false;
        end
        
        -- Attempt to find a rule for this item..
        for k, v in pairs(Lotomatic.rules.loot) do
            if (v == itemId) then
                local lootItem = struct.pack("bbbbbbb", 0x41, 0x04, 0x00, 0x00, itemSlot, 0x00, 0x00, 0x00):totable();
                AddOutgoingPacket(0x41, lootItem);
                if (Lotomatic.debug_mode == true) then
                    print(string.format('[Lotomatic] Attempted to loot item: %d', itemId));
                end
                return false;
            end
        end
        for k, v in pairs(Lotomatic.rules.pass) do
            if (v == itemId) then
                local passItem = struct.pack("bbbbbbb", 0x42, 0x04, 0x00, 0x00, itemSlot, 0x00, 0x00, 0x00):totable();
                AddOutgoingPacket(0x42, passItem);
                if (Lotomatic.debug_mode == true) then
                    print(string.format('[Lotomatic] Attempted to pass item: %d', itemId));
                end
                return false;
            end
        end
        
        -- Debug print if no rule was found..
        if (Lotomatic.debug_mode == true) then
            print(string.format('[Lotomatic] No rule found for slot: %02d -- item: %d', itemSlot, itemId));
        end
        return false;
    end

    -----------------------------------------------------------------------------------------------
    -- Handles sending the auto-sort packet on desired packets..
    -- Note: This is DSP friendly. It is only sent every 5 seconds, and only if one of the below
    --       packets were obtained. This can almost never trigger if you are doing nothing. :)
    --
    -- 29 = Inventory finish downloading / update.
    -- 30 = Inventory modified.
    -- 31 = Inventory assigned.
    -- 32 = Inventroy update.
    -----------------------------------------------------------------------------------------------
    if ((Lotomatic.auto_sort == true) and id == 29 or id == 30 or id == 31 or id == 32) then
        if (Lotomatic.last_sort <= (os.clock() - 8)) then
            -- Send the auto-sort packet..
            local autosort = struct.pack("bbbbbbb", 0x3A, 0x08, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00):totable();
            AddOutgoingPacket(0x3A, autosort);
            
            -- Store the current time..
            Lotomatic.last_sort = os.clock();

            -- Debug mode print-out..
            if (Lotomatic.debug_mode == true) then
                print('[Lotomatic] Sent auto-sort packet.');
            end
        end
    end
    return false;
end );
