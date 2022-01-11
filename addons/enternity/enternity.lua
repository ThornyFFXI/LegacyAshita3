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

_addon.author   = 'Hypnotoad';
_addon.name     = 'enternity';
_addon.version  = '3.0.0';

require 'common'
require 'ffxi.targets'

----------------------------------------------------------------------------------------------------
-- Configurations
----------------------------------------------------------------------------------------------------
local default_config =
{
    skip = false
};
local enternity_config = default_config;

----------------------------------------------------------------------------------------------------
-- Variables
----------------------------------------------------------------------------------------------------
local ignore = 
{
    'Stone Picture Frame',  -- Requires correct timing, should not be skipped
    'Geomantic Reservoir',  -- Causes dialogue freeze for some reason
};

----------------------------------------------------------------------------------------------------
-- func: load
-- desc: Event called when the addon is being loaded.
----------------------------------------------------------------------------------------------------
ashita.register_event('load', function()
    -- Load the configuration file..
    enternity_config = ashita.settings.load_merged(_addon.path .. '/settings/settings.json', enternity_config);
end);

----------------------------------------------------------------------------------------------------
-- func: unload
-- desc: Event called when the addon is being unloaded.
----------------------------------------------------------------------------------------------------
ashita.register_event('unload', function()
    -- Save the configuration file..
    ashita.settings.save(_addon.path .. '/settings/settings.json', enternity_config);
end);

----------------------------------------------------------------------------------------------------
-- func: command
-- desc: Event called when a command was entered.
----------------------------------------------------------------------------------------------------
ashita.register_event('command', function(command, ntype)
    -- Get the arguments of the command..
    local args = command:args();
    if (args[1] ~= '/enternity') then
        return false;
    end

    -- Handle the skip command..
    if (#args >= 2 and args[2] == 'skip') then
        enternity_config.skip = not enternity_config.skip;
        print(string.format('\31\200[\31\05Enternity\31\200] \31\130Set skip status to: \30\02%s', tostring(enternity_config.skip)));
    end

    return true;
end);

---------------------------------------------------------------------------------------------------
-- func: incoming_text
-- desc: Event called when the addon is asked to handle an incoming chat line.
---------------------------------------------------------------------------------------------------
ashita.register_event('incoming_text', function(mode, chat, modifiedmode, modifiedmessage, blocked)
    if (blocked) then return false; end

    -- Look for a mode to skip..
    if (mode == 662 or mode == 919) then
        if not (enternity_config.skip == false and chat:match(string.char(0x1E, 0x02))) then
            local target = ashita.ffxi.targets.get_target('t');
            if not (target ~= nil and table.hasvalue(ignore, target.Name)) then
                chat = chat:gsub(string.char(0x7F, 0x31), '');
                return chat;
            end
        end
    end

    return false;
end);