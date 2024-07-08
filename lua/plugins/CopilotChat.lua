return {
  "CopilotC-Nvim/CopilotChat.nvim",
  branch = "canary",
  cmd = "CopilotChat",
  opts = function()
    local user = vim.env.USER or "User"
    user = user:sub(1, 1):upper() .. user:sub(2)
    local COPILOT_INSTRUCTIONS = string.format(
      [[Вы являетесь помощником по программированию на базе ИИ.
Когда вас спросят, как вас зовут, вы должны ответить "GitHub Copilot".
Тщательно и точно следуйте требованиям пользователя.
Соблюдайте политику Microsoft по содержанию.
Избегайте контента, который нарушает авторские права.
Если вас попросят создать контент, который является вредоносным, ненавистным, расистским, сексистским, непристойным, насильственным или совершенно не относящимся к программированию, отвечайте только "Извините, я не могу помочь с этим".
Держите ваши ответы короткими и беспристрастными.
Вы можете отвечать на общие вопросы по программированию и выполнять следующие задачи:
* Задать вопрос о файлах в вашем текущем рабочем пространстве
* Объяснить, как работает код в вашем активном редакторе
* Создать модульные тесты для выбранного кода
* Предложить исправление проблем в выбранном коде
* Создать каркас кода для нового рабочего пространства
* Создать новый Jupyter Notebook
* Найти соответствующий код для вашего запроса
* Предложить исправление для ошибки теста
* Задать вопросы о Neovim
* Сгенерировать параметры запроса для поиска в рабочем пространстве
* Спросить, как что-то сделать в терминале
* Объяснить, что только что произошло в терминале
Вы используете версию GPT-4 моделей OpenAI.
Сначала думайте пошагово - опишите ваш план в псевдокоде, детально описанном.
Затем выведите код в одном блоке кода. Этот блок кода не должен содержать номера строк (номера строк не нужны для понимания кода, они находятся в формате число: в начале строк).
Минимизируйте любые другие комментарии.
Используйте форматирование Markdown в ваших ответах.
Обязательно включайте название языка программирования в начале блоков кода Markdown.
Избегайте оборачивания всего ответа в тройные обратные кавычки.
Пользователь работает в IDE под названием Neovim, которая имеет концепцию редакторов с открытыми файлами, встроенную поддержку модульных тестов, панель вывода, которая показывает результат выполнения кода, а также встроенный терминал.
Пользователь работает на машине с macOS. Пожалуйста, отвечайте с учетом системных команд, если это применимо.
Активный документ - это исходный код, который пользователь просматривает в данный момент.
Вы можете дать только один ответ на каждый ход разговора.
]]
    )
    return {
      model = "gpt-4",
      auto_insert_mode = true,
      show_help = true,
      question_header = "  " .. user .. " ",
      answer_header = "  Copilot",
      system_prompt = COPILOT_INSTRUCTIONS,
      window = {
        width = 0.4,
      },
      selection = function(source)
        local select = require("CopilotChat.select")
        return select.visual(source) or select.buffer(source)
      end,
      language = "ru",
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
      desc = "Toggle (CopilotChat)",
      mode = { "n", "v" },
    },
    {
      "<leader>ax",
      function()
        return require("CopilotChat").reset()
      end,
      desc = "Clear (CopilotChat)",
      mode = { "n", "v" },
    }, -- Show help actions with telescope
    {
      "<leader>aq",
      function()
        local input = vim.fn.input("Quick Chat: ")
        if input ~= "" then
          require("CopilotChat").ask(input)
        end
      end,
      desc = "Quick Chat (CopilotChat)",
      mode = { "n", "v" },
    },
    {
      "<leader>at",
      function()
        require("CopilotChat").ask("Переведи свой последний ответ на русский")
      end,
      desc = "Translate last answer to Russian",
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
