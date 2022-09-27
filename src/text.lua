---
-- This module contains basic string manipulation methods not included in the Lua standard library.
--
local M = {}

---
-- Check if string starts with a substring.
--
-- @param text string to check
--
-- @param start substring
--
-- @return <code>true</code> if text starts with mentioned substring, <code>false</code> if any of the parameters is nil
--         or the text does not start with the substring
--
function M.starts_with(text, start)
    return text ~= nil and start ~= nil and start == string.sub(text, 1, string.len(start))
end

---
-- Remove leading and trailing spaces from a string
--
-- @param text string to be trimmed
--
-- @return trimmed string
--
function M.trim(text)
    return text:match "^%s*(.-)%s*$"
end

---
-- Split a delimited string into its components.
--
-- @param text string to split
--
-- @param delimiter to split at (default: ',')
--
function M.split(text, delimiter)
    if(text == nil) then
        return nil
    end
    delimiter = delimiter or ','
    local tokens = {}
    for token in (text .. delimiter):gmatch("(.-)" .. delimiter) do
        if (token ~= nil and token ~= "") then
            table.insert(tokens, M.trim(token))
        end
    end
    return tokens
end

return M
