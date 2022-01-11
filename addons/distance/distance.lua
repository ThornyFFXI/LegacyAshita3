--[[
* Ashita - Copyright (c) 2014 - 2017 atom0s [atom0s@live.com]
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
_addon.name     = 'distance';
_addon.version  = '3.0.0';

require 'common'
require 'ffxi.targets'

----------------------------------------------------------------------------------------------------
-- Configurations
----------------------------------------------------------------------------------------------------
local default_config = 
{
    font =
    {
        family      = 'Arial',
        size        = 16,
        color       = 0xFFFFFFFF,
        position    = { -180, 20 },
    },
    show_name   = false,
    show_id     = false,
    show_id_hex = false
};
local distance_config = default_config;

----------------------------------------------------------------------------------------------------
-- func: load
-- desc: Event called when the addon is being loaded.
----------------------------------------------------------------------------------------------------
ashita.register_event('load', function()
    -- Load the configuration file..
    distance_config = ashita.settings.load_merged(_addon.path .. '/settings/settings.json', distance_config);

    -- Create the font object..
    local f = AshitaCore:GetFontManager():Create('__distance_addon');
    f:SetColor(distance_config.font.color);
    f:SetFontFamily(distance_config.font.family);
    f:SetFontHeight(distance_config.font.size);
    f:SetBold(true);
    f:SetPositionX(distance_config.font.position[1]);
    f:SetPositionY(distance_config.font.position[2]);
    f:SetText('0.0');
    f:SetVisibility(true);
end);

----------------------------------------------------------------------------------------------------
-- func: unload
-- desc: Event called when the addon is being unloaded.
----------------------------------------------------------------------------------------------------
ashita.register_event('unload', function()
    -- Get the font object..
    local f = AshitaCore:GetFontManager():Get('__distance_addon');

    -- Update the configuration position..
    distance_config.font.position = { f:GetPositionX(), f:GetPositionY() };

    -- Save the configuration file..
    ashita.settings.save(_addon.path .. '/settings/settings.json', distance_config);

    -- Delete the font object..
    AshitaCore:GetFontManager():Delete('__distance_addon');
end);

----------------------------------------------------------------------------------------------------
-- func: render
-- desc: Event called when the addon is being rendered.
----------------------------------------------------------------------------------------------------
ashita.register_event('render', function()
    -- Get the font object..
    local f = AshitaCore:GetFontManager():Get('__distance_addon');
    if (f == nil) then return; end

    -- Ensure we have a valid player..
    local party = AshitaCore:GetDataManager():GetParty();
    if (party:GetMemberActive(0) == false or party:GetMemberServerId(0) == 0) then
        f:SetText('');
        return;
    end

    -- Ensure we have a valid target..
    local target = ashita.ffxi.targets.get_target('t');
    if (target == nil or target.Name == '' or target.TargetIndex == 0) then
        f:SetText('');
        return;
    end
    
    local str = string.format('%.1f', math.sqrt(target.Distance));
    
    -- Append the name..
    if (distance_config.show_name == true) then
        str = str .. ' ' .. target.Name;
    end
    
    -- Append the server id (decimal)..
    if (distance_config.show_id == true) then
        str = string.format('%s [%d]', str, target.ServerId);
    end
    
    -- Append the server id (hex)..
    if (distance_config.show_id_hex == true) then
        str = string.format('%s [%08X]', str, target.ServerId);
    end
    
    -- Set the distance text..
    f:SetText(str);
end);