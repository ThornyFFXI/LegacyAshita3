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
_addon.name     = 'ImGui Style';
_addon.version  = '3.0.0';

require 'common'

----------------------------------------------------------------------------------------------------
-- Variables
----------------------------------------------------------------------------------------------------
local show_style_window = nil;

---------------------------------------------------------------------------------------------------
-- func: SaveImGuiStyle
-- desc: Saves the current ImGui style for the current player.
---------------------------------------------------------------------------------------------------
local function SaveImGuiStyle()
    -- Obtain the local player entity..
    local p = GetPlayerEntity();
    if (p == nil) then return; end;
    
    -- Ensure we have a name..
    if (p.Name == nil or string.len(p.Name) == 0) then
        return;
    end
    
    -- Obtain the current style..
    local s = imgui.style;
    
    -- Build a style block to save..
    local f = { };
    f.Alpha                     = s.Alpha;
    f.WindowPadding             = { s.WindowPadding.x, s.WindowPadding.y };
    f.WindowMinSize             = { s.WindowMinSize.x, s.WindowMinSize.y };
    f.WindowRounding            = s.WindowRounding;
    f.WindowTitleAlign          = s.WindowTitleAlign;
    f.ChildWindowRounding       = s.ChildWindowRounding;
    f.FramePadding              = { s.FramePadding.x, s.FramePadding.y };
    f.FrameRounding             = s.FrameRounding;
    f.ItemSpacing               = { s.ItemSpacing.x, s.ItemSpacing.y };
    f.ItemInnerSpacing          = { s.ItemInnerSpacing.x, s.ItemInnerSpacing.y };
    f.TouchExtraPadding         = { s.TouchExtraPadding.x, s.TouchExtraPadding.y };
    f.IndentSpacing             = s.IndentSpacing;
    f.ColumnsMinSpacing         = s.ColumnsMinSpacing;
    f.ScrollbarSize             = s.ScrollbarSize;
    f.ScrollbarRounding         = s.ScrollbarRounding;
    f.GrabMinSize               = s.GrabMinSize;
    f.GrabRounding              = s.GrabRounding;
    f.DisplayWindowPadding      = { s.DisplayWindowPadding.x, s.DisplayWindowPadding.y };
    f.DisplaySafeAreaPadding    = { s.DisplaySafeAreaPadding.x, s.DisplaySafeAreaPadding.y };
    f.AntiAliasedLines          = s.AntiAliasedLines;
    f.AntiAliasedShapes         = s.AntiAliasedShapes;
    f.CurveTessellationTol      = s.CurveTessellationTol;

    f.colors = { };
    for x = 0, ImGuiCol_ModalWindowDarkening do
        f.colors[x] = { s.Colors[x].x, s.Colors[x].y, s.Colors[x].z, s.Colors[x].w };
    end
    
    -- Save the style..
    ashita.settings.save(_addon.path .. 'settings/' .. p.Name .. '.json', f);

    print('[ImGuiStyle] Saved player UI configurations!');
end

