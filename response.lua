-- HTTP Response class
-- (c)copyright 2018 by Gerald Wodni <gerald.wodni@gmail.com>

local Response = {}
Response.__index = Response

function Response.new( connection )
  local self = setmetatable( {}, Response )
  self.connection = connection
  self.headersSent = false
  self.sendQueue = {}
  return self
end

function Response:queue( data )
    self.sendQueue[ #self.sendQueue + 1 ] = data
end

function Response:status( status )
  self:queue( "HTTP/1.1 " .. status .. "\r\n" )
end

function Response:header( name, value )
  self:queue( name .. ":" .. value .. "\r\n" )
end

function Response:send( data )
  if not self.headersSent then
    self:queue( "\r\n" )
    self.headersSent = true
  end
  self:queue( data )
end

function Response:close( data )
    if data then
        self:queue(data)
    end

    -- send queued responses
    local function send()
        if #self.sendQueue > 0 then
            self.connection:send(table.remove( self.sendQueue, 1 ))
        else
            -- close connection once finished
            self.connection:close()
            -- free remaining references and start gc
            self.connection = nil
            self.sendQueue = nil
            collectgarbage()
        end
    end

    self.connection:on("sent", send)
    send()
end

-- helpers
function Response:sendStatus(status, description)
    self:status(status)
    self:header("Content-Type", "text/html")
    self:send("<h1>" .. status .. "</h1><p>" .. description .. "</p>")
end

return Response
