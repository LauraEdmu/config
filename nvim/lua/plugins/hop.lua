return {
  {
    "phaazon/hop.nvim",
    version = "*",
    opts = {},
    keys = {
      {
        "gw",
        function()
          require("hop").hint_words()
        end,
        mode = "n",
        desc = "Hop to word (Helix-style)",
      },
    },
  },
}

