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

----------------------------------------------------------------------------------------------------
-- Extensions
----------------------------------------------------------------------------------------------------
require 'imguidef'
require 'logging'
require 'mathex'
require 'settings'
require 'stringex'
require 'tableex'
require 'timer'

----------------------------------------------------------------------------------------------------
-- Common FFXI Requires
----------------------------------------------------------------------------------------------------
require 'ffxi.enums'

----------------------------------------------------------------------------------------------------
-- func: switch
-- desc: Switch case implementation for Lua. (Credits: Unknown Original Author)
----------------------------------------------------------------------------------------------------
function switch(c)
    local switch_table = 
    {
        casevar = c,
        caseof = function(self, code)
            local f;
            if (self.casevar) then
                f = code[self.casevar] or code.default;
            else
                f = code.missing or code.default;
            end
            if f then
                if (type(f) == 'function') then
                    return f(self.casevar,self);
                else
                    error('case: ' .. tostring(self.casevar) .. ' is not a function!');
                end
            end
        end
    };
    return switch_table
end