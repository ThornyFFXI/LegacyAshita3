--[[
 * Nomad - Copyright (c) 2016 atom0s [atom0s@live.com]
 *
 * This work is licensed under the Creative Commons Attribution-NonCommercial-NoDerivatives 4.0 International License.
 * To view a copy of this license, visit http://creativecommons.org/licenses/by-nc-nd/4.0/ or send a letter to
 * Creative Commons, PO Box 1866, Mountain View, CA 94042, USA.
 *
 * By using Nomad, you agree to the above license and its terms.
 *
 *      Attribution - You must give appropriate credit, provide a link to the license and indicate if changes were
 *                    made. You must do so in any reasonable manner, but not in any way that suggests the licensor
 *                    endorses you or your use.
 *
 *   Non-Commercial - You may not use the material (Nomad) for commercial purposes.
 *
 *   No-Derivatives - If you remix, transform, or build upon the material (Nomad), you may not distribute the
 *                    modified material. You are, however, allowed to submit the modified works back to the original
 *                    Nomad project in attempt to have it added to the original project.
 *
 * You may not apply legal terms or technological measures that legally restrict others
 * from doing anything the license permits.
 *
 * No warranties are given.
]]--


_addon.author   = 'atom0s';
_addon.name     = 'Nomad';
_addon.version  = '3.0.0';

require 'common'

----------------------------------------------------------------------------------------------------
-- Variables
----------------------------------------------------------------------------------------------------
local NOMAD_POINTER         = 0x00;
local ZONE_FLAGS_OFFSET1    = 0x09;
local ZONE_FLAGS_OFFSET2    = 0x17;
local ZONE_FLAGS_OFFSET3    = 0x00;
local ZONE_FLAGS_POINTER    = 0x00;

----------------------------------------------------------------------------------------------------
-- func: msg
-- desc: Prints out a message with the Nomad tag at the front.
----------------------------------------------------------------------------------------------------
local function msg(s)
    local txt = '\31\200[\31\05Nomad\31\200]\31\130 ' .. s;
    print(txt);
end

----------------------------------------------------------------------------------------------------
-- func: err
-- desc: Prints out an error message with the Nomad tag at the front.
----------------------------------------------------------------------------------------------------
local function err(s)
    local txt = '\31\200[\31\05Nomad\31\200]\31\39 ' .. s;
    print(txt);
end

----------------------------------------------------------------------------------------------------
-- func: load
-- desc: Event called when the addon is being loaded.
----------------------------------------------------------------------------------------------------
ashita.register_event('load', function()
    -- Locate the mog house check pointer..
    local pointer = ashita.memory.findpattern('FFXiMain.dll', 0, '0544FE00000FBF2925FFFF00003BC5????4283C10283FA04', 0x00, 0x00);
    if (pointer == 0) then
        err('Failed to find required pointer. (1)');
        return;
    end
    NOMAD_POINTER = pointer;

    -- Locate the zone flags pointer..
    pointer = ashita.memory.findpattern('FFXiMain.dll', 0, '8B8C24040100008B90????????0BD18990????????8B15????????8B82', 0x00, 0x00);
    if (pointer == 0) then
        err('Failed to find required pointer. (2)');
        return;
    end

    -- Obtain the offset from the function..
    local offset = ashita.memory.read_uint32(pointer + ZONE_FLAGS_OFFSET1);
    if (offset == 0) then
        err('Failed to read required offset. (2)');
        return;
    end
    ZONE_FLAGS_OFFSET3 = offset;

    -- Obtain the pointer to the zone flags..
    pointer = ashita.memory.read_uint32(pointer + ZONE_FLAGS_OFFSET2);
    if (pointer == 0) then
        err('Failed to read required pointer. (2)');
        return;
    end
    ZONE_FLAGS_POINTER = pointer;
end);

---------------------------------------------------------------------------------------------------
-- func: command
-- desc: Event called when a command was entered.
---------------------------------------------------------------------------------------------------
ashita.register_event('command', function(command, ntype)
    -- Get the command arguments..
    local args = command:args();

    -- Enable nomad mode..
    if (#args >= 2 and args[1] == '/nomad' and args[2] == 'on') then
        -- Validate the zone flags pointer information..
        if (ZONE_FLAGS_POINTER == 0 or ZONE_FLAGS_OFFSET3 == 0) then
            err('Pointer information is invalid; cannot continue.');
            return;
        end

        -- Read the pointers current value..
        local pointer = ashita.memory.read_uint32(ZONE_FLAGS_POINTER);
        if (pointer == 0) then
            err('Current zone is not loaded or is invalid.');
            return;
        end

        -- Validate the mog house function information..
        if (NOMAD_POINTER == 0) then
            err('Failed to find required pointer.');
            return;
        end
        
        -- Apply the mog house bit to the flags..
        local zoneflags = ashita.memory.read_uint32(pointer + ZONE_FLAGS_OFFSET3);
        if (bit.band(zoneflags, 0x100) == 0) then
            ashita.memory.write_uint32(pointer + ZONE_FLAGS_OFFSET3, bit.bor(zoneflags, 0x100));
        end 

        -- Enable the zone as a mog house..
        ashita.memory.write_uint8(NOMAD_POINTER + 0x0F, 0xEB);
        msg('Mog house mode has been: \31\04Enabled');
        msg('You can now access your mog house via the main menu.');
        return true;
    end

    -- Disable nomad mode..
    if (#args >= 2 and args[1] == '/nomad' and args[2] == 'off') then
        -- Validate the zone flags pointer information..
        if (ZONE_FLAGS_POINTER == 0 or ZONE_FLAGS_OFFSET3 == 0) then
            err('Pointer information is invalid; cannot continue.');
            return;
        end

        -- Read the pointers current value..
        local pointer = ashita.memory.read_uint32(ZONE_FLAGS_POINTER);
        if (pointer == 0) then
            err('Current zone is not loaded or is invalid.');
            return;
        end

        -- Validate the mog house function information..
        if (NOMAD_POINTER == 0) then
            err('Failed to find required pointer.');
            return;
        end
        
        -- Remove the mog house bit from the flags..
        local zoneflags = ashita.memory.read_uint32(pointer + ZONE_FLAGS_OFFSET3);
        if (bit.band(zoneflags, 0x100) == 0x100) then
            ashita.memory.write_uint32(pointer + ZONE_FLAGS_OFFSET3, bit.band(zoneflags, bit.bnot(0x100)));
        end

        -- Remove mog house patch..
        ashita.memory.write_uint8(NOMAD_POINTER + 0x0F, 0x74);
        msg('Mog house mode has been: \31\04Disabled');
        return true;
    end

    return false;
end);