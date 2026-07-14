<div align="center">
  <h1>Roblox Universal UI Library</h1>
  <p>A modern and clean UI library for Roblox scripts.</p>
</div>

---

## Overview

**Roblox Universal UI** is a lightweight, responsive library for your exploit scripts. It features a clean design, smooth animations, and a straightforward API.

### Features
- Smooth window dragging and fluid animations.
- Clean tab system for organizing elements.
- Toggle visibility instantly with **`Right Shift`**.
- Fully automatic layout and scrollbar resizing.

---

## Quick Start

You can load this library directly into any script using `loadstring`:

```lua
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/danilito222222/roblox-universal-ui/master/library.lua"))()
```

---

## API Reference & Example

Here is a comprehensive example demonstrating how to build your interface:

```lua
-- 1. Load the Library
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/danilito222222/roblox-universal-ui/master/library.lua"))()

-- 2. Create the Main Window
local Window = Library:CreateWindow({
    Title = "Premium Hub V2"
})

-- 3. Create Tabs
local MainTab = Window:CreateTab("Main")
local SettingsTab = Window:CreateTab("Settings")

-- ==========================================
-- MAIN TAB ELEMENTS
-- ==========================================

-- Sections
MainTab:CreateSection("Character Mods")

-- Button with Notification
MainTab:CreateButton({
    Name = "Heal Player",
    Callback = function()
        Library:Notify({
            Title = "Success",
            Text = "Player has been healed to 100 HP!",
            Duration = 3
        })
    end
})

-- Toggle
local AutoFarmToggle = MainTab:CreateToggle({
    Name = "Auto-Farm",
    Default = false,
    Callback = function(state)
        print("Auto-farm is now:", state)
    end
})

-- Slider (With Floats!)
MainTab:CreateSlider({
    Name = "Jump Power Multiplier",
    Min = 1,
    Max = 5,
    Default = 1.5,
    Float = true, -- Now supports decimal numbers!
    Callback = function(value)
        print("Jump Multiplier:", value)
    end
})

-- TextBox (Input)
MainTab:CreateTextBox({
    Name = "Teleport to Player",
    Default = "Username...",
    Callback = function(text)
        print("Teleporting to:", text)
    end
})

-- ==========================================
-- SETTINGS TAB ELEMENTS
-- ==========================================
SettingsTab:CreateSection("Preferences")

-- Dropdown
SettingsTab:CreateDropdown({
    Name = "Select Theme",
    Options = {"Dark", "Light", "Abyss"},
    Callback = function(selected)
        print("Theme:", selected)
    end
})

-- Keybind
SettingsTab:CreateKeybind({
    Name = "Toggle Menu Key",
    Default = Enum.KeyCode.RightShift,
    Callback = function()
        print("Keybind pressed!")
    end
})

-- Color Picker
SettingsTab:CreateColorPicker({
    Name = "ESP Color",
    Default = Color3.fromRGB(255, 0, 0),
    Callback = function(color)
        print("New ESP Color set!")
    end
})

-- Programmatically change values later:
-- AutoFarmToggle:Set(true)
```

---

<div align="center">
  <p>by NochHawk</p>
</div>
