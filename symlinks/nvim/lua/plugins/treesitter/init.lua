return {
  "nvim-treesitter/nvim-treesitter",
  branch = "main",
  build = ":TSUpdate",
  config = function()
    local ts = require("nvim-treesitter")
    local languages = { "lua", "vim", "c", "cpp", "python", "bash", "cmake" }

    -- Install parsers (tap is NOT here — it's manual)
    ts.install(languages)

    -- Register custom tap parser
    vim.treesitter.language.add("tap", {
      path = vim.fn.expand("~/.config/nvim/parser/tap.so"),
    })
    vim.treesitter.language.register("tap", "tap")

    -- Enable highlighting/indent/folds per filetype
    vim.api.nvim_create_autocmd("FileType", {
      pattern = vim.list_extend({ "tap" }, languages),
      callback = function()
        vim.treesitter.start()
        vim.wo.foldexpr = "v:lua.vim.treesitter.foldexpr()"
        vim.wo.foldmethod = "expr"
        vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
      end,
    })
  end,
}
