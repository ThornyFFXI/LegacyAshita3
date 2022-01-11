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
_addon.name     = 'stfu';
_addon.version  = '3.0.0';

require 'common'

---------------------------------------------------------------------------------------------------
-- Variables
---------------------------------------------------------------------------------------------------
local stfu = { };
stfu.last_text = nil;
stfu.blocked =
{
    "Equipment changed.",
    "Equipment removed.",
    "You were unable to change your equipped items.",
    "You must close the currently open window to use that command.",
    "You cannot use that command at this time.",
    "You cannot use that command while viewing the chat log.",
    "You cannot use that command while charmed.",
    "You cannot use that command while healing.",
    "You cannot use that command while unconscious.",
    "You can only use that command during battle.",
    "You cannot perform that action on the selected sub-target.",

    -- May remove these in the future if people feel that they are overkill..
    "You cannot attack that target.",
    "Target out of range."
};

---------------------------------------------------------------------------------------------------
-- func: prevent_spam
-- desc: Determines if the given message is being spammed.
---------------------------------------------------------------------------------------------------
local function prevent_spam(msg)
    -- Do nothing if there is no previous text yet..
    if (stfu.last_text == nil) then
        return false;
    end
    
    -- Check if this message is the same as the last..
    if (stfu.last_text == msg or 
        string.contains(stfu.last_text, msg)) then
        return true;
    end
    
    return false;
end

---------------------------------------------------------------------------------------------------
-- func: incoming_text
-- desc: Event called when the addon is asked to handle an incoming chat line.
---------------------------------------------------------------------------------------------------
ashita.register_event('incoming_text', function(mode, chat)
    -- Loop and check for known blocked messages..
    for _, v in pairs(stfu.blocked) do
        -- Check if this message is being spammed..
        local spam = prevent_spam(v);
        if (spam and string.contains(chat, v)) then
            stfu.last_text = chat;
            return true;
        end
    end
    
    -- Store the current chat line..
    stfu.last_text = chat;
    
    -- Look for calls..
    local r = '<((c|nc|sc)all|(c|nc|sc)all[0-9]+)>';
    local c = ashita.regex.search(chat, r);
    if (c ~= nil) then
        return ashita.regex.replace(chat, r, '($1)');
    end
    
    return false;
end);