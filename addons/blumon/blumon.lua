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
_addon.name     = 'blumon';
_addon.version  = '3.0.0';

require 'common'

---------------------------------------------------------------------------------------------------
-- func: incoming_packet
-- desc: Event called when the addon is asked to handle an incoming packet.
---------------------------------------------------------------------------------------------------
ashita.register_event('incoming_packet', function(id, size, data, modified, blocked)
    -- Message basic packet..
    if (id == 0x29) then
        -- Get the message id..
        local msgid = struct.unpack('H', data, 0x18 + 1);
        if (msgid == 419) then
            local sender = struct.unpack('H', data, 0x14 + 1);
            local target = struct.unpack('H', data, 0x16 + 1);
            local spellId = struct.unpack('L', data, 0x0C + 1);
            local player = GetPlayerEntity();
            if (sender == player.TargetIndex and target == player.TargetIndex) then
                local name = AshitaCore:GetResourceManager():GetString('spellname', spellId);
                if (name == nil) then name = spellId; end
                print('\31\130=========================\31\07>>> \30\02Learned a blue spell! \31\200[\31\05' .. tostring(name) .. '\31\200]');
            end
        end
    end

    return false;
end);