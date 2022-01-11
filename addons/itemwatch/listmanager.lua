--[[
 * ItemWatch - Copyright (c) 2016 atom0s [atom0s@live.com]
 *
 * This work is licensed under the Creative Commons Attribution-NonCommercial-NoDerivatives 4.0 International License.
 * To view a copy of this license, visit http://creativecommons.org/licenses/by-nc-nd/4.0/ or send a letter to
 * Creative Commons, PO Box 1866, Mountain View, CA 94042, USA.
 *
 * By using ItemWatch, you agree to the above license and its terms.
 *
 *      Attribution - You must give appropriate credit, provide a link to the license and indicate if changes were
 *                    made. You must do so in any reasonable manner, but not in any way that suggests the licensor
 *                    endorses you or your use.
 *
 *   Non-Commercial - You may not use the material (ItemWatch) for commercial purposes.
 *
 *   No-Derivatives - If you remix, transform, or build upon the material (ItemWatch), you may not distribute the
 *                    modified material. You are, however, allowed to submit the modified works back to the original
 *                    ItemWatch project in attempt to have it added to the original project.
 *
 * You may not apply legal terms or technological measures that legally restrict others
 * from doing anything the license permits.
 *
 * No warranties are given.
]]--

require 'common';
require 'imguidef';
require 'helpers';

----------------------------------------------------------------------------------------------------
-- ListManager Module Table
----------------------------------------------------------------------------------------------------
local ListManager = {};
ListManager.watched_items   = {};
ListManager.watched_keys    = {};
ListManager.saved_lists     = {};

----------------------------------------------------------------------------------------------------
-- func: items_watch_count
-- desc: Returns the total number of item watches.
----------------------------------------------------------------------------------------------------
function ListManager.items_watch_count()
    return #ListManager.watched_items;
end

----------------------------------------------------------------------------------------------------
-- func: keys_watch_count
-- desc: Returns the total number of key item watches.
----------------------------------------------------------------------------------------------------
function ListManager.keys_watch_count()
    return #ListManager.watched_keys;
end

----------------------------------------------------------------------------------------------------
-- func: total_watch_count
-- desc: Returns the total number of watches.
----------------------------------------------------------------------------------------------------
function ListManager.total_watch_count()
    return #ListManager.watched_items + #ListManager.watched_keys;
end

----------------------------------------------------------------------------------------------------
-- func: add_watched_item
-- desc: Adds an item to the watched items list.
----------------------------------------------------------------------------------------------------
function ListManager.add_watched_item(itemid)
    -- Ensure this item is unique..
    for _, v in pairs(ListManager.watched_items) do
        if (v[1] == itemid) then
            msg(string.format('Cannot add item %d to the watch list; it is already being watched.', itemid));
            return false;
        end
    end

    -- Lookup the item name..
    local item = AshitaCore:GetResourceManager():GetItemById(itemid);
    if (item == nil or item.Name[0] == nil or string.len(item.Name[0]) < 2) then
        msg(string.format('Cannot add item %d to the watch list; it appears to be invalid.', itemid));
        return false;
    end

    -- Add the item to the watch list..
    table.insert(ListManager.watched_items, { itemid, item.Name[0] });
    msg(string.format('Added \'\30\05%s\30\01\' to the item watch list.', item.Name[0]));
end

----------------------------------------------------------------------------------------------------
-- func: delete_watched_item
-- desc: Deletes an item from the item watch list.
----------------------------------------------------------------------------------------------------
function ListManager.delete_watched_item(itemid)
    -- Delete all watched items matching the given itemid..
    for x = #ListManager.watched_items, 1, -1 do
        if (ListManager.watched_items[x][1] == itemid) then
            msg(string.format('Removed \'\30\05%s\30\01\' from the item watch list.', ListManager.watched_items[x][2]));
            table.remove(ListManager.watched_items, x);
        end
    end
end

----------------------------------------------------------------------------------------------------
-- func: clear_watched_items
-- desc: Deletes all items from the item watch list.
----------------------------------------------------------------------------------------------------
function ListManager.clear_watched_items()
    ListManager.watched_items = {};
    msg('Cleared watched items list.');
end

----------------------------------------------------------------------------------------------------
-- func: add_watched_key
-- desc: Adds a key item to the watched keys list.
----------------------------------------------------------------------------------------------------
function ListManager.add_watched_key(keyid)
    -- Ensure this key is unique..
    for _, v in pairs(ListManager.watched_keys) do
        if (v[1] == keyid) then
            msg(string.format('Cannot add key item %d to the watch list; it is already being watched.', keyid));
            return false;
        end
    end

    -- Lookup the key item name..
    local name = AshitaCore:GetResourceManager():GetString('keyitems', keyid);
    if (name == nil or string.len(name) < 2) then
        msg(string.format('Cannot add key item %d to the watch list; it appears to be invalid.', keyid));
        return false;
    end

    -- Add the key item to the watch list..
    table.insert(ListManager.watched_keys, { keyid, name });
    msg(string.format('Added \'\30\05%s\30\01\' to the key item watch list.', name));
