local lsh = {
    paths = {'/bin', '/usr/bin'}
}
local utils = require 'lsh.utils'

local LuaShellProcess = {
    __tostring = function(t)
        return t.text
    end
}

local function ProcessResult(name, text, errorcode)
    local new = {name = name, text = text, errorcode = errorcode}
    setmetatable(new, LuaShellProcess)
    return new
end

local function shell_bridge(name)
    return function(...)
        local cmd = string.format("%s %s", name, table.concat({...}, " "))
        local handle = io.popen(cmd)
        local result = ProcessResult(name, handle:read("*a"), errorcode)
        handle:close()
        return result
    end
end

local function path()
    local cmds = {}
    local brigde = shell_bridge "ls"
    for dir in utils.iter(lsh.paths) do
        table.insert(cmds, brigde(dir).text)
    end
    return string.gmatch(table.concat(cmds, "\n"), "%g+")
end

function lsh.import_path(t)
    local opt = t or {}
    local path = path()
    for name in path do
        if not opt.overwrite and lsh[name] then
            utils.show("warning: the '%s' command already exists")
        else
            _G[name] = shell_bridge(name)
            if opt.import_type == "qualified" then
                lsh[name] = _G[name]
            end
        end
    end
end

return lsh