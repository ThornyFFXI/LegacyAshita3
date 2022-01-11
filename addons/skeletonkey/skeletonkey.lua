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
_addon.name     = 'skeletonkey';
_addon.version  = '3.0.0';

require 'common'
require 'ffxi.targets'

----------------------------------------------------------------------------------------------------
-- Variables
----------------------------------------------------------------------------------------------------
local skeletonkey = { };
skeletonkey.enabled = false;

----------------------------------------------------------------------------------------------------
-- func: command
-- desc: Event called when a command was entered.
----------------------------------------------------------------------------------------------------
ashita.register_event('command', function(command, ntype)
    local args = command:args();
    if (args[1] == '/skeletonkey' or args[1] == '/sk' or args[1] == '/key') then
        skeletonkey.enabled = not skeletonkey.enabled;

        local fmt = '\30\02Enabled';
        if (skeletonkey.enabled == false) then
            fmt = '\30\68Disabled';
        end
        print(string.format('\31\200[\31\05' .. 'skeletonkey' .. '\31\200] \31\130Skeleton key mode set to: %s', fmt));
        return true;
    end
    return false;
end);

----------------------------------------------------------------------------------------------------
-- func: render
-- desc: Event called when the addon is being rendered.
----------------------------------------------------------------------------------------------------
ashita.register_event('render', function()
    -- Ensure the addon is enabled..
    if (skeletonkey.enabled == false) then
        return;
    end

    -- Get the current target..
    local target = ashita.ffxi.targets.get_target('t');
    if (target == nil) then return; end

    -- Ensure the target is a door..
    if (bit.band(target.SpawnFlags, 0x20) ~= 0x20) then
        return;
    end

    -- Set the door to an open state..
    target.Status = 8;
end);