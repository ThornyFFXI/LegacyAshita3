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
_addon.name     = 'blusets';
_addon.version  = '3.0.0';

require 'common'
blu = require 'bluemage'

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
end

----------------------------------------------------------------------------------------------------
-- func: load
-- desc: Event called when the addon is being loaded.
----------------------------------------------------------------------------------------------------
ashita.register_event('load', function()
    -- Initialize the Blue Mage library..
    if (blu.initialize() == false) then
        err('Failed to initialize required library.');
        return;
    end
end);

----------------------------------------------------------------------------------------------------
-- func: render
-- desc: Event called when the addon is being rendered.
----------------------------------------------------------------------------------------------------
ashita.register_event('render', function()
    -- Process the blue packet queue..
    blu.process_queue();
end);

----------------------------------------------------------------------------------------------------
-- func: command
-- desc: Event called when a command was entered.
----------------------------------------------------------------------------------------------------
ashita.register_event('command', function(command, ntype)
    -- Get the command arguments..
    local args = command:args();
    local commands = { '/blusets', '/bluesets', '/bluset', '/blueset', '/bs' };

    -- Ensure this is a valid command this addon should handle..
    if (table.hasvalue(commands, args[1]) == false) then
        return false;
    end

    -- List - Lists all available saved sets.
    ----------------------------------------------------------------------------------------------------
    if (#args >= 2 and args[2] == 'list') then
        local files = ashita.file.get_dir(_addon.path .. '/sets/', '*.txt', false);
        if (files ~= nil and #files > 0) then
            for _, v in pairs(files) do
                msg('Found spell set file: \31\04' .. v:gsub('.txt', ''));
            end
        else
            msg('No saved spell sets found.');
        end
        return true;
    end

    -- Load - Loads a saved spell list from disk.
    ----------------------------------------------------------------------------------------------------
    if (#args >= 3 and args[2] == 'load') then
        local name = command:gsub('([\/%w]+) ', '', 2):trim();
        if (name:endswith('.txt') == false) then
            name = name .. '.txt';
        end

        if (ashita.file.file_exists(_addon.path .. '/sets/' .. name) == false) then
            msg('Cannot load spell list, file does not exist: \31\04' .. name);
            return true;
        end

        blu.reset_all_spells();

        local data = ashita.settings.load(_addon.path .. '/sets/' .. name);
        for k, v in pairs(data) do
            blu.set_spell_by_name(v, k);
        end
        
        msg('Loaded blue spell set: \31\04' .. name);
        return true;
    end

    -- Save - Saves a saved spell list to disk.
    ----------------------------------------------------------------------------------------------------
    if (#args >= 3 and args[2] == 'save') then
        local name = command:gsub('([\/%w]+) ', '', 2):trim();
        if (name:endswith('.txt') == false) then
            name = name .. '.txt';
        end

        local spells = blu.get_spell_names();
        local data = ashita.settings.JSON:encode_pretty(spells, nil, { pretty = true, align_keys = false, indent = '    ' });

        ashita.file.create_dir(_addon.path .. '/sets/');

        local f = io.open(_addon.path .. '/sets/' .. name, 'w');
        if (f == nil) then
            err('Failed to save blue spell set.');
            return true;
        end

        f:write(data);
        f:close();

        msg('Saved blue spell set: \31\04' .. name);
        return true;
    end

    -- Delete - Deletes a saved spell list from disk.
    ----------------------------------------------------------------------------------------------------
    if (#args >= 3 and args[2] == 'delete') then
        local name = command:gsub('([\/%w]+) ', '', 2):trim();
        if (name:endswith('.txt') == false) then
            name = name .. '.txt';
        end
        
        if (ashita.file.file_exists(_addon.path .. '/sets/' .. name) == false) then
            msg('Cannot delete spell list, file does not exist: \31\04' .. name);
            return true;
        end

        os.remove(_addon.path .. '/sets/' .. name);
        msg('Deleted blue spell set: \31\04' .. name);
        return true;
    end

    -- Unset - Unsets all currently set spells.
    ----------------------------------------------------------------------------------------------------
    if (#args >= 2 and args[2] == 'unset') then
        blu.reset_all_spells();
        msg('Unset all current blue spells.');
        return true;
    end

    -- Set - Sets a blue spell.
    ----------------------------------------------------------------------------------------------------
    if (#args >= 4 and args[2] == 'set') then
        local index = tonumber(args[3]);
        if (index <= 0 or index > 20) then
            err('Invalid spell index; must be 1 to 20.');
            return true;
        end

        local spell = tonumber(args[4]);
        if (spell == nil or spell < 512 and spell ~= 0) then
            err('Invalid spell id, blue spells start at id 512.');
            return true;
        end

        blu.set_spell(spell, index);
        return true;
    end

    -- Prints the addon help..
    print_help('/blusets', {
        { '/blusets list',                  '- Lists all the known sets saved to disk.' },
        { '/blusets load [name]',           '- Loads a blue magic spell set from the given file name.' },
        { '/blusets save [name]',           '- Saves the current set blue magic spells to the given file name.' },
        { '/blusets delete [name]',         '- Deletes the given saved blue magic spell set.' },
        { '/blusets unset',                 '- Unsets all current set blue magic spells.' },
        { '/blusets set [index] [spellid]', '- Sets a blue magic spell to the given index.' },
    });
    return true;
end);