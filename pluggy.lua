-- Pluggy main file
-- (c)copyright 2018 by Gerald Wodni <gerald.wodni@gmail.com>
local Request  = require "request"
local Response = require "response"

-- web server
function webserver(port, router)
    local server = net.createServer(net.TCP, 10000)
    server:listen(port, function( connection )
        -- accumulate header  
        local req = Request.new( connection, function( req )
            -- find matching response handler
            local res = Response.new( connection );
            if router[req.path] ~= nil then
                router[req.path]( req, res )
            else
                -- no direct match, check for prefix handler
                local found = false
                for path, handler in pairs(router) do
                    if path:sub(1,1) == "^" and #req.path >= #path-1 and path:find( req.path:sub( 1, #path-1 ), 2, true ) == 2 then
                        handler( req, res )
                        found = true
                        break
                    end
                end

                -- handle 404
                if not found then
                    if router["404"] ~= nil then
                        router["404"]( req, res )
                    else
                        res:sendStatus("404 Not Found", "Resource not found")
                    end
                end
            end
            res:close()
            req = nil
            res = nil
        end)
    end)
end

-- Global router object
Router = {}

-- run this on startup
function connect()
    -- debug echo
    Router["/debug"] = function( req, res )
        res:status( "200 OK" )
        res:header( "Content-Type", "text/html" )
        res:send("<h1>debug</h1><h2>" .. req.method .. " &gt;" .. req.path .. "&lt;</h2>")
        res:send( "<table><thead><tr><th>Field</th><th>Value</th></tr></thead><tbody>" )
        for name, value in pairs(req.headers) do
            res:send( "<tr><td>" .. name .. "</td><td>" .. value .. "</td></tr>" )
        end
        res:send( "</tbody></table>" .. "<h3>ContentData:</h3><pre>" .. req.requestData .. "</pre>")
        print( "All sent!" )
    end
    -- debug routes
    Router["/routes"] = function( req, res )
        res:status( "200 OK" )
        res:header( "Content-Type", "text/html" )
        res:send("<h1>Routes</h1><ul>")
        for path, handler in pairs( Router ) do
            res:send("<li>" .. path .. "</li>")
        end
        res:send("</ul>")
    end
    
    -- zeroconf dns (propagate host as <name>.local in lan)
    mdns.register("pluggy")
    webserver(80, Router)
end

function startup()
    
    print("Waiting for IP")
    tmr.alarm(0, 500, tmr.ALARM_SEMI, function()
        if wifi.sta.getip() == nil then
            print("No IP")
            tmr.start(0)
        else
            print("Got IP")
            tmr.unregister(0)
            connect()
        end
    end)
end
startup()
