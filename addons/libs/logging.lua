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

ashita                  = ashita or { };
ashita.logging          = ashita.logging or { };
ashita.logging.level    = ashita.logging.level or { };

----------------------------------------------------------------------------------------------------
-- Logging Level
----------------------------------------------------------------------------------------------------
ashita.logging.level.None           = 0; -- Logs a normal message.
ashita.logging.level.Information    = 1; -- Logs a warning.
ashita.logging.level.Warning        = 2; -- Logs a warning.
ashita.logging.level.Error          = 3; -- Logs an error.
ashita.logging.level.Debug          = 4; -- Logs a debug message.

----------------------------------------------------------------------------------------------------
-- func: ashita.logging.log
-- desc: Prints a string to the current log file.
----------------------------------------------------------------------------------------------------
local function log(lvl, src, str)
    LogManager:Log(lvl, src, str);
end
ashita.logging.log = log;

----------------------------------------------------------------------------------------------------
-- func: ashita.logging.normal
-- desc: Logs an normal line to the log file.
----------------------------------------------------------------------------------------------------
local function log_normal(src, str)
    ashita.logging.log(ashita.logging.level.None, src, str);
end
ashita.logging.normal = log_normal;

----------------------------------------------------------------------------------------------------
-- func: ashita.logging.info
-- desc: Logs an information line to the log file.
----------------------------------------------------------------------------------------------------
local function log_info(src, str)
    ashita.logging.log(ashita.logging.level.Information, src, str);
end
ashita.logging.info = log_info;

----------------------------------------------------------------------------------------------------
-- func: ashita.logging.warn
-- desc: Logs a warning line to the log file.
----------------------------------------------------------------------------------------------------
local function log_warning(src, str)
    ashita.logging.log(ashita.logging.level.Warning, src, str);
end
ashita.logging.warn = log_warning;

----------------------------------------------------------------------------------------------------
-- func: ashita.logging.error
-- desc: Logs an error line to the log file.
----------------------------------------------------------------------------------------------------
local function log_error(src, str)
    ashita.logging.log(ashita.logging.level.Error, src, str);
end
ashita.logging.error = log_error;

----------------------------------------------------------------------------------------------------
-- func: ashita.logging.debug
-- desc: Logs a debug line to the log file.
----------------------------------------------------------------------------------------------------
local function log_debug(src, str)
    ashita.logging.log(ashita.logging.level.Debug, src, str);
end
ashita.logging.debug = log_debug;