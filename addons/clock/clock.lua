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
_addon.name     = 'clock';
_addon.version  = '3.0.0';

require 'common'
require 'date'

----------------------------------------------------------------------------------------------------
-- Configurations
----------------------------------------------------------------------------------------------------
local default_config =
{
    font =
    {
        family      = 'Tahoma',
        size        = 10,
        color       = math.d3dcolor(255, 255, 255, 255),
        position    = { 1, 1 }
    },
    background =
    {
        color       = math.d3dcolor(128, 0, 0, 0),
        visible     = true
    },
    format      = '[%I:%M:%S]',
    separator   = ' - ',
    clocks      = { }
};
local clock_config = default_config;

----------------------------------------------------------------------------------------------------
-- func: load
-- desc: Event called when the addon is being loaded.
----------------------------------------------------------------------------------------------------
ashita.register_event('load', function()
    -- Load the configuration file..
    clock_config = ashita.settings.load_merged(_addon.path .. '/settings/settings.json', clock_config);

    -- Create the font object..
    local f = AshitaCore:GetFontManager():Create('__clock_addon');
    f:SetColor(clock_config.font.color);
    f:SetFontFamily(clock_config.font.family);
    f:SetFontHeight(clock_config.font.size);
    f:SetPositionX(clock_config.font.position[1]);
    f:SetPositionY(clock_config.font.position[2]);
    f:SetText('');
    f:SetVisibility(true);
    f:GetBackground():SetVisibility(clock_config.background.visible);
    f:GetBackground():SetColor(clock_config.background.color);
end);

----------------------------------------------------------------------------------------------------
-- func: unload
-- desc: Event called when the addon is being unloaded.
----------------------------------------------------------------------------------------------------
ashita.register_event('unload', function()
    -- Get the font object..
    local f = AshitaCore:GetFontManager():Get('__clock_addon');

    -- Update the configuration position..
    clock_config.font.position = { f:GetPositionX(), f:GetPositionY() };

    -- Save the configuration file..
    ashita.settings.save(_addon.path .. '/settings/settings.json', clock_config);

    -- Delete the font object..
    AshitaCore:GetFontManager():Delete('__clock_addon');
end);

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

----------------------------------------------------------------------------------------------------
-- func: command
-- desc: Event called when a command was entered.
----------------------------------------------------------------------------------------------------
ashita.register_event('command', function(command, ntype)
    -- Get the arguments of the command..
    local args = command:args();
    if (args[1] ~= '/time') then
        return false;
    end

    -- Adds a new timer to the list..
    if (#args == 4 and args[2] == 'add') then
        local offset = tonumber(args[3]);
        local name = args[4];
        
        table.insert(clock_config.clocks, { offset, name });
        return true;
    end
    
    -- Deletes an existing timer from the list..
    if (#args == 3 and args[2] == 'delete') then
        local offset = tonumber(args[3]);
        
        -- Loop the current table and delete all matching offsets..
        for x = #clock_config.clocks, 1, -1 do
            if (clock_config.clocks[x][1] == offset) then
                table.remove(clock_config.clocks, x);
            end
        end
        return true;
    end
    
    -- Sets the separator for the timestamp objects..
    if (#args == 3 and args[2] == 'separator') then
        clock_config.separator = args[3];
        return true;
    end
    
    -- Sets the color for the timestamp objects..
    if (#args == 6 and args[2] == 'color') then
        clock_config.color[1] = tonumber(args[3]);
        clock_config.color[2] = tonumber(args[4]);
        clock_config.color[3] = tonumber(args[5]);
        clock_config.color[4] = tonumber(args[6]);
        local f = AshitaCore:GetFontManager():Get('__clock_addon');
        if (f ~= nil) then
            local c = clock_config.color;
            f:SetColor(math.d3dcolor(c[1], c[2], c[3], c[4]));
        end
        return true;
    end

    -- Prints the addon help..
    print_help('/time', {
        { '/time add [offset] [name]',  '- Adds a new clock entry for the given time offset.' },
        { '/time delete [offset]',      '- Deletes a clock entry by its time offset.' },
        { '/time [separator]',          '- Sets the separator used between the clocks.' },
        { '/time color [a] [r] [g] [b]','- Sets the clocks font color.' },
    });
    return true;
end);

----------------------------------------------------------------------------------------------------
-- func: render
-- desc: Event called when the addon is being rendered.
----------------------------------------------------------------------------------------------------
ashita.register_event('render', function()
    -- Obtain the font object..
    local f = AshitaCore:GetFontManager():Get('__clock_addon');

    -- Ensure we have a clock table..
    if (f == nil or clock_config.clocks == nil or type(clock_config.clocks) ~= 'table') then
        return;
    end

    -- Build the table of timestamps..
    local timestamps = { };
    for k, v in pairs(clock_config.clocks) do
        local offset = tonumber(v[1]);
        if (offset == 0) then
            table.insert(timestamps, os.date(date():toutc():fmt(string.format('%s %s', clock_config.format, v[2]))));
        else
            table.insert(timestamps, os.date(date():toutc():addhours(offset):fmt(string.format('%s %s', clock_config.format, v[2]))));
        end
    end

    f:SetText(table.concat(timestamps, clock_config.separator));
end);