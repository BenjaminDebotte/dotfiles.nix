return {
  {
    "lucidph3nx/nvim-sops",
    event = { "BufReadPre", "BufNewFile" },
    cmd = { "SopsEncrypt", "SopsDecrypt" },
    opts = {},
    keys = {
      { "<leader>fe", "<cmd>SopsEncrypt<cr>", desc = "Encrypt buffer (SOPS)" },
      { "<leader>fd", "<cmd>SopsDecrypt<cr>", desc = "Decrypt buffer (SOPS)" },
      { "<leader>Se", "<cmd>SopsEncrypt<cr>", desc = "Encrypt buffer (SOPS)" },
      { "<leader>Sd", "<cmd>SopsDecrypt<cr>", desc = "Decrypt buffer (SOPS)" },
    },
  },
}
