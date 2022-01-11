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
_addon.name     = 'OnEvent';
_addon.version  = '3.0.0';

require 'common'

---------------------------------------------------------------------------------------------------
-- Variables
---------------------------------------------------------------------------------------------------
local onevent = { events = { } };

---------------------------------------------------------------------------------------------------
-- func: remove_command
-- desc: Removes the leading function command for adding events.
---------------------------------------------------------------------------------------------------
local function remove_command(cmd)
    if (cmd:find('/onevent add')) then
        offset = 14;
    else
        offset = 9;
    end
    return cmd:sub(offset);
end

---------------------------------------------------------------------------------------------------
-- func: split_command
-- desc: Splits a command and returns the action, if found.
---------------------------------------------------------------------------------------------------
local function split_command(cmd)
    -- Remove the command..
    cmd = remove_command(cmd);
    
    -- Attempt to split with a space..
    local trigger, action = string.match(cmd, '([^,]+) | ([^,]+)');
    if (action == nil or action == cmd) then
        trigger, action = string.match(cmd, '([^,]+)|([^,]+)');
    end
    return trigger, action;
end

---------------------------------------------------------------------------------------------------
-- func: Command
-- desc: Called when our addon receives a command.
---------------------------------------------------------------------------------------------------
ashita.register_event('command', function(cmd, nType)
    -- Skip commands that we should not handle..
    local args = cmd:args();
    if (args[1] ~= '/onevent' and args[1] ~= '/oe') then
        return false;
    end
    
    -- Skip invalid commands..
    if (#args <= 1 or cmd:contains('<st')) then
        return true;
    end
    
    -- Do we want to add a trigger..
    if (args[2] == 'add') then
        if (#args < 3) then
            return true;
        end
        
        -- Attempt to obtain the action..
        local trigger, action = split_command(cmd);
        if (action == nil) then
            print('[OnEvent] Could not parse the action from the command!');
            return true;
        end
        
        -- Ensure we do not already have this event..
        for k, v in pairs(onevent.events) do
            if (v[1] == trigger) then
                print('[OnEvent] An event already exists with that trigger!');
                return true;
            end
        end
        
        -- Insert this into our list of actions..
        table.insert(onevent.events, { trigger, action });
        print(string.format('[OnEvent] Added: %s => %s', trigger, action));        
        return true;
    end
    
    -- Do we want to add a trigger..
    if (args[2] == 'remove' or args[2] == 'rem' or args[2] == 'delete' or args[2] == 'del') then
        if (#args < 3) then
            return true;
        end
        
        -- Attempt to locate and remove the action..
        for x = 1, #onevent.events do
            if (onevent.events[x][1] == cmd:sub(cmd:find(" ", cmd:find(" ") + 1) + 1)) then
                table.remove(onevent.events, x);
                print(string.format('[OnEvent] Removed: %s', cmd:sub(cmd:find(" ", cmd:find(" ") + 1) + 1)));
                return true;
            end
        end
        return true;
    end
    
    -- Do we want to delete all triggers..
    if (args[2] == 'removeall' or args[2] == 'deleteall') then
        onevent.events = { };
        print('[OnEvent] Removed all events!');
        return true;
    end
    
    -- Do we want to print out the bound action list..
    if (args[2] == 'list') then
        if (#onevent.events == 0) then
            print('[OnEvent] No events currently registered.');
            return true;
        end
        for k, v in pairs(onevent.events) do
            print(string.format('[OnEvent] %s => %s', v[1], v[2]));
        end
        return true;
    end
    
    return true;
end);

---------------------------------------------------------------------------------------------------
-- func: newchat
-- desc: Called when our addon receives a chat line.
---------------------------------------------------------------------------------------------------
ashita.register_event('incoming_text', function(mode, chat)
    for k, v in pairs(onevent.events) do
        if (chat:contains(v[1])) then
            AshitaCore:GetChatManager():QueueCommand(v[2], 1);
        end
    end
    return false;
end);