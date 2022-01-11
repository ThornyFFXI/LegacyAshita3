--[[
* Ashita - Copyright (c) 2014 - 2018 atom0s [atom0s@live.com]
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
_addon.name     = 'Aspect';
_addon.version  = '1.0.1';

require 'common'

local aspect    = { };
aspect.pointer  = ashita.memory.findpattern('FFXiMain.dll', 0, 'A1????????85C074??D9442404D80D????????D80D', 1, 0);

---------------------------------------------------------------------------------------------------
-- func: load
-- desc: First called when our addon is loaded.
---------------------------------------------------------------------------------------------------
ashita.register_event('load', function()
    -- Find the configuration pointer..
    if (aspect.pointer == 0) then
        error('[Aspect] Failed to find required pointer.');
        return;
    end
end);

---------------------------------------------------------------------------------------------------
-- func: render
-- desc: Called when the addon is being rendered.
---------------------------------------------------------------------------------------------------
ashita.register_event('render', function()
    -- Get the current window size..
    local w = AshitaCore:GetConfigurationManager():get_float('boot_config', 'window_x', 800);
    local h = AshitaCore:GetConfigurationManager():get_float('boot_config', 'window_y', 600);

    -- Read the pointer data..
    local ptr = ashita.memory.read_uint32(aspect.pointer);
    if (ptr == 0) then
        error('[Aspect] Failed to read required pointer data.');
        return;
    end
    ptr = ashita.memory.read_uint32(ptr);

    -- Write the aspect ratio..
    local r = (h / (w * 0.25 * 3.0));
    ashita.memory.write_float(ptr + 0x2F0, r);
end);