---------------------------------------------------------------------------------------------------
-- func: LoadImGuiStyle
-- desc: Loads the current players style.
---------------------------------------------------------------------------------------------------
local function LoadImGuiStyle(name)
    local f = ashita.settings.load(_addon.path .. 'settings/' .. name .. '.json', f);
    if (f == nil) then return; end
    
    local s = imgui.style;

    s.Alpha                     = f.Alpha;
    s.WindowPadding             = ImVec2(f.WindowPadding[1], f.WindowPadding[2]);
    s.WindowMinSize             = ImVec2(f.WindowMinSize[1], f.WindowMinSize[2]);
    s.WindowRounding            = f.WindowRounding;
    s.WindowTitleAlign          = f.WindowTitleAlign;
    s.ChildWindowRounding       = f.ChildWindowRounding;
    s.FramePadding              = ImVec2(f.FramePadding[1], f.FramePadding[2]);
    s.FrameRounding             = f.FrameRounding;
    s.ItemSpacing               = ImVec2(f.ItemSpacing[1], f.ItemSpacing[2]);
    s.ItemInnerSpacing          = ImVec2(f.ItemInnerSpacing[1], f.ItemInnerSpacing[2]);
    s.TouchExtraPadding         = ImVec2(f.TouchExtraPadding[1], f.TouchExtraPadding[2]);
    s.IndentSpacing             = f.IndentSpacing;
    s.ColumnsMinSpacing         = f.ColumnsMinSpacing;
    s.ScrollbarSize             = f.ScrollbarSize;
    s.ScrollbarRounding         = f.ScrollbarRounding;
    s.GrabMinSize               = f.GrabMinSize;
    s.GrabRounding              = f.GrabRounding;
    s.DisplayWindowPadding      = ImVec2(f.DisplayWindowPadding[1], f.DisplayWindowPadding[2]);
    s.DisplaySafeAreaPadding    = ImVec2(f.DisplaySafeAreaPadding[1], f.DisplaySafeAreaPadding[2]);
    s.AntiAliasedLines          = f.AntiAliasedLines;
    s.AntiAliasedShapes         = f.AntiAliasedShapes;
    s.CurveTessellationTol      = f.CurveTessellationTol;
    
    for x = 0, ImGuiCol_ModalWindowDarkening do
        ashita.gui.stylecolor(x, ImVec4(f.colors[tostring(x)][1], f.colors[tostring(x)][2], f.colors[tostring(x)][3], f.colors[tostring(x)][4]));
    end
end

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
    show_style_window = imgui.CreateVar(1);
    
    -- Obtain the local player entity..
    local p = GetPlayerEntity();
    if (p == nil) then return; end;
    
    -- Ensure we have a name..
    if (p.Name == nil or string.len(p.Name) == 0) then
        return;
    end
    
    -- Load the current players settings..
    LoadImGuiStyle(p.Name);
end);

----------------------------------------------------------------------------------------------------
-- func: unload
-- desc: Event called when the addon is being unloaded.
----------------------------------------------------------------------------------------------------
ashita.register_event('unload', function()
    if (show_style_window ~= nil) then
        imgui.DeleteVar(show_style_window);
    end
end);

----------------------------------------------------------------------------------------------------
-- func: command
-- desc: Event called when a command was entered.
----------------------------------------------------------------------------------------------------
ashita.register_event('command', function(command, ntype)
    local args = command:args();
    
    -- Ensure this is an imguistyle command..
    if (args[1] ~= '/imguistyle') then
        return false;
    end
    
    -- Toggles the editor..
    if (#args == 1 or args[2] == 'show') then
        if (show_style_window ~= nil) then
            imgui.SetVarValue(show_style_window, not imgui.GetVarValue(show_style_window));
        end
        return true;
    end
    
    -- Saves the style..
    if (#args == 2 and args[2] == 'save') then
        SaveImGuiStyle();    
        return true;
    end

    print_help('/imguistyle', {
        { '/imguistyle show', '- Toggles the ImGui style editor window on and off.' },
        { '/imguistyle save', '- Saves the current style to the players personal settings file.' },
    });
    return true;
end);

----------------------------------------------------------------------------------------------------
-- func: render
-- desc: Event called when the addon is being rendered.
----------------------------------------------------------------------------------------------------
ashita.register_event('render', function()
    if (show_style_window == nil) then
        return;
    end
    
    if (imgui.GetVarValue(show_style_window) == true) then
        imgui.Begin('Style Editor');
        imgui.ShowStyleEditor();
        imgui.End();
    end
end);

---------------------------------------------------------------------------------------------------
-- func: incoming_packet
-- desc: Called when our addon receives an incoming packet.
---------------------------------------------------------------------------------------------------
ashita.register_event('incoming_packet', function(id, size, data)
    -- Look for zoning / login packets to load
    -- player specific configs..
    if (id == 0x000A) then
        -- Get the players name and load their config..
        local name = struct.unpack('s', data, 0x84 + 1);
        LoadImGuiStyle(name);
    end

    return false;
end);