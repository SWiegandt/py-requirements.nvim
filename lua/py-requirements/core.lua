local api = require('py-requirements.api')
local requirements = require('py-requirements.requirements')
local ui = require('py-requirements.ui')
local user = require('py-requirements.user')

local function handle()
    local buf = user.buffer()
    local modules = requirements.parse_modules(buf)
    ui.display(buf, modules)
    for _, module in ipairs(modules) do
        vim.schedule(function()
            module.versions = api.get_versions(module.name)
            ui.display(buf, modules)
        end)
    end
end

local M = {}

function M.update()
    handle()
end

return M