end

----------------------------------------------------------------------------------------------------
-- func: delete_watched_key
-- desc: Deletes a key item from the key item watch list.
----------------------------------------------------------------------------------------------------
function ListManager.delete_watched_key(keyid)
    -- Delete all watched key items matching the given key item id..
    for x = #ListManager.watched_keys, 1, -1 do
        if (ListManager.watched_keys[x][1] == keyid) then
            msg(string.format('Removed \'\30\05%s\30\01\' from the key item watch list.', ListManager.watched_keys[x][2]));
            table.remove(ListManager.watched_keys, x);
        end
    end
end

----------------------------------------------------------------------------------------------------
-- func: clear_watched_keys
-- desc: Deletes all key items from the key item watch list.
----------------------------------------------------------------------------------------------------
function ListManager.clear_watched_keys()
    ListManager.watched_keys = {};
    msg('Cleared watched key items list.');
end

----------------------------------------------------------------------------------------------------
-- func: find_items
-- desc: Finds all items with the partial name match.
----------------------------------------------------------------------------------------------------
function ListManager.find_items(name)
    local items = {};

    for x = 0, 65535 do
        local item = AshitaCore:GetResourceManager():GetItemById(x);
        if (item ~= nil and item.Name[0] ~= nil and string.len(item.Name[0]) > 1) then
            local n = tostring(item.Name[0]):lower();
            if (n:contains(name)) then
                table.insert(items, { x, item.Name[0] });
            end
        end
    end

    return items;
end

----------------------------------------------------------------------------------------------------
-- func: find_keys
-- desc: Finds all key items with the partial name match.
----------------------------------------------------------------------------------------------------
function ListManager.find_keyitems(name)
    local keys = {};

    for x = 0, 65535 do
        local keyname = AshitaCore:GetResourceManager():GetString('keyitems', x);
        if (keyname ~= nil and string.len(keyname) > 1) then
            keyname = tostring(keyname):lower();
            if (keyname:contains(name)) then
                table.insert(keys, { x, keyname });
            end
        end
    end
    
    return keys;
end

----------------------------------------------------------------------------------------------------
-- func: refresh_saved_lists
-- desc: Refreshes the saved list table.
----------------------------------------------------------------------------------------------------
function ListManager.refresh_saved_lists()
    ListManager.saved_lists = {};

    -- Obtain a list of all list files..
    local files = ashita.file.get_dir(_addon.path .. '/settings/lists/', '*.lst', false);
    if (files == nil) then
        msg('Failed to obtain saved lists.');
        return;
    end

    -- Loop the found files and find all .lst files..
    for _, v in pairs(files) do
        if (v:endswith('.lst')) then
            table.insert(ListManager.saved_lists, v);
        end
    end
end

----------------------------------------------------------------------------------------------------
-- func: save_list_new
-- desc: Saves the current watch data to a new list file.
----------------------------------------------------------------------------------------------------
function ListManager.save_list_new(name)
    -- Validate the file name..
    if (name == nil or string.len(name) < 2) then
        msg('Invalid file name; cannot save new list.');
        return;
    end

    -- Ensure the file does not already exist..
    name = name .. '.lst';
    if (ashita.file.file_exists(_addon.path .. '/settings/lists/' .. name)) then
        msg('Cannot save new list file. File already exists.');
        return;
    end

    -- Build the output json data..
    local data = ashita.settings.JSON:encode_pretty({ items = ListManager.watched_items, keys = ListManager.watched_keys });

    -- Open the file for writing..
    local f = io.open(_addon.path .. '/settings/lists/' .. name, 'w');
    if (f == nil) then
        msg('Failed to create and open new list file for writing.');
        return;
    end

    -- Save the data to the file..
    f:write(data);
    f:close();

    msg(string.format('Saved the list data to: \'\30\05%s\30\01\'', name));

    -- Refresh the saved lists table..
    ListManager.refresh_saved_lists();
end

