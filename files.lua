-- Pluggy init file
-- (c)copyright 2018 by Gerald Wodni <gerald.wodni@gmail.com>

local Mimetypes = {
    lua = "text/plain"
}

local function unescape( input )
    local text = ""
    local i = 1
    repeat
        local c = input:sub( i, i )
        if c == "%" and i + 2 < #input then
            text = text .. string.char( tonumber( "0x" .. input:sub( i+1, i+2 ) ) )
            i = i+2
        else
            text = text .. c
        end
        i = i + 1
    until i > #input
    return text
end

local function serveFile( req, res, filename, download )
    local pos = filename:find(".[^.]*$")
    local extension = ""
    if pos then
        extension = filename:sub(pos+1)
    end
    print("Extension:", extension)
    local f = file.open( filename, "r" )
    if f then
        local mime = Mimetypes[ extension ]
        if not mime then
            mime = "application/octet-stream"
        end
    
        res:status("200 OK")
        res:header("Content-Type", mime)
        res:header("Connection", "close")
        res:header("Content-Length", tostring( f:seek("end") ))
        if download then
            res:header("Content-Disposition", 'attachment;filename="' .. filename .. '"')
        end
        f:seek("set")
        repeat
            local chunk = f:read()
            if chunk then
                res:send(chunk)
            end
        until chunk == nil
        f:close()
    else
        res:sendStatus("404 Not Found", "File not found")
    end
end

Router["/files"] = function( req, res )
    print("calling ls")
    res:status("200 OK")
    res:header("Content-Type", "text/html")
    res:send("<h1>ls</h1>")
    local remaining, used, total
    remaining, used, total = file.fsinfo()
    res:send("<p>Total: " .. total .. "kb<br/>Used: " .. used .. "kb<br/>Free: " .. remaining .. "kb</p>")
    res:send("<table><thead><tr><th>Name</th><th>Size</th><th>Action</th></tr></thead><tbody>")
    for name, size in pairs( file.list() ) do
        res:send( "<tr><td>" .. name .. "</td><td>" .. size .. "</td>"
            .. "<td><a href=\"/files/show/" .. name .. "\">Show</a></td>"
            .. "<td><a href=\"/files/download/" .. name .. "\">Download</a></td>"
            .. "<td><a href=\"/files/edit/" .. name .. "\">Edit</a></td>"
            .. "<td><a href=\"/files/delete/" .. name .. "\">Delete</a></td>"
            .. "</tr>" )
    end
    res:send("</tbody></table>");
    print("ls done!")
end

Router["^/files/show"] = function( req, res )
    local filename = unescape( req.path:sub( 13 ) )
    serveFile( req, res, filename )
end

Router["^/files/download"] = function( req, res )
    local filename = unescape( req.path:sub( 17 ) )
    serveFile( req, res, filename, true )
end

Router["^/files/delete"] = function( req, res )
    local filename = unescape( req.path:sub( 15 ) )
    print("Deleting>" .. filename .. "<" )
    print( file.remove( filename ) )
    res:sendStatus( "200 OK", "File deleted" )
end

Router["^/files/edit"] = function( req, res )
    local filename = unescape( req.path:sub( 13 ) )
    serveFile( req, res, filename )
end

Router["^/files/save"] = function( req, res )
    local filename = unescape( req.path:sub( 13 ) )
    res:sendStatus( "200 OK", req.requestData )
end

