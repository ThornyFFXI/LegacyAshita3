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

_addon.author   = 'Hypnotoad';
_addon.name     = 'status';
_addon.version  = '3.0.0';

require 'common'
local StatusEffects = require('statuseffects');
local Party = {};

---------------------------------------------------------------------------------------------------
-- desc: Default Status configuration table.
---------------------------------------------------------------------------------------------------
local default_config =
{
	max_displayed = 10,
    font =
    {
        family      = 'Arial',
        size        = 10,
        color       = 0xFFFFFFFF,
        position    = { 100, 300 },
        bgcolor     = 0x80000000,
        bgvisible   = true,
    }
};
local configs = default_config;

---------------------------------------------------------------------------------------------------
-- func: load
-- desc: First called when our addon is loaded.
---------------------------------------------------------------------------------------------------
ashita.register_event('load', function()
    -- Load the configuration file..
	configs = ashita.settings.load_merged(_addon.path .. '/settings/settings.json', configs);

	local previous = 0;
	for i = 1, 5 do
		Party[i] = {};
		Party[i][1] = ''; -- party member name
		Party[i][2] = {}; -- buff name
		Party[i][3] = {}; -- buff id
		
		local name = string.format("__status_bar%d", i);
		local bar = AshitaCore:GetFontManager():Create(name);
		
		if (i == 1) then
			bar:SetPositionX(configs.font.position[1]);
			bar:SetPositionY(configs.font.position[2]);
		else
			bar:SetParent(previous);
			bar:SetAnchorParent(1); -- 1 = Right
			bar:SetPositionX(3);
			bar:SetPositionY(0);
		end
		
		bar:SetColor(configs.font.color);
		bar:SetFontFamily(configs.font.family);
		bar:SetFontHeight(configs.font.size);
		bar:SetBold(false);
		bar:GetBackground():SetColor(configs.font.bgcolor);
		bar:GetBackground():SetVisibility(configs.font.bgvisible);
		bar:SetVisibility(true);
		
		previous = bar;
		
		for j = 1, 32 do
			Party[i][3][j] = 0xFF;
		end
	end
end);

---------------------------------------------------------------------------------------------------
-- func: unload
-- desc: Called when our addon is unloaded.
---------------------------------------------------------------------------------------------------
ashita.register_event('unload', function()
	-- Get the font object..
    local f = AshitaCore:GetFontManager():Get('__status_bar1');
	
	-- Update the configuration position..
    configs.font.position = { f:GetPositionX(), f:GetPositionY() };
    
    -- Save the configuration file..
    ashita.settings.save(_addon.path .. '/settings/settings.json', configs);
	
	-- Delete the font objects..
	for i = 1, 5 do
		local name = string.format("__status_bar%d", i);
		AshitaCore:GetFontManager():Delete(name);
	end
end);

---------------------------------------------------------------------------------------------------
-- func: Render
-- desc: Called when our addon is rendered.
---------------------------------------------------------------------------------------------------
ashita.register_event('render', function()
	local Text = '';
	local limit = 0;
	
	for i = 1, 5 do
		local Text = '';
		local name = string.format("__status_bar%d", i);
		local bar = AshitaCore:GetFontManager():Get(name);
		
		for j = 1, 32 do
			if (limit >= configs.max_displayed) then
				break;
			end
			
			if (Party[i][3][j] ~= 0xFF) then
				if (Text ~= "") then
					Text = Text .. "\n";
				end
				
				Text = Text .. Party[i][2][j] .. " (" .. Party[i][1] .. ")";
				limit = limit + 1;
			end
		end
		
		bar:SetText(Text);
		Text = '';
	end
end);

---------------------------------------------------------------------------------------------------
-- func: incoming_packet
-- desc: Called when our addon receives an incoming packet.
---------------------------------------------------------------------------------------------------
ashita.register_event('incoming_packet', function(id, size, packet)
	-- Party Member's Status
	if (id == 0x76) then
		for i = 0, 4 do
			local userIndex = struct.unpack('H', packet, 8+1 + (i * 0x30));
			
			if (AshitaCore:GetDataManager():GetEntity():GetName(userIndex) ~= nil) then
			
				Party[i+1][1] = AshitaCore:GetDataManager():GetEntity():GetName(userIndex);
				
				for j = 0, 31 do
					local BitMask = bit.band(bit.rshift(struct.unpack('b', packet, bit.rshift(j, 2) + 0x0C + (i * 0x30) + 1), 2 * (j % 4)), 3);
					if (struct.unpack('b', packet, 0x14 + (i * 0x30) + j + 1) ~= -1 or BitMask > 0) then
						local buffid = bit.bor(struct.unpack('B', packet, 0x14 + (i * 0x30) + j + 1), bit.lshift(BitMask, 8));
						
						if (table.haskey(StatusEffects, buffid)) then
							Party[i+1][2][j+1] = AshitaCore:GetResourceManager():GetString("statusnames", buffid, 2);
							Party[i+1][3][j+1] = buffid;
						else
							Party[i+1][3][j+1] = 0xFF;
						end
					end
				end
			end
		end
	end
	
	return false;
end);