return {
  "mbbill/undotree",
  config = function()
    -- Enable persistent undo
    vim.opt.undofile = true

    -- Keymaps for undotree
    vim.keymap.set("n", "<leader>u", vim.cmd.UndotreeToggle, { desc = "Toggle Undotree" })
  end,
}
