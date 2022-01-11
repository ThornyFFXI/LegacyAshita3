--[[
 *	The MIT License (MIT)
 *
 *	Copyright (c) 2014 Vicrelant
 *	
 *	Permission is hereby granted, free of charge, to any person obtaining a copy
 *	of this software and associated documentation files (the "Software"), to 
 *	deal in the Software without restriction, including without limitation the 
 *	rights to use, copy, modify, merge, publish, distribute, sublicense, and/or 
 *	sell copies of the Software, and to permit persons to whom the Software is 
 *	furnished to do so, subject to the following conditions:
 *	
 *	The above copyright notice and this permission notice shall be included in 
 *	all copies or substantial portions of the Software.
 *	
 *	THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR 
 *	IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, 
 *	FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE 
 *	AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 *	LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING 
 *	FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER 
 *	DEALINGS IN THE SOFTWARE.
]]--

_addon.author   = 'Vicrelant';
_addon.name     = 'pbar';
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
        name        = 'Arial',
        size        = 10,
        color       = 0xFFFFFFFF,
        position    = { 7, 120 },
        bgcolor     = 0x80000000,
        bgvisible   = true,
		bold		= true
    },
	color =
	{
		hp_color	= 'FFFFFFFF',
		tp_color	= 'FFFFFFFF',
		tp_color_99	= 'FF00FF00',
		hp_color_75	= 'FFFFFF00',
		hp_color_50	= 'FFFFA500',
		hp_color_25	= 'FFFF0000',
		mp_color	= 'FFFFFFFF',
		mp_color_75	= 'FFFFFF00',
		mp_color_50	= 'FFFFA500',
		mp_color_25	= 'FFFF0000',
	}
};
local pbar_config = default_config;

----------------------------------------------------------------------------------------------------
-- func: load
-- desc: Event called when the addon is being loaded.
----------------------------------------------------------------------------------------------------
ashita.register_event('load', function()
    -- Load the settings..
	pbar_config = ashita.settings.load_merged(_addon.path .. 'settings/pbar.json', pbar_config);

	-- Create our font object..
	local f = AshitaCore:GetFontManager():Create( '__pbar_addon' );
    f:SetBold( pbar_config.font.bold );
    f:SetColor( pbar_config.font.color );
    f:SetFontFamily( pbar_config.font.name );
    f:SetFontHeight( pbar_config.font.size );
    f:SetPositionX( pbar_config.font.position[1] );
    f:SetPositionY( pbar_config.font.position[2] );
	f:SetText( '' );
    f:SetVisibility( false );
	f:GetBackground():SetColor( pbar_config.font.bgcolor );
    f:GetBackground():SetVisibility( pbar_config.font.bgvisible );
end);

----------------------------------------------------------------------------------------------------
-- func: unload
-- desc: Event called when the addon is being unloaded.
----------------------------------------------------------------------------------------------------
ashita.register_event('unload', function()
    -- Save the configuration..
    ashita.settings.save(_addon.path .. 'settings/pbar.json', pbar_config);
    
    -- Unload our font object..
    AshitaCore:GetFontManager():Delete( '__pbar_addon' );
end);

----------------------------------------------------------------------------------------------------
-- func: render
-- desc: Event called when the addon is being rendered.
----------------------------------------------------------------------------------------------------
ashita.register_event('render', function()
	local f    	= AshitaCore:GetFontManager():Create( '__pbar_addon' );
    local player= AshitaCore:GetDataManager():GetPlayer();
	local pet	= ashita.ffxi.targets.get_target('pet');
	
	-- Ensure we have a valid player..
	
	if (pet == nil) then
		f:SetVisibility( false );
		return;
	end
	
	local pettp		= player:GetPetTP()/10;
	local petmp     = player:GetPetMP();
	
	------------------------------------
	-- change color when TP is above 99%
	------------------------------------
	if (pettp > 99) then
		tp_color = pbar_config.color.tp_color_99;
	else
		tp_color = pbar_config.color.tp_color;
	end
	
	------------------------------------
	-- change color when HP is below 75%
	------------------------------------
	if (pet.HealthPercent < 25) then
		hp_color = pbar_config.color.hp_color_25;
	elseif (pet.HealthPercent < 50) then
		hp_color = pbar_config.color.hp_color_50;
	elseif (pet.HealthPercent < 75) then
		hp_color = pbar_config.color.hp_color_75;
	else
		hp_color = pbar_config.color.hp_color;
	end
	
	------------------------------------
	-- change color when MP is below 75%
	------------------------------------
	if (petmp < 25) then
		mp_color = pbar_config.color.mp_color_25;
	elseif (petmp < 50) then
		mp_color = pbar_config.color.mp_color_50;
	elseif (petmp < 75) then
		mp_color = pbar_config.color.mp_color_75;
	else
		mp_color = pbar_config.color.mp_color;
	end

	f:SetVisibility( true );
	
	-----------------------------------
	-- Format and output to the screen.
	-----------------------------------
	f:SetText(string.format('%s HP:[|c%s|%d%%|r] TP:[|c%s|%d%%|r] MP:[|c%s|%d%%|r]', 
		pet.Name, 
		hp_color, pet.HealthPercent, 
		tp_color, player:GetPetTP() / 10, 
		mp_color, petmp));	
end);