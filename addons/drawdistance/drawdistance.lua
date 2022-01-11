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
_addon.name     = 'drawdistance';
_addon.version  = '3.0.0';

require 'common'

----------------------------------------------------------------------------------------------------
-- Variables
----------------------------------------------------------------------------------------------------
local drawdistance = { };
drawdistance.pointer = 0;

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
-- func: load
-- desc: Event called when the addon is being loaded.
----------------------------------------------------------------------------------------------------
ashita.register_event('load', function()
    -- Scan for the required pointer..
    local pointer = ashita.memory.findpattern('FFXiMain.dll', 0, '8BC1487408D80D', 0, 0);
    if (pointer == nil) then
        print('[DrawDistance] Failed to find required pattern.');
        return;
    end

    -- Store the pointer..
    drawdistance.pointer = pointer;
end);

----------------------------------------------------------------------------------------------------
-- func: command
-- desc: Event called when a command was entered.
----------------------------------------------------------------------------------------------------
ashita.register_event('command', function(command, ntype)
    -- Get the arguments of the command..
    local args = command:args();
    if (args[1] ~= '/drawdistance') then
        return false;
    end

    -- Set the world distance..
    if (#args >= 3 and args[2] == 'setworld') then
        local pointer = ashita.memory.read_uint32(drawdistance.pointer + 0x07);
        ashita.memory.write_float(pointer, tonumber(args[3]));
        return true;
    end

    -- Set the mob distance..
    if (#args >= 3 and args[2] == 'setmob') then
        local pointer = ashita.memory.read_uint32(drawdistance.pointer + 0x0F);
        ashita.memory.write_float(pointer, tonumber(args[3]));
        return true;
    end

    -- Prints the addon help..
    print_help('/drawdistance', {
        { '/drawdistance setworld [num]',   '- Sets the world render distance..' },
        { '/drawdistance setmob [num]',     '- Sets the mob render distance.' }
    });
    return true;
end);