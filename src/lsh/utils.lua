local utils = {}

function utils.show(format, ...)
    print("lsh:",string.format(format, select(1, ...)))
end

function utils.iter(t)
    local idx
    return function()
        idx, value = next(t, idx)
        return value
    end
end

function utils.dir(t)
    for k,v in pairs(t or {}) do
         print(k,v)
    end
end

function utils.slice(t, idx)
    local result = {}
    table.move(t, idx, #t, 1, result)
    return result
end

return utils