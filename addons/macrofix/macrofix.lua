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
_addon.name     = 'macrofix';
_addon.version  = '3.0.0';

require 'common'

----------------------------------------------------------------------------------------------------
-- Variables
----------------------------------------------------------------------------------------------------
local macrofix  = 
{ 
    address1 = nil,
    address1_backup = nil,
    
    address2 = nil,
    address2_backup = nil,
    
    address3 = nil,
    address3_backup = nil,
    
    address4 = nil,
    address4_backup = nil,
    
    address5 = nil,
    address5_backup = nil,
    
    address6 = nil,
    address6_backup = nil,
};

----------------------------------------------------------------------------------------------------
-- func: load
-- desc: Event called when the addon is being loaded.
----------------------------------------------------------------------------------------------------
ashita.register_event('load', function()
    -- Local variables used for scanning..
    local sig = nil;
    local ptr = nil;
    local new = nil;
    
    -- Scan for the signatures..
    ptr = ashita.memory.findpattern('FFXiMain.dll', 0, '83C41084C074??8BCEE8????????84C074??8A460CB9????????3AC3', 0, 0);
    if (ptr == 0) then error('Failed to locate critical signature #1!'); end
    macrofix.address1 = ptr + 5;
    macrofix.address1_backup = ashita.memory.read_uint8(ptr + 5);
    ashita.memory.write_uint8(ptr + 5, 0xEB);
 
    ptr = ashita.memory.findpattern('FFXiMain.dll', 0, '83C41084C074??8BCEE8????????84C074??807E0C02', 0, 0);
    if (ptr == 0) then error('Failed to locate critical signature #2!'); end
    macrofix.address2 = ptr + 5;
    macrofix.address2_backup = ashita.memory.read_uint8(ptr + 5);
    ashita.memory.write_uint8(ptr + 5, 0xEB);

    ptr = ashita.memory.findpattern('FFXiMain.dll', 0, '2B46103BC3????????????68????????B9', 0, 0);
    if (ptr == 0) then error('Failed to locate critical signature #3!'); end
    macrofix.address3 = ptr + 5;
    macrofix.address3_backup = ashita.memory.read_array(ptr + 5, 6);
    new = { 0x90, 0x90, 0x90, 0x90, 0x90, 0x90 };
    ashita.memory.write_array(ptr + 5, new);

    ptr = ashita.memory.findpattern('FFXiMain.dll', 0, '2B46103BC3????68????????B9', 0, 0);
    if (ptr == 0) then error('Failed to locate critical signature #4!'); end
    macrofix.address4 = ptr + 5;
    macrofix.address4_backup = ashita.memory.read_array(ptr + 5, 2);
    new = { 0x90, 0x90 };
    ashita.memory.write_array(ptr + 5, new);
    
    ptr = ashita.memory.findpattern('FFXiMain.dll', 0, '83C41084C0????8BCEE8????????84C0????8A460C84C0????8B461485C0', 0, 0);
    if (ptr == 0) then error('Failed to locate critical signature #5!'); end
    macrofix.address5 = ptr + 7;
    macrofix.address5_backup = ashita.memory.read_array(ptr + 7, 7);
    new = { 0xE9, 0x9B, 0x00, 0x00, 0x00, 0xCC, 0xCC };
    ashita.memory.write_array(ptr + 7, new);
    
    -- Scan and patch last part, must be separated from the above!
    ptr = ashita.memory.findpattern('FFXiMain.dll', 0, '83C41084C0????8BCEE8????????84C0????8A460C84C0????8B461485C0', 0, 0);
    if (ptr == 0) then error('Failed to locate critical signature #6!'); end
    macrofix.address6 = ptr + 7;
    macrofix.address6_backup = ashita.memory.read_array(ptr + 7, 7);
    new = { 0xE9, 0xCD, 0x00, 0x00, 0x00, 0xCC, 0xCC };
    ashita.memory.write_array(ptr + 7, new);
end);

----------------------------------------------------------------------------------------------------
-- func: unload
-- desc: Event called when the addon is being unloaded.
----------------------------------------------------------------------------------------------------
ashita.register_event('unload', function()
    if (macrofix.address1 ~= nil and macrofix.address1_backup ~= nil) then
        ashita.memory.write_uint8(macrofix.address1, macrofix.address1_backup);
    end
    if (macrofix.address2 ~= nil and macrofix.address2_backup ~= nil) then
        ashita.memory.write_uint8(macrofix.address2, macrofix.address2_backup);
    end
    if (macrofix.address3 ~= nil and macrofix.address3_backup ~= nil) then
        ashita.memory.write_array(macrofix.address3, macrofix.address3_backup);
    end
    if (macrofix.address4 ~= nil and macrofix.address4_backup ~= nil) then
        ashita.memory.write_array(macrofix.address4, macrofix.address4_backup);
    end
    if (macrofix.address5 ~= nil and macrofix.address5_backup ~= nil) then
        ashita.memory.write_array(macrofix.address5, macrofix.address5_backup);
    end
    if (macrofix.address6 ~= nil and macrofix.address6_backup ~= nil) then
        ashita.memory.write_array(macrofix.address6, macrofix.address6_backup);
    end
end);