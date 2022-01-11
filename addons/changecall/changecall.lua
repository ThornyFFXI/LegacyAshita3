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

_addon.author   = 'atom0s';
_addon.name     = 'ChangeCall';
_addon.version  = '1.0.2';

require 'common'

---------------------------------------------------------------------------------------------------
-- Variables
---------------------------------------------------------------------------------------------------
local settings  = { };
settings.callid = 14;

----------------------------------------------------------------------------------------------------
-- func: command
-- desc: Event called when a command was entered.
----------------------------------------------------------------------------------------------------
ashita.register_event('command', function(command, ntype)
    -- Ensure we should handle this command..
    local args = command:args();
    if (args[1] ~= '/changecall') then
        return false;
    end
    
    -- Pull the new call id to use..
    local callid = string.gsub(command, '/changecall', ''):trim();
    if (callid == nil or string.len(callid) == 0 or tonumber(callid) == nil) then
        settings.callid = 0;
    else
        settings.callid = tonumber(callid);
    end
    
    local newid = '';
    if (settings.callid > 0) then
        newid = tostring(settings.callid);
    end
    
    print(string.format('\31\200[\31\05' .. 'ChangeCall'.. '\31\200] \31\130Calls overriden to now use: \'\30\02<call%s>\30\01\'', newid));
    return true;
end);

---------------------------------------------------------------------------------------------------
-- func: incoming_text
-- desc: Event called when the addon is asked to handle an incoming chat line.
---------------------------------------------------------------------------------------------------
ashita.register_event('incoming_text', function(mode, message, modifiedmode, modifiedmessage, blocked)
    -- Look for any type of call..
    local r = '<((c|nc|sc)all|(c|nc|sc)all([0-9]+))>';
    local c = ashita.regex.search(modifiedmessage, r);
    if (c ~= nil) then
        local newid = '';
        if (settings.callid > 0) then
            newid = tostring(settings.callid);
        end
    
        -- Replace the call with our desired number..
        return ashita.regex.replace(modifiedmessage, r, '<call' .. newid .. '>');
    end

    return false;
end);