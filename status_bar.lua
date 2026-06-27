#!/usr/bin/env lua

local posix = require("posix")
local poll = require("posix.poll")

-- TODO: Add the current pid to a file. (delete on close)
-- Could also consider listening on sockets and select. Can have consistent port and possible to send value from outside.
posix.signal(posix.SIGUSR1, function()
    --local handle <close> = assert(io.popen("dmenu </dev/null"))
    --local input = handle:read("*all")
end)
-- TODO: Check if the pid file exists, if so, don't fully run script, just trigger an update.

local function sleep(seconds)
    local timeout_ms = seconds * 1000
    local fds = {}

    local res, _, errno = poll.poll(fds, timeout_ms)
    if not res and errno == posix.errno.EINTR then
        return false
    end
    return true
end

local function sysctl(node)
    local handle <close> = assert(io.popen("sysctl -n " .. node))
    local result = handle:read("*line")
    return result
end

local function get_uname()
  local f <close> = assert(io.popen("uname -s 2>/dev/null"))
  return f:read("*l")
end
local uname = get_uname()

local idle_prev
local total_prev
local function linux_cpu_usage()
    local handle <close> = assert(io.open("/proc/stat"))
    local first_line = handle:read("*line")
    local cpu_stats = {}
    for word in first_line:gmatch("(%d+)") do
        table.insert(cpu_stats, tonumber(word))
    end
    local idle = cpu_stats[4] + cpu_stats[5]
    local total = 0
    for i = 1, #cpu_stats - 2 do
        total = total + cpu_stats[i]
    end

    local diff_idle = idle - tonumber(idle_prev or 0)
    local diff_total = total - tonumber(total_prev or 0)
    local usage = (1 - diff_idle / diff_total) * 100
    idle_prev = idle
    total_prev = total
    return math.floor(usage) .. "%"
end
local function freebsd_cpu_usage()
    local h <close> = assert(io.popen("vmstat 1 2 | tail -1"))
    local line = h:read("*line")

    local idle = tonumber(line:match("(%d+)%s*$"))
    return tostring(100 - idle) .. "%"
end

local function linux_cpu_temp()
    local handle = assert(io.popen("sensors 2>/dev/null | grep --max-count=1 ^CPU:"))
    local result = handle:read("*all")
    handle:close()
    local pos = result:find("%+")
    return result:sub(pos + 1):gsub("%s", "")
end
local function freebsd_cpu_temp()
    local handle <close> = assert(io.popen("sysctl -n dev.cpu.0.temperature"))
    local result = handle:read("*line")
    return result
end

local function linux_ram_usage()
    local total_mem, available_mem
    for line in io.lines("/proc/meminfo") do
        if line:match("^MemTotal:") then
            total_mem = tonumber(line:match("%d+"))
        elseif line:match("^MemAvailable:") then
            available_mem = tonumber(line:match("%d+"))
        end

        if total_mem and available_mem then
            break
        end
    end
    local used_mem = total_mem - available_mem
    return math.floor(used_mem / 1024) .. " MB"
end
local function freebsd_ram_usage()
    local page_size = tonumber(sysctl("hw.pagesize")) or 4096
    local active_pages = tonumber(sysctl("vm.stats.vm.v_active_count"))
    local wire_pages = tonumber(sysctl("vm.stats.vm.v_wire_count"))
    local laundry_pages = tonumber(sysctl("vm.stats.vm.v_laundry_count"))

    local used_pages = active_pages + wire_pages + laundry_pages
    local used_mb = math.floor((used_pages * page_size) / (1024 * 1024))
    return used_mb .. "MB"
end

local battery_alert = false
local function alert_if_battery_low(capacity, charging)
    if capacity < 20 and not charging and (battery_alert == false or capacity < 10) then
        os.execute("notify-send --urgency critical 'Low Battery' '"..capacity .. "% remaining'")
        battery_alert = true
    end
    if capacity > 20 then
        battery_alert = false
    end
end

local function linux_battery_usage()
    local battery_path = "/sys/class/power_supply/BAT0/"
    local status_file = battery_path .. "status"
    local capacity_file = battery_path .. "capacity"
    local power_file = battery_path .. "power_now"

    local file = assert(io.open(status_file, "r"))
    local status = ""
    local charging = false
    if file:read("*l") ~= "Discharging" then
        status = " AC"
        charging = true
    end
    file:close()
    file = assert(io.open(capacity_file, "r"))
    local capacity = tonumber(file:read("*all"))
    file:close()
    local wattage = ""
    if not charging then
        file = assert(io.open(power_file, "r"))
        local power_now = file:read("*all")
        file:close()
        wattage = string.format(" %.2fW", power_now / 1000000)
    end
    alert_if_battery_low(capacity, charging)

    return capacity .. "%" .. status .. wattage
end
local function freebsd_battery_usage()
    local state = tonumber(sysctl("hw.acpi.battery.state"))
    local rate = sysctl("hw.acpi.battery.rate")
    local charging = state == 2 or state == 0
    if charging then
        rate = "AC"
    else
        rate = math.floor(rate / 1000) .. "W"
    end

    local life = sysctl("hw.acpi.battery.life")
    alert_if_battery_low(tonumber(life), charging)

    return life .. "% " .. rate
end

while not os.execute("xprop -root >/dev/null") do
    os.execute("sleep 0.2")
end

local ok, result = pcall(function()
    local cpu_usage
    local cpu_temp
    local ram_usage
    local battery_usage
    if uname == "Linux" then
        cpu_usage = linux_cpu_usage
        cpu_temp = linux_cpu_temp
        ram_usage = linux_ram_usage
        battery_usage = linux_battery_usage
    elseif uname == "FreeBSD" then
        cpu_usage = freebsd_cpu_usage
        cpu_temp = freebsd_cpu_temp
        ram_usage = freebsd_ram_usage
        battery_usage = freebsd_battery_usage
    else
        error("unsupported OS")
    end

    local sleep_alert = false
    while true do
        local date = os.date("%H:%M %a %d %B")
        if tonumber(os.date("%H")) >= 23 and sleep_alert == false then
            os.execute("notify-send 'It is past 11PM, time to stop programming'")
            sleep_alert = true
        end
        local status_line = string.format("CPU: %s @ %s | RAM: %s | BAT: %s | %s", cpu_usage(), cpu_temp(), ram_usage(), battery_usage(), date)
        assert(os.execute("xsetroot -name '" .. status_line .. "'"))
        sleep(15)
    end
end)
if not ok then
    os.execute("notify-send --urgency critical 'status_bar failed: " .. result .. "'")
end
