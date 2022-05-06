--- This class implements an abstraction for a query string including its tokens.
-- @classmod Query

local Query = {}

--- Create a new instance of a <code>Query</code>.
-- @param tokens tokens the query consists of
-- @return new instance
function Query.create(tokens)
    return Query:new({tokens = tokens})
end

--- Create a new instance of a <code>Query</code>.
-- @param object pre-initialized instance
-- @return query object
function Query:new(object)
    object = object or {}
    object.tokens = object.tokens or {}
    self.__index = self
    setmetatable(object, self)
    return object
end

--- Append a single token.
-- While the same can be achieved with calling <code>appendAll</code> with a single parameter, this method is faster.
-- @param token token to append
function Query:append(token)
    self.tokens[#self.tokens + 1] = token
end

--- Append all tokens.
-- @param ... tokens to append
function Query:appendAll(...)
    for _, token in ipairs(table.pack(...)) do
        self.tokens[#self.tokens + 1] = token
    end
end

--- Get the tokens this query consists of
-- @return tokens
function Query:get_tokens()
    return self.tokens
end

--- Return the whole query as string.
-- @return query as string
function Query:to_string()
    return table.concat(self.tokens)
end

return Query
