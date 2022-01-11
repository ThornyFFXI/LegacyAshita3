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
_addon.name     = 'mapdot';
_addon.version  = '3.0.0';

require 'common'

----------------------------------------------------------------------------------------------------
-- Variables
----------------------------------------------------------------------------------------------------
local mapdot    = { };
mapdot.pointer  = ashita.memory.findpattern('FFXiMain.dll', 0, 'A1????????85C074??D9442404D80D????????8B4C2404', 0, 0);
mapdot.backup   = { };
mapdot.showdots = false;

----------------------------------------------------------------------------------------------------
-- func: load
-- desc: Event called when the addon is being loaded.
----------------------------------------------------------------------------------------------------
ashita.register_event('load', function()
    -- Ensure the pointer was located..
    if (mapdot.pointer == 0) then
        print('[MapDot] (Error) Failed to find required pattern.');
        return;
    end

    -- Backup the patched area..
    mapdot.backup = ashita.memory.read_array(mapdot.pointer + 0x34, 3);

    -- Patch the memory..
    local data = { 0x90, 0x90, 0x90 };
    ashita.memory.write_array(mapdot.pointer + 0x34, data);

    -- Set the map to show all dots..
    local map = ashita.memory.read_uint32(mapdot.pointer + 1);
    if (map == 0) then return; end

    map = ashita.memory.read_uint32(map);
    if (map == 0) then return; end

    ashita.memory.write_uint8(map + 0x2F, 1);
    mapdot.showdots = true;
end);

----------------------------------------------------------------------------------------------------
-- func: unload
-- desc: Event called when the addon is being unloaded.
----------------------------------------------------------------------------------------------------
ashita.register_event('unload', function()
    -- Undo the memory patch..
    if (mapdot.backup ~= nil and #mapdot.backup > 0) then
        ashita.memory.write_array(mapdot.pointer + 0x34, mapdot.backup);
    end
end);

---------------------------------------------------------------------------------------------------
-- func: render
-- desc: Called when our addon is told to render.
---------------------------------------------------------------------------------------------------
ashita.register_event('render', function()
    if (mapdot.pointer == 0 or mapdot.showdots == true) then
        return;
    end

    -- Set the map to show all dots..
    local map = ashita.memory.read_uint32(mapdot.pointer + 1);
    if (map == 0) then return; end

    map = ashita.memory.read_uint32(map);
    if (map == 0) then return; end

    ashita.memory.write_uint8(map + 0x2F, 1);
    mapdot.showdots = true;
end);