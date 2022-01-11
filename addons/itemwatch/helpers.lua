--[[
 * ItemWatch - Copyright (c) 2016 atom0s [atom0s@live.com]
 *
 * This work is licensed under the Creative Commons Attribution-NonCommercial-NoDerivatives 4.0 International License.
 * To view a copy of this license, visit http://creativecommons.org/licenses/by-nc-nd/4.0/ or send a letter to
 * Creative Commons, PO Box 1866, Mountain View, CA 94042, USA.
 *
 * By using ItemWatch, you agree to the above license and its terms.
 *
 *      Attribution - You must give appropriate credit, provide a link to the license and indicate if changes were
 *                    made. You must do so in any reasonable manner, but not in any way that suggests the licensor
 *                    endorses you or your use.
 *
 *   Non-Commercial - You may not use the material (ItemWatch) for commercial purposes.
 *
 *   No-Derivatives - If you remix, transform, or build upon the material (ItemWatch), you may not distribute the
 *                    modified material. You are, however, allowed to submit the modified works back to the original
 *                    ItemWatch project in attempt to have it added to the original project.
 *
 * You may not apply legal terms or technological measures that legally restrict others
 * from doing anything the license permits.
 *
 * No warranties are given.
]]--

require 'common'
require 'imguidef'

----------------------------------------------------------------------------------------------------
-- func: normalize_path
-- desc: Normalizes the slashes in a given path.
----------------------------------------------------------------------------------------------------
function normalize_path(path)
    -- Convert all slashes to a normalized slash..
    local p = path:gsub('/', '\\');

    -- Locate all double slashes..
    local index = p:find('\\');
    while (index ~= nil) do
        if (p:sub(index+1, index+1) == '\\') then
            p = p:remove(index);
            index = p:find('\\');
        else
            index = p:find('\\', index + 1);
        end
    end
    return p;
end

----------------------------------------------------------------------------------------------------
-- func: trim
-- desc: Trims a string of whitespace.
----------------------------------------------------------------------------------------------------
function trim(s, compact)
    if (compact == false) then
        return s:match("^%s*(.-)%s*$");
    else
        return s:match("^(.-)%s*$");
    end
end

----------------------------------------------------------------------------------------------------
-- func: colorize_string
-- desc: Colorizes a string with the given D3DCOLOR.
----------------------------------------------------------------------------------------------------
function colorize_string(s, c)
    local a = bit.rshift(bit.band(c, 0xFF000000), 24);
    local r = bit.rshift(bit.band(c, 0x00FF0000), 16);
    local g = bit.rshift(bit.band(c, 0x0000FF00), 8);
    local b = bit.band(c, 0x000000FF);
    return string.format('|c%02X%02X%02X%02X|%s|r', a, r, g, b, s);
end

----------------------------------------------------------------------------------------------------
-- func: color_to_argb
-- desc: Converts a color to its argb values.
----------------------------------------------------------------------------------------------------
function color_to_argb(c)
    local a = bit.rshift(bit.band(c, 0xFF000000), 24);
    local r = bit.rshift(bit.band(c, 0x00FF0000), 16);
    local g = bit.rshift(bit.band(c, 0x0000FF00), 8);
    local b = bit.band(c, 0x000000FF);

    return a, r, g, b;
end

----------------------------------------------------------------------------------------------------
-- func: colortable_to_int
-- desc: Converts an imgui color table to a D3DCOLOR int.
----------------------------------------------------------------------------------------------------
function colortable_to_int(t)
    local a = t[4];
    local r = t[1] * 255;
    local g = t[2] * 255;
    local b = t[3] * 255;

    -- Handle 3 and 4 color tables..
    if (a == nil) then
        a = 255;
    else
        a = a * 255;
    end

    return math.d3dcolor(a, r, g, b);
end

----------------------------------------------------------------------------------------------------
-- func: msg
-- desc: Prints out a message with the Itemwatch tag at the front.
----------------------------------------------------------------------------------------------------
function msg(s)
    local txt = '\30\1[\31\05ItemWatch\30\1]\30\01 ' .. s;
    print(txt);
end

----------------------------------------------------------------------------------------------------
-- func: show_help
-- desc: Shows a tooltip with ImGui.
----------------------------------------------------------------------------------------------------
function show_help(desc)
    imgui.TextDisabled('(?)');
    if (imgui.IsItemHovered()) then
        imgui.SetTooltip(desc);
    end
end