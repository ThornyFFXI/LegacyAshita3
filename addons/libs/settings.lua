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

ashita          = ashita or { };
ashita.settings = ashita.settings or { };

if (ashita.settings.JSON == nil) then
    ashita.settings.JSON = require('json.json');
end
----------------------------------------------------------------------------------------------------
-- func: normalize_path
-- desc: Normalizes a paths slashes to a single format.
----------------------------------------------------------------------------------------------------
local function normalize_path(path)
    local p = path:gsub('/', '\\');
    local i = p:find('\\');

    while (i ~= nil) do
        if (p:sub(i + 1, i + 1) == '\\') then
            p = p:remove(i);
            i = p:find('\\');
        else
            i = p:find('\\', i + 1);
        end
    end
    return p;
end

----------------------------------------------------------------------------------------------------
-- func: path_from_file
-- desc: Obtains a path from a file location.
----------------------------------------------------------------------------------------------------
local function path_from_file(f)
    -- Ensure the given data has a file extension..
    if (f:find('%.') == nil) then
        return f;
    end

    -- Find the location of the first slash..
    local s = f:find('\\');
    if (s == nil) then return f; end

    -- Find the last slash location..
    while (true) do
        local c = f:find('\\', s + 1);
        if (c == nil) then break; end
        s = c;
    end

    -- Pull and return the file path..
    return f:sub(0, s - 1);
end

----------------------------------------------------------------------------------------------------
-- func: save_settings
-- desc: Saves a table, as JSON, to the given file.
----------------------------------------------------------------------------------------------------
local function save_settings(name, t)
    -- Convert the table to json..
    local data = ashita.settings.JSON:encode_pretty(t, nil, { pretty = true, align_keys = false, indent = '    ' });
    if (data == nil) then
        error('Failed to convert data to JSON for saving.');
        return false;
    end

    -- Normalize the path..
    local name = normalize_path(name);

    -- Ensure the path exists..
    local dir = path_from_file(name);
    if (not ashita.file.dir_exists(dir)) then
        ashita.file.create_dir(dir);
    end

    -- Save the config file..
    local f = io.open(name, 'w');
    if (f == nil) then
        error('Failed to save configuration.');
        return false;
    end

    -- Write and close the file..
    f:write(data);
    f:close();

    return true;
end
ashita.settings.save = save_settings;

----------------------------------------------------------------------------------------------------
-- func: load_settings
-- desc: Loads a json settings file and converts its data to a Lua table.
----------------------------------------------------------------------------------------------------
local function load_settings(name)
    -- Load the file for reading..
    local f = io.open(name, 'r');
    if (f == nil) then
        return nil;
    end

    -- Read the full file contents..
    local raw = f:read('*a');
    f:close();

    -- Convert the JSON to a Lua table..
    local data = ashita.settings.JSON:decode(raw);
    if (type(data) == 'table') then return data; end

    -- Failed to convert..
    return nil;
end
ashita.settings.load = load_settings;

----------------------------------------------------------------------------------------------------
-- func: load_settings_merged
-- desc: Loads a json settings file and converts its data to a Lua table. Afterward, merges the
--       loaded settings into the parent table.
----------------------------------------------------------------------------------------------------
local function load_settings_merged(name, parent)
    -- Ensure the parent table is valid..
    if (parent == nil or type(parent) ~= 'table') then
        return nil;
    end

    -- Load the settings..
    local data = ashita.settings.load(name);
    if (data == nil) then
        return parent;
    end

    -- Merge the tables..
    return table.merge(parent, data);
end
ashita.settings.load_merged = load_settings_merged;