--- This class implements an abstraction for a query string including its tokens.
-- @classmod Query
local Query = {}
Query.__index = Query

--- Create a new instance of a `Query`.
-- @param tokens list of tokens that make up the query
-- @return query object
function Query:new(tokens)
    local instance = setmetatable({}, self)
    instance:_init(tokens)
    return instance
end

function Query:_init(tokens)
    self._tokens = tokens or {}
end

--- Append a single token.
-- While the same can be achieved with calling `append_all` with a single parameter, this method is faster.
-- @param token token to append
function Query:append(token)
    self._tokens[#self._tokens + 1] = token
end

--- Append all tokens.
-- @param ... tokens to append
function Query:append_all(...)
    for _, token in ipairs(table.pack(...)) do
        self._tokens[#self._tokens + 1] = token
    end
end

--- Get the tokens this query consists of
-- @return tokens
function Query:get_tokens()
    return self._tokens
end

--- Return the whole query as string.
-- @return query as string
function Query:to_string()
    return table.concat(self._tokens)
end

return Query
