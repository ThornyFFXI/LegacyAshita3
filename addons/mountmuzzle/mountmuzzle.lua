--[[
Copyright © 2018, Sjshovan (Apogee)
All rights reserved.

Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions are met:

    * Redistributions of source code must retain the above copyright
      notice, this list of conditions and the following disclaimer.
    * Redistributions in binary form must reproduce the above copyright
      notice, this list of conditions and the following disclaimer in the
      documentation and/or other materials provided with the distribution.
    * Neither the name of Mount Muzzle nor the
      names of its contributors may be used to endorse or promote products
      derived from this software without specific prior written permission.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
DISCLAIMED. IN NO EVENT SHALL Sjshovan (Apogee) BE LIABLE FOR ANY
DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
(INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
(INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
--]]

_addon.name = 'Mount Muzzle'
_addon.description = 'Change or remove the default mount music.'
_addon.author = 'Sjshovan (Apogee) sjshovan@gmail.com'
_addon.version = '0.9.0'
_addon.commands = {'/mountmuzzle', '/muzzle', '/mm'}

require('constants')
require('helpers')

require 'common'

local default_settings = {    
	muzzle = "silent"
}

local settings = default_settings;

local defaults = {
    muzzle = muzzles.silent.name
}

local needs_inject = false

local help = {
    commands = {
        buildHelpSeperator('=', 26),
        buildHelpTitle('Commands'),
        buildHelpSeperator('=', 26),
        buildHelpCommandEntry('list', 'Display the available muzzle types.'),
        buildHelpCommandEntry('set <muzzle>', 'Set the current muzzle to the given muzzle type.'),
        buildHelpCommandEntry('get', 'Display the current muzzle.'),
        buildHelpCommandEntry('default', 'Set the current muzzle to the default (Silent).'),
        buildHelpCommandEntry('unload', 'Unload Mount Muzzle.'),
        buildHelpCommandEntry('reload', 'Reload Mount Muzzle.'),
        buildHelpCommandEntry('about', 'Display information about Mount Muzzle.'),
        buildHelpCommandEntry('help', 'Display Mount Muzzle commands.'),
        buildHelpSeperator('=', 26),
    },
    types = {
        buildHelpSeperator('=', 23),
        buildHelpTitle('Types'),
        buildHelpSeperator('=', 23),
        buildHelpTypeEntry(muzzles.silent.name, muzzles.silent.description),
        buildHelpTypeEntry(muzzles.mount.name, muzzles.mount.description),
        buildHelpTypeEntry(muzzles.chocobo.name, muzzles.chocobo.description),
        buildHelpTypeEntry(muzzles.zone.name, muzzles.zone.description),
        buildHelpSeperator('=', 23),
    },
    about = {
        buildHelpSeperator('=', 23),
        buildHelpTitle('About'),
        buildHelpSeperator('=', 23),
        buildHelpTypeEntry('Name', _addon.name),
        buildHelpTypeEntry('Description', _addon.description),
        buildHelpTypeEntry('Author', _addon.author),
        buildHelpTypeEntry('Version', _addon.version),
        buildHelpSeperator('=', 23),
    },
    aliases = {
        muzzles = {
            s = muzzles.silent.name,
            m = muzzles.mount.name,
            c = muzzles.chocobo.name,
            z = muzzles.zone.name
        }
    }
}

function display_help(table_help)
    for index, command in pairs(table_help) do
        displayResponse(command)
    end
end

function getMuzzle()
    return settings.muzzle
end

function getPlayerBuffs() 
    return AshitaCore:GetDataManager():GetPlayer():GetBuffs()
end

function resolveCurrentMuzzle()
    local current_muzzle = getMuzzle()
    
    if not muzzleValid(current_muzzle) then
        current_muzzle = muzzles.silent.name
        setMuzzle(current_muzzle)
        displayResponse(
            string.format(
                'Note: Muzzle found in settings was not valid and is now set to the default (%s\30\1).', 
                strColor('Silent', colors.secondary)
            ),
            colors.warn
        )
    end
    
    return muzzles[current_muzzle]
end

function setMuzzle(muzzle)
    settings.muzzle = muzzle
    ashita.settings.save(_addon.path .. '/settings/settings.json', settings);
end

function playerInReive()
    return tableContains(getPlayerBuffs(), player.buffs.reiveMark)
end

function playerIsMounted()
    local entity = AshitaCore:GetDataManager():GetEntity()

    if entity then
        return tableContains(
            player.statuses.mounted, entity:GetStatus(player.statuses.types.mount)
        ) or tableContains(
            getPlayerBuffs(), player.buffs.mounted
        )
    end
    
    return false 
end

function muzzleValid(muzzle)
    return muzzles[muzzle] ~= nil
end

function injectMuzzleMusic()
    injectMusic(music.types.mount, resolveCurrentMuzzle().song)
end

function injectMusic(bgmType, songID)
    local bgm_packet = struct.pack("bbbbbbb", 
        0x5F, 0x04, 0x00, 0x00, 0x04, 0x00, songID, 0x00
    ):totable();
    AddIncomingPacket(packets.inbound.music_change.id, bgm_packet)
end

function requestInject()
    needs_inject = true
end

function handleInjectionNeeds() 
    if needs_inject and playerIsMounted() then
        injectMuzzleMusic()
        needs_inject = false; 
    end
end

function tryInject()
    requestInject()
    handleInjectionNeeds()
end

ashita.register_event('load', function()
    settings = ashita.settings.load_merged(
        _addon.path .. '/settings/settings.json', settings
    )   
    tryInject();
end)

ashita.register_event('unload', function() 
    injectMusic(music.types.mount, muzzles.zone.song)
end)

ashita.register_event('command', function(command, ntype)

    local command_args = command:lower():args()

    if not tableContains(_addon.commands, command_args[1]) then
        return false
    end 

    local respond = false
    local response_message = ''
    local success = true
 
    if command_args[2] == 'list' or command_args[2] == 'l' then
        display_help(help.types)

    elseif command_args[2] == 'set' or command_args[2] == 's' then
        respond = true
        
        local muzzle = tostring(command_args[3]):lower()
        local from_alias = help.aliases.muzzles[muzzle]
        
        if (from_alias ~= nil) then
            muzzle = from_alias
        end

        if not muzzleValid(muzzle) then
            success = false
            response_message = 'Muzzle type not recognized.'
        else
            requestInject()
            setMuzzle(muzzle)
            response_message = string.format(
                'Updated current muzzle to %s.', 
                strColor(ucFirst(muzzle), colors.secondary)
            )
        end

    elseif command_args[2] == 'get' or command_args[2] == 'g' then
        respond = true
        response_message = string.format(
            'Current muzzle is %s.', 
            strColor(ucFirst(getMuzzle()), colors.secondary)
        )

    elseif command_args[2] == 'default' or command_args[2] == 'd' then
        respond = true
        requestInject()

        setMuzzle(muzzles.silent.name)
        response_message = string.format(
            'Updated current muzzle to the default (%s\30\1).', 
            strColor('Silent', colors.secondary)
        )

    elseif command_args[2] == 'reload' or command_args[2] == 'r' then
        AshitaCore:GetChatManager():QueueCommand('/addon reload mountmuzzle', 1)
    
    elseif command_args[2] == 'unload' or command_args[2] == 'u' then
        respond = true
        response_message = 'Thank you for using Mount Muzzle. Goodbye.'
        AshitaCore:GetChatManager():QueueCommand('/addon unload mountmuzzle', 1)

    elseif command_args[2] == 'about' or command_args[2] == 'a' then
        display_help(help.about)
        
    elseif command_args[2] == 'help' or command_args[2] == 'h' then
        display_help(help.commands)

    else
        display_help(help.commands)
    
    end

    if respond then
        displayResponse(
            buildCommandResponse(response_message, success)
        )
    end
    
    handleInjectionNeeds()

    return false
end)

ashita.register_event('incoming_packet', function(id, size, packet, modified_packet, blocked_packet)
    if id == packets.inbound.music_change.id then
        local music_type = struct.unpack('H', packet, packets.inbound.music_change.offsets.type + 1)
   
        if music_type == music.types.mount then
            injectMusic(music.types.mount, resolveCurrentMuzzle().song)
            return true               
        end

        tryInject()
    end
	
    return false
end)