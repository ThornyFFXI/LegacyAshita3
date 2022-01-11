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

ashita              = ashita or { };
ashita.ffxi         = ashita.ffxi or { };
ashita.ffxi.weather = ashita.ffxi.weather or { };

-- Scan for patterns..
ashita.ffxi.weather.pointer = ashita.memory.findpattern('FFXiMain.dll', 0, '66A1????????663D????72', 0x02, 0);

-- Signature validation..
if (ashita.ffxi.weather.pointer == 0) then
    error('weather.lua -- signature validation failed!');
end

----------------------------------------------------------------------------------------------------
-- func: get_weather
-- desc: Returns the current weather id.
----------------------------------------------------------------------------------------------------
local function get_weather()
    local pointer = ashita.memory.read_uint32(ashita.ffxi.weather.pointer);
    return ashita.memory.read_uint8(pointer);
end 
ashita.ffxi.weather.get_weather = get_weather;