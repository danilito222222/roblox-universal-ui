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
    Title = "My Awesome Script"
})

-- 3. Create Tabs
local MainTab = Window:CreateTab("Player")
local CombatTab = Window:CreateTab("Combat")

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

-- Dropdown
CombatTab:CreateDropdown({
    Name = "Select Target",
    Options = {"Player1", "Player2", "Admin"},
    Callback = function(selected)
        print("You selected:", selected)
    end
})
```

---

<div align="center">
  <p>by NochHawk</p>
</div>
