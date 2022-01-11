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

_addon.author   = 'bluekirby';
_addon.name     = 'repeater';
_addon.version  = '3.0.2';

require 'common'

local __go;
local __command;
local __timer;
local __cycle;

function read_fps_divisor() -- borrowed from fps addon
    local fpsaddr = ashita.memory.findpattern('FFXiMain.dll', 0, '81EC000100003BC174218B0D', 0, 0);
    if (fpsaddr == 0) then
        print('[FPS] Could not locate required signature!');
        return true;
    end

    -- Read the address..
    local addr = ashita.memory.read_uint32(fpsaddr + 0x0C);
    addr = ashita.memory.read_uint32(addr);
    return ashita.memory.read_uint32(addr + 0x30);
end;

function quoted_concat(t, s, o)
    if (o == nil) then return ''; end
    if (o > #t) then return ''; end

    local ret = '';
    for x = o, #t do
        local spaces = string.find(t[x], " ");
        if (spaces) then
            ret = ret .. string.format('"%s"%s', t[x], s);
        else
            ret = ret .. string.format('%s%s', t[x], s);
        end
    end
    return ret;
end

ashita.register_event('load', function()
    __go = false;
    __command = "";
    __timer = 0;
    __cycle = 5;
end );

ashita.register_event('command', function(cmd, nType)
    -- Ensure we should handle this command..
    local args = cmd:args();
    if (args[1] ~= '/repeat') then
        return false;
    elseif (#args < 2) then
        return true;
    elseif ((args[2] == 'set') and (#args >= 3)) then
        __command = quoted_concat(args," ",3);
        __command = string.trim(__command);
        print ("Command to be repeated: " .. __command);
        return true;
    elseif (args[2] == 'start') then
        if(#__command > 1) then
            print("Starting cycle!")
            __go = true;
        else
            print("Set a command first!")
        end
        return true;
    elseif (args[2] == 'stop') then
        __go = false;
        print("Cycle Terminated!")
        return true;
    elseif ((args[2] == 'cycle') and (#args == 3)) then
        __cycle = tonumber(args[3]);
        if(__cycle < 1) then __cycle = 1 end
        __timer = 0;
        print("Commands will be executed every " .. __cycle .. " seconds!")
    elseif (args[2] == 'help') then
        print("Valid commands are set start stop and cycle")
    end
    return false;
end );

ashita.register_event('render', function()
    if(__go) then
        if(__timer == (60 / read_fps_divisor() * __cycle)) then
            AshitaCore:GetChatManager():QueueCommand(__command, 1);
            __timer = 0;
        else
            __timer = __timer + 1;
        end
    end
end );