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
    if self.contentLength and #self.requestData == self.contentLength then
        self.callback( self )
    end
end

function Request:parseHeader(header)
    local colonPos = header:find(":")
    if colonPos then
        local name = header:sub(1, colonPos-1):lower()
        local value = header:sub(colonPos+1)
        if value:sub(1,1) == " " then
            value = value:sub(2)
        end
        -- check for Content-Length
        if name == "content-length" then
            self.contentLength = tonumber( value )
        end
        self.headers[ name ] = value
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
        headersEnd = self.requestData:find("\n\n")
        contentStart = headersEnd + 2
    end

    -- parse headers line by line
    local headers = self.requestData:sub(1, headersEnd):gsub("\r\n", "\n")
    repeat
        pos = headers:find("\n")
        if pos then
            self:parseHeader( headers:sub(1, pos-1) )
            headers = headers:sub( pos+1 )
        else
            self:parseHeader( headers )
            headers = nil
        end
    until headers == nil

    -- content Data after headers
    self.requestData = self.requestData:sub(contentStart)

    if not self.contentLength or #self.requestData == self.contentLength then
        self.callback( self )
    end
end

return Request
