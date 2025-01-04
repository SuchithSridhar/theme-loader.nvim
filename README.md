# **theme-loader.nvim**

A highly configurable theme loader for Neovim that allows mapping of theme
names (like `dark`, `light`, etc.) to specific themes or custom functions.
Supports both automatic file watching and manual reloading of themes.

---

## **Features**

- Modular and configurable theme loading.
- Supports both built-in `vim.cmd.colorscheme()` strings and custom Lua functions.
- Automatic reloading when the theme file is saved (optional).
- Manual reload via a function (`reload_theme()`), which can be mapped to a keybind.
- Error handling with informative notifications.

## Purpose

I have other scripts that control the contents of `theme.txt` and this plugin
allows me to use that file to load a particluar theme. I also use this
`theme.txt` file to determine the theme for multiple different programs. This
plugin allows neovim to follow this consistency.

---


## **Installation**

### **Prerequisites**

- Neovim 0.8+.
- [lazy.nvim](https://github.com/folke/lazy.nvim) as your package manager.

### **Installation with `lazy.nvim`**

Add the following to your Neovim configuration:

```lua
require("lazy").setup({
  {
    "suchithsridhar/theme-loader.nvim",
    event = "VeryLazy", -- Ensure plugin loaded after UI elements
    config = function()
      require("theme-loader").setup({
        theme_file = os.getenv("HOME") .. "/.config/theme.txt", -- Path to your theme file
        theme_map = {
          dark = "tokyonight-night", -- Use Neovim colorscheme string
          light = "catppuccin-latte", -- Another colorscheme
          custom = function()         -- Custom function example
            vim.o.background = "dark"
            vim.cmd.colorscheme("gruvbox")
          end,
        },
        watch_file = true,  -- Enable or disable automatic reloading
      })
    end,
  },
})
```

---

## **Configuration**

### **`setup` options:**

| Option       | Type             | Required | Default | Description                                                               |
| -------------| ---------------- | -------- | ------- | ------------------------------------------------------------------------- |
| `theme_file` | `string`          | Yes      | `nil`   | Path to the file that contains the theme name (`dark`, `light`, etc.).    |
| `theme_map`  | `table<string, string|function>` | Yes      | `nil`   | A map of theme names to either a `colorscheme` string or a function.      |
| `watch_file` | `boolean`         | No       | `false` | Whether to watch the theme file and automatically reload on save.         |

---

### **Example Theme Map:**

```lua
theme_map = {
  dark = "tokyonight-night",       -- Use colorscheme "tokyonight-night"
  light = "catppuccin-latte",      -- Use colorscheme "catppuccin-latte"
  custom = function()              -- Custom function for complex theme setup
    vim.o.background = "dark"
    vim.cmd.colorscheme("gruvbox")
  end,
}
```

---

## **Usage**

### **1. Initial Theme Load:**

On startup, the plugin reads `theme.txt` and applies the corresponding theme.

### **2. Automatic Reload on Save:**

If `watch_file = true`, saving the theme file (`theme.txt`) automatically reloads the theme.

### **3. Manual Reload via Keybind:**

You can manually reload the theme using the `reload_theme()` function:
```lua
vim.keymap.set("n", "<leader>rt", function()
  require("theme-loader").reload_theme()
end, { desc = "Reload theme from theme.txt" })
```
- Press `<leader>rt` to reload the theme.

---

## **Example `theme.txt` File**

Contents of `theme.txt`:
```
dark
```
- If the file contains `"dark"`, the `"tokyonight-night"` theme is applied.
- If `"light"` is in the file, `"catppuccin-latte"` is applied.

---

## **Error Handling:**

- If the theme name from `theme.txt` does not exist in the `theme_map`, an error is displayed:
  ```text
  Theme-loader: No theme found for name '<theme_name>'.
  ```
- If the theme file path is incorrect or the file is empty, appropriate errors are shown.

---

## **FAQ**

### **1. How do I disable automatic reloading?**

Set `watch_file` to `false` in the `setup` configuration:

```lua
require("theme-loader").setup({
  theme_file = os.getenv("HOME") .. "/.config/theme.txt",
  theme_map = { dark = "tokyonight-night", light = "catppuccin-latte" },
  watch_file = false, -- Disable file watcher
})
```

### **2. Can I map more themes?**

Yes! You can add more theme mappings in the `theme_map`:

```lua
theme_map = {
  dark = "tokyonight-night",
  light = "catppuccin-latte",
  vscode = "vscode",
  gruvbox_dark = function()
    vim.o.background = "dark"
    vim.cmd.colorscheme("gruvbox")
  end,
}
```

