#!/usr/sbin/lua

require("os")

function wrp(tmplte, left_side, right_side)
    local bracket_color = "#287373"
    local fg_color      = "#cccccc"
    local left_side     = left_side or "[ "
    local right_side    = right_side or " ]"
    local function setcol(s)
        return '%{F' .. s .. '}'
    end
    local function closecol()
        return '%{F-}'
    end
    return setcol(bracket_color) .. left_side .. closecol() ..
           setcol(fg_color) .. tmplte .. closecol() ..
           setcol(bracket_color) .. right_side .. closecol()
end

local mpd_defaults={
    address="localhost", -- mpd server info (localhost:6600 are mpd defaults)
    port=6600,           -- mpd server default port
    password=nil,        -- mpd password (if any)
    mpd_len = 80,        -- default mpd string length
}

local alter_fn="Iosevka"
local success
local last_success

local function saferead(file)
    local data, err, errno
    repeat
        data, err, errno = file:read()
    until errno ~= 4 -- EINTR
    return data, err, errno
end

local function get_mpd_status()
    local cmd_string = "status\n"
                     .. "close\n"
    if mpd_defaults.password ~= nil then
        cmd_string = "password " 
                   .. mpd_defaults.password
                   .. "\n"
                   .. cmd_string
    end
    cmd_string = string.format('echo -n "%s" | netcat %s %d', cmd_string, mpd_defaults.address, mpd_defaults.port)
    last_success = success
    success = false
    local mpd = io.popen(cmd_string, "r")

    -- welcome msg
    local data = saferead(mpd)
    if data == nil or string.sub(data,1,6) ~= "OK MPD" then
        mpd:close()
        print(wrp("no mpd", "[","]"))
        return wrp("no mpd", "[","]")
    end

    local info = {}
    repeat
        data = saferead(mpd)
        if data == nil then break end
        local _,_,attrib,val = string.find(data, "(.-): (.*)")
        if attrib == "volume" then
            info.volume = val
        elseif attrib == "state" then
            info.state = val
        end
    until string.sub(data,1,2) == "OK" or string.sub(data,1,3) == "ACK"
    if data == nil or string.sub(data,1,2) ~= "OK" then
        mpd:close()
        print("error querying mpd status")
        return wrp("error querying mpd status", "[","]")
    end

    mpd:close()
    success = true

    -- done querying; now build the string
    if info.state == "play" then
        mpd_st = wrp("Vol: " .. info.volume.."%")
        print(mpd_st)
    else
        print ""
    end
end

get_mpd_status()
