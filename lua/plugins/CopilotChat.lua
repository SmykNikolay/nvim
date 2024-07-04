return {
  "CopilotC-Nvim/CopilotChat.nvim",
  branch = "canary",
  cmd = "CopilotChat",
  opts = function()
    local user = vim.env.USER or "User"
    user = user:sub(1, 1):upper() .. user:sub(2)
    return {
      model = "gpt-4",
      auto_insert_mode = true,
      show_help = true,
      question_header = "  " .. user .. " ",
      answer_header = "  Copilot",
      window = {
        width = 0.4,
      },
      selection = function(source)
        local select = require("CopilotChat.select")
        return select.visual(source) or select.buffer(source)
      end,
      -- Добавляем настройки языка
      language = "ru", -- Указываем язык общения
      pre_prompt = "Все ответы должны быть на русском языке. ", -- Предварительная настройка для общения
    }
  end,
  keys = {
    { "<c-s>", "<CR>", ft = "copilot-chat", desc = "Submit Prompt", remap = true },
    { "<leader>a", "", desc = "+ai", mode = { "n", "v" } },
    {
      "<leader>aa",
      function()
        return require("CopilotChat").toggle()
      end,
      desc = "Toggle (CopilotChat )",
      mode = { "n", "v" },
    },
    {
      "<leader>ax",
      function()
        return require("CopilotChat").reset()
      end,
      desc = "Clear (CopilotChat)",
      mode = { "n", "v" },
    },

    {
      "<leader>ah",
      function()
        DESIGN_PATTERNS = {
          "Abstract Factory",
          "Builder",
          "Factory Method",
          "Prototype",
          "Singleton",
          "Adapter",
          "Bridge",
          "Composite",
          "Decorator",
          "Facade",
          "Flyweight",
          "Proxy",
          "Chain of Responsibility",
          "Command",
          "Interpreter",
          "Iterator",
          "Mediator",
          "Memento",
          "Observer",
          "State",
          "Strategy",
          "Template Method",
          "Visitor",
        }

        require("CopilotChat").ask(
          "Посоветуй как улучшить код, используя лучшие практики и паттерны програмирования "
            .. table.concat(DESIGN_PATTERNS, " ")
        )
      end,
      desc = "Design Pattern",
      mode = { "n", "v" },
    },

    {

      "<leader>aq",
      function()
        local input = vim.fn.input("Quick Chat: ")
        if input ~= "" then
          require("CopilotChat").ask(
            "Все ответы должны быть на русском языке. " .. input
          )
        end
      end,
      desc = "Quick Chat (CopilotChat)",
      mode = { "n", "v" },
    },

    -- ---------------------------
    {
      "<leader>af",
      function()
        require("CopilotChat").ask(
          "Посоветуй, какие новые функции языка я могу использовать в текущем файле."
        )
      end,
      desc = "New Language Features Advice",
      mode = { "n", "v" },
    },
    {
      "<leader>aR",
      function()
        require("CopilotChat").ask(
          "Посоветуй, как улучшить читаемость текущего файла."
        )
      end,
      desc = "Code Readability Improvement Advice",
      mode = { "n", "v" },
    },
    {
      "<leader>aS",
      function()
        require("CopilotChat").ask(
          "Посоветуй, как улучшить безопасность текущего файла."
        )
      end,
      desc = "Security Improvement Advice",
      mode = { "n", "v" },
    },
    {
      "<leader>aF",
      function()
        require("CopilotChat").ask(
          "Посоветуй, как улучшить производительность текущего файла."
        )
      end,
      desc = "Performance Improvement Advice",
      mode = { "n", "v" },
    },
    {
      "<leader>ar",
      function()
        require("CopilotChat").ask("Посоветуй, как рефакторить текущий файл.")
      end,
      desc = "Refactor Advice",
      mode = { "n", "v" },
    },
    -- Show help actions with telescope
    -- Show prompts actions with telescope
  },
  config = function(_, opts)
    local chat = require("CopilotChat")
    require("CopilotChat.integrations.cmp").setup()

    vim.api.nvim_create_autocmd("BufEnter", {
      pattern = "copilot-chat",
      callback = function()
        vim.opt_local.relativenumber = false
        vim.opt_local.number = false
      end,
    })

    chat.setup(opts)
  end,
}
