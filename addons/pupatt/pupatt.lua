--[[
* Ashita - Copyright (c) 2014 - 2020 atom0s [atom0s@live.com]
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

_addon.author   = 'Tornac';
_addon.name     = 'pupatt';
_addon.version  = '1.12';

---------------------------------
--DO NOT EDIT BELOW THIS LINE
---------------------------------

require 'common'
require 'ffxi.recast'
require 'logging'
require 'timer'

--------------------------------------------------------------
-- Default settings.
--------------------------------------------------------------
currentProfile  = { };
attachmentQueue = { };  -- Table to hold commands queued for sending
objDelay        = 0.65; -- The delay to prevent spamming packets.
objTimer        = 0;    -- The current time used for delaying packets.
unequip         = 0x00;
pupSub          = 0x00;
offset          = 0x04;

inProgress      = false; -- packet sending is in progress.
queOffset       = 1; -- smoother experience for packets.
defaultAtt      = false;

pupattProfiles = { }; -- table for holding attachment profiles
petlessZones   = {50,235,234,224,284,233,70,257,251,14,242,250,226,245,
                 237,249,131,53,252,231,236,246,232,240,247,243,223,248,230,
                 26,71,244,239,238,241,256,257}

---------------------------------------------------------------
--try to load  file when addon is loaded
---------------------------------------------------------------

ashita.register_event('load', function()
    load_pupattSettings();
end);

---------------------------------------------------------------
-- sees if any values are in a given table.
---------------------------------------------------------------

function contains(table, val)
   for i=1,#table do
      if table[i] == val then 
         return true
      end
   end
   return false;
end;

------------------------------------------------------------------------------------------------
-- desc: Getting pup information from packets for subsequent equipment changes.
----------------------------------------------------------------------------------------------------

ashita.register_event('incoming_packet', function(id, size, packet)
    -- Party Member's Status
    if (id == 0x044) then
        DiffPack = struct.unpack('B', packet, 0x05 + 1);
        equippedOffset = 1; -- Increase by one byte every loop
        if (DiffPack == 0) then
        -- Unpack 14 bytes and set the slotid:attachmentid into currentAttachments table
            for i = 1, 14 do
                attachmentId = string.format("0x%X" , struct.unpack('B', packet, 0x08 + equippedOffset));
                currentAttachments[i] = attachmentId;
                equippedOffset = equippedOffset + 1;
            end
        end
    end
    return false;
end);

------------------------------------------------------------------------------------------------
-- desc: Adds all the attachements from the given profile.
----------------------------------------------------------------------------------------------------

--Pass in a slot ID + hex id of the Attachment
-- Slot ID 1 = Head, 2=frame, 3-14 = attachment slots
function addAttachment(slot, id) 
    slots = {0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00};
    slots[slot] = id;
    local attach = struct.pack('I2I2BBBBBBI2BBBBBBBBBBBBBB', 0x5302, 0x0000, id, 0x00, unequip, 0x00, 0x12, pupSub, 0x0000, slots[1],slots[2],slots[3],slots[4],slots[5],slots[6],slots[7],slots[8],slots[9],slots[10],slots[11],slots[12],slots[13],slots[14]):totable();
    table.insert(attachmentQueue, { 0x102, attach});
end;

------------------------------------------------------------------------------------------------
-- desc: Clearing all the attachment out of the puppet.
----------------------------------------------------------------------------------------------------
 
function clearAttachments() 
    local player    = GetPlayerEntity();
    local pet       = GetEntity(player.PetTargetIndex);

    if(pet == nil) then 
        print ("Clearing Attachments");
        slots = {0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00};
        for slot,id in pairs(currentAttachments) do 
            slots[slot] = id;
        end
        slots[1] = 0x00;
        slots[2] = 0x00;
        local unattach = struct.pack('I2I2BBBBBBI2BBBBBBBBBBBBBB', 0x5302, 0x0000, 0x00, 0x00, 0x01, 0x00, 0x12, pupSub, 0x0000, slots[1],slots[2],slots[3],slots[4],slots[5],slots[6],slots[7],slots[8],slots[9],slots[10],slots[11],slots[12],slots[13],slots[14]):totable();
        table.insert(attachmentQueue, { 0x102, unattach});
    else
        print("Puppet still out please despawn to unequip attachments.")
    end
end;

----------------------------------------------------------------------------------------------------
-- desc: Pup attachment struct.packing.
----------------------------------------------------------------------------------------------------

function load_pupatt(attachmentSet)
    local player    = GetPlayerEntity();
    local pet       = GetEntity(player.PetTargetIndex);
    local MainJob   = AshitaCore:GetDataManager():GetPlayer():GetMainJob();
    local SubJob    = AshitaCore:GetDataManager():GetPlayer():GetSubJob();
	
    if ((MainJob == 18 or SubJob == 18)and pet == nil) then
        if (SubJob == 18) then
            local pupSub = 0x01;
        end
        for slot,item in ipairs(attachmentSet) do
            addAttachment(slot,item);
        end
    else
        print("Puppet is still out please please despawn pet to make changes to attachments.")
    end
end;

----------------------------------------------------------------------------------------------------
-- desc: Despawns your pet based on cooldowns.
----------------------------------------------------------------------------------------------------

function despawn_pet()
    local recastTimerDeactivate    = ashita.ffxi.recast.get_ability_recast_by_id(208);
    local player                   = GetPlayerEntity();
    local pet                      = GetEntity(player.PetTargetIndex);

    if (recastTimerDeactivate == 0 and pet ~= nil) then
        AshitaCore:GetChatManager():QueueCommand('/ja "Deactivate" <me>' , 1);
    elseif (recastTimerDeactivate > 0 and pet ~= nil) then
        print('<<Pupatt: Deactivate is not ready yet please try again later>>')
    end
end;

----------------------------------------------------------------------------------------------------
-- desc: Summons your pet based on cooldowns and zone_id.
----------------------------------------------------------------------------------------------------

function Summon_pet()
    local recastTimerActivate    = ashita.ffxi.recast.get_ability_recast_by_id(205);
    local recastTimerdeusex      = ashita.ffxi.recast.get_ability_recast_by_id(115);
    local zone_id                = AshitaCore:GetDataManager():GetParty():GetMemberZone(0);
    local player                 = GetPlayerEntity();
    local pet                    = GetEntity(player.PetTargetIndex);
	
    if (pet == nil) then
        if contains(petlessZones, zone_id) then
            print("You are in a zone that dose not allow pets.")
        else
            if (recastTimerActivate == 0) then
                print("<<Pupatt: Using Activate>>")
                AshitaCore:GetChatManager():QueueCommand('/ja "Activate" <me>' , 1);
            elseif(recastTimerdeusex == 0) then
                print('<<Pupatt: Activate is not ready using Deus Ex Automata>>')
                AshitaCore:GetChatManager():QueueCommand('/ja "Deus Ex Automata" <me>' , 1);
            elseif(recastTimerdeusex > 0 and recastTimerdeusex > 0) then
                print('<<Pupatt: Activate and Deus Ex Automata is not ready yet please try again later>>')
            end
        end
    else
        print("Your puppet is already out")
    end
end;

----------------------------------------------------------------------------------------------------
-- func: process_queue
-- desc: Processes the packet queue to be sent.
----------------------------------------------------------------------------------------------------

function process_queue()
    if  (os.clock() >= (objTimer + objDelay)) then
        objTimer = os.clock();	
        -- Ensure the queue has something to process..
        if (#attachmentQueue > queOffset) then
            queOffset = 0
            inProgress = true
            -- Obtain the first queue entry..
            local data = table.remove(attachmentQueue, 1);

            -- Send the queued object..
			--print("Sending packet #"..(#attachmentQueue + 1))
            AddOutgoingPacket(data[1], data[2]);
        elseif (#attachmentQueue == queOffset and inProgress == true) then
                print("Attachment change completed")
                inProgress = false
                queOffset = 1
        end
    end
end

----------------------------------------------------------------------------------------------------
-- func: render
-- desc: Event called when the addon is being rendered.
----------------------------------------------------------------------------------------------------

ashita.register_event('render', function()
    -- Process the objectives packet queue..
    process_queue();
    attFromMemory();
end);


---------------------------------------------------------------------------------------------------
-- func: load_pupattSettings
-- desc: load pup attachments from a file and sets currentattachment equip.
---------------------------------------------------------------------------------------------------

function load_pupattSettings()
    local tempCommands = ashita.settings.load(_addon.path .. '/settings/pupattProfiles.json');
    if tempCommands ~= nil then
        print('Stored objective profiles found.');
        pupattProfiles = tempCommands;
    else
        print('pupatt profiles could not be loaded. Creating empty lists.');
        pupattProfiles = { };
    end
end;

---------------------------------------------------------------------------------------------------
-- func: new_profile
-- desc: Creates new profile with current objectives
---------------------------------------------------------------------------------------------------

function new_profile(profileName)
    print("Saving current attachments to profile " .. profileName)
    newProfile = {}
    for k,v in pairs (currentAttachments) do
        convv = string.format("0x%X",v)
        if (__debug) then
            print(string.format("slot id and attachmentId: %d, 0x%X", k, v));
            print(convk)
            print(convv)
        end
        table.insert(newProfile, convv)
    end
    pupattProfiles[profileName] = newProfile;
end;

---------------------------------------------------------------------------------------------------
-- func: list_profiles
-- desc: Lists saved profiles
---------------------------------------------------------------------------------------------------

function list_profiles()
    print("Current Profiles:\n")
    printProfiles = ashita.settings.JSON:encode_pretty(pupattProfiles, nil, {pretty = true, indent = "->    " });
    print(printProfiles);
end;

---------------------------------------------------------------
 -- Prepairs, reads and stores the current attachment for 1st time use.
---------------------------------------------------------------

function attFromMemory()
    if (defaultAtt == false) then
        local pointer1 = ashita.memory.findpattern('FFXiMain.dll', 0, 'C1E1032BC8B0018D????????????B9????????F3A55F5E5B', 10, 0);
        if (pointer1 == 0) then
            err('Failed to locate current attachments, please cycle a attachment to continue.');
        else
            local offset1 = ashita.memory.read_uint32(pointer1);
            pointer = ashita.memory.read_uint32(AshitaCore:GetPointerManager():GetPointer('inventory'));
            pointer = ashita.memory.read_uint32(pointer);
            currentAttachments = ashita.memory.read_array((pointer + offset1) + offset, 0x0E);
            if (currentAttachments ~= nil) then
                for i = 1, 14 do
                    currentAttachments[i] = string.format("0x%X" , currentAttachments[i]);
                end
                defaultAtt = true
            end
        end
    end
end;

---------------------------------------------------------------------------------------------------
-- func: save_profiles
-- desc: saves current pup attachment profiles to a file
---------------------------------------------------------------------------------------------------

function save_profiles()
    print("Writing saved profiles to file settings/pupattProfiles.json");
    -- Save the addon settings to a file (from the addonSettings table)
    ashita.settings.save(_addon.path .. '/settings' .. '/pupattProfiles.json' , pupattProfiles);
end;

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
end;

----------------------------------------------------------------------------------------------------
-- func: user_commands
-- desc: User commands to help interact with the program.
----------------------------------------------------------------------------------------------------

ashita.register_event('command', function(command, ntype)
    -- Get the arguments of the command..
    local args = command:args();

    if (args[1] ~= '/pupatt') then
        return false;
    end

    if (#args == 3 and args[2] == 'newprofile') then
        new_profile(args[3])
        return true;
  	end

    if (#args >= 2 and args[2] == 'list') then
        list_profiles()
        return true;
    end
	
    if (#args >= 2 and args[2] == 'current') then
        currentAtt = ashita.settings.JSON:encode_pretty(currentAttachments, nil, {pretty = true, indent = "->    " });
        print(currentAtt);
        return true;
    end
	
    if (#args >= 2 and args[2] == 'save') then
        save_profiles()
        return true;
    end
	
    if (#args >= 2 and args[2] == 'clear') then
        clearAttachments()
        return true;
    end
	
    if (#args >= 2 and args[2] == 'spawn') then
        Summon_pet()
        return true;
    end
	
    if (#args >= 2 and args[2] == 'despawn') then
        despawn_pet()
        return true;
    end

    if (#args >= 2 and args[2] == 'load') then
        print("Loading " .. args[3]);
        if pupattProfiles[args[3]] then
            ashita.timer.once(1,clearAttachments);
            ashita.timer.once(2,load_pupatt,pupattProfiles[args[3]]);
        else
            print (args[3] .. " profile not found");
        end
        return true;
    end
	  
 -- Prints the addon help..
    print_help('/pupatt', {
        {'/pupatt load profileName', ' - Loads a saved profile from settings.  '},
        {'/pupatt newprofile profileName', ' - creates a new profile.'},
        {'/pupatt save', ' - Saves the new profile created.'},
        {'/pupatt list', ' - Lists the profiles as well as the hex values for each attachment.'},
        {'/pupatt current', ' - Lists the current attachments hex values.'},
        {'/pupatt clear', ' - Clears the current attachments.'},
        {'/pupatt spawn', ' - Spawns the puppet using whatever is off cooldown.'},
        {'/pupatt despawn', ' - despawns the puppet.'},	
    });
    return true;


end);
