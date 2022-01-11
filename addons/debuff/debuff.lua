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
_addon.name     = 'debuff';
_addon.version  = '3.0.0';

require 'common'

----------------------------------------------------------------------------------------------------
-- func: command
-- desc: Event called when a command was entered.
----------------------------------------------------------------------------------------------------
ashita.register_event('command', function(command, ntype)
    -- Ensure we should handle this command..
    local args = command:args();
    if (args[1] ~= '/debuff' and args[1] ~= '/cancel') then
        return false;
    end
    
    -- Ensure we have enough arguments..
    if (#args ~= 2) then return true; end
    
    -- Obtain the buff id..
    local buffid = tonumber(args[2]);
    
    -- Check if nil, try string input instead..
    if (buffid == nil) then
        local buffname = command:gsub('([\/%w]+) ', '', 1):trim();

        -- Loop the status names..
        for x = 0, 640 do
            local name = AshitaCore:GetResourceManager():GetString('statusnames', x);
            if (name ~= nil and #name > 0) then
                if (name:lower() == buffname:lower()) then
                    buffid = x;
                    break;
                end                
            end
        end
    end
    
    -- Build and send debuff packet..
    if (buffid ~= nil and buffid > 0) then
        local debuff = struct.pack("bbbbhbb", 0xF1, 0x04, 0x00, 0x00, buffid, 0x00, 0x00):totable();
        AddOutgoingPacket(0xF1, debuff);
    end

    return true;
end);
