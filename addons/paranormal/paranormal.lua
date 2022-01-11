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
_addon.name     = 'paranormal';
_addon.version  = '3.0.0';

require 'common'

----------------------------------------------------------------------------------------------------
-- func: msg
-- desc: Prints out a message with the addon tag at the front.
----------------------------------------------------------------------------------------------------
local function msg(s)
    local txt = '\31\200[\31\05' .. _addon.name .. '\31\200]\31\130 ' .. s;
    print(txt);
end

----------------------------------------------------------------------------------------------------
-- func: err
-- desc: Prints out an error message with the addon tag at the front.
----------------------------------------------------------------------------------------------------
local function err(s)
    local txt = '\31\200[\31\05' .. _addon.name .. '\31\200]\31\39 ' .. s;
    print(txt);
end

----------------------------------------------------------------------------------------------------
-- func: load
-- desc: Event called when the addon is being loaded.
----------------------------------------------------------------------------------------------------
ashita.register_event('load', function()
    -- Locate the command list pointer..
    local pointer = ashita.memory.findpattern('FFXiMain.dll', 0, '88440C008A420141423C20????8D442400C6440C000050', 0x18, 0x00);
    if (pointer == 0) then
        err('Failed to locate the required pointer.');
        return;
    end

    -- Loop all commands and adjust their flags..
    local start = ashita.memory.read_uint32(pointer);
    while true do
        -- Read the command information..
        local cmdName = ashita.memory.read_uint8(start);
        local cmdFlag = ashita.memory.read_uint8(start + 0x16);
        
        -- Finish when we find a non-command entry..
        if (cmdName ~= 0x2F) then break; end

        -- Check if the flag can be used while dead..
        if (bit.band(cmdFlag, 0x20) ~= 0x20) then
            -- Enable the command for dead usage..
            local flags = bit.bor(cmdFlag, 0x20);
            ashita.memory.write_uint8(start + 0x16, flags);
        end
        
        -- Step to the next command entry..
        start = start + 0x18;
    end

    msg('Paranormal now active, all commands should be usable while dead!');
end);