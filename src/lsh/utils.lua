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

function map(fn, t)
    local value = {}
    for item in utils.iter(t) do
        table.insert(fn(item))
    end
    return value
end

return utils