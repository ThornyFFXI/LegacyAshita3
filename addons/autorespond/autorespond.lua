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
_addon.name     = 'autorespond';
_addon.version  = '3.0.0';

require 'common'

local autorespond   = { };
autorespond.afk     = true;
autorespond.message = 'Sorry but I am not currently here. Leave a message after the beep! ~';

----------------------------------------------------------------------------------------------------
-- func: print_help
-- desc: Displays a help block for proper command usage.
----------------------------------------------------------------------------------------------------
local function print_help(cmd, help)
    -- Print the invalid format header..
    print('\31\200[\31\05' .. _addon.name .. '\31\200]\30\01 ' .. '\30\68Invalid format for command:\30\02 ' .. cmd .. '\30\01'); 

    -- Loop and print the help commands..
    for k, v in pairs(help) do
        print('\31\200[\31\05' .. _addon.name .. '\31\200]\30\01 ' .. '\30\68Syntax:\30\02 ' .. v[1] .. '\30\71 ' .. v[2]);
    end
end

----------------------------------------------------------------------------------------------------
-- func: command
-- desc: Event called when a command was entered.
----------------------------------------------------------------------------------------------------
ashita.register_event('command', function(command, ntype)
    -- Get the arguments of the command..
    local args = command:args();
    if (args[1] ~= '/afk') then
        return false;
    end

    -- Toggle afk status on and off..
    if (#args == 1) then 
        autorespond.afk = not autorespond.afk;
        print(string.format('\31\200[\31\05' .. 'autorespond' .. '\31\200]\31\130 AFK status set to: \30\02%s', tostring(autorespond.afk)));
        return true;
    end

    -- Sets the afk message..
    if (#args > 2 and args[2] == 'message') then
        autorespond.message = command:sub(command:find(' ', command:find(' ') + 1) + 1);
        print(string.format('\31\200[\31\05' .. 'autorespond' .. '\31\200]\31\130 AFK message set to: \30\02%s', tostring(autorespond.message)));
        return true;
    end

    -- Prints the addon help..
    print_help('/afk', {
        { '/afk',               '- Toggles the auto-response on and off.' },
        { '/afk message [msg]', '- Sets the auto-response message.' }
    });
    return true;
end);

---------------------------------------------------------------------------------------------------
-- func: incoming_packet
-- desc: Event called when the addon is asked to handle an incoming packet.
---------------------------------------------------------------------------------------------------
ashita.register_event('incoming_packet', function(id, size, data, modified, blocked)
    if (id == 0x0017) then
        local p = data:totable();
        if (p[5] == 0x03 and autorespond.afk == true) then
            local name = struct.unpack('s', data, 9);
            AshitaCore:GetChatManager():QueueCommand(string.format('/tell %s %s', name, autorespond.message), 1);
        end
    end
    return false;
end);