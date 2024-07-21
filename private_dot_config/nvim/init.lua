-- bootstrap lazy.nvim, LazyVim and your plugins
require("config.lazy")

vim.cmd([[set spelllang=en_us,de]])

if not vim.g.vscode then
  local telescope = require("telescope")
  telescope.load_extension("chezmoi")
  vim.keymap.set("n", "<leader>cz", telescope.extensions.chezmoi.find_files, {})
end
