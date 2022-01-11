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
_addon.name     = 'craftmon';
_addon.version  = '3.0.0';

require 'common'

---------------------------------------------------------------------------------------------------
-- func: GetResultQuality
-- desc: Returns a table holding a color id and string representation of the given craft result id.
---------------------------------------------------------------------------------------------------
local function GetResultQuality(res)
    return switch(res) : caseof
    {
        [0] = function() return { 1, 'Normal Quality' }; end,
        [1] = function() return { 39, 'Break' }; end,
        [2] = function() return { 5, 'High-Quality' }; end,
        [3] = function() return { 5, 'High-Quality' }; end,
        [4] = function() return { 5, 'High-Quality' }; end,
        ['default'] = function()
            return { 4, string.format('Unknown Quality (%d)', res) }; 
        end
    };
end

---------------------------------------------------------------------------------------------------
-- func: incoming_packet
-- desc: Called when our addon receives an incoming packet.
---------------------------------------------------------------------------------------------------
ashita.register_event('incoming_packet', function(id, size, data)
    -- Synth Animation Packet
    if (id == 0x0030) then
        local pid       = struct.unpack('L', data, 0x04 + 1);
        local pindex    = struct.unpack('H', data, 0x08 + 1);
        local player    = GetPlayerEntity();
        
        -- Ensure this is a packet about our player..
        if (player.TargetIndex == pindex) then
            local res   = struct.unpack('b', data, 0x0C + 1);
            local data  = GetResultQuality(res);
            print(string.format('\31\130=========================\31\07>>> \31\%c%-25s', data[1], data[2]));
        end        
    end
    
    -- Synth Results Packet
    if (id == 0x006F) then
        local res       = struct.unpack('b', data, 0x04 + 1);
        local count     = struct.unpack('b', data, 0x06 + 1);
        local itemid    = struct.unpack('H', data, 0x08 + 1);
    
        -- Ensure the synth was a success..
        if (res == 0) then
            local item = AshitaCore:GetResourceManager():GetItemById(itemid);
            if (item ~= nil) then
                print(string.format('\31\130=========================\31\07>>> \31\01Created: \31\36%s x%d', item.Name[0], count));
            end
        end
    end
    
    return false;
end);