# lsh
Lua Shell Toolkit

## Why?

For fun. I've had a look and found some other projects that do exaclty the same thing ([here](https://github.com/zserge/luash), [here](https://github.com/stevedonovan/luaish) and [here](https://github.com/ncopa/lua-shell)), but not exaclty the way I wanted.

You can import your path commands into your Lua repl trought `lsh.import_path(opt)` function:

```lua
-- override and qualified false values
lsh.import_path() -- after that you might see same warnings, but it's ok

-- Will not overrides in name colisions and put all path commands under `lsh` module
lsh.import_path { overwrite = false, qualified = true }

-- Will overrides in name colisions and put all path commands onto globally scope
lsh.import_path { overwrite = true, qualified = true }
```

After import your path commands, you might have fun:

```lua
lsh.import_path()
curl 'http://example.com' -- will execute curl shell command and print the url contents
cat '/tmp/file'
ls '/tmp'
```

## lsh module

### ProcessResult

Type: `table`

Represents a result from a shell command, containing the command results.

| Property   | Type    | Description |
| ---------  | ------- | ----------- |
| name       | string  | Shell command name |
| text       | string  | Shell command result |

### ProcessCmd

Type: `table`

Represents a result from a shell command, containing the command results.

| Property   | Type    | Description |
| ---------- | ------- | ----------- |
| name       | string  | Shell command name |
| cmd        | string  | Shell command |

### import_path(opt)

Type: `function`

Reads your `$PATH` environment variable and creates a shell bridge for every path command and exposes using [io.popen](http://www.lua.org/manual/5.4/manual.html#pdf-io.popen) Lua function.

After that your path commands will be available for call in your global name or you can change that using `opt` parameter.

| Parameter | Type    | Default | Description |
| --------- | ------- | ------- | ----------- |
| overwrite | boolean | false   | The overwrite strategy in name colisions (`lsh` or `_G`) |
| qualified | boolean | false   | The import strategy when import path |

## Limitations or space to improve

- Currently, the library is using [io.popen](http://www.lua.org/manual/5.4/manual.html#pdf-io.popen), which is system dependent and is not available on all platforms.
- Supports only colon path delimiter.
- Pipes implementation started, but isn't finished.
- Didn't have any tests.

Contributions are very welcome. 😀