-- HTTP (incomming) Request class
-- (c)copyright 2018 by Gerald Wodni <gerald.wodni@gmail.com>

local Request = {}
Request.__index = Request

function Request.new( connection, callback )
    local self = setmetatable( {}, Request )
    self.connection = connection
    self.callback = callback
    self.headers = {}
    self.requestData = ""

    self.connection:on("receive", function( conn, chunk )
        self:onReceive( chunk )
    end)

    return self
end

function Request:onReceive( chunk )
    self.requestData = self.requestData .. chunk
    -- got all headers
    if self.requestData:find("\r\n\r\n") or self.requestData:find("\n\n") then
        self:parseHeaders()
    end
end

function Request:parseHeaders()
    local pos
    pos = self.requestData:find(" ")
    self.method = self.requestData:sub(1, pos-1 )
    pos = self.requestData:find(" ", #self.method + 2)
    self.path = self.requestData:sub( #self.method + 2, pos-1 )

    local headersEnd = self.requestData:find("\r\n\r\n")
    local contentStart = headersEnd + 4
    if not headersEnd then
        headerEnd = self.requestData:find("\n\n")
        contentStart = headersEnd + 2
    end

    self.callback( self )
end

return Request
