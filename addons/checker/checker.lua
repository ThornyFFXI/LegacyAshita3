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

_addon.author   = 'atom0s & Lolwutt';
_addon.name     = 'Checker';
_addon.version  = '3.0.0';

require 'common'

---------------------------------------------------------------------------------------------------
-- Check Condition Table
---------------------------------------------------------------------------------------------------
local conditions =
{
    { 0xAA, '\31\200(\31\130High Evasion, High Defense\31\200)'},
    { 0xAB, '\31\200(\31\130High Evasion\31\200)' },
    { 0xAC, '\31\200(\31\130High Evasion, Low Defense\31\200)' },
    { 0xAD, '\31\200(\31\130High Defense\31\200)' },
    { 0xAE, '' },
    { 0xAF, '\31\200(\31\130Low Defense\31\200)' },
    { 0xB0, '\31\200(\31\130Low Evasion, High Defense\31\200)' },
    { 0xB1, '\31\200(\31\130Low Evasion\31\200)' },
    { 0xB2, '\31\200(\31\130Low Evasion, Low Defense\31\200)' },
};

---------------------------------------------------------------------------------------------------
-- Check Type Table
---------------------------------------------------------------------------------------------------
local checktype = 
{
    { 0x40, '\30\02too weak to be worthwhile' },
    { 0x41, '\30\02like incredibly easy prey' },
    { 0x42, '\30\02like easy prey' },
    { 0x43, '\30\102like a decent challenge' },
    { 0x44, '\30\08like an even match' },
    { 0x45, '\30\68tough' },
    { 0x46, '\30\76very tough' },
    { 0x47, '\30\76incredibly tough' }
};

---------------------------------------------------------------------------------------------------
-- Widescan Storage Data
---------------------------------------------------------------------------------------------------
local widescan = { };

---------------------------------------------------------------------------------------------------
-- func: incoming_packet
-- desc: Called when our addon receives an incoming packet.
---------------------------------------------------------------------------------------------------
ashita.register_event('incoming_packet', function(id, size, data)
    -- Zone Change Packet
    if (id == 0x000A) then
        -- Reset the widescan data..
        widescan = { };
        return false;
    end

    -- Message Basic Packet
    if (id == 0x0029) then
        local p = struct.unpack('l', data, 0x0C + 1); -- Monster Level
        local v = struct.unpack('L', data, 0x10 + 1); -- Check Type
        local m = struct.unpack('H', data, 0x18 + 1); -- Defense and Evasion

        local ctype = nil;
        local ccond = nil;

        -- Obtain the check type and condition string..
        for k, vv in pairs(checktype) do
            if (vv[1] == v) then
                ctype = vv[2];
            end
        end
        for k, vv in pairs(conditions) do
            if (vv[1] == m) then
                ccond = vv[2];
            end
        end

        -- Check for impossible to gauge..
        if (m == 0xF9) then
            ctype = '';
            ccond = '';
        end

        -- Ensure a check type and condition was found..
        if (ctype == nil or ccond == nil) then
            return false;
        end

        -- Obtain the target entity..
        local target = struct.unpack('H', data, 0x16 + 1);
        local entity = GetEntity(target);
        if (entity == nil) then
            return false;
        end

        -- Check the level for overrides from widescan..
        if (p <= 0) then
            local l = widescan[target];
            if (l ~= nil) then
                p = l;
            end
        end

        -- Print out based on NM or not..
        if (m == 0xF9) then
            local lvl = '???';
            if (p > 0) then
                lvl = tostring(p);
            end
            print(string.format('\31\200[\30\82checker\31\200] \31\130%s \30\82%s\31\130 \31\200(Lv. \30\82%s\31\200) \30\05Impossible to gauge!', entity.Name, string.char(0x81, 0xA8), lvl));
        else
            print(string.format('\31\200[\30\82checker\31\200] \31\130%s \30\82%s\31\130 \31\200(Lv. \30\82%d\31\200) \31\130Seems %s\31\130. %s', entity.Name, string.char(0x81, 0xA8), p, ctype, ccond));
        end

        return true;
    end

    -- Widescan Result Packet
    if (id == 0x00F4) then
        local i = struct.unpack('H', data, 0x04 + 1); -- Entity Index
        local l = struct.unpack('b', data, 0x06 + 1); -- Entity Level
        
        -- Store the index and level information..
        widescan[i] = l;
        return false;
    end

    return false;
end);