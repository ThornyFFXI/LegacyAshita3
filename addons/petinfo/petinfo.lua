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
_addon.name     = 'petinfo';
_addon.version  = '3.0.0';

require 'common'

----------------------------------------------------------------------------------------------------
-- func: render
-- desc: Called when the addon is rendering.
----------------------------------------------------------------------------------------------------
ashita.register_event('render', function()
    -- Obtain the local player..
    local player = GetPlayerEntity();
    if (player == nil) then
        return;
    end
    
    -- Obtain the players pet index..
    if (player.PetTargetIndex == 0) then
        return;
    end
    
    -- Obtain the players pet..
    local pet = GetEntity(player.PetTargetIndex);
    if (pet == nil) then
        return;
    end
    
    -- Display the pet information..
    imgui.SetNextWindowSize(200, 100, ImGuiSetCond_Always);
    if (imgui.Begin('PetInfo') == false) then
        imgui.End();
        return;
    end
    
    local pettp = AshitaCore:GetDataManager():GetPlayer():GetPetTP();
    local petmp = AshitaCore:GetDataManager():GetPlayer():GetPetMP();
    
    imgui.Text(pet.Name);
    imgui.Separator();
    
    -- Set the progressbar color for health..
    imgui.PushStyleColor(ImGuiCol_PlotHistogram, 1.0, 0.61, 0.61, 0.6);
    imgui.Text('HP:');
    imgui.SameLine();
    imgui.PushStyleColor(ImGuiCol_Text, 1.0, 1.0, 1.0, 1.0);
    imgui.ProgressBar(pet.HealthPercent / 100, -1, 14);
    imgui.PopStyleColor(2);
    
    imgui.PushStyleColor(ImGuiCol_PlotHistogram, 0.0, 0.61, 0.61, 0.6);
    imgui.Text('MP:');
    imgui.SameLine();
    imgui.PushStyleColor(ImGuiCol_Text, 1.0, 1.0, 1.0, 1.0);
    imgui.ProgressBar(petmp / 100, -1, 14);
    imgui.PopStyleColor(2);
    
    imgui.PushStyleColor(ImGuiCol_PlotHistogram, 0.4, 1.0, 0.4, 0.6);
    imgui.Text('TP:');
    imgui.SameLine();
    imgui.PushStyleColor(ImGuiCol_Text, 1.0, 1.0, 1.0, 1.0);
    imgui.ProgressBar(pettp / 3000, -1, 14, tostring(pettp));
    imgui.PopStyleColor(2);
    
    imgui.End();
end);