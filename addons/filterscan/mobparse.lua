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

---------------------------------------------------------------------------------------------------
-- func: ParseZoneMobDat
-- desc: Parses a zone monster dat for monster name and id entries.
---------------------------------------------------------------------------------------------------
function ParseZoneMobDat( path )
    -- Attempt to open the DAT file..
    local f = io.open( path, 'rb' );
    if (f == nil) then
        return nil;
    end
    
    -- Attempt to obtain the file size..
    local curr = f:seek();
    local size = f:seek( 'end' );
    f:seek( 'set', 0 );
    
    -- Ensure the file size is valid.. (Entries are 0x1C in length)
    if (size == 0 or ((size - math.floor( size / 0x20 ) * 0x20) ~= 0)) then
        f:close();
        return nil;
    end
    
    -- Parse each entry from the file..
    local mobEntries = { };
    for x = 0, ((size / 0x20) - 1) do
        local mobData = f:read(0x20);
        local mobName, mobId = struct.unpack('c28L', mobData);
        table.insert(mobEntries, { bit.band(mobId, 0x0FFF), mobName });
    end
    f:close();
    
    return mobEntries;
end