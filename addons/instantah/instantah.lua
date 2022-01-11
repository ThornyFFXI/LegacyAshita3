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
_addon.name     = 'instantah';
_addon.version  = '3.0.0';

require 'common'

----------------------------------------------------------------------------------------------------
-- Variables
----------------------------------------------------------------------------------------------------
local instantah = { };
instantah.pointer = 0;

----------------------------------------------------------------------------------------------------
-- func: err
-- desc: Prints out an error message with the addon tag at the front.
----------------------------------------------------------------------------------------------------
local function err(s)
    local txt = '\31\200[\31\05InstantAH\31\200]\31\39 ' .. s;
    print(txt);
end

----------------------------------------------------------------------------------------------------
-- func: load
-- desc: Event called when the addon is being loaded.
----------------------------------------------------------------------------------------------------
ashita.register_event('load', function()
    -- Locate the required pointer..
    local pointer = ashita.memory.findpattern('FFXiMain.dll', 0, '668BC1B9????????0FAFC233D2F7F1', 0x00, 0x00);
    if (pointer == 0) then
        err('Failed to find required pointer.');
        return;
    end
    instantah.pointer = pointer;

    -- Patch the function..
    ashita.memory.write_uint8(instantah.pointer + 0x27, 0xEB);
    print(string.format('\31\200[\31\05' .. 'InstantAH'.. '\31\200] \31\130Function patched; auction results should now be instant.'));
end);

----------------------------------------------------------------------------------------------------
-- func: unload
-- desc: Event called when the addon is being unloaded.
----------------------------------------------------------------------------------------------------
ashita.register_event('unload', function()
    if (instantah.pointer ~= 0) then
        ashita.memory.write_uint8(instantah.pointer + 0x27, 0x74);
    end
end);