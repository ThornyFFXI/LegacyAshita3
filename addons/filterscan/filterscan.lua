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
_addon.name     = 'filterscan';
_addon.version  = '3.0.1';

require 'common'
require 'mobparse'

-- Get the proper install folder..
local polVersion = AshitaCore:GetConfigurationManager():get_uint32("boot_config", "pol_version", 2);
if (polVersion == 4) then
    polVersion = 3;
end

---------------------------------------------------------------------------------------------------
-- Variables
---------------------------------------------------------------------------------------------------
local FilterScan = 
{
    FFXiPath    = ashita.file.get_install_dir(polVersion, 1) .. '\\',
    MobList     = { },
    ZoneDatList = require('zonemoblist'),
    Filter      = { }
};

---------------------------------------------------------------------------------------------------
-- func: UpdateZoneMobList
-- desc: Updates the zone mob list.
---------------------------------------------------------------------------------------------------
local function UpdateZoneMobList(zoneId)
    -- Attempt to get the dat file for this entry..
    local dat = FilterScan.ZoneDatList[zoneId];
    if (dat == nil) then
        FilterScan.MobList = { };
        return false;
    end

    -- Attempt to parse the dat file..
    FilterScan.MobList = ParseZoneMobDat(FilterScan.FFXiPath .. dat);
    return true;
end

---------------------------------------------------------------------------------------------------
-- func: MobNameFromTargetIndex
-- desc: Returns the mob name from the given target index.
---------------------------------------------------------------------------------------------------
local function MobNameFromTargetIndex(targetIndex)
    if (FilterScan.MobList == nil) then
        return nil;
    end
    for _, v in pairs(FilterScan.MobList) do
        if (v[1] == targetIndex) then
            return v[2];
        end
    end
    return nil;
end

----------------------------------------------------------------------------------------------------
-- func: load
-- desc: Event called when the addon is being loaded.
----------------------------------------------------------------------------------------------------
ashita.register_event('load', function()
    -- Parse the players current zone if we are in-game..
    if (AshitaCore:GetDataManager():GetParty():GetMemberActive(0) > 0) then
        local zoneId = AshitaCore:GetDataManager():GetParty():GetMemberZone(0);
        UpdateZoneMobList(zoneId);
        print('Loaded zone mobs.')
    end    
end);

----------------------------------------------------------------------------------------------------
-- func: command
-- desc: Event called when a command was entered.
----------------------------------------------------------------------------------------------------
ashita.register_event('command', function(command, ntype)
    -- Ensure we should handle this command..
    local args = command:args();
    if (args[1] ~= '/filterscan') then
        return false;
    end
    
    -- the list of targets gets reset anytime the cmd is called. calling w/o params will 'disable' the filter
    FilterScan.Filter = { }
    
    -- pull the target mobs from the arg and split them into the list
    local filter = (string.gsub(command, '/filterscan', '')):trim()
    
    for target in string.gmatch(filter, "[^,]+") do
        if (target ~= nil) then
            table.insert(FilterScan.Filter, target:lower():trim())
        end
    end
    
    print(string.format('[FilterScan] Set new filter to: %s', filter));
    return true;
end);

---------------------------------------------------------------------------------------------------
-- func: incoming_packet
-- desc: Called when our addon receives an incoming packet.
---------------------------------------------------------------------------------------------------
ashita.register_event('incoming_packet', function(id, size, data)
    -- Check for zone-in packets..
    if (id == 0x0A) then
        -- Are we zoning into a mog house..
        if (struct.unpack('b', data, 0x80 + 1) == 1) then
            return false;
        end
    
        -- Pull the zone id from the packet..
        local zoneId = struct.unpack('H', data, 0x30 + 1);
        if (zoneId == 0) then
            zoneId = struct.unpack('H', data, 0x42 + 1);
        end
        
        -- Update our mob list..
        UpdateZoneMobList(zoneId);
    end

    -- Handle incoming widescan result packets..
    if (id == 0xF4) then
        local targetIndex   = struct.unpack('H', data, 0x04 + 1);
        local mobName       = MobNameFromTargetIndex(targetIndex);

        if (mobName == nil) then
            return false;
        else
        
            -- there is nothing in the filter list, so you get all the entities
            if (table.getn(FilterScan.Filter) == 0) then
                return false
            end
            
            local mob = mobName:lower()
            local idx_s = tostring(targetIndex)
            
            for _, target in pairs(FilterScan.Filter) do
                if (mob:find(target) ~= nil or targetIndex == tonumber(target, 16) or idx_s == target) then
                    -- the mob has matched an item in the filter
                    return false
                end
            end

            -- Ignore all non-matching entries..
            return true;
        end
        
        -- This should never happen here..
        return true;
    end

    return false;
end);