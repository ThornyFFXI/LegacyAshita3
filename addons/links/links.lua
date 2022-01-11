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
_addon.name     = 'links';
_addon.version  = '3.0.2';

require 'common'

----------------------------------------------------------------------------------------------------
-- Variables (ImGui)
----------------------------------------------------------------------------------------------------
local urls = { };
local variables =
{
    ['var_ShowLinksWindow'] = { nil, ImGuiVar_BOOLCPP, false },
};

----------------------------------------------------------------------------------------------------
-- func: ParseForLinks
-- desc: Parses a string for multiple urls.
----------------------------------------------------------------------------------------------------
local function ParseForLinks(msg, index)
    if (msg == nil) then return nil, 0; end
    
    -- Parse for http protocols..
    local start = msg:find('http://', index);
    if (start == nil) then
        start = msg:find('https://', index);
    end

    -- Parse for www..
    if (start == nil) then
        start = msg:find('www', index);
    end
    if (start == nil) then
        return nil;
    end

    -- Get the url..
    local urlEnd = msg:find(' ', start) or string.len(msg);
    local url = string.sub(msg, start, urlEnd);
    return url, urlEnd;
end

----------------------------------------------------------------------------------------------------
-- func: load
-- desc: Event called when the addon is being loaded.
----------------------------------------------------------------------------------------------------
ashita.register_event('load', function()
    -- Initialize the custom variables..
    for k, v in pairs(variables) do
        -- Create the variable..
        if (v[2] >= ImGuiVar_CDSTRING) then 
            variables[k][1] = imgui.CreateVar(variables[k][2], variables[k][3]);
        else
            variables[k][1] = imgui.CreateVar(variables[k][2]);
        end
        
        -- Set a default value if present..
        if (#v > 2 and v[2] < ImGuiVar_CDSTRING) then
            imgui.SetVarValue(variables[k][1], variables[k][3]);
        end        
    end
end);

----------------------------------------------------------------------------------------------------
-- func: unload
-- desc: Event called when the addon is being unloaded.
----------------------------------------------------------------------------------------------------
ashita.register_event('unload', function()
    -- Cleanup the custom variables..
    for k, v in pairs(variables) do
        if (variables[k][1] ~= nil) then
            imgui.DeleteVar(variables[k][1]);
        end
        variables[k][1] = nil;
    end
end);

----------------------------------------------------------------------------------------------------
-- func: command
-- desc: Event called when a command was entered.
----------------------------------------------------------------------------------------------------
ashita.register_event('command', function(command, ntype)
    local args = command:args();
    
    -- Toggle the links window..
    if (#args >= 1 and args[1] == '/links') then
        imgui.SetVarValue(variables['var_ShowLinksWindow'][1], not imgui.GetVarValue(variables['var_ShowLinksWindow'][1]));
        return true;
    end
    
    return false;
end);

---------------------------------------------------------------------------------------------------
-- func: incoming_packet
-- desc: Called when our addon receives an incoming packet.
---------------------------------------------------------------------------------------------------
ashita.register_event('incoming_packet', function(id, size, data)
    local msg = nil;

    -- 0x0017 - Chat
    if (id == 0x17) then
        -- Obtain the chat message from the packet..
        msg, _ = struct.unpack('s', data, 0x18 + 1);
    end
    
    -- 0x004D - Server Message
    if (id == 0x004D) then
        -- Get the packet message size..
        local s = struct.unpack('L', data, 0x14 + 1);
        
        -- Clamp the size to the max packet size..
        -- This is needed for DSP since it messes up chat alignment packets..
        local ss = math.clamp(s, 1, size - 0x18);
            
        -- Obtain the chat message from the packet..
        msg, _ = struct.unpack('c' .. ss, data, 0x18 + 1);
    end
    
    -- 0x00CA - Bazaar Message
    if (id == 0x00CA) then
        -- Obtain the chat message from the packet..
        msg, _ = struct.unpack('s', data, 0x04 + 1);
    end
    
    -- 0x00CC - Linkshell Message
    if (id == 0x00CC) then
        -- Obtain the chat message from the packet..
        msg, _ = struct.unpack('s', data, 0x08 + 1);
    end
    
    -- Parse the message for links..
    if (msg ~= nil) then
        local url, start = ParseForLinks(msg, 0);
        while url ~= nil do
            table.insert(urls, url);
            url, start = ParseForLinks(msg ,start);
        end
    end
    
    return false;
end);

----------------------------------------------------------------------------------------------------
-- func: render
-- desc: Event called when the addon is being rendered.
----------------------------------------------------------------------------------------------------
ashita.register_event('render', function()
    if (imgui.GetVarValue(variables['var_ShowLinksWindow'][1]) == false) then
        return;
    end

    imgui.SetNextWindowSize(300, 200, ImGuiSetCond_FirstUseEver);
    if (not imgui.Begin('Links', variables['var_ShowLinksWindow'][1])) then
        imgui.End();
        return;
    end
    
    if (imgui.Button('Clear Url List')) then
        urls = { };
    end
    imgui.Separator();
    for k, v in pairs(urls) do
        if (imgui.Button(string.format('%s##%s', v, k))) then
            ashita.misc.open_url(v);
        end
    end
    
    imgui.End();
end);