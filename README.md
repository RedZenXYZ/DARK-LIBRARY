# 🌑 Dark Lib

A dark-themed Roblox UI library for building in-game script hub interfaces. Features a floating toggle button, collapsible tab sidebar, animated components, and a built-in command bar.

---

## Getting Started

```lua
local Dark = loadstring(game:HttpGet("YOUR_RAW_URL_HERE"))()
local Lib = Dark.CreateLib()
```

> Re-executing the script returns the existing UI instead of rebuilding it — safe to run multiple times.

---

## Creating a Tab

```lua
local tab = Lib:AddTab("Tab Name", ICON_ASSET_ID, mode)
```

| Parameter | Type | Description |
|-----------|------|-------------|
| `name` | `string` | Label shown on the sidebar button |
| `image` | `number` \| `nil` | Roblox asset ID for the tab icon. If `nil`, the label is centered |
| `mode` | `"scroll"` \| `"full"` \| `nil` | Content area mode (see below) |

### Tab Modes

| Mode | Description |
|------|-------------|
| `nil` / `"scroll"` | Default — wraps content in a `ScrollingFrame` with auto layout |
| `"full"` | Returns a raw `Frame`, you control the layout entirely |

---

## Components

### Button

```lua
local btn = tab:AddButton("Name", "Optional subtitle", function()
    print("clicked")
end)

btn:UpdateButton("New Label")
```

---

### Toggle

```lua
local toggle = tab:AddToggle("Name", "Optional subtitle", function(state)
    print(state) -- true / false
end)

toggle:UpdateToggle(true)   -- force a state
toggle:UpdateToggle()       -- flip current state
toggle:GetValue()           -- returns current bool
```

---

### Slider

```lua
local slider = tab:AddSlider("Name", "Optional subtitle", 0, 100, 5, function(value)
    print(value)
end)

slider:SetValue(50)
slider:GetValue()
```

| Parameter | Type | Description |
|-----------|------|-------------|
| `min` | `number` | Minimum value (default `0`) |
| `max` | `number` | Maximum value (default `100`) |
| `step` | `number` | Increment amount (default `1`) |
| `callback` | `function` | Called with the current value on drag |

---

### Dropdown

```lua
local drop = tab:AddDropdown("Name", "Optional subtitle", {"Option A", "Option B", "Option C"}, function(selected)
    print(selected)
end)

drop:GetSelected()            -- returns current selection string
drop:SetOptions({"X", "Y"})  -- replace options list
drop:Close()                  -- close the dropdown programmatically
```

---

### TextBox

```lua
local box = tab:AddTextBox("Name", "Optional subtitle", "Placeholder…", function(text, enterPressed)
    print(text, enterPressed)
end)

box:GetText()
box:SetText("hello")
```

> Callback fires on `FocusLost`. `enterPressed` is `true` when the user pressed Enter.

---

### TextLabel

```lua
local lbl = tab:AddTextLabel("Some text", 13, Color3.fromRGB(200, 200, 205))

lbl:SetText("Updated text")
lbl:SetColor(Color3.fromRGB(255, 100, 100))
```

| Parameter | Type | Description |
|-----------|------|-------------|
| `text` | `string` | Display text |
| `size` | `number` \| `nil` | Font size (default `13`) |
| `color` | `Color3` \| `nil` | Text color (default off-white) |

---

## UI Controls

| Action | Result |
|--------|--------|
| **Single click** the floating button | Open / close the main frame |
| **Double click** the floating button | Toggle the command bar |
| **Enter** in the command bar | Execute the typed script |
| Click the **‹** button on the sidebar | Collapse the tab bar |
| Click the collapsed sidebar strip | Expand the tab bar |
| Drag the **handle** below the main frame | Reposition the window |

---

## Command Bar

Double-clicking the floating button slides in a transparent text input next to it. Type any Lua and press **Enter** to execute. Errors are printed to the output via `warn`.

---

## Notes

- Requires `CoreGui` access — intended for use in an executor context.
- All animations use `TweenService` with `Quad` easing (`0.15s` fast, `0.20s` medium).
- The singleton cache uses `_G.DARK_EXECUTOR` — clearing `_G` will allow a full rebuild on next execute.
