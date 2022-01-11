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
_addon.name     = 'ahgo';
_addon.version  = '3.0.0';

require 'common'

---------------------------------------------------------------------------------------------------
-- AH-Go Table
---------------------------------------------------------------------------------------------------
local ahgo = { };
ahgo.auction_pointer    = ashita.memory.findpattern('FFXiMain.dll', 0, 'DFE02500410000DDD8????8B46086A0150', 0, 0);
ahgo.shop_pointer       = ashita.memory.findpattern('FFXiMain.dll', 0, 'DFE02500410000DDD8????B301', 0, 0);

----------------------------------------------------------------------------------------------------
-- func: load
-- desc: Event called when the addon is being loaded.
----------------------------------------------------------------------------------------------------
ashita.register_event('load', function()
    -- Validate the pointers..
    if (ahgo.auction_pointer == 0) then
        print('\31\200[\31\05' .. 'AH-Go'.. '\31\200]\30\01 ' .. '\30\68Failed to find required auction signature.\30\01');
        return;
    end 
    if (ahgo.shop_pointer == 0) then
        print('\31\200[\31\05' .. 'AH-Go'.. '\31\200]\30\01 ' .. '\30\68Failed to find required shop signature.\30\01');
        return;
    end

    -- Apply the auction house check patch..
    ahgo.auction_pointer        = ahgo.auction_pointer + 0x09;
    ahgo.auction_pointer_backup = ashita.memory.read_uint8(ahgo.auction_pointer);
    ashita.memory.write_uint8(ahgo.auction_pointer, 0xEB);

    -- Apply the shop check patch..  
    ahgo.shop_pointer           = ahgo.shop_pointer + 0x09;
    ahgo.shop_pointer_backup    = ashita.memory.read_uint8(ahgo.shop_pointer);
    ashita.memory.write_uint8(ahgo.shop_pointer, 0xEB);
    print(string.format('\31\200[\31\05' .. 'AH-Go'.. '\31\200] \31\130Functions patched; you should now be able to move while using the AH and shops!'));
end);

----------------------------------------------------------------------------------------------------
-- func: unload
-- desc: Event called when the addon is being unloaded.
----------------------------------------------------------------------------------------------------
ashita.register_event('unload', function()
    -- Restore the auction check patch..
    if (ahgo.auction_movement_check_backup ~= nil) then
        ashita.memory.write_uint8(ahgo.auction_pointer, ahgo.auction_pointer_backup);
    end

    -- Restore the shop check patch..
    if (ahgo.shop_movement_check_backup ~= nil) then
        ashita.memory.write_uint8(ahgo.shop_pointer, ahgo.shop_pointer_backup);
    end
end);

----------------------------------------------------------------------------------------------------
-- func: command
-- desc: Event called when a command was entered.
----------------------------------------------------------------------------------------------------
ashita.register_event('command', function(command, ntype)
    -- Get the arguments of the command..
    local args = command:args();
    
    -- Opens the auction house..
    if (args[1] == '/ah') then
        local packet = 
        { 
            0x4C, 0x1E, 0x00, 0x00, 0x02, 0xFF, 0x01, 0x00, 0x00, 0x00, 0x04, 0x00, 0x00, 0x00, 0x00, 0x00,
            0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
            0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
            0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00 
        };
        AddIncomingPacket(0x4C, packet);
        return true;
    end
    
    return false;
end);