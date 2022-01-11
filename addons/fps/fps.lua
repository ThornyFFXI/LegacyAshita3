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
_addon.name     = 'FPS';
_addon.version  = '3.0.0';

require 'common'

----------------------------------------------------------------------------------------------------
-- FPS Configuration
----------------------------------------------------------------------------------------------------
local default_config =
{
    font =
    {
        family      = 'Arial',
        size        = 12,
        color       = math.d3dcolor(255, 255, 0, 0),
        position    = { 1, 1 }
    },
    format = 'FPS: %.1f'
};
local fps_config = default_config;

----------------------------------------------------------------------------------------------------
-- FPS Variables
----------------------------------------------------------------------------------------------------
local fps = { };
fps.count = 0;
fps.timer = 0;
fps.frame = 0;
fps.show  = true;

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
-- func: load
-- desc: Event called when the addon is being loaded.
----------------------------------------------------------------------------------------------------
ashita.register_event('load', function()
    -- Load the configuration file..
    fps_config = ashita.settings.load_merged(_addon.path .. '/settings/fps.json', fps_config);

    -- Create the font object..
    local f = AshitaCore:GetFontManager():Create('__fps_addon');
    f:SetColor(fps_config.font.color);
    f:SetFontFamily(fps_config.font.family);
    f:SetFontHeight(fps_config.font.size);
    f:SetPositionX(fps_config.font.position[1]);
    f:SetPositionY(fps_config.font.position[2]);
    f:SetText('');
    f:SetVisibility(fps.show);
end);

----------------------------------------------------------------------------------------------------
-- func: unload
-- desc: Event called when the addon is being unloaded.
----------------------------------------------------------------------------------------------------
ashita.register_event('unload', function()
    -- Get the font object..
    local f = AshitaCore:GetFontManager():Get('__fps_addon');

    -- Update the configuration position..
    fps_config.font.position = { f:GetPositionX(), f:GetPositionY() };

    -- Save the configuration file..
    ashita.settings.save(_addon.path .. '/settings/fps.json', fps_config);

    -- Delete the font object..
    AshitaCore:GetFontManager():Delete('__fps_addon');
end);

----------------------------------------------------------------------------------------------------
-- func: command
-- desc: Event called when a command was entered.
----------------------------------------------------------------------------------------------------
ashita.register_event('command', function(command, ntype)
    -- Get the arguments of the command..
    local args = command:args();
    if (args[1] ~= '/fps') then
        return false;
    end

    -- Toggle the FPS visibility..
    if (#args == 1 or args[2] == 'show') then
        fps.show = not fps.show;
        return true;
    end

    -- Set the FPS color..
    if (#args >= 6 and args[2] == 'color') then
        font_config.font.color = math.d3dcolor(tonumber(args[3]), tonumber(args[4]), tonumber(args[5]),tonumber(args[6]));
        local f = AshitaCore:GetFontManager():Get('__fps_addon');
        if (f ~= nil) then f:SetColor(font_config.font.color); end
        return true;
    end

    -- Set the font family and height..
    if (#args >= 4 and args[2] == 'font') then
        font_config.font.family = args[3];
        font_config.font.size = tonumber(args[4]);
        local f = AshitaCore:GetFontManager():Get('__fps_addon');
        if (f ~= nil) then 
            f:SetFontFamily(font_config.font.family);
            f:SetFontHeight(font_config.font.size); 
        end
        return true;
    end

    -- Set the FPS divisor..
    if (#args >= 2 and tonumber(args[2]) > 0) then
        local pointer = ashita.memory.findpattern('FFXiMain.dll', 0, '81EC000100003BC174218B0D', 0, 0);
        if (pointer == 0) then
            print('[FPS] Could not locate the required signature to patch the FPS divisor!');
            return true;
        end

        -- Read into the pointer..
        local addr = ashita.memory.read_uint32(pointer + 0x0C);
        addr = ashita.memory.read_uint32(addr);

        -- Set the new FPS divisor..
        ashita.memory.write_uint32(addr + 0x30, tonumber(args[2]));
        print(string.format('\31\200[\31\05FPS\31\200] \31\130Set FPS divisor to: \30\02%d', tonumber(args[2])));
        return true;
    end

    -- Prints the addon help..
    print_help('/fps', {
        { '/fps show',                  '- Toggles the FPS display on and off.' },
        { '/fps color [a] [r] [g] [b]', '- Sets the FPS display color.' },
        { '/fps font [name] [size]',    '- Sets the FPS display font family and height.' },
        { '/fps [num]',                 '- Sets the FPS divisor. (1 = 60FPS, 2 = 30FPS, etc.)' },
    });
    return true;
end);

----------------------------------------------------------------------------------------------------
-- func: render
-- desc: Event called when the addon is being rendered.
----------------------------------------------------------------------------------------------------
ashita.register_event('render', function()
    -- Get the font object..
    local f = AshitaCore:GetFontManager():Get('__fps_addon');
    if (f == nil) then return; end

    -- Set the font visibility..
    f:SetVisibility(fps.show);

    -- Skip calculations if font is disabled..
    if (fps.show == false) then return; end

    -- Calculate the current FPS..
    fps.count = fps.count + 1;
    if (os.time() >= fps.timer + 1) then
        fps.frame = fps.count;
        fps.count = 0;
        fps.timer = os.time();
    end

    -- Update the FPS font..
    f:SetText(string.format(fps_config.format, fps.frame));
end);