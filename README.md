# Universal UI Library for Roblox

A beautiful, modern, and universal UI library for Roblox exploit scripts, inspired by Fluent Design.

## Features
- Smooth drag-and-drop window mechanics.
- Organized tab system.
- Interactive elements: Buttons, Toggles, Sliders, Dropdowns.
- Fluid animations with `TweenService`.
- Supports any Roblox executor (Synapse, Krnl, Fluxus, etc.).

## How to Use (Loadstring)

Once you upload `library.lua` to GitHub (or any raw text hosting service like Pastebin), you can load it in your scripts like this:

```lua
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/danilito222222/roblox-universal-ui/master/library.lua"))()
```

*(Note: Replace the URL above with the actual raw URL of your `library.lua` file after publishing it.)*

## Example Script

Here is a full example of how to build a UI using this library:

```lua
-- Load the library
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/danilito222222/roblox-universal-ui/master/library.lua"))()

-- Create a Window
local Window = Library:CreateWindow({
    Title = "My Awesome Script"
})

-- Create Tabs
local MainTab = Window:CreateTab("Main")
local SettingsTab = Window:CreateTab("Settings")

-- Add Elements to the Main Tab
MainTab:CreateButton({
    Name = "Kill All Players",
    Callback = function()
        print("Executing Kill All...")
    end
})

MainTab:CreateToggle({
    Name = "Auto Farm",
    Default = false,
    Callback = function(state)
        print("Auto Farm state:", state)
    end
})

MainTab:CreateSlider({
    Name = "WalkSpeed",
    Min = 16,
    Max = 200,
    Default = 16,
    Callback = function(value)
        game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = value
    end
})

-- Add Elements to the Settings Tab
SettingsTab:CreateDropdown({
    Name = "Select Target",
    Options = {"Player1", "Player2", "Player3"},
    Callback = function(selected)
        print("Selected target:", selected)
    end
})
```

## How to publish to GitHub

Since this was generated locally, here are the steps to publish it to your own GitHub account:
1. Go to [GitHub](https://github.com/) and create a new repository (e.g., `roblox-ui-lib`).
2. Upload the `library.lua` file to this repository.
3. Once uploaded, open `library.lua` in GitHub and click the **Raw** button.
4. Copy the URL from your browser (it should start with `https://raw.githubusercontent.com/...`).
5. Use that URL in your `loadstring` function!