----------------------------------------------------------------------------------------------------
-- func: save_list_existing
-- desc: Saves the current watch data to an existing list file. (Or new if it doesn't exist.)
----------------------------------------------------------------------------------------------------
function ListManager.save_list_existing(index)
    -- Validate the index..
    if (index < 0 or #ListManager.saved_lists == 0) then
        msg('You must select a list from the left!');
        msg('If no lists are shown, press the refresh button or save as a new list instead.');
        return;
    end

    -- Get the selected list..
    local name = ListManager.saved_lists[index + 1];
    if (name == nil) then
        msg('Invalid file selected; cannot save new list.');
        return;
    end

    -- Validate the file name..
    if (name == nil or string.len(name) < 2) then
        msg('Invalid file name; cannot save new list.');
        return;
    end

    -- Build the output json data..
    local data = ashita.settings.JSON:encode_pretty({ items = ListManager.watched_items, keys = ListManager.watched_keys });

    -- Open the file for writing..
    local f = io.open(_addon.path .. '/settings/lists/' .. name, 'w');
    if (f == nil) then
        msg('Failed to create and open new list file for writing.');
        return;
    end

    -- Save the data to the file..
    f:write(data);
    f:close();

    msg(string.format('Saved the list data to: \'\30\05%s\30\01\'', name));

    -- Refresh the saved lists table..
    ListManager.refresh_saved_lists();
end

----------------------------------------------------------------------------------------------------
-- func: load_list
-- desc: Loads a list file from disk and populates the managers watch data.
----------------------------------------------------------------------------------------------------
function ListManager.load_list(index)
    -- Validate the index..
    if (index < 0 or #ListManager.saved_lists == 0) then
        msg('You must select a list from the left!');
        msg('If no lists are shown, press the refresh button or save a new list instead.');
        return;
    end

    -- Get the selected list..
    local name = ListManager.saved_lists[index + 1];
    if (name == nil) then
        msg('Invalid file selected; cannot load list.');
        return;
    end

    -- Ensure the selected file exists..
    if (ashita.file.file_exists(_addon.path .. '/settings/lists/' .. name) == false) then
        msg(string.format('Invalid list file; file was not found. \'\30\05%s\30\01\'', name));
        return;
    end

    -- Load the list data..
    local data = ashita.settings.load(_addon.path .. '/settings/lists/' .. name);
    if (data == nil) then
        msg(string.format('Invalid list file; failed to load file data. \'\30\05%s\30\01\'', name));
        return;
    end

    -- Clear the current watch data..
    ListManager.watched_items = {};
    ListManager.watched_keys = {};

    -- Populate the watched items..
    if (data.items ~= nil) then
        ListManager.watched_items = data.items;
    end

    -- Populate the watched key items..
    if (data.keys ~= nil) then
        ListManager.watched_keys = data.keys;
    end
    
    msg(string.format('Loaded list file: \'\30\05%s\30\01\'', name));
end

----------------------------------------------------------------------------------------------------
-- func: load_list_merged
-- desc: Loads a list file from disk and merges its data into the managers watch data.
----------------------------------------------------------------------------------------------------
function ListManager.load_list_merged(index)
    -- Validate the index..
    if (index < 0 or #ListManager.saved_lists == 0) then
        msg('You must select a list from the left!');
        msg('If no lists are shown, press the refresh button or save a new list instead.');
        return;
    end

    -- Get the selected list..
    local name = ListManager.saved_lists[index + 1];
    if (name == nil) then
        msg('Invalid file selected; cannot load list.');
        return;
    end

    -- Ensure the selected file exists..
    if (ashita.file.file_exists(_addon.path .. '/settings/lists/' .. name) == false) then
        msg(string.format('Invalid list file; file was not found. \'\30\05%s\30\01\'', name));
        return;
    end

    -- Load the list data..
    local data = ashita.settings.load(_addon.path .. '/settings/lists/' .. name);
    if (data == nil) then
        msg(string.format('Invalid list file; failed to load file data. \'\30\05%s\30\01\'', name));
        return;
    end

    -- Populate the watched items..
    if (data.items ~= nil) then
        for _, v in pairs(data.items) do
            ListManager.add_watched_item(v[1]);
        end
    end

    -- Populate the watched key items..
    if (data.keys ~= nil) then
        for _, v in pairs(data.keys) do
            ListManager.add_watched_key(v[1]);
        end
    end
    
    msg(string.format('Loaded list file (merged): \'\30\05%s\30\01\'', name));
end

----------------------------------------------------------------------------------------------------
-- func: delete_list
-- desc: Deletes a list file on disk.
----------------------------------------------------------------------------------------------------
function ListManager.delete_list(index)
    -- Validate the index..
    if (index < 0 or #ListManager.saved_lists == 0) then
        msg('You must select a list from the left!');
        msg('If no lists are shown, press the refresh button or save a new list instead.');
        return;
    end

    -- Get the selected list..
    local name = ListManager.saved_lists[index + 1];
    if (name == nil) then
        msg('Invalid file selected; cannot delete list.');
        return;
    end

    -- Ensure the selected file exists..
    if (ashita.file.file_exists(_addon.path .. '/settings/lists/' .. name) == false) then
        msg(string.format('Invalid list file; file was not found. \'\30\05%s\30\01\'', name));
        return;
    end

    -- Delete the file..
    os.remove(_addon.path .. '/settings/lists/' .. name);

    -- Refresh the saved lists table..
    ListManager.refresh_saved_lists();
end

----------------------------------------------------------------------------------------------------
-- func: delete_all_lists
-- desc: Deletes all list files on disk.
----------------------------------------------------------------------------------------------------
function ListManager.delete_all_lists()
    -- Obtain a list of all list files..
    local files = file:get_dir(_addon.path .. '/settings/lists/');
    if (files == nil) then
        return;
    end

    -- Loop the found files and delete all .lst files..
    for _, v in pairs(files) do
        if (v:endswith('.lst')) then
            os.remove(_addon.path .. '/settings/lists/' .. v);
        end
    end

    -- Refresh the saved lists table..
    ListManager.refresh_saved_lists();
    
    msg('Deleted all saved lists.');
end

-- Return the module table..
return ListManager;