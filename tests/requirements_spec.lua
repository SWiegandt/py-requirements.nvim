local requirements = require('py-requirements.requirements')

describe('requirements', function()
    it('test', function()
        local buf = vim.api.nvim_get_current_buf()
        vim.print(buf)
        vim.print(vim.inspect(requirements.parse_modules(buf)))
        assert.equals(2, 2)
    end)
end)
