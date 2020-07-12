local lsh = {}
local utils = require "lsh.utils"

local LuaShellProcess

function lsh.ProcessResult(name, text, errorcode)
    local new = {name = name, text = text, errorcode = errorcode}
    setmetatable(new, LuaShellProcess)
    return new
end

function lsh.ProcessCmd(name, cmd)
    local new = {name = name, cmd = cmd or name}
    setmetatable(new, LuaShellProcess)
    return new
end

LuaShellProcess = {
    __tostring = function(t)
        return t.text or string.format("%s shell function", t.name)
    end,
    __bor = function(pin, pout)
        local cmd = ProcessCmd(pout.name .. "<<<" .. pin.text)
        return cmd().text
    end,
    __call = function(...)
        local params = {...}
        local cmd = params[1] or error('cmd not found')
        local cmdargs = string.format("%s %s", cmd.name, table.concat(utils.slice(params, 2), " "))
        local handle = io.popen(cmdargs)
        local result = ProcessResult(cmd.name, handle:read("*a"), errorcode)
        handle:close()
        return result
    end
}

local function path()
    local cmds = {}
    local brigde = ProcessCmd("ls")
    for dir in os.getenv("PATH"):gmatch("([^:]+)") do
        table.insert(cmds, brigde(dir).text)
    end
    return string.gmatch(table.concat(cmds, "\n"), "%g+")
end

function lsh.import_path(t)
    local opt = t or {}
    local qualified, overwrite = opt.qualified or false, opt.overwrite or false
    for name in path() do
        local target = _G
        if qualified == true then
            target = lsh
        end
        if overwrite == false and target[name] then
            utils.show("warning: the '%s' command already exists", name)
        else
            target[name] = ProcessCmd(name)
        end
    end
end

return lsh