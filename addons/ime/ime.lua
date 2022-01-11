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
_addon.name     = 'IME';
_addon.version  = '3.0.0';

require 'common'

----------------------------------------------------------------------------------------------------
-- Variables
----------------------------------------------------------------------------------------------------
local ime = 
{
    bar_visible_offset      = 0x2F,
    bar_visible_ptr         = 0,
    bar_usage_offset1       = 0xF0EC,
    bar_usage_offset2       = 0xF10C,
    bar_usage_ptr           = 0,
    last_update_check       = 0,
};

----------------------------------------------------------------------------------------------------
-- func: load
-- desc: Event called when the addon is being loaded.
----------------------------------------------------------------------------------------------------
ashita.register_event('load', function()
    -- Locate the IME bar visibility function..
    local bar_visible = ashita.memory.findpattern('FFXiMain.dll', 0, '83EC08A1????????5333DB56', 0, 0);
    if (bar_visible == nil or bar_visible == 0) then
        print('[IME] Failed to locate required function: IMEBarVisible');
        return;
    end
    ime.bar_visible_ptr = bar_visible + ime.bar_visible_offset;
    
    -- Ensure we have the proper instruction to replace..
    if (ashita.memory.read_uint8(ime.bar_visible_ptr) ~= 0x74) then
        print('[IME] Failed to locate required function: IMEBarVisible -- Offset appears wrong!');
        return;
    end

    -- Locate the IME bar usage function..
    local bar_usage = ashita.memory.findpattern('FFXiMain.dll', 0, '8B0D????????81EC0401000053568B', 0, 0);
    if (bar_usage == nil or bar_usage == 0) then
        print('[IME] Failed to locate required function: IMEBarUsage');
        return;
    end
    ime.bar_usage_ptr = bar_usage + 2;
    ime.bar_usage_ptr = ashita.memory.read_uint32(ime.bar_usage_ptr); 
end);

----------------------------------------------------------------------------------------------------
-- func: unload
-- desc: Event called when the addon is being unloaded.
----------------------------------------------------------------------------------------------------
ashita.register_event('unload', function()
    -- Restore our patch for the IME visibility..
    if (ime.bar_visible_ptr ~= nil and ime.bar_visible_ptr ~= 0) then
        ashita.memory.write_uint8(ime.bar_visible_ptr, 0x74);
    end
    
    -- Restore the IME usage variables..
    local ptr = ashita.memory.read_uint32(ime.bar_usage_ptr);
    if (ptr == nil or ptr == 0) then
        print('[IME] Failed to read bar usage pointer, cannot apply needed fixes! (1)');
    else
        ptr = ashita.memory.read_uint32(ime.bar_usage_ptr);
        if (ptr == nil or ptr == 0) then
            print('[IME] Failed to read bar usage pointer, cannot apply needed fixes! (2)');
        else
            ashita.memory.write_uint8(ptr + ime.bar_usage_offset1, 1);
            ashita.memory.write_uint8(ptr + ime.bar_usage_offset2, 1);
        end
    end
end);

----------------------------------------------------------------------------------------------------
-- func: render
-- desc: Event called when the addon is being rendered.
----------------------------------------------------------------------------------------------------
ashita.register_event('render', function()
    -- Ensure we have valid pointers..
    if (ime.bar_visible_ptr == 0 or ime.bar_visible_ptr == nil or
        ime.bar_usage_ptr == 0 or ime.bar_usage_ptr == nil) then
        return;
    end

    -- Ensure our patches are applied every 5 seconds..
    if (ime.last_update_check <= (os.clock() - 5)) then
        -- Store the current update check time..
        ime.last_update_check = os.clock();
        
        -- Ensure our patch for the IME visibility is set..
        -- Patch: JE -> JMP
        if (ashita.memory.read_uint8(ime.bar_visible_ptr) == 0x74) then
            ashita.memory.write_uint8(ime.bar_visible_ptr, 0xEB);
        end
        
        -- Ensure the game allows us to use the IME bar..
        local ptr = ashita.memory.read_uint32(ime.bar_usage_ptr);
        if (ptr == nil or ptr == 0) then
            print('[IME] Failed to read bar usage pointer, cannot apply needed fixes! (1)');
        else
            ptr = ashita.memory.read_uint32(ime.bar_usage_ptr);
            if (ptr == nil or ptr == 0) then
                print('[IME] Failed to read bar usage pointer, cannot apply needed fixes! (2)');
            else
                ashita.memory.write_uint8(ptr + ime.bar_usage_offset1, 0);
                ashita.memory.write_uint8(ptr + ime.bar_usage_offset2, 0);
            end
        end
    end
end);