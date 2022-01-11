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
_addon.name     = 'allmaps';
_addon.version  = '3.0.1';

require 'common'

---------------------------------------------------------------------------------------------------
-- allmaps Table
---------------------------------------------------------------------------------------------------
local allmaps   = { };
allmaps.pointer1 = ashita.memory.findpattern('FFXiMain.dll', 0, '50??????????83C4048886????????0FBF8E????????8A', 0x01, 0);
allmaps.pointer2 = ashita.memory.findpattern('FFXiMain.dll', 0, '50??????????83C4048886????????0FBF96????????8A', 0x01, 0);

----------------------------------------------------------------------------------------------------
-- func: load
-- desc: Event called when the addon is being loaded.
----------------------------------------------------------------------------------------------------
ashita.register_event('load', function()
    -- Validate the pointers..
    if (allmaps.pointer1 == 0 or allmaps.pointer2 == 0) then
        print('\31\200[\31\05' .. 'allmaps'.. '\31\200]\30\01 ' .. '\30\68Failed to find required signature(s).\30\01');
        return;
    end

    -- Backup the function data..
    allmaps.backup1 = ashita.memory.read_array(allmaps.pointer1, 5);
    allmaps.backup2 = ashita.memory.read_array(allmaps.pointer2, 5);

    -- Overwrite the function..
    local patch = { 0xB8, 0x01, 0x00, 0x00, 0x00 };
    ashita.memory.write_array(allmaps.pointer1, patch);
    ashita.memory.write_array(allmaps.pointer2, patch);
    print(string.format('\31\200[\31\05' .. 'allmaps'.. '\31\200] \31\130Function patched; /map should now display all maps as if you own them.'));
    print(string.format('\31\200[\31\05' .. 'allmaps'.. '\31\200] \31\130Function patched; viewing homepoint/waypoint warps should now display maps.'));
end);

----------------------------------------------------------------------------------------------------
-- func: unload
-- desc: Event called when the addon is being unloaded.
----------------------------------------------------------------------------------------------------
ashita.register_event('unload', function()
    -- Restore the map function patch..
    if (allmaps.backup1 ~= nil) then
        ashita.memory.write_array(allmaps.pointer1, allmaps.backup1);
    end
    if (allmaps.backup2 ~= nil) then
        ashita.memory.write_array(allmaps.pointer2, allmaps.backup2);
    end
end);