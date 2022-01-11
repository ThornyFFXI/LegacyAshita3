--[[
* Ashita - Copyright (c) 2014 - 2017 atom0s [atom0s@live.com]
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

ashita              = ashita or { };
ashita.ffxi         = ashita.ffxi or { };
ashita.ffxi.targets = ashita.ffxi.targets or { };

-- Scan for patterns..
ashita.ffxi.targets.pointers = { };
ashita.ffxi.targets.pointers =
{
    ['lastst'] =
    {
        pointer = ashita.memory.findpattern('FFXiMain.dll', 0, 'A1????????BF????????8B??B9', 0, 0),
        offset1 = 0x01
    },
    ['scan'] =
    {
        pointer = ashita.memory.findpattern('FFXiMain.dll', 0, 'A1????????85C074??F7', 0, 0),
        offset1 = 0x01,
        offset2 = 0x350E4
    },
    ['r'] =
    {
        pointer = ashita.memory.findpattern('FFXiMain.dll', 0, '8B0D????????85C9750333C0C36A00', 0, 0),
        offset1 = 0x02,
        offset2 = 0x011E
    }
};

----------------------------------------------------------------------------------------------------
-- func: get_target_lastst
-- desc: Returns the <lastst> target.
----------------------------------------------------------------------------------------------------
local function get_target_lastst()
    local lastst = ashita.ffxi.targets.pointers.lastst;

    -- Ensure the pointer is valid..
    if (lastst.pointer == 0) then
        return nil;
    end

    -- Read the target pointer..
    local pointer = ashita.memory.read_uint32(lastst.pointer + lastst.offset1);
    if (pointer == 0) then return nil; end

    -- Read the pointer..
    pointer = ashita.memory.read_uint32(pointer);
    if (pointer == 0) then return nil; end

    -- Read the entity index..
    return ashita.memory.read_uint32(pointer + 0xB8);
end
ashita.ffxi.targets.get_target_lastst = get_target_lastst;

----------------------------------------------------------------------------------------------------
-- func: get_target_bt
-- desc: Returns the <bt> target.
----------------------------------------------------------------------------------------------------
local function get_target_bt()
    -- Obtain the local player..
    local player = GetPlayerEntity();
    if (player == nil) then
        return nil;
    end

    -- Obtain the players server id..
    local serverId = player.ServerId;
    for x = 0, 2303 do
        local entity = GetEntity(x);
        if (entity ~= nil and entity.WarpPointer ~= 0 and entity.ClaimServerId == serverId) then
            if (entity.StatusServer ~= 2 and entity.StatusServer ~= 3) then
                return entity;
            end
        end
    end
    return nil;
end
ashita.ffxi.targets.get_target_bt = get_target_bt;

----------------------------------------------------------------------------------------------------
-- func: get_target_bt
-- desc: Returns the <bt> target.
----------------------------------------------------------------------------------------------------
local function get_target_pet()
    -- Obtain the local player..
    local player = GetPlayerEntity();
    if (player == nil) then
        return nil;
    end

    -- Ensure the players pet index is valid.. 
    if (player.PetTargetIndex == 0) then
        return nil;
    end

    -- Return the pet entity..
    return GetEntity(player.PetTargetIndex);
end
ashita.ffxi.targets.get_target_pet = get_target_pet;

----------------------------------------------------------------------------------------------------
-- func: get_target_scan
-- desc: Returns the <scan> target.
----------------------------------------------------------------------------------------------------
local function get_target_scan()
    local scan = ashita.ffxi.targets.pointers.scan;

    -- Ensure the pointer is valid..
    if (scan.pointer == 0) then
        return nil;
    end

    -- Read the pointer..
    local pointer = ashita.memory.read_uint32(scan.pointer + scan.offset1);
    if (pointer == 0) then return nil; end

    -- Read the pointer..
    pointer = ashita.memory.read_uint32(pointer);
    if (pointer == 0) then return nil; end

    -- Validate the scan target is set..
    pointer = pointer + scan.offset2;
    if (ashita.memory.read_uint32(pointer) ~= 1) then
        return nil;
    end

    -- Read the entity index..
    return GetEntity(bit.band(ashita.memory.read_uint32(pointer + 0x10), 0xFFFF));
end
ashita.ffxi.targets.get_target_scan = get_target_scan;

----------------------------------------------------------------------------------------------------
-- func: get_target_ht
-- desc: Returns the <ht> target.
----------------------------------------------------------------------------------------------------
local function get_target_ht()
    local e = nil;

    for x = 0, 2303 do
        local entity = GetEntity(x);
        if (entity ~= nil and entity.WarpPointer ~= 0 and entity.StatusServer ~= 2 and entity.StatusServer ~= 3) then
            if (bit.band(bit.rshift(entity.Render.Flags0, 5), 1) == 1) then
                if (bit.band(bit.rshift(entity.Render.Flags1, 16), 1) == 1) then
                    if (e == nil) then
                        e = entity;
                    else
                        if (math.sqrt(entity.Distance) < math.sqrt(e.Distance)) then
                            e = entity;
                        end
                    end 
                end
            end
        end
    end

    return e;
end
ashita.ffxi.targets.get_target_ht = get_target_ht;

----------------------------------------------------------------------------------------------------
-- func: get_target_ft
-- desc: Returns the <ft> target.
----------------------------------------------------------------------------------------------------
local function get_target_ft()
    -- Validate the entity map pointer..
    local entity_map = AshitaCore:GetPointerManager():GetPointer('entitymap');
    if (entity_map == 0) then
        return nil;
    end

    -- Locate the player pointer..
    local player = ashita.memory.read_uint32(ashita.memory.read_uint32(entity_map) + (4 * GetPlayerEntity().TargetIndex));

    -- Read the follower index..
    local follower = ashita.memory.read_uint16(player + 0x264);
    if (follower == 0) then
        return nil;
    end

    -- Return the follower entity..
    return GetEntity(follower);
end
ashita.ffxi.targets.get_target_ft = get_target_ft;

----------------------------------------------------------------------------------------------------
-- func: get_target_normal
-- desc: Returns the <t> target.
----------------------------------------------------------------------------------------------------
local function get_target_normal()
    return GetEntity(AshitaCore:GetDataManager():GetTarget():GetTargetIndex());
end
ashita.ffxi.targets.get_target_normal = get_target_normal;

----------------------------------------------------------------------------------------------------
-- func: get_target_r
-- desc: Returns the <r> target.
----------------------------------------------------------------------------------------------------
local function get_target_r()
    local rtarget = ashita.ffxi.targets.pointers.r;

    -- Ensure the pointer is valid..
    if (rtarget.pointer == 0) then
        return nil;
    end

    -- Read the pointer..
    local pointer = ashita.memory.read_uint32(rtarget.pointer + rtarget.offset1);
    if (pointer == 0) then print('no1');return nil; end

    -- Read the pointer..
    pointer = ashita.memory.read_uint32(pointer);
    if (pointer == 0) then print('no2');return nil; end

    -- Offset the pointer..
    pointer = pointer + rtarget.offset2;

    -- Read the response target name..
    local name = ashita.memory.read_string(pointer, 30);
    if (name == nil or #name == 0) then
        return nil;
    end

    -- Locate the matching entity..
    for x = 0, 2303 do
        local ent = GetEntity(x);
        if (ent ~= nil and ent.Name == name) then
            return ent;
        end
    end
    return nil;
end
ashita.ffxi.targets.get_target_r = get_target_r;

----------------------------------------------------------------------------------------------------
-- func: get_target
-- desc: Returns the desired target by its short-hand tag.
----------------------------------------------------------------------------------------------------
local function get_target(name)
    -- Convert to lower name..
    name = string.lower(name);

    -- Return the desired target..
    return switch(name) : caseof
    {
        ['lastst']  = function() return get_target_lastst(); end,
        ['bt']      = function() return get_target_bt(); end,
        ['me']      = function() return GetPlayerEntity(); end,
        ['pet']     = function() return get_target_pet(); end,
        ['scan']    = function() return get_target_scan(); end,
        ['ht']      = function() return get_target_ht(); end,
        ['ft']      = function() return get_target_ft(); end,
        ['t']       = function() return get_target_normal(); end,
        ['r']       = function() return get_target_r(); end,
        ['default'] = function() return nil; end,
    };
end
ashita.ffxi.targets.get_target = get_target;

----------------------------------------------------------------------------------------------------
-- func: get_last_teller_name
-- desc: Returns the name of the last person to send the player a whisper.
----------------------------------------------------------------------------------------------------
local function get_last_teller_name()
    local rtarget = ashita.ffxi.targets.pointers.r;

    -- Ensure the pointer is valid..
    if (rtarget.pointer == 0) then
        return nil;
    end

    -- Read the pointer..
    local pointer = ashita.memory.read_uint32(rtarget.pointer + rtarget.offset1);
    if (pointer == 0) then print('no1');return nil; end

    -- Read the pointer..
    pointer = ashita.memory.read_uint32(pointer);
    if (pointer == 0) then print('no2');return nil; end

    -- Offset the pointer..
    pointer = pointer + rtarget.offset2;

    -- Read the response target name..
    return ashita.memory.read_string(pointer, 30);
end
ashita.ffxi.targets.get_last_teller_name = get_last_teller_name;