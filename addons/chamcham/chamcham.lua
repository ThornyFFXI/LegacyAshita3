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
_addon.name     = 'ChamCham';
_addon.version  = '3.0.0';

require 'common'

imgui = ashita.gui;

----------------------------------------------------------------------------------------------------
-- Variables
----------------------------------------------------------------------------------------------------
local chamcham = { };
chamcham.offset = 0x660;

----------------------------------------------------------------------------------------------------
-- ImGui Object Variables
----------------------------------------------------------------------------------------------------
local variables =
{
    ['var_ShowEditor']      = { nil, ImGuiVar_BOOLCPP, true },
    ['var_ColorNpc']        = { nil, ImGuiVar_FLOATARRAY, 4 },
    ['var_ColorPc']         = { nil, ImGuiVar_FLOATARRAY, 4 },
    ['var_ColorMonster']    = { nil, ImGuiVar_FLOATARRAY, 4 },
};

----------------------------------------------------------------------------------------------------
-- func: load
-- desc: Event called when the addon is being loaded.
----------------------------------------------------------------------------------------------------
ashita.register_event('load', function()
    -- Initialize the ImGui variables..
    for k, v in pairs(variables) do
        if (v[2] >= ImGuiVar_CDSTRING) then 
            variables[k][1] = imgui.CreateVar(variables[k][2], variables[k][3]);
        else
            variables[k][1] = imgui.CreateVar(variables[k][2]);
        end
        if (#v > 2 and v[2] < ImGuiVar_CDSTRING) then
            imgui.SetVarValue(variables[k][1], variables[k][3]);
        end        
    end

    imgui.SetVarValue(variables['var_ShowEditor'][1], true);
    imgui.SetVarValue(variables['var_ColorNpc'][1], 1.0, 0.0, 0.0, 1.0);
    imgui.SetVarValue(variables['var_ColorMonster'][1], 0.0, 1.0, 0.0, 1.0);
    imgui.SetVarValue(variables['var_ColorPc'][1], 0.0, 0.0, 1.0, 1.0);
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
    -- Get the arguments of the command..
    local args = command:args();
    if (args[1] ~= '/chamcham') then
        return false;
    end

    imgui.SetVarValue(variables['var_ShowEditor'][1], not imgui.GetVarValue(variables['var_ShowEditor'][1]));
    return true;
end);

----------------------------------------------------------------------------------------------------
-- func: apply_cham
-- desc: Applies the cham coloring to the given entity.
----------------------------------------------------------------------------------------------------
local function apply_cham(e)
    local f = e.SpawnFlags;

    -- PC 
    if (bit.band(f, 0x0001) == 0x0001) then
        local c1 = imgui.GetVarValue(variables['var_ColorPc'][1]);
        local c2 = math.d3dcolor(c1[4] * 255, c1[3] * 255, c1[2] * 255, c1[1] * 255);
        ashita.memory.write_uint32(e.WarpPointer + chamcham.offset, c2);        
    -- NPC (Friendly)
    elseif (bit.band(f, 0x0002) == 0x0002) then
        local c1 = imgui.GetVarValue(variables['var_ColorMonster'][1]);
        local c2 = math.d3dcolor(c1[4] * 255, c1[3] * 255, c1[2] * 255, c1[1] * 255);
        ashita.memory.write_uint32(e.WarpPointer + chamcham.offset, c2);
    -- NPC (Monster)
    else
        local c1 = imgui.GetVarValue(variables['var_ColorNpc'][1]);
        local c2 = math.d3dcolor(c1[4] * 255, c1[3] * 255, c1[2] * 255, c1[1] * 255);
        ashita.memory.write_uint32(e.WarpPointer + chamcham.offset, c2);
    end
end

----------------------------------------------------------------------------------------------------
-- func: render
-- desc: Event called when the addon is being rendered.
----------------------------------------------------------------------------------------------------
ashita.register_event('render', function()
    for x = 0, 2303 do
        local e = GetEntity(x);
        if (e ~= nil and e.WarpPointer ~= 0) then
            apply_cham(e);
        end
    end
    
    -- Don't render the editor if its hidden..
    if (not imgui.GetVarValue(variables['var_ShowEditor'][1])) then
        return;
    end

    -- Begin rendering the the editor UI.. 
    imgui.SetNextWindowSize(400, 92, ImGuiSetCond_Always);
    if (not imgui.Begin('ChamCham Editor', variables['var_ShowEditor'][1])) then
        imgui.End();
        return;
    end
    imgui.ColorEdit4('pc', variables['var_ColorPc'][1], true);
    imgui.ColorEdit4('npc', variables['var_ColorNpc'][1], true);
    imgui.ColorEdit4('monster', variables['var_ColorMonster'][1], true);
    imgui.End();
end);