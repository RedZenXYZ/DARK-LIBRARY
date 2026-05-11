local Dark = loadstring(game:HttpGet("https://raw.githubusercontent.com/RedZenXYZ/DARK-LIBRARY/refs/heads/main/source.lua"))()

local Lib = Dark.CreateLib()
local executor = Lib:AddTab("EXECUTOR", nil, "full")

-- ── Save directory ────────────────────────────────────────────────────────────
local SAVE_DIR = "DarkExecutor"
local TABS_DIR = SAVE_DIR .. "/Tabs"
if not isfolder(SAVE_DIR) then makefolder(SAVE_DIR) end
if not isfolder(TABS_DIR) then makefolder(TABS_DIR) end

local function TabPath(name)
	return TABS_DIR .. "/" .. name .. ".lua"
end

local function SaveTab(name, content)
	pcall(writefile, TabPath(name), content)
end

local function LoadTab(name)
	local ok, content = pcall(readfile, TabPath(name))
	return ok and content or ""
end

local function DeleteTab(name)
	pcall(delfile, TabPath(name))
end

local function RenameTabFile(oldName, newName)
	local ok, content = pcall(readfile, TabPath(oldName))
	if ok then
		pcall(writefile, TabPath(newName), content)
		pcall(delfile, TabPath(oldName))
	end
end

-- ── Entry helpers ─────────────────────────────────────────────────────────────
local HubEntries = {}  -- [name] = { name, row, nameLabel, nameBox, favBtn }
local searchQuery = ""

-- ── Tab bar (script tabs row above the editor) ────────────────────────────────
local TAB_H = 28  -- height of the tab bar

local TabBar = Instance.new("Frame", executor.Frame)
TabBar.Name = "TabBar"
TabBar.AnchorPoint = Vector2.new(0, 0)
TabBar.Position = UDim2.new(0, 10, 0, 4)
TabBar.Size = UDim2.new(1, -50, 0, TAB_H)
TabBar.BackgroundTransparency = 1
TabBar.ClipsDescendants = true

local TabBarScroll = Instance.new("ScrollingFrame", TabBar)
TabBarScroll.Size = UDim2.new(1, -30, 1, 0)
TabBarScroll.BackgroundTransparency = 1
TabBarScroll.ScrollBarThickness = 0
TabBarScroll.ScrollingDirection = "X"
TabBarScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
TabBarScroll.AutomaticCanvasSize = Enum.AutomaticSize.X
TabBarScroll.ElasticBehavior = Enum.ElasticBehavior.Never

local TabBarLayout = Instance.new("UIListLayout", TabBarScroll)
TabBarLayout.FillDirection = Enum.FillDirection.Horizontal
TabBarLayout.Padding = UDim.new(0, 4)
TabBarLayout.SortOrder = Enum.SortOrder.LayoutOrder
TabBarLayout.VerticalAlignment = Enum.VerticalAlignment.Center

-- "+" button to add a new script tab
local AddTabBtn = Instance.new("TextButton", TabBar)
AddTabBtn.AnchorPoint = Vector2.new(1, 0.5)
AddTabBtn.Position = UDim2.new(1, 0, 0.5, 0)
AddTabBtn.Size = UDim2.new(0, TAB_H, 0, TAB_H)
AddTabBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
AddTabBtn.BackgroundTransparency = 0.3
AddTabBtn.Text = "+"
AddTabBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
AddTabBtn.TextSize = 16
AddTabBtn.Font = Enum.Font.GothamBold
AddTabBtn.BorderSizePixel = 0
local addCorner = Instance.new("UICorner", AddTabBtn)
addCorner.CornerRadius = UDim.new(1, 0)

-- ── Editor area (below the tab bar) ──────────────────────────────────────────
local EDITOR_TOP = TAB_H + 8

-- LineNumbers lives in its own ScrollingFrame on the left, outside Source
local LINE_W = 30  -- initial width, grows with content

local LineNumFrame = Instance.new("Frame", executor.Frame)
LineNumFrame.Name = "LineNumFrame"
LineNumFrame.AnchorPoint = Vector2.new(0, 0)
LineNumFrame.Position = UDim2.new(0, 10, 0, EDITOR_TOP)
LineNumFrame.Size = UDim2.new(0, LINE_W, 1, -(EDITOR_TOP + 6))
LineNumFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
LineNumFrame.BackgroundTransparency = 0.5
LineNumFrame.BorderSizePixel = 0
LineNumFrame.ClipsDescendants = true

local LineNumScroll = Instance.new("ScrollingFrame", LineNumFrame)
LineNumScroll.Name = "LineNumScroll"
LineNumScroll.Size = UDim2.new(1, 0, 1, 0)
LineNumScroll.BackgroundTransparency = 1
LineNumScroll.ScrollBarThickness = 0
LineNumScroll.ScrollingDirection = "Y"
LineNumScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
LineNumScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
LineNumScroll.ElasticBehavior = Enum.ElasticBehavior.Never
LineNumScroll.ScrollingEnabled = false

-- Source sits to the right of LineNumFrame, width adjusts when line nums grow
local Source = Instance.new("ScrollingFrame", executor.Frame)
Source.Name = "Source"
Source.AnchorPoint = Vector2.new(0, 0)
Source.Position = UDim2.new(0, 10 + LINE_W + 2, 0, EDITOR_TOP)
Source.Size = UDim2.new(1, -(10 + LINE_W + 2 + 40), 1, -(EDITOR_TOP + 6))
Source.BackgroundTransparency = 0.5
Source.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
Source.BorderSizePixel = 0
Source.CanvasSize = UDim2.new(0, 0, 0, 0)
Source.ScrollBarImageColor3 = Color3.new(0, 1, 1)
Source.ScrollBarThickness = 4
Source.AutomaticCanvasSize = Enum.AutomaticSize.XY
Source.ElasticBehavior = Enum.ElasticBehavior.Never
Source.VerticalScrollBarInset = Enum.ScrollBarInset.Always

local ScriptBox = Instance.new("TextBox", Source)
ScriptBox.Position = UDim2.new(0, 0, 0, 0)
ScriptBox.Size = UDim2.new(1, 0, 1, 0)
ScriptBox.AutomaticSize = Enum.AutomaticSize.XY
ScriptBox.BackgroundTransparency = 1
ScriptBox.BorderSizePixel = 0
ScriptBox.TextColor3 = Color3.fromRGB(255, 255, 255)
ScriptBox.TextXAlignment = Enum.TextXAlignment.Left
ScriptBox.TextYAlignment = Enum.TextYAlignment.Top
ScriptBox.TextWrapped = false
ScriptBox.TextScaled = false
ScriptBox.ClearTextOnFocus = false
ScriptBox.MultiLine = true
ScriptBox.TextSize = 14
ScriptBox.Font = Enum.Font.Code
ScriptBox.Text = ""
ScriptBox.TextEditable = true
ScriptBox.CursorPosition = -1

