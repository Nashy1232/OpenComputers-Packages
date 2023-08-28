local event = require "event"
local shell = require "shell"
local thread = require "thread"

local threads = {}
local program = "/usr/bin/starlight-transmuter/script.lua"

function start()
    local proc = thread.create(shell.execute, program, os.getenv("shell"))
    proc:detach()
    table.insert(threads, proc)
end

function stop()
    for i, proc in  ipairs(threads) do
        if proc.status and proc:status() ~= "dead" then
            proc:kill()
        end
    end
end