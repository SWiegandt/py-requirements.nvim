# py-requirements.nvim

Neovim plugin that helps manage python requirements.

![demo](doc/demo.gif)

# Features

- Integrated with `nvim-cmp`
- Uses `treesitter` parser to read `requirements.txt`, hopefully more robust than
  ad-hoc string manipulation
- Displays diagnostics in `normal` mode with warnings for not using latest version
- Cache `pypi` responses within a session to improve performance
- Auto upgrade dependencies when keymaps are configured
- Display package description from PyPI in a floating window with syntax highlighting

# Limitations

- Only supports `requirements.txt` files, if there's interest this can be expanded

# Dependencies

- `curl` on your system: Used to get version information from pypi
- [plenary.nvim](https://github.com/nvim-lua/plenary.nvim): Used to run `curl` command
- [requirements](https://github.com/ObserverOfTime/tree-sitter-requirements) parser for
  [treesitter](https://github.com/nvim-treesitter/nvim-treesitter/tree/master): Used to
  parse `requirements.txt` file

# Install

## Lazy.nvim

```lua
{
    'MeanderingProgrammer/py-requirements.nvim',
    dependencies = { 'nvim-lua/plenary.nvim' },
    config = function()
        require('py-requirements').setup({
            -- Enabled by default if you do not use `nvim-cmp` set to false
            enable_cmp = true,
            -- Specify what file patterns to apply the plugin to
            -- For info on patterns, see :h pattern
            file_patterns = { 'requirements.txt' },
            -- For available options, see :h vim.lsp.util.open_floating_preview
            float_opts = { border = 'rounded' },
        })
    end,
}
```

## Set Keymaps

```lua
config = function()
    local requirements = require('py-requirements')
    vim.keymap.set('n', '<leader>ru', requirements.upgrade, { silent = true, desc = 'Requirements: Upgrade' })
    vim.keymap.set('n', '<leader>rU', requirements.upgrade_all, { silent = true, desc = 'Requirements: Upgrade All' })
    vim.keymap.set('n', '<leader>rK', requirements.show_description, { silent = true, desc = 'Requirements: Show package description' })
    requirements.setup({...})
end
```

## Install `requirements` Parser

```lua
require('nvim-treesitter.configs').setup({
    ...
    ensure_installed = {
        ...
        'requirements',
        ...
    },
    ...
})
```

## Add Completion Source

```lua
local cmp = require('cmp')
cmp.setup({
    ...
    sources = cmp.config.sources({
        ...
        { name = 'py-requirements' },
        ...
    }),
    ...
})
```

## Prioritize `sort_text` Comparator

The ideal (latest to oldest version) ordering is defined by the `sortText` attribute of each
completion item sent to `nvim-cmp`.

By default this comparator has been disabled by `nvim-cmp`. Comparators for requirements files
can be enabled by configuring `nvim-cmp` directly, or by setting the `cmp_sorting` option in the plugin config
to a list of comparators, which will automatically enable them for any buffer this plugin is active for.

The suggested sorting can be enabled by providing the following configuration when setting up the plugin:

```lua
require('py-requirements').setup({
    ...
    cmp_sorting = require("py-requirements.cmp").sort_by.version
})
```

# Testing

```bash
just test
```

# Related Projects

- [crates.nvim](https://github.com/Saecki/crates.nvim): Many ideas were taken from this
  project and translated to work with Python modules rather than Rust crates
- [cmp-pypi](https://github.com/vrslev/cmp-pypi): Found this one rather late, similar
  idea but built to work with `pyproject.toml` files

# TODO

- Support `pyproject.toml` / `poetry`
- Is there a way to configure `nvim-cmp` automatically with `require('cmp.config').set_buffer`,
  would likely run as part of `load` autocmd.
