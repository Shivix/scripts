#!/usr/bin/env lua

local posix = require("posix")
local unistd = posix.unistd

if #arg == 0 then
    print("Usage: " .. arg[0] .. " <command>")
    os.exit(1)
end

local master, slave = posix.openpty()

local pid = unistd.fork()
if pid == 0 then
    unistd.close(master)
    unistd.execp(arg[1], { table.unpack(arg, 2) })
    os.exit(1)
end

unistd.close(slave)

local pager <close> = assert(io.popen("bat", "w"))

local chunk_size = 4096
while true do
    local chunk = unistd.read(master, chunk_size)
    if not chunk or #chunk == 0 then
        break
    end
    pager:write(chunk)
end
