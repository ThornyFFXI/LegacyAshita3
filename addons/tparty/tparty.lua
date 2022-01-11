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
_addon.name     = 'tparty';
_addon.version  = '3.0.0';

require 'common'
require 'ffxi.targets'

----------------------------------------------------------------------------------------------------
-- Variables
----------------------------------------------------------------------------------------------------
local tparty = { };
tparty.targethpp_str    = '__tparty_targethpp'; -- The base name used for a string object.
tparty.partytpp_str     = '__tparty_partytpp';  -- The base name used for a string object.

----------------------------------------------------------------------------------------------------
-- func: load
-- desc: Event called when the addon is being loaded.
----------------------------------------------------------------------------------------------------
ashita.register_event('load', function()
    -- Pull the current configuration info for position calculations..
    tparty.window_x = AshitaCore:GetConfigurationManager():get_int32('boot_config', 'window_x', 800);
    tparty.window_y = AshitaCore:GetConfigurationManager():get_int32('boot_config', 'window_y', 800);
    tparty.menu_x   = AshitaCore:GetConfigurationManager():get_int32('boot_config', 'menu_x', 0);
    tparty.menu_y   = AshitaCore:GetConfigurationManager():get_int32('boot_config', 'menu_y', 0);

    -- Ensure the menu sizes have a valid resolution..
    if (tparty.menu_x <= 0) then
        tparty.menu_x = tparty.window_x;
    end
    if (tparty.menu_y <= 0) then
        tparty.menu_y = tparty.window_y;
    end

    -- Calculate the scaling based on the resolution..
    tparty.scale_x = tparty.window_x / tparty.menu_x;
    tparty.scale_y = tparty.window_y / tparty.menu_y;

    -- Create the target hp % text object..
    local f = AshitaCore:GetFontManager():Create(tparty.targethpp_str);
    f:SetColor(0xFFFFFFFF);
    f:SetFontFamily('Arial');
    f:SetFontHeight(8 * tparty.scale_y);
    f:SetBold(true);
    f:SetRightJustified(true);
    f:SetPositionX(0);
    f:SetPositionY(0);
    f:SetText('0.0');
    f:SetLocked(true);
    f:SetVisibility(true);

    -- Create the individual party member labels..
    for x = 0, 17 do
        f = AshitaCore:GetFontManager():Create(string.format('%s%d', tparty.partytpp_str, x));
        f:SetColor(0xFFFFFFFF);
        f:SetFontFamily('Arial');
        f:SetFontHeight(8 * tparty.scale_y);
        f:SetBold(true);
        f:SetRightJustified(true);
        f:SetPositionX(0);
        f:SetPositionY(0);
        f:SetText(string.format('TP: %d', x));
        f:SetLocked(true);
        f:SetVisibility(true);
    end
end);

----------------------------------------------------------------------------------------------------
-- func: unload
-- desc: Event called when the addon is being unloaded.
----------------------------------------------------------------------------------------------------
ashita.register_event('unload', function()
    -- Cleanup the font objects..
    AshitaCore:GetFontManager():Delete(tparty.targethpp_str);
    for x = 0, 17 do
        AshitaCore:GetFontManager():Delete(string.format('%s%d', tparty.partytpp_str, x));
    end
end);

----------------------------------------------------------------------------------------------------
-- func: render
-- desc: Event called when the addon is being rendered.
----------------------------------------------------------------------------------------------------
ashita.register_event('render', function()
    -- Obtain needed information managers..
    local party     = AshitaCore:GetDataManager():GetParty();
    local target    = AshitaCore:GetDataManager():GetTarget();

    -- Calculate offset position starting points..
    local posx = tparty.window_x - (101 * tparty.scale_x);
    local posy = tparty.window_y - (34 * tparty.scale_y);
    local curx = 0;
    local cury = 0;

    -- Locate the players zone..
    local zone = party:GetMemberZone(0);

    -- Handle the players local party..
    for x = 0, 5 do
        -- Get the current player slot font object..
        local f = AshitaCore:GetFontManager():Get(string.format('%s%d', tparty.partytpp_str, x));

        -- Ensure the player is valid to render information for..
        if (x ~= 0 and zone ~= party:GetMemberZone(x) or party:GetMemberActive(x) == 0) then
            f:SetVisibility(false);
        else
            -- Calculate the needed position of the font..
            curx = posx;
            cury = posy - ((party:GetAllianceParty0MemberCount() - 1 - x) * (20 * tparty.scale_y));

            -- Update the font object..
            local tp = party:GetMemberCurrentTP(x);
            f:SetPositionX(curx);
            f:SetPositionY(cury);
            f:SetText(tostring(tp));
            f:SetVisibility(true);
            if (tp >= 1000) then
                f:SetColor(0xFF00FF00);
            else
                f:SetColor(0xFFFFFFFF);
            end
        end
    end

    -- Calculate the alliance offsets..
    local posx_a0 = posx;
    local posy_a0 = tparty.window_y - (389 * tparty.scale_y);
    local posx_a1 = posx;
    local posy_a1 = tparty.window_y - (288 * tparty.scale_y);

    -- Handle the alliance party information..
    for x = 6, 17 do
        curx = 0;
        cury = 0;

        -- Calculate the alliance position..
        if ((x >= 6) and (x < 12)) then
            curx = posx_a0;
            cury = posy_a0 + (((x - 6) * 16) * tparty.scale_y);
        else
            curx = posx_a1;
            cury = posy_a1 + (((x - 12) * 16) * tparty.scale_y);
        end

        -- Get the current player slot font object..
        local f = AshitaCore:GetFontManager():Get(string.format('%s%d', tparty.partytpp_str, x));
        local tp = party:GetMemberCurrentTP(x);
        f:SetPositionX(curx);
        f:SetPositionY(cury);
        f:SetText(tostring(tp));
        if (tp >= 1000) then
            f:SetColor(0xFF00FF00);
        else
            f:SetColor(0xFFFFFFFF);
        end

        -- Set the visibility of the party members information..
        if (party:GetMemberActive(x) == 0 or zone ~= party:GetMemberZone(x)) then
            f:SetVisibility(false);
        else
            f:SetVisibility(true);
        end
    end

    -- Obtain the current target..
    local target = ashita.ffxi.targets.get_target('t');
    if (target == nil) then
        f = AshitaCore:GetFontManager():Get(tparty.targethpp_str);
        f:SetText('0');
        f:SetVisibility(false);
    else
        curx = posx - 2;
        cury = posy - (((party:GetAllianceParty0MemberCount() - 1) * 21) + 34) * tparty.scale_y;

        f = AshitaCore:GetFontManager():Get(tparty.targethpp_str);
        f:SetPositionX(curx);
        f:SetPositionY(cury);
        f:SetText(tostring(target.HealthPercent));
        f:SetVisibility(true);
    end
end);