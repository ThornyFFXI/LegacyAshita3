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
_addon.name     = 'timestamp';
_addon.version  = '3.0.1';

require 'common'

----------------------------------------------------------------------------------------------------
-- Configurations
----------------------------------------------------------------------------------------------------
local default_config =
{
    color           = 200,
    format          = '%H:%M:%S',
    open_bracket    = '[',
    close_bracket   = ']'
};
local configs = default_config;

----------------------------------------------------------------------------------------------------
-- func: load
-- desc: Event called when the addon is being loaded.
----------------------------------------------------------------------------------------------------
ashita.register_event('load', function()
    -- Load the configuration file..
    configs = ashita.settings.load_merged(_addon.path .. '/settings/settings.json', configs);
end);

----------------------------------------------------------------------------------------------------
-- func: unload
-- desc: Event called when the addon is being unloaded.
----------------------------------------------------------------------------------------------------
ashita.register_event('unload', function()
    -- Save the configuration file..
    ashita.settings.save(_addon.path .. '/settings/settings.json', configs);
end);

---------------------------------------------------------------------------------------------------
-- func: incoming_text
-- desc: Event called when the addon is asked to handle an incoming chat line.
---------------------------------------------------------------------------------------------------
ashita.register_event('incoming_text', function(mode, message, modifiedmode, modifiedmessage, blocked)
    -- Do nothing if the line is already blocked..
    if (blocked) then return false; end

    -- Handle the modified message if its set..
    if (modifiedmessage ~= nil and #modifiedmessage > 0) then
        message = modifiedmessage;
    end
        
    -- Check for double-chat lines (ie. npc chat)..
    if (message:startswith(string.char(0x1E, 0x01))) then
        return false;
    end  
    --[[local f = string.sub(message, 1, 1);
    if (f ~= nil and (string.byte(f) == 0x1E or string.byte(f) == 0x1F)) then
        if (string.sub(message, 5, 5) == '[') then
            return false;
        end
    end]]    

    -- Skip ignored chat modes..
    local ignored = T{
        -- Synergy
        600, 702, 909, 919,

        -- Linkshell / System Messages
        200, 973
    };
    if (ignored:hasvalue(mode)) then
        return false;
    end

    -- Create and apply the timestamp..
    local timestamp = os.date(string.format('\31\%c[%s]\30\01 ', configs.color, configs.format));
    return timestamp .. message;
end);