local ScriptPadding = Instance.new("UIPadding", ScriptBox)
ScriptPadding.PaddingRight = UDim.new(0, 30)
ScriptPadding.PaddingBottom = UDim.new(0, 30)

local function UpdateScriptBoxSize()
	if ScriptBox:IsFocused() then return end
	local tx, ty = ScriptBox.TextBounds.X, ScriptBox.TextBounds.Y
	local sx, sy = Source.AbsoluteSize.X, Source.AbsoluteSize.Y
	local newX = math.max(0, tx - sx + 30)
	--local newY = math.max(0, ty - sy + 30)
	ScriptBox.Size = UDim2.new(1, newX, 1, 0)
end

ScriptBox:GetPropertyChangedSignal("TextBounds"):Connect(UpdateScriptBoxSize)
ScriptBox.FocusLost:Connect(UpdateScriptBoxSize)
Source:GetPropertyChangedSignal("AbsoluteSize"):Connect(UpdateScriptBoxSize)

local LineNumbers = Instance.new("TextLabel", LineNumScroll)
LineNumbers.Name = "LineNumbers"
LineNumbers.AnchorPoint = Vector2.new(0, 0)
LineNumbers.Position = UDim2.new(0, 0, 0, 0)
LineNumbers.Size = UDim2.new(1, 0, 1, 0)
LineNumbers.AutomaticSize = Enum.AutomaticSize.Y
LineNumbers.BackgroundTransparency = 1
LineNumbers.BorderSizePixel = 0
LineNumbers.TextColor3 = Color3.fromRGB(120, 200, 200)
LineNumbers.TextXAlignment = Enum.TextXAlignment.Right
LineNumbers.TextYAlignment = Enum.TextYAlignment.Top
LineNumbers.Font = Enum.Font.Code
LineNumbers.TextSize = 14
LineNumbers.TextWrapped = false
LineNumbers.Text = "1"

local TextPadding = Instance.new("UIPadding", LineNumbers)
TextPadding.PaddingRight = UDim.new(0, 2)
TextPadding.PaddingBottom = UDim.new(0, 30)

local function UpdateLines()
	local count = 1
	for _ in string.gmatch(ScriptBox.Text, "\n") do count += 1 end
	local t = {}
	for i = 1, count do t[i] = i end
	LineNumbers.Text = table.concat(t, "\n")
end
UpdateLines()
ScriptBox:GetPropertyChangedSignal("Text"):Connect(UpdateLines)

-- When line number text width changes, resize LineNumFrame and reposition Source
local GUTTER_PAD = 8
LineNumbers:GetPropertyChangedSignal("TextBounds"):Connect(function()
	local newW = LineNumbers.TextBounds.X + GUTTER_PAD
	local left = 10 + newW + 2
	LineNumFrame.Size = UDim2.new(0, newW, 1, -(EDITOR_TOP + 6))
	Source.Position = UDim2.new(0, left, 0, EDITOR_TOP)
	Source.Size = UDim2.new(1, -(left + 40), 1, -(EDITOR_TOP + 6))
end)

-- Sync LineNumScroll vertical offset with Source canvas scroll
Source:GetPropertyChangedSignal("CanvasPosition"):Connect(function()
	LineNumScroll.CanvasPosition = Vector2.new(0, Source.CanvasPosition.Y)
end)

-- ── Tool buttons ──────────────────────────────────────────────────────────────
local ToolContainer = Instance.new("Frame", executor.Frame)
ToolContainer.Name = "ToolContainer"
ToolContainer.AnchorPoint = Vector2.new(1, 0.5)
ToolContainer.Position = UDim2.new(1, -2, 0.5, 0)
ToolContainer.Size = UDim2.new(0, 36, 1, -16)
ToolContainer.BackgroundTransparency = 1

local ToolLayout = Instance.new("UIListLayout", ToolContainer)
ToolLayout.Padding = UDim.new(0, 6)
ToolLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
ToolLayout.VerticalAlignment = Enum.VerticalAlignment.Center
ToolLayout.SortOrder = Enum.SortOrder.LayoutOrder

local function CreateToolButton(imageId)
	local btn = Instance.new("TextButton", ToolContainer)
	btn.Size = UDim2.new(0, 32, 0, 32)
	btn.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
	btn.BackgroundTransparency = 0.3
	btn.BorderSizePixel = 0
	btn.Text = ""
	local c = Instance.new("UICorner", btn)
	c.CornerRadius = UDim.new(0, 10)
	
	local icon = Instance.new("ImageLabel", btn)
	icon.Size = UDim2.new(0.8, 0, 0.8, 0)
	icon.Position = UDim2.new(0.5, 0, 0.5, 0)
	icon.BackgroundTransparency = 1
	icon.AnchorPoint = Vector2.new(0.5, 0.5)
	icon.Image = imageId and ("rbxassetid://" .. imageId) or ""
	return btn
end

local ExecuteBtn = CreateToolButton(116651535114885)
local UndoBtn    = CreateToolButton(107044600796242)
local RedoBtn    = CreateToolButton(133742372514080)
local ClearBtn   = CreateToolButton(128372145651723)
local SaveBtn   = CreateToolButton(11768914234)

-- ── Undo / Redo history ───────────────────────────────────────────────────────
local History   = {}
local RedoStack = {}
local MaxHistory = 100
local Changing   = false

local function UpdateUndoRedoState()
	local canUndo = #History > 1
	local canRedo = #RedoStack > 0
	local undoIcon = UndoBtn:FindFirstChildOfClass("ImageLabel")
	local redoIcon = RedoBtn:FindFirstChildOfClass("ImageLabel")
	if undoIcon then undoIcon.ImageTransparency = canUndo and 0 or 0.65 end
	if redoIcon then redoIcon.ImageTransparency = canRedo and 0 or 0.65 end
	UndoBtn.BackgroundTransparency = canUndo and 0.3 or 0.7
	RedoBtn.BackgroundTransparency = canRedo and 0.3 or 0.7
end

local function SaveState(text)
	if History[#History] ~= text then
		table.insert(History, text)
		if #History > MaxHistory then table.remove(History, 1) end
	end
	UpdateUndoRedoState()
end

SaveState(ScriptBox.Text)

ExecuteBtn.MouseButton1Click:Connect(function()
	local func, err = loadstring(ScriptBox.Text)
	if func then pcall(func) else warn("Execution Error:", err) end
end)

UndoBtn.MouseButton1Click:Connect(function()
	if #History > 1 then
		Changing = true
		local last = table.remove(History)
		table.insert(RedoStack, last)
		ScriptBox.Text = History[#History]
		task.wait(0.1)
		Changing = false
		UpdateUndoRedoState()
	end
end)

RedoBtn.MouseButton1Click:Connect(function()
	if #RedoStack > 0 then
		Changing = true
		local text = table.remove(RedoStack)
		table.insert(History, text)
		ScriptBox.Text = text
		task.wait(0.1)
		Changing = false
		UpdateUndoRedoState()
	end
end)

ClearBtn.MouseButton1Click:Connect(function()
	ScriptBox.Text = ""
end)

SaveBtn.MouseButton1Click:Connect(function()
	-- default name from current tab
	local defaultName = ""
	if activeTab > 0 and ScriptTabs[activeTab] then
		defaultName = ScriptTabs[activeTab].name
	end
	MakePopup(executor.Frame, "Save to Scripts Hub", {
		{name = "Name", placeholder = defaultName ~= "" and defaultName or "Script name...", multiline = false},
	}, function(values)
		local newName = SanitizeName(values[1]:match("^%s*(.-)%s*$"))
		if newName == "" then newName = defaultName end
		if newName == "" then newName = "Saved Script" end
		local content = ScriptBox.Text
		-- avoid collision
		local base, n = newName, 1
		while HubEntries[newName] do
			newName = base .. " (" .. n .. ")"
			n += 1
		end
		AddHubEntry(newName, content)
	end)
end)



--[[
	Each entry in ScriptTabs:
	  { name, button (the tab TextButton), closeBtn }
	activeTab  = index of the currently selected tab
	pendingClose[i] = true if the tab was clicked once for close (needs second click)
]]

local ScriptTabs  = {}
local activeTab   = 0
local pendingClose = {}
local tabCounter  = 0

local function SanitizeName(name)
	-- strip characters that are unsafe in filenames
	return (name:gsub('[<>:"/\\|?*%c]', "_"))
end

local function SelectTab(index)
	-- save current content before switching
	if activeTab > 0 and ScriptTabs[activeTab] then
		ScriptTabs[activeTab].content = ScriptBox.Text
		SaveTab(ScriptTabs[activeTab].name, ScriptBox.Text)
	end

	activeTab = index
	local tab = ScriptTabs[index]

	-- update ScriptBox
	Changing = true
	ScriptBox.Text = tab.content
	History = {tab.content}
	RedoStack = {}
	Changing = false
	UpdateLines()
	UpdateUndoRedoState()

	-- update button visual states
	for i, t in ipairs(ScriptTabs) do
		t.button.BackgroundTransparency = (i == index) and 0.2 or 0.6
	end

	-- clear any pending-close state on the newly selected tab
	pendingClose[index] = nil
	local closeLabel = tab.button:FindFirstChild("CloseLabel")
	if closeLabel then closeLabel.Text = "×" end
end

local function RemoveTab(index)
	local tab = ScriptTabs[index]
	DeleteTab(tab.name)
	tab.button:Destroy()
	table.remove(ScriptTabs, index)
	table.remove(pendingClose, index)

	if #ScriptTabs == 0 then
		-- no tabs left — clear editor
		activeTab = 0
		Changing = true
		ScriptBox.Text = ""
		Changing = false
		UpdateLines()
		return
	end

	-- pick a sensible tab to switch to
	local next = math.min(index, #ScriptTabs)
	activeTab = 0  -- force SelectTab to not save to the removed tab
	SelectTab(next)
end

local function AddScriptTab(name, content)
	name = name or ("Script " .. tabCounter)
	content = content or "-- " .. name .. "\n"

	-- ── tab button container ──────────────────────────────────────────────────
	local btn = Instance.new("TextButton", TabBarScroll)
	btn.Name = "ScriptTab_" .. tabCounter
	btn.LayoutOrder = tabCounter
	btn.Size = UDim2.new(0, 90, 1, 0)
	btn.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
	btn.BackgroundTransparency = 0.6
	btn.Text = ""
	btn.AutoButtonColor = false
	btn.ClipsDescendants = false

	local btnCorner = Instance.new("UICorner", btn)
	btnCorner.CornerRadius = UDim.new(1, 0)

	-- name label (left side, editable on double-click)
	local nameLabel = Instance.new("TextLabel", btn)
	nameLabel.Name = "NameLabel"
	nameLabel.AnchorPoint = Vector2.new(0, 0.5)
	nameLabel.Position = UDim2.new(0, 8, 0.5, 0)
	nameLabel.Size = UDim2.new(1, -26, 1, 0)
	nameLabel.BackgroundTransparency = 1
	nameLabel.Text = name
	nameLabel.TextColor3 = Color3.fromRGB(210, 210, 210)
	nameLabel.TextSize = 11
	nameLabel.Font = Enum.Font.GothamMedium
	nameLabel.TextXAlignment = Enum.TextXAlignment.Left
	nameLabel.TextTruncate = Enum.TextTruncate.AtEnd

	-- hidden TextBox for renaming
	local nameBox = Instance.new("TextBox", btn)
	nameBox.Name = "NameBox"
	nameBox.AnchorPoint = Vector2.new(0, 0.5)
	nameBox.Position = UDim2.new(0, 8, 0.5, 0)
	nameBox.Size = UDim2.new(1, -26, 1, 0)
	nameBox.BackgroundTransparency = 1
	nameBox.Text = name
	nameBox.TextColor3 = Color3.fromRGB(255, 255, 255)
	nameBox.TextSize = 11
	nameBox.Font = Enum.Font.GothamMedium
	nameBox.TextXAlignment = Enum.TextXAlignment.Left
	nameBox.ClearTextOnFocus = false
	nameBox.Visible = false

	-- close button (right side, needs two clicks)
	local closeBtn = Instance.new("TextButton", btn)
	closeBtn.Name = "CloseLabel"
	closeBtn.AnchorPoint = Vector2.new(1, 0.5)
	closeBtn.Position = UDim2.new(1, -4, 0.5, 0)
	closeBtn.Size = UDim2.new(0, 16, 0, 16)
	closeBtn.BackgroundTransparency = 1
	closeBtn.Text = "×"
	closeBtn.TextColor3 = Color3.fromRGB(180, 180, 180)
	closeBtn.TextSize = 13
	closeBtn.Font = Enum.Font.GothamBold

	local index = #ScriptTabs + 1
	ScriptTabs[index] = {
		name    = name,
		content = content,
		button  = btn,
	}

	-- save file if it doesn't already exist
	if not isfile(TabPath(name)) then
		SaveTab(name, content)
	end

	-- ── interactions ──────────────────────────────────────────────────────────

	-- select this tab on click (on the button itself, not the close btn)
	btn.MouseButton1Click:Connect(function()
		local myIndex
		for i, t in ipairs(ScriptTabs) do
			if t.button == btn then myIndex = i break end
		end
		if myIndex then SelectTab(myIndex) end
	end)

	-- double-click (two clicks within 0.4s) on the active tab enters rename mode
	local lastClickTime = 0
	btn.MouseButton1Click:Connect(function()
		local myIndex
		for i, t in ipairs(ScriptTabs) do
			if t.button == btn then myIndex = i break end
		end
		if myIndex ~= activeTab then return end
		local now = tick()
		if now - lastClickTime < 0.4 then
			-- enter rename mode
			nameLabel.Visible = false
			nameBox.Visible = true
			nameBox:CaptureFocus()
		end
		lastClickTime = now
	end)

	nameBox.FocusLost:Connect(function(enterPressed)
		local newName = nameBox.Text:match("^%s*(.-)%s*$")  -- trim whitespace
		newName = SanitizeName(newName)
		if newName == "" then newName = nameLabel.Text end

		local myIndex
		for i, t in ipairs(ScriptTabs) do
			if t.button == btn then myIndex = i break end
		end

		if myIndex and newName ~= ScriptTabs[myIndex].name then
			RenameTabFile(ScriptTabs[myIndex].name, newName)
			ScriptTabs[myIndex].name = newName
		end

		nameLabel.Text = newName
		nameBox.Text   = newName
		nameLabel.Visible = true
		nameBox.Visible   = false
	end)

	-- close button: first click turns it red + sets pending, second click removes
	closeBtn.MouseButton1Click:Connect(function()
		local myIndex
		for i, t in ipairs(ScriptTabs) do
			if t.button == btn then myIndex = i break end
		end
		if not myIndex then return end

		if pendingClose[myIndex] then
			-- second click — actually close
			RemoveTab(myIndex)
		else
			-- first click — arm for close, dim × to gray
			pendingClose[myIndex] = true
			closeBtn.TextColor3 = Color3.fromRGB(255, 80, 80)
			-- auto-disarm after 2 seconds
			task.delay(2, function()
				if pendingClose[myIndex] then
					pendingClose[myIndex] = nil
					if closeBtn and closeBtn.Parent then
						closeBtn.TextColor3 = Color3.fromRGB(180, 180, 180)
					end
				end
			end)
		end
	end)

	-- select the new tab immediately
	SelectTab(index)
	return index
end

-- "+" button creates a new blank tab
AddTabBtn.MouseButton1Click:Connect(function()
	tabCounter += 1
	AddScriptTab("Script " .. tabCounter)
end)

local autoSaveThread = nil
ScriptBox:GetPropertyChangedSignal("Text"):Connect(function()
	if Changing then return end
	SaveState(ScriptBox.Text)
	RedoStack = {}
	-- auto-save: debounce 1s so we don't writefile on every keystroke
	if autoSaveThread then task.cancel(autoSaveThread) end
	autoSaveThread = task.delay(1, function()
		if activeTab > 0 and ScriptTabs[activeTab] then
			ScriptTabs[activeTab].content = ScriptBox.Text
			SaveTab(ScriptTabs[activeTab].name, ScriptBox.Text)
		end
	end)
end)

-- ── Boot: load saved tabs or create a default one ─────────────────────────────
local function BootTabs()
	-- collect .lua files saved from previous sessions
	local loaded = false
	local ok, files = pcall(listfiles, TABS_DIR)
	if ok and files then
		table.sort(files)
		for _, path in ipairs(files) do
			local fileName = path:match("([^/\\]+)%.lua$")
			if fileName then
				local content = LoadTab(fileName)
				AddScriptTab(fileName, content)
				loaded = true
			end
		end
	end
	if not loaded then
		AddScriptTab("Script 1", "-- Script 1\n")
	end
end

BootTabs()

-- ══════════════════════════════════════════════════════════════════════════════
-- SCRIPTS HUB TAB
-- ══════════════════════════════════════════════════════════════════════════════
local HUB_DIR  = SAVE_DIR .. "/Hub"
local FAV_FILE = SAVE_DIR .. "/favourites.txt"
if not isfolder(HUB_DIR) then makefolder(HUB_DIR) end

-- ── Persistence helpers ───────────────────────────────────────────────────────
local function HubPath(name)
	return HUB_DIR .. "/" .. name .. ".lua"
end

local function SaveHubScript(name, content)
	pcall(writefile, HubPath(name), content)
end

local function LoadHubScript(name)
	local ok, c = pcall(readfile, HubPath(name))
	return ok and c or ""
end

local function DeleteHubScript(name)
	pcall(delfile, HubPath(name))
end

local function RenameHubFile(oldName, newName)
	local ok, c = pcall(readfile, HubPath(oldName))
	if ok then
		pcall(writefile, HubPath(newName), c)
		pcall(delfile, HubPath(oldName))
	end
end

-- favourites stored as newline-separated names in a single file
local Favourites = {}

local ORDER_FILE = SAVE_DIR .. "/hub_order.txt"
local HubOrder   = {}  -- ordered list of names, persisted

local function LoadFavourites()
	local ok, raw = pcall(readfile, FAV_FILE)
	if not ok then return end
	for line in raw:gmatch("[^\n]+") do
		Favourites[line:match("^%s*(.-)%s*$")] = true
	end
end

local function SaveFavourites()
	local lines = {}
	for name in pairs(Favourites) do
		table.insert(lines, name)
	end
	pcall(writefile, FAV_FILE, table.concat(lines, "\n"))
end

local function LoadOrder()
	local ok, raw = pcall(readfile, ORDER_FILE)
	if not ok then return end
	for line in raw:gmatch("[^\n]+") do
		table.insert(HubOrder, line:match("^%s*(.-)%s*$"))
	end
end

local function SaveOrder()
	-- rebuild order from current LayoutOrder values
	local sorted = {}
	for _, entry in pairs(HubEntries) do
		table.insert(sorted, entry)
	end
	table.sort(sorted, function(a, b)
		return a.row.LayoutOrder < b.row.LayoutOrder
	end)
	local lines = {}
	for _, entry in ipairs(sorted) do
		table.insert(lines, entry.name)
	end
	pcall(writefile, ORDER_FILE, table.concat(lines, "\n"))
end

LoadFavourites()
LoadOrder()

-- ── Shared popup helper ───────────────────────────────────────────────────────
-- Creates a modal popup with text fields and confirm/cancel buttons.
-- fields = { {name="label", placeholder="...", multiline=false}, ... }
-- onConfirm(values) called with a table of field values on confirm.
local function MakePopup(parent, title, fields, onConfirm)
	-- dark backdrop
	local backdrop = Instance.new("Frame", parent)
	backdrop.Name = "PopupBackdrop"
	backdrop.Size = UDim2.new(1, 0, 1, 0)
	backdrop.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
	backdrop.BackgroundTransparency = 0.4
	backdrop.BorderSizePixel = 0
	backdrop.ZIndex = 20
	
	local frameCorner = Instance.new("UICorner", backdrop)
	frameCorner.CornerRadius = UDim.new(0, 8)

	local POPUP_W = 220
	local FIELD_H = 24
	local ML_H    = 70
	local PAD     = 10
	local BTN_H   = 26

	-- calculate total height
	local contentH = PAD + 20 + PAD  -- title
	for _, f in ipairs(fields) do
		contentH += (f.multiline and ML_H or FIELD_H) + PAD
	end
	contentH += BTN_H + PAD

	local popup = Instance.new("Frame", backdrop)
	popup.Name = "Popup"
	popup.AnchorPoint = Vector2.new(0.5, 0.5)
	popup.Position = UDim2.new(0.5, 0, 0.5, 0)
	popup.Size = UDim2.new(0, POPUP_W, 0, contentH)
	popup.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
	popup.BackgroundTransparency = 0.05
	popup.BorderSizePixel = 0
	popup.ZIndex = 21

	local popupCorner = Instance.new("UICorner", popup)
	popupCorner.CornerRadius = UDim.new(0, 12)

	-- title label
	local titleLbl = Instance.new("TextLabel", popup)
	titleLbl.Size = UDim2.new(1, -PAD * 2, 0, 20)
	titleLbl.Position = UDim2.new(0, PAD, 0, PAD)
	titleLbl.BackgroundTransparency = 1
	titleLbl.Text = title
	titleLbl.TextColor3 = Color3.fromRGB(230, 230, 230)
	titleLbl.TextSize = 13
	titleLbl.Font = Enum.Font.GothamBold
	titleLbl.TextXAlignment = Enum.TextXAlignment.Left
	titleLbl.ZIndex = 22

	-- build fields
	local boxes = {}
	local yOffset = PAD + 20 + PAD

	for _, f in ipairs(fields) do
		local lbl = Instance.new("TextLabel", popup)
		lbl.Size = UDim2.new(1, -PAD * 2, 0, 12)
		lbl.Position = UDim2.new(0, PAD, 0, yOffset)
		lbl.BackgroundTransparency = 1
		lbl.Text = f.name
		lbl.TextColor3 = Color3.fromRGB(150, 150, 150)
		lbl.TextSize = 10
		lbl.Font = Enum.Font.GothamMedium
		lbl.TextXAlignment = Enum.TextXAlignment.Left
		lbl.ZIndex = 22
		yOffset += 13

		local fh = f.multiline and ML_H or FIELD_H
		local box = Instance.new("TextBox", popup)
		box.Size = UDim2.new(1, -PAD * 2, 0, fh)
		box.Position = UDim2.new(0, PAD, 0, yOffset)
		box.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
		box.BackgroundTransparency = 0.2
		box.BorderSizePixel = 0
		box.Text = f.default or ""
		box.PlaceholderText = f.placeholder or ""
		box.PlaceholderColor3 = Color3.fromRGB(90, 90, 90)
		box.TextColor3 = Color3.fromRGB(220, 220, 220)
		box.TextSize = 12
		box.Font = Enum.Font.Code
		box.TextXAlignment = Enum.TextXAlignment.Left
		box.TextYAlignment = f.multiline and Enum.TextYAlignment.Top or Enum.TextYAlignment.Center
		box.MultiLine = f.multiline or false
		box.TextWrapped = f.multiline or false
		box.ClearTextOnFocus = false
		box.ZIndex = 22

		local bCorner = Instance.new("UICorner", box)
		bCorner.CornerRadius = UDim.new(0, 6)

		if f.multiline then
			local bPad = Instance.new("UIPadding", box)
			bPad.PaddingLeft = UDim.new(0, 6)
			bPad.PaddingTop  = UDim.new(0, 4)
		else
			local bPad = Instance.new("UIPadding", box)
			bPad.PaddingLeft  = UDim.new(0, 6)
			bPad.PaddingRight = UDim.new(0, 6)
		end

		table.insert(boxes, box)
		yOffset += fh + PAD
	end

	-- confirm / cancel row
	local confirmBtn = Instance.new("TextButton", popup)
	confirmBtn.Size = UDim2.new(0.45, 0, 0, BTN_H)
	confirmBtn.Position = UDim2.new(0.05, 0, 0, yOffset)
	confirmBtn.BackgroundColor3 = Color3.fromRGB(0, 80, 0)
	confirmBtn.BackgroundTransparency = 0.2
	confirmBtn.BorderSizePixel = 0
	confirmBtn.Text = "Confirm"
	confirmBtn.TextColor3 = Color3.fromRGB(220, 220, 220)
	confirmBtn.TextSize = 12
	confirmBtn.Font = Enum.Font.GothamBold
	confirmBtn.ZIndex = 22
	local ccCorner = Instance.new("UICorner", confirmBtn)
	ccCorner.CornerRadius = UDim.new(0, 8)

	local cancelBtn = Instance.new("TextButton", popup)
	cancelBtn.Size = UDim2.new(0.45, 0, 0, BTN_H)
	cancelBtn.Position = UDim2.new(0.5, 0, 0, yOffset)
	cancelBtn.BackgroundColor3 = Color3.fromRGB(80, 0, 0)
	cancelBtn.BackgroundTransparency = 0.2
	cancelBtn.BorderSizePixel = 0
	cancelBtn.Text = "Cancel"
	cancelBtn.TextColor3 = Color3.fromRGB(220, 220, 220)
	cancelBtn.TextSize = 12
	cancelBtn.Font = Enum.Font.GothamBold
	cancelBtn.ZIndex = 22
	local cxCorner = Instance.new("UICorner", cancelBtn)
	cxCorner.CornerRadius = UDim.new(0, 8)

	cancelBtn.MouseButton1Click:Connect(function()
		backdrop:Destroy()
	end)

	confirmBtn.MouseButton1Click:Connect(function()
		local values = {}
		for _, box in ipairs(boxes) do
			table.insert(values, box.Text)
		end
		backdrop:Destroy()
		onConfirm(values)
	end)

	-- focus first field
	task.defer(function()
		if boxes[1] then boxes[1]:CaptureFocus() end
	end)

	return backdrop
end

-- ── Hub tab frame ─────────────────────────────────────────────────────────────
local hub = Lib:AddTab("HUB", nil, "full")
hub.Frame.ClipsDescendants = true

local HUB_PAD = 6
local ITEM_H  = 36
local BTN_W   = 26

-- two buttons right of search: upload (⬆) only now
-- layout: [SearchBar ........] [⬆]
local TOPBAR_BTNS = BTN_W + HUB_PAD  -- 1 btn + right pad

-- Search bar
local SearchBar = Instance.new("TextBox", hub.Frame)
SearchBar.Name = "SearchBar"
SearchBar.AnchorPoint = Vector2.new(0, 0)
SearchBar.Position = UDim2.new(0, HUB_PAD, 0, HUB_PAD)
SearchBar.Size = UDim2.new(1, -(HUB_PAD + TOPBAR_BTNS + 4), 0, 26)
SearchBar.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
SearchBar.BackgroundTransparency = 0.3
SearchBar.BorderSizePixel = 0
SearchBar.PlaceholderText = "Search scripts..."
SearchBar.PlaceholderColor3 = Color3.fromRGB(100, 100, 100)
SearchBar.Text = ""
SearchBar.TextColor3 = Color3.fromRGB(220, 220, 220)
SearchBar.TextSize = 12
SearchBar.Font = Enum.Font.GothamMedium
SearchBar.TextXAlignment = Enum.TextXAlignment.Left
SearchBar.ClearTextOnFocus = false

local sbCorner = Instance.new("UICorner", SearchBar)
sbCorner.CornerRadius = UDim.new(0, 8)
local sbPad = Instance.new("UIPadding", SearchBar)
sbPad.PaddingLeft = UDim.new(0, 8)
sbPad.PaddingRight = UDim.new(0, 8)

-- Upload button (⬆) — opens name+content popup
local UploadBtn = Instance.new("TextButton", hub.Frame)
UploadBtn.AnchorPoint = Vector2.new(1, 0)
UploadBtn.Position = UDim2.new(1, -HUB_PAD, 0, HUB_PAD)
UploadBtn.Size = UDim2.new(0, BTN_W, 0, 26)
UploadBtn.BackgroundColor3 = Color3.fromRGB(0, 35, 60)
UploadBtn.BackgroundTransparency = 0.2
UploadBtn.Text = "⬆"
UploadBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
UploadBtn.TextSize = 14
UploadBtn.Font = Enum.Font.GothamBold
UploadBtn.BorderSizePixel = 0
local uploadCorner = Instance.new("UICorner", UploadBtn)
uploadCorner.CornerRadius = UDim.new(1, 0)

-- Scrollable list
local LIST_TOP = HUB_PAD + 26 + HUB_PAD

local HubScroll = Instance.new("ScrollingFrame", hub.Frame)
HubScroll.Name = "HubScroll"
HubScroll.AnchorPoint = Vector2.new(0, 0)
HubScroll.Position = UDim2.new(0, 0, 0, LIST_TOP)
HubScroll.Size = UDim2.new(1, 0, 1, -LIST_TOP)
HubScroll.BackgroundTransparency = 1
HubScroll.ScrollBarThickness = 3
HubScroll.ScrollBarImageColor3 = Color3.fromRGB(80, 80, 80)
HubScroll.ScrollingDirection = Enum.ScrollingDirection.Y
HubScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
HubScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
HubScroll.ElasticBehavior = Enum.ElasticBehavior.Never
HubScroll.BorderSizePixel = 0

local HubLayout = Instance.new("UIListLayout", HubScroll)
HubLayout.Padding = UDim.new(0, 2)
HubLayout.SortOrder = Enum.SortOrder.LayoutOrder
HubLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center

local HubPad = Instance.new("UIPadding", HubScroll)
HubPad.PaddingBottom = UDim.new(0, 4)
HubPad.PaddingLeft = UDim.new(0, 4)
HubPad.PaddingRight = UDim.new(0, 4)

-- ── Divider rows ──────────────────────────────────────────────────────────────
local DIVIDER_H = 18

local function MakeDivider(labelText, order, isFav)
	local row = Instance.new("Frame", HubScroll)
	row.Name = "Divider_" .. labelText
	row.LayoutOrder = order
	row.Size = UDim2.new(1, 0, 0, DIVIDER_H)
	row.BackgroundTransparency = 1

	local lbl = Instance.new("TextLabel", row)
	lbl.AnchorPoint = Vector2.new(0, 0.5)
	lbl.Position = UDim2.new(0, 6, 0.5, 0)
	lbl.Size = UDim2.new(0, 90, 1, 0)
	lbl.BackgroundTransparency = 1
	lbl.Text = labelText
	lbl.TextColor3 = isFav
		and Color3.fromRGB(255, 200, 0)
		or  Color3.fromRGB(140, 140, 140)
	lbl.TextSize = 10
	lbl.Font = Enum.Font.GothamBold
	lbl.TextXAlignment = Enum.TextXAlignment.Left

	return row
end

-- layout order: favs = 1..499, divider at 0 and 500, all scripts = 501..999
local FavDivider = MakeDivider("★  Favourites", 0,   true)
local AllDivider = MakeDivider("All Scripts",   500, false)

local function MakeHubButton(parent, text, bgCol)
	local b = Instance.new("TextButton", parent)
	b.Size = UDim2.new(0, BTN_W, 0, BTN_W)
	b.BackgroundColor3 = bgCol or Color3.fromRGB(30, 30, 30)
	b.BackgroundTransparency = 0.3
	b.BorderSizePixel = 0
	b.Text = text
	b.TextColor3 = Color3.fromRGB(220, 220, 220)
	b.TextSize = 13
	b.Font = Enum.Font.GothamBold
	b.AutoButtonColor = true
	local c = Instance.new("UICorner", b)
	c.CornerRadius = UDim.new(1, 0)
	return b
end

local function RefreshVisibility()
	local q = searchQuery:lower()
	local hasFav, hasAll = false, false
	for name, entry in pairs(HubEntries) do
		local visible = (q == "") or (name:lower():find(q, 1, true) ~= nil)
		entry.row.Visible = visible
		if visible then
			if Favourites[name] then hasFav = true else hasAll = true end
		end
	end
	FavDivider.Visible = hasFav
	AllDivider.Visible = hasAll
end

local function UpdateLayout()
	-- apply saved order positions first, then assign fav/all section offsets
	local favOrder, allOrder = 1, 501
	local orderMap = {}
	for i, n in ipairs(HubOrder) do
		orderMap[n] = i
	end

	-- sort entries by saved order (unknown entries go to end)
	local sorted = {}
	for _, entry in pairs(HubEntries) do
		table.insert(sorted, entry)
	end
	table.sort(sorted, function(a, b)
		local oa = orderMap[a.name] or math.huge
		local ob = orderMap[b.name] or math.huge
		return oa < ob
	end)

	for _, entry in ipairs(sorted) do
		if Favourites[entry.name] then
			entry.row.LayoutOrder = favOrder
			favOrder += 1
		else
			entry.row.LayoutOrder = allOrder
			allOrder += 1
		end
	end
	RefreshVisibility()
end

-- ── AddHubEntry ───────────────────────────────────────────────────────────────
local function AddHubEntry(name, content)
	if HubEntries[name] then return end

	SaveHubScript(name, content or "")

	local row = Instance.new("Frame", HubScroll)
	row.Name = "HubEntry_" .. name
	row.Size = UDim2.new(1, 0, 0, ITEM_H)
	row.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
	row.BackgroundTransparency = 0.4
	row.BorderSizePixel = 0

	local rowCorner = Instance.new("UICorner", row)
	rowCorner.CornerRadius = UDim.new(0, 8)

	-- 4 buttons: exec, fav, import, delete
	local DRAG_W         = 22
	local NAME_LEFT      = DRAG_W + 8
	local NAME_RIGHT_PAD = BTN_W * 4 + 18

	-- ── drag handle ───────────────────────────────────────────────────────────
	local dragHandle = Instance.new("TextButton", row)
	dragHandle.Name = "DragHandle"
	dragHandle.AnchorPoint = Vector2.new(0, 0.5)
	dragHandle.Position = UDim2.new(0, 4, 0.5, 0)
	dragHandle.Size = UDim2.new(0, DRAG_W, 0, DRAG_W)
	dragHandle.BackgroundTransparency = 1
	dragHandle.Text = "⋮⋮"
	dragHandle.TextColor3 = Color3.fromRGB(110, 110, 110)
	dragHandle.TextSize = 11
	dragHandle.Font = Enum.Font.GothamBold
	dragHandle.AutoButtonColor = false

	-- name label (after handle)
	local nameLabel = Instance.new("TextButton", row)
	nameLabel.Name = "NameLabel"
	nameLabel.AnchorPoint = Vector2.new(0, 0.5)
	nameLabel.Position = UDim2.new(0, NAME_LEFT, 0.5, 0)
	nameLabel.Size = UDim2.new(1, -(NAME_LEFT + NAME_RIGHT_PAD), 1, 0)
	nameLabel.BackgroundTransparency = 1
	nameLabel.Text = name
	nameLabel.TextColor3 = Color3.fromRGB(210, 210, 210)
	nameLabel.TextSize = 12
	nameLabel.Font = Enum.Font.GothamMedium
	nameLabel.TextXAlignment = Enum.TextXAlignment.Left
	nameLabel.TextTruncate = Enum.TextTruncate.AtEnd

	-- hidden rename TextBox
	local nameBox = Instance.new("TextBox", row)
	nameBox.Name = "NameBox"
	nameBox.AnchorPoint = Vector2.new(0, 0.5)
	nameBox.Position = UDim2.new(0, NAME_LEFT, 0.5, 0)
	nameBox.Size = UDim2.new(1, -(NAME_LEFT + NAME_RIGHT_PAD), 1, 0)
	nameBox.BackgroundTransparency = 1
	nameBox.Text = name
	nameBox.TextColor3 = Color3.fromRGB(255, 255, 255)
	nameBox.TextSize = 12
	nameBox.Font = Enum.Font.GothamMedium
	nameBox.TextXAlignment = Enum.TextXAlignment.Left
	nameBox.ClearTextOnFocus = false
	nameBox.Visible = false

	-- right-side buttons container (4 buttons × BTN_W + 3 gaps of 4)
	local btnRow = Instance.new("Frame", row)
	btnRow.AnchorPoint = Vector2.new(1, 0.5)
	btnRow.Position = UDim2.new(1, -6, 0.5, 0)
	btnRow.Size = UDim2.new(0, BTN_W * 4 + 12, 0, BTN_W)
	btnRow.BackgroundTransparency = 1

	local btnLayout = Instance.new("UIListLayout", btnRow)
	btnLayout.FillDirection = Enum.FillDirection.Horizontal
	btnLayout.Padding = UDim.new(0, 4)
	btnLayout.VerticalAlignment = Enum.VerticalAlignment.Center
	btnLayout.SortOrder = Enum.SortOrder.LayoutOrder

	local execBtn   = MakeHubButton(btnRow, "▶",  Color3.fromRGB(0, 55, 0))
	local favBtn    = MakeHubButton(btnRow, Favourites[name] and "★" or "☆", Color3.fromRGB(45, 35, 0))
	local importBtn = MakeHubButton(btnRow, "↓",  Color3.fromRGB(0, 25, 55))
	local deleteBtn = MakeHubButton(btnRow, "🗑", Color3.fromRGB(55, 0, 0))
	execBtn.LayoutOrder   = 4
	favBtn.LayoutOrder    = 3
	importBtn.LayoutOrder = 2
	deleteBtn.LayoutOrder = 1

	favBtn.TextColor3 = Favourites[name]
		and Color3.fromRGB(255, 200, 0)
		or  Color3.fromRGB(140, 140, 140)

	local entry = {
		name      = name,
		row       = row,
		nameLabel = nameLabel,
		nameBox   = nameBox,
		favBtn    = favBtn,
	}
	HubEntries[name] = entry

	-- ── drag-to-reorder ───────────────────────────────────────────────────────
	local dragging       = false
	local dragStartY     = 0
	local dragStartOrder = 0

	local function GetSortedSection()
		local isFav = Favourites[entry.name]
		local list  = {}
		for _, e in pairs(HubEntries) do
			local eFav = Favourites[e.name]
			if (isFav and eFav) or (not isFav and not eFav) then
				table.insert(list, e)
			end
		end
		table.sort(list, function(a, b)
			return a.row.LayoutOrder < b.row.LayoutOrder
		end)
		return list
	end

	dragHandle.InputBegan:Connect(function(input)
		if input.UserInputType ~= Enum.UserInputType.MouseButton1
			and input.UserInputType ~= Enum.UserInputType.Touch then return end
		dragging = true
		dragStartY    = input.Position.Y
		dragStartOrder = row.LayoutOrder
		dragHandle.TextColor3 = Color3.fromRGB(220, 220, 220)
		row.BackgroundTransparency = 0.15
	end)

	dragHandle.InputEnded:Connect(function(input)
		if input.UserInputType ~= Enum.UserInputType.MouseButton1
			and input.UserInputType ~= Enum.UserInputType.Touch then return end
		if not dragging then return end
		dragging = false
		dragHandle.TextColor3 = Color3.fromRGB(110, 110, 110)
		row.BackgroundTransparency = 0.4
		SaveOrder()
	end)

	UserInputService.InputChanged:Connect(function(input)
		if not dragging then return end
		if input.UserInputType ~= Enum.UserInputType.MouseMovement
			and input.UserInputType ~= Enum.UserInputType.Touch then return end

		local delta       = input.Position.Y - dragStartY
		local steps       = math.floor(delta / (ITEM_H + 2) + 0.5)
		local targetOrder = dragStartOrder + steps

		local isFav      = Favourites[entry.name]
		local sectionMin = isFav and 1 or 501
		local sectionMax = isFav and 499 or 999
		targetOrder = math.clamp(targetOrder, sectionMin, sectionMax)
		if targetOrder == row.LayoutOrder then return end

		-- swap with whichever entry currently occupies targetOrder
		for _, other in ipairs(GetSortedSection()) do
			if other ~= entry and other.row.LayoutOrder == targetOrder then
				other.row.LayoutOrder = row.LayoutOrder
				row.LayoutOrder = targetOrder
				break
			end
		end
	end)

	-- ── delete (two clicks, auto-disarms after 2s) ────────────────────────────
	local pendingDelete = false
	deleteBtn.MouseButton1Click:Connect(function()
		if pendingDelete then
			-- second click — remove entry
			if Favourites[entry.name] then
				Favourites[entry.name] = nil
				SaveFavourites()
			end
			DeleteHubScript(entry.name)
			HubEntries[entry.name] = nil
			row:Destroy()
			RefreshVisibility()
		else
			-- first click — arm, turn red
			pendingDelete = true
			deleteBtn.BackgroundColor3 = Color3.fromRGB(160, 0, 0)
			deleteBtn.BackgroundTransparency = 0.2
			task.delay(2, function()
				if pendingDelete and deleteBtn.Parent then
					pendingDelete = false
					deleteBtn.BackgroundColor3 = Color3.fromRGB(55, 0, 0)
					deleteBtn.BackgroundTransparency = 0.3
				end
			end)
		end
	end)
	HubEntries[name] = entry

	-- ── double-click to rename ────────────────────────────────────────────────
	local lastClick = 0
	nameLabel.MouseButton1Click:Connect(function()
		local now = tick()
		if now - lastClick < 0.4 then
			nameLabel.Visible = false
			nameBox.Visible = true
			nameBox:CaptureFocus()
		end
		lastClick = now
	end)

	nameBox.FocusLost:Connect(function()
		local newName = SanitizeName(nameBox.Text:match("^%s*(.-)%s*$"))
		if newName == "" then newName = entry.name end

		if newName ~= entry.name then
			local oldName = entry.name
			if Favourites[oldName] then
				Favourites[oldName] = nil
				Favourites[newName] = true
				SaveFavourites()
			end
			RenameHubFile(oldName, newName)
			HubEntries[oldName] = nil
			entry.name = newName
			HubEntries[newName] = entry
			row.Name = "HubEntry_" .. newName
		end

		nameLabel.Text = entry.name
		nameBox.Text   = entry.name
		nameLabel.Visible = true
		nameBox.Visible   = false
		UpdateLayout()
	end)

	-- ── execute ───────────────────────────────────────────────────────────────
	execBtn.MouseButton1Click:Connect(function()
		local src = LoadHubScript(entry.name)
		local fn, err = loadstring(src)
		if fn then pcall(fn) else warn("Hub Execute Error:", err) end
	end)

	-- ── favourite toggle ──────────────────────────────────────────────────────
	favBtn.MouseButton1Click:Connect(function()
		if Favourites[entry.name] then
			Favourites[entry.name] = nil
			favBtn.Text = "☆"
			favBtn.TextColor3 = Color3.fromRGB(140, 140, 140)
		else
			Favourites[entry.name] = true
			favBtn.Text = "★"
			favBtn.TextColor3 = Color3.fromRGB(255, 200, 0)
		end
		SaveFavourites()
		UpdateLayout()
	end)

	-- ── import — always opens a new script tab ───────────────────────────────
	importBtn.MouseButton1Click:Connect(function()
		local src = LoadHubScript(entry.name)
		tabCounter += 1
		AddScriptTab(entry.name, src)
		executor:Select()
	end)

	UpdateLayout()
end

-- ── Upload button — popup with name + content fields ─────────────────────────
UploadBtn.MouseButton1Click:Connect(function()
	MakePopup(hub.Frame, "Upload Script", {
		{name = "Name",    placeholder = "Script name...",         multiline = false},
		{name = "Content", placeholder = "-- Paste script here...", multiline = true},
	}, function(values)
		local newName = SanitizeName((values[1] or ""):match("^%s*(.-)%s*$"))
		local content = values[2] or ""
		if newName == "" then newName = "Uploaded Script" end
		local base, n = newName, 1
		while HubEntries[newName] do
			newName = base .. " (" .. n .. ")"
			n += 1
		end
		AddHubEntry(newName, content)
	end)
end)

-- ── SaveBtn — save current executor tab into ScriptsHub ──────────────────────
SaveBtn.MouseButton1Click:Connect(function()
	local defaultName = (activeTab > 0 and ScriptTabs[activeTab])
		and ScriptTabs[activeTab].name
		or  "Saved Script"
	local currentContent = ScriptBox.Text

	MakePopup(executor.Frame, "Save to ScriptsHub", {
		{name = "Name", placeholder = "Script name...", default = defaultName, multiline = false},
	}, function(values)
		local newName = SanitizeName((values[1] or ""):match("^%s*(.-)%s*$"))
		if newName == "" then newName = defaultName end
		local base, n = newName, 1
		while HubEntries[newName] do
			newName = base .. " (" .. n .. ")"
			n += 1
		end
		AddHubEntry(newName, currentContent)
	end)
end)

-- ── Search ────────────────────────────────────────────────────────────────────
SearchBar:GetPropertyChangedSignal("Text"):Connect(function()
	searchQuery = SearchBar.Text
	RefreshVisibility()
end)

-- ── Boot: load existing hub scripts ──────────────────────────────────────────
local function BootHub()
	local ok, files = pcall(listfiles, HUB_DIR)
	if not ok or not files then return end
	table.sort(files)
	for _, path in ipairs(files) do
		local fileName = path:match("([^/\\]+)%.lua$")
		if fileName then
			AddHubEntry(fileName, LoadHubScript(fileName))
		end
	end
	-- apply saved order now that all entries exist
	UpdateLayout()
end

BootHub()
