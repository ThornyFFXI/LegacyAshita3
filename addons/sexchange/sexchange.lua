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
_addon.name     = 'sexchange';
_addon.version  = '3.0.0';

require 'common'

----------------------------------------------------------------------------------------------------
-- Variables
----------------------------------------------------------------------------------------------------
local sexchange     = { };
sexchange.race      = 5;
sexchange.hair      = 2;
sexchange.enabled   = false;

----------------------------------------------------------------------------------------------------
-- func: print_help
-- desc: Displays a help block for proper command usage.
----------------------------------------------------------------------------------------------------
local function print_help(cmd, help)
    -- Print the invalid format header..
    print('\31\200[\31\05' .. _addon.name .. '\31\200]\30\01 ' .. '\30\68Invalid format for command:\30\02 ' .. cmd .. '\30\01'); 

    -- Loop and print the help commands..
    for k, v in pairs(help) do
        print('\31\200[\31\05' .. _addon.name .. '\31\200]\30\01 ' .. '\30\68Syntax:\30\02 ' .. v[1] .. '\30\71 ' .. v[2]);
    end
end

---------------------------------------------------------------------------------------------------
-- func: command
-- desc: Event called when a command was entered.
---------------------------------------------------------------------------------------------------
ashita.register_event('command', function(command, ntype)
    -- Get the command arguments..
    local args = command:args();
    if (args[1] ~= '/sexchange') then
        return false;
    end

    -- Toggle sexchange on and off..
    if (#args == 1) then
        sexchange.enabled = not sexchange.enabled;
        local fmt = '\30\02Enabled';
        if (sexchange.enabled == false) then
            fmt = '\30\68Disabled';
        end
        print(string.format('\31\200[\31\05sexchange\31\200] \31\130SexChange is now: %s', fmt));
        return true;
    end

    -- Enable sexchange..
    if (#args >= 2 and args[2] == 'on') then
        sexchange.enabled = true;
        print(string.format('\31\200[\31\05sexchange\31\200] \31\130SexChange is now: %s', '\30\02Enabled'));
        return true;
    end

    -- Disable sexchange..
    if (#args >= 2 and args[2] == 'off') then
        sexchange.enabled = false;
        print(string.format('\31\200[\31\05sexchange\31\200] \31\130SexChange is now: %s', '\30\68Disabled'));
        return true;
    end

    -- Set the desired race..
    if (#args >= 3 and args[2] == 'race') then
        sexchange.race = tonumber(args[3]);
        print(string.format('\31\200[\31\05sexchange\31\200] \31\130Set race to: \30\02%d', tonumber(args[3])));
        return true;
    end

    -- Set the desired hair..
    if (#args >= 3 and args[2] == 'hair') then
        sexchange.hair = tonumber(args[3]);
        print(string.format('\31\200[\31\05sexchange\31\200] \31\130Set hair to: \30\02%d', tonumber(args[3])));
        return true;
    end

    -- Prints the addon help..
    print_help('/sexchange', {
        { '/sexchange',                 '- Toggles SexChange on and off.' },
        { '/sexchange on',              '- Turns SexChange on.' },
        { '/sexchange off',             '- Turns SexChange off.' },
        { '/sexchange race [raceid]',   '- Sets the race type to apply to the player.' },
        { '/sexchange hair [hairid]',   '- Sets the hair type to apply to the player.' },
    });
    return true;
end);

---------------------------------------------------------------------------------------------------
-- func: incoming_packet
-- desc: Called when our addon receives an incoming packet.
---------------------------------------------------------------------------------------------------
ashita.register_event('incoming_packet', function(id, size, data, modified, blocked)
    -- Do nothing if the packet is blocked..
    if (blocked == true) then return false; end
    if (sexchange.enabled == false) then return false; end

    -- Zone
    if (id == 0x0A) then
        local playerId = struct.unpack('L', data, 0x04 + 1);
        if (playerId == AshitaCore:GetDataManager():GetParty():GetMemberServerId(0)) then
            local packet = data:totable();
            packet[0x44 + 1] = sexchange.hair;
            packet[0x45 + 1] = sexchange.race;
            return packet;
        end
    end

    -- Character Update
    if (id == 0x0D) then
        local playerId = struct.unpack('L', data, 0x04 + 1);
        if (playerId == AshitaCore:GetDataManager():GetParty():GetMemberServerId(0)) then
            local packet = data:totable();
            if (packet[0x0A + 1] == 0x1F) then
                packet[0x48 + 1] = sexchange.hair;
                packet[0x49 + 1] = sexchange.race;
                return packet;
            end
        end
    end

    -- Character Jobs
    if (id == 0x1B) then
        local packet = data:totable();
        packet[0x04 + 1] = sexchange.race;
        return packet;
    end

    -- Character Appearance
    if (id == 0x51) then
        local packet = data:totable();
        packet[0x04 + 1] = sexchange.hair;
        packet[0x05 + 1] = sexchange.race;
        return packet;
    end

    return false;
end);