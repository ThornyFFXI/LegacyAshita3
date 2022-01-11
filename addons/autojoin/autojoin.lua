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

_addon.author   = 'atom0s (based on Lolwutt plugin)';
_addon.name     = 'autojoin';
_addon.version  = '3.0.0';

require 'common'

----------------------------------------------------------------------------------------------------
-- Default Configurations
----------------------------------------------------------------------------------------------------
local default_config =
{
    default = 'ignore',
    decline = { },
    join    = { },
    ignore  = { }
};

local autojoin_config = default_config;
local users = { };
local default_action = 2;

----------------------------------------------------------------------------------------------------
-- func: msg
-- desc: Prints out a message with the Nomad tag at the front.
----------------------------------------------------------------------------------------------------
local function msg(s)
    local txt = '\31\200[\31\05AutoJoin\31\200]\31\130 ' .. s;
    print(txt);
end

---------------------------------------------------------------------------------------------------
-- func: GetUserEntry
-- desc: Gets a users entry within the loaded user list.
---------------------------------------------------------------------------------------------------
local function GetUserEntry(name)
    for k, v in pairs(users) do
        if (v[1] == name) then
            return v;
        end
    end
    return nil;
end

----------------------------------------------------------------------------------------------------
-- func: load
-- desc: Event called when the addon is being loaded.
----------------------------------------------------------------------------------------------------
ashita.register_event('load', function()
    -- Save the default settings if they don't exist..
    if (not ashita.file.file_exists(_addon.path .. '/settings/settings.json')) then
        ashita.settings.save(_addon.path .. '/settings/settings.json', autojoin_config);
    end

    -- Load the configuration file..
    autojoin_config = ashita.settings.load_merged(_addon.path .. '/settings/settings.json', autojoin_config);
    
    -- Build a list of user types from the settings file..
    for k, v in pairs(autojoin_config.decline) do
        table.insert(users, { v:lower(), 0 });
    end
    for k, v in pairs(autojoin_config.join) do
        table.insert(users, { v:lower(), 1 });
    end
    for k, v in pairs(autojoin_config.ignore) do
        table.insert(users, { v:lower(), 2 });
    end

    -- Set the default action..
    if (autojoin_config.default == 'decline') then
        default_action = 0;
    elseif (autojoin_config.default == 'join') then
        default_action = 1;
    else
        default_action = 2;
    end
end);

---------------------------------------------------------------------------------------------------
-- func: incoming_packet
-- desc: Called when our addon receives an incoming packet.
---------------------------------------------------------------------------------------------------
ashita.register_event('incoming_packet', function(id, size, data, modified, blocked)
    -- Look for party request packets..
    if (id == 0xDC) then
        -- Obtain the inviter action..
        local name      = struct.unpack('s', data, 0x0C + 1);
        local user      = GetUserEntry(name:lower());
        local action    = default_action;

        -- Update the action based on the found user entry..
        if (user ~= nil) then
            action = user[2];
        end

        -- Handle the action..
        if (action ~= 2) then
            -- Rebuild the response packet..
            local packet = { 0x74, 0x04, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00 };
            packet[5] = action;
            AddOutgoingPacket(0x74, packet);

            if (action == 1) then
                msg('Accepting invite from: \30\03' .. name);
            else
                msg('Declined invite from: \30\03' .. name);
            end

            return true;
        end
    end

    return false;
end);