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
ashita.ffxi.recast  = ashita.ffxi.recast or { };

-- Scan for patterns..
ashita.ffxi.recast.a_recast_ptr = ashita.memory.findpattern('FFXiMain.dll', 0, '894124E9????????8B46??6A006A00508BCEE8', 0x19, 0);
ashita.ffxi.recast.s_recast_ptr = ashita.memory.findpattern('FFXiMain.dll', 0, '56BE????????66833E00??????????????662906', 0x02, 0);

-- Signature validation..
if (ashita.ffxi.recast.a_recast_ptr == 0 or ashita.ffxi.recast.s_recast_ptr == 0) then
    print(string.format('A Pointer: %08X', ashita.ffxi.recast.a_recast_ptr));
    print(string.format('S Pointer: %08X', ashita.ffxi.recast.s_recast_ptr));
    error('recast.lua -- signature validation failed!');
end

ashita.ffxi.recast.a_recast_ptr = ashita.memory.read_uint32(ashita.ffxi.recast.a_recast_ptr);
ashita.ffxi.recast.s_recast_ptr = ashita.memory.read_uint32(ashita.ffxi.recast.s_recast_ptr);

----------------------------------------------------------------------------------------------------
-- func: get_ability_ids
-- desc: Returns a table containing the current ability recast ids.
----------------------------------------------------------------------------------------------------
local function get_ability_ids()
    local t = { };
    for x = 0, 31 do
        t[x + 1] = ashita.memory.read_uint8(ashita.ffxi.recast.a_recast_ptr + (x * 8) + 3);
    end
    return t;
end 
ashita.ffxi.recast.get_ability_ids = get_ability_ids;

----------------------------------------------------------------------------------------------------
-- func: get_ability_id_from_index
-- desc: Returns the ability id at the given index in the recast id list.
----------------------------------------------------------------------------------------------------
local function get_ability_id_from_index(index)
    return ashita.memory.read_uint8(ashita.ffxi.recast.a_recast_ptr + (index * 8) + 3);
end
ashita.ffxi.recast.get_ability_id_from_index = get_ability_id_from_index;

----------------------------------------------------------------------------------------------------
-- func: get_ability_recast_by_index
-- desc: Returns the raw recast timer for the ability at the given index.
----------------------------------------------------------------------------------------------------
local function get_ability_recast_by_index(index)
    return ashita.memory.read_uint32(ashita.ffxi.recast.a_recast_ptr + (index * 4) + 0xF8);
end
ashita.ffxi.recast.get_ability_recast_by_index = get_ability_recast_by_index;

----------------------------------------------------------------------------------------------------
-- func: get_ability_recast_by_id
-- desc: Returns the raw recast timer for the ability of the given id.
----------------------------------------------------------------------------------------------------
local function get_ability_recast_by_id(id)
    local ids = get_ability_ids();
    for k, v in pairs(ids) do
        if (v == id) then
            return get_ability_recast_by_index(k - 1);
        end
    end
    return -1;
end
ashita.ffxi.recast.get_ability_recast_by_id = get_ability_recast_by_id;

----------------------------------------------------------------------------------------------------
-- func: get_spell_recast_by_index
-- desc: Returns the raw recast timer for the spell at the given index.
----------------------------------------------------------------------------------------------------
local function get_spell_recast_by_index(index)
    return ashita.memory.read_uint16(ashita.ffxi.recast.s_recast_ptr + (index * 2));
end
ashita.ffxi.recast.get_spell_recast_by_index = get_spell_recast_by_index;

----------------------------------------------------------------------------------------------------
-- func: format_timestamp
-- desc: Formats a recast timer into a hh:mm:ss timestamp.
----------------------------------------------------------------------------------------------------
local function format_timestamp(timer)
    local t = timer / 60;
    local h = math.floor(t / (60 * 60));
    local m = math.floor(t / 60 - h * 60);
    local s = math.floor(t - (m + h * 60) * 60);
    return string.format('%02i:%02i:%02i', h, m, s);
end
ashita.ffxi.recast.format_timestamp = format_timestamp;