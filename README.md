<div align="center">
  <h1>✨ Roblox Universal UI Library ✨</h1>
  <p>A modern, fluid, and highly customizable UI library for Roblox script execution.</p>
  
  [![Lua](https://img.shields.io/badge/Language-Lua-blue.svg)](https://www.lua.org/)
  [![Roblox](https://img.shields.io/badge/Platform-Roblox-red.svg)](https://www.roblox.com/)
  [![License](https://img.shields.io/badge/License-MIT-green.svg)](https://opensource.org/licenses/MIT)
</div>

---

## 🚀 Overview

**Roblox Universal UI** is designed to give your exploit scripts a beautiful, Fluent-inspired look. It works flawlessly across **all major executors** (Synapse X, Krnl, Script-Ware, Fluxus, Delta, etc.).

### 🛡️ Compatibility & Audit
- **CoreGui Support**: Automatically attempts to place the UI in `CoreGui` to protect it from being detected by game anti-cheats. If `CoreGui` is restricted (on weaker executors), it gracefully falls back to `PlayerGui`.
- **Anti-Break Layout**: Uses dynamic `UIListLayout` calculation, meaning you can add 1,000+ buttons and the scrollbar will automatically adjust.
- **Persistent**: `ResetOnSpawn` is disabled, so your UI won't disappear when your character dies.

---

## ⚡ Features

| Feature | Description |
|---|---|
| 🖱️ **Smooth Dragging** | Grab the top bar to easily drag the window across your screen. |
| 🗂️ **Tab System** | Organize your script features cleanly into multiple tabs. |
| 🎨 **Fluid Animations** | Every interaction features premium `TweenService` animations (e.g., Ripple effects on buttons). |
| ⌨️ **Quick Toggle** | Press **`Right Shift`** to hide/show the menu instantly. |
| ❌ **Close Button** | Click the **`X`** in the top right to completely unload the UI from the game. |

---

## 📦 How to Load (Quick Start)

You can load this library directly into any of your scripts without downloading files. Just use `loadstring`:

```lua
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/danilito222222/roblox-universal-ui/master/library.lua"))()
```

---

## 🛠️ API Reference & Examples

Here is a comprehensive example demonstrating everything you can create. Copy and paste this to see it in action!

```lua
-- 1. Load the Library
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/danilito222222/roblox-universal-ui/master/library.lua"))()

-- 2. Create the Main Window
local Window = Library:CreateWindow({
    Title = "🔥 My Awesome Script"
})

-- 3. Create Tabs
local MainTab = Window:CreateTab("Player")
local CombatTab = Window:CreateTab("Combat")

-- ==========================================
-- 🟢 PLAYER TAB ELEMENTS
-- ==========================================

-- Button
MainTab:CreateButton({
    Name = "Heal Player",
    Callback = function()
        print("Heal button clicked!")
    end
})

-- Toggle (Switch)
MainTab:CreateToggle({
    Name = "Auto-Farm",
    Default = false,
    Callback = function(state)
        print("Auto-farm is now:", state)
        -- `state` is true or false
    end
})

-- Slider
MainTab:CreateSlider({
    Name = "WalkSpeed",
    Min = 16,
    Max = 250,
    Default = 16,
    Callback = function(value)
        game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = value
    end
})

-- ==========================================
-- 🔴 COMBAT TAB ELEMENTS
-- ==========================================

-- Dropdown
CombatTab:CreateDropdown({
    Name = "Select Target",
    Options = {"Noob1", "ProGamer", "Admin"},
    Callback = function(selected)
        print("You selected:", selected)
    end
})
```

---

<div align="center">
  <p>Made with ❤️ by the open-source community. Feel free to fork and modify!</p>
</div>
