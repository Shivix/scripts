#!/usr/bin/env lua

local lualib_file = require "lualib.file"

if #arg ~= 1 then
    print("Usage: " .. arg[0] .. " <file>")
    os.exit(1)
end
local filename = arg[1]

local output_lines = {}
local inside_code = false
local code_lines = {}
local code_language = nil
local code_block_count = 0

local function create_code_file(file_type)
    local code_file <close> = lualib_file.tmp_file("sent_code_gen", "." .. file_type)
    local image_filename = string.format("/tmp/sent_code_gen_%d.png", code_block_count)

    code_file:write(table.concat(code_lines, "\n"))
    code_file:flush()

    local base = 70
    local min = 14
    local font_size = math.floor(base - (#code_lines * 2))
    if font_size < min then font_size = min end
    local cmd = string.format(
        'silicon %s --output %s --no-window-controls --pad-horiz 150 --pad-vert 150 --no-round-corner --background "#000000" --theme gruvbox-dark --font "JetBrains Mono=%d"',
        code_file.path, image_filename, font_size
    )
    os.execute(cmd)

    table.insert(output_lines, "@" .. image_filename)
end

for line in io.lines(filename) do
    if line:match("^```") then
        if inside_code then
            -- End of code block.
            create_code_file(code_language)
            inside_code = false
            code_lines = {}
        else
            -- Beginning of code block.
            code_language = line:match("```(%w+)")
            assert(code_language, "please provide a language to the code block")
            inside_code = true
            code_block_count = code_block_count + 1
        end
        goto continue
    end

    if inside_code then
        table.insert(code_lines, line)
    else
        table.insert(output_lines, line)
    end
    ::continue::
end

for _, line in ipairs(output_lines) do
    print(line)
end
