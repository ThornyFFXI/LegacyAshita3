--[[
 *
 * Copyright (c) 2011-2014 - Ashita Development Team
 *
 * Ashita is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * Ashita is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with Ashita.  If not, see <http://www.gnu.org/licenses/>.
 *
]]--

require 'common'

---------------------------------------------------------------------------------------------------
-- func: split_items
-- desc: Splits a comma separated list of items into a table.
---------------------------------------------------------------------------------------------------
function split_items(ids)
    local t = { };
    for token in ids:gmatch('[%d]+') do
        table.insert(t, token);
    end
    return t;
end

---------------------------------------------------------------------------------------------------
-- func: skip_entry
-- desc: Skips a line based on known patterns.
---------------------------------------------------------------------------------------------------
function skip_entry(line)
    if (#line == 0 or line:find('<%?xml') ~= nil) then
        return true;
    end
    if (line:contains('<Lotomatic>') or line:contains('</Lotomatic>')) then
        return true;
    end
    if (line:startswith('<!--') and line:endswith('-->')) then
        return true;
    end
    if (not line:startswith('<itementry ') and line:endswith('-->')) then
        return true;
    end
    return false;
end

---------------------------------------------------------------------------------------------------
-- func: is_comment
-- desc: Determines if we are currently in an XML comment.
---------------------------------------------------------------------------------------------------
function is_comment(line, incomment)
    -- Find the first comment starter..
    local start = line:find('<!%-%-');
    if (start == nil) then
        if (incomment == true) then
            -- If we are in a comment, try to find and ender..
            if (line:find('%-%->') ~= nil) then
                return false;
            end
            -- we are still in a comment..
            return true;
        end
        return false;
    end

    -- Find the last occurrence of a comment starting..
    while (true) do
        local n = line:find('<!%-%-', start + 1);
        if (n ~= nil) then
            start = n;
        else
            break;
        end
    end

    -- Next see if we have a comment end after this start..
    if (line:find('%-%->', start) ~= nil) then
        return false;
    end
    return true;
end

---------------------------------------------------------------------------------------------------
-- func: load_profile
-- desc: Loads a Lotomatic profile.
---------------------------------------------------------------------------------------------------
function load_profile(path)
    local rules = { loot = { }, pass = { } };

    -- Attemp to load the profile..
    local f = io.open(path, 'r');
    if (f == nil) then
        return false, rules;
    end

    -- Attempt to parse the profile line by line..
    local line = f:read();
    local incomment = false;
    while (line ~= nil) do
        -- Cleanup the line..
        line = line:trim():gsub('\t', '');

        -- Determine if this should be skipped..
        local skip = skip_entry(line);
        incomment = is_comment(line, incomment);
        if (not skip and not incomment) then
            -- Attempt to parse the ids and rules..
            local itemIds   = line:match('id="([%d+,]+)"');
            local itemRule  = line:match('rule="(%a+)"');

            -- Split the ids and add to our loaded rules..
            if (itemIds ~= nil and itemRule ~= nil) then
                for k, v in pairs(split_items(itemIds)) do
                    if (itemRule == 'loot') then
                        table.insert(rules.loot, tonumber(v:trim()));
                    else
                        table.insert(rules.pass, tonumber(v:trim()));
                    end
                end
            end
        end

        -- Read the next line..
        line = f:read();
    end

    -- Cleanup and return..
    f:close();
    return true, rules;
end