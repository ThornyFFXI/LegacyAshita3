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
_addon.name     = 'filterless';
_addon.version  = '3.0.0';

require 'common'

----------------------------------------------------------------------------------------------------
-- Variables
----------------------------------------------------------------------------------------------------
local filterless = { };

----------------------------------------------------------------------------------------------------
-- func: load
-- desc: Event called when the addon is being loaded.
----------------------------------------------------------------------------------------------------
ashita.register_event('load', function()
    -- Scan for the required signature..
    local pointer = ashita.memory.findpattern('FFXiMain.dll', 0, '8B0D????????85C975??83C8??C38B44240450E8????????C3', 0, 0); 
    if (pointer == 0) then
        error('[Filterless] Failed to locate required signature.');
        return;
    end

    -- Store the pointer..
    filterless.pointer = pointer;
end);

----------------------------------------------------------------------------------------------------
-- func: render
-- desc: Event called when the addon is being rendered.
----------------------------------------------------------------------------------------------------
ashita.register_event('render', function()
    -- Ensure the pointer is valid..
    if (filterless.pointer == nil or filterless.pointer == 0) then
        return;
    end

    -- Read the pointer value..
    local pointer = ashita.memory.read_uint32(filterless.pointer + 0x02);
    if (pointer == 0) then return; end

    -- Read the pointer value..
    pointer = ashita.memory.read_uint32(pointer);
    if (pointer == 0) then return; end

    -- Set chat filter to disabled..
    ashita.memory.write_uint32(pointer + 0x04, 1);
end);