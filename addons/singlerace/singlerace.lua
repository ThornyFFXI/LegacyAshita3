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
_addon.name     = 'singlerace';
_addon.version  = '3.0.0';

require 'common'

----------------------------------------------------------------------------------------------------
-- Variables
----------------------------------------------------------------------------------------------------
local singlerace    = { };
singlerace.race     = 5;
singlerace.hair     = 2;
singlerace.pcon     = true;
singlerace.npcon    = true;

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
    if (args[1] ~= '/singlerace') then
        return false;
    end

    -- Set the desired race..
    if (#args >= 3 and args[2] == 'race') then
        singlerace.race = tonumber(args[3]);
        print(string.format('\31\200[\31\05singlerace\31\200] \31\130Set forced race to: \30\02%d', tonumber(args[3])));
        return true;
    end

    -- Set the desired hair..
    if (#args >= 3 and args[2] == 'hair') then
        singlerace.hair = tonumber(args[3]);
        print(string.format('\31\200[\31\05singlerace\31\200] \31\130Set forced hair to: \30\02%d', tonumber(args[3])));
        return true;
    end

    -- Set the pc mode on or off..
    if (#args >= 2 and args[2] == 'pc') then
        local enabled = false;
        if (#args >= 3) then
            enabled = args[3] == 'on' or args[3] == 'enabled' or args[3] == '1';
        else
            enabled = not singlerace.pcon;
        end 

        singlerace.pcon = enabled;
        print(string.format('\31\200[\31\05singlerace\31\200] \31\130Set PC enabled to to: \30\02%s', tostring(singlerace.pcon)));
        return true;
    end

    -- Set the npc mode on or off..
    if (#args >= 2 and args[2] == 'npc') then
        local enabled = false;
        if (#args >= 3) then
            enabled = args[3] == 'on' or args[3] == 'enabled' or args[3] == '1';
        else
            enabled = not singlerace.npcon;
        end 

        singlerace.npcon = enabled;
        print(string.format('\31\200[\31\05singlerace\31\200] \31\130Set NPC enabled to to: \30\02%s', tostring(singlerace.npcon)));
        return true;
    end

    -- Prints the addon help..
    print_help('/singlerace', {
        { '/singlerace race [raceid]',      '- Sets the enforced race type to apply to other players.' },
        { '/singlerace hair [hairid]',      '- Sets the enforced hair type to apply to other players.' },
        { '/singlerace npc',                '- Toggles if the NPC mode is enabled or disabled.' },
        { '/singlerace npc [on|1|enabled]', '- Toggles if the NPC mode is enabled or disabled.' },
        { '/singlerace pc',                 '- Toggles if the PC mode is enabled or disabled.' },
        { '/singlerace pc [on|1|enabled]',  '- Toggles if the PC mode is enabled or disabled.' },
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

    -- Look for player update packets..
    if (id == 0x000D and singlerace.pcon) then
        local packet = data:totable();
        if (packet[0x0A + 1] == 0x1F) then
            packet[0x48 + 1] = singlerace.hair;
            packet[0x49 + 1] = singlerace.race;
            return packet;
        end
    end

    -- Look for entity update packets..
    if (id == 0x000E and singlerace.npcon) then
        local packet = data:totable();
        if (packet[0x0A + 1] == 0x57) then
            -- This does not work on all NPCs due to how some of them are handled.
            -- In the future this addon may support every npc, mob, etc. but for now
            -- a good majority are working with just this small packet override.
            packet[0x32 + 1] = singlerace.hair;
            packet[0x33 + 1] = singlerace.race;
            return packet;
        end
    end

    return false;
end);