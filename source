-- Singleton cache: re-executing returns the existing Dark/Lib
if DARK_EXECUTOR then
	return DARK_EXECUTOR
end

-- ── Save Config ──--
local SAVE_DIR = "DarkExecutor"
if not isfolder(SAVE_DIR) then makefolder(SAVE_DIR) end

function jsonencode(Table)
	return game:GetService("HttpService"):JSONEncode(Table)
end

function jsondecode(TableString)
	return game:GetService("HttpService"):JSONDecode(TableString)
end

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

-- Tween presets
local TWEEN_FAST   = TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
local TWEEN_MEDIUM = TweenInfo.new(0.20, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

-- Tab button colours
local COL_TAB_IDLE     = Color3.fromRGB(220, 220, 225)
local COL_TAB_SEL      = Color3.fromRGB(255, 255, 255)
local COL_TAB_BG_SEL   = Color3.fromRGB(85, 170, 255) 
local TRAN_TAB_IDLE    = 1
local TRAN_TAB_SEL     = 0.35

local Dark = {}
function Dark.CreateLib()
	if DARK_EXECUTOR_LIB then
		return DARK_EXECUTOR_LIB
	end
	local ScreenGui = Instance.new("ScreenGui", game:GetService("CoreGui"))
	local Frame = Instance.new("Frame", ScreenGui)
	local Gradient = Instance.new("UIGradient", Frame)
	local Background = Instance.new("ImageLabel", Frame)
	local MoreExecutor = Instance.new("Frame", ScreenGui)
	local OpenButton = Instance.new("TextButton", MoreExecutor)
	local Label = Instance.new("ImageLabel", OpenButton)
	local Scroll = Instance.new("CanvasGroup", Frame)
	local ScrollBG = Instance.new("ImageLabel", Scroll)
	local TabsScroll = Instance.new("ScrollingFrame", Scroll)
	local UIListLayout = Instance.new("UIListLayout", TabsScroll)
	local TabClose = Instance.new("ImageButton", Scroll)
	local TabBarOpen = Instance.new("ImageButton", Frame)
	local FrameTabs = Instance.new("Folder", Frame)

	ScreenGui.Name = "DARK_EXECUTOR"
	ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

	-- ── Floating open/close button ──────────────────────────────────────────
	MoreExecutor.Name = "MoreExecutor"
	MoreExecutor.Size = UDim2.new(0, 42, 0, 42)
	MoreExecutor.AnchorPoint = Vector2.new(0, 1)
	MoreExecutor.Position = UDim2.new(0, 17, 1, -17)
	MoreExecutor.BackgroundTransparency = 1

	local tween = nil
	OpenButton.Name = "OpenButton"
	OpenButton.Size = UDim2.new(1, 0, 1, 0)
	OpenButton.AnchorPoint = Vector2.new(0, 0)
	OpenButton.Position = UDim2.new(0, 0, 0, 0)
	OpenButton.BackgroundTransparency = 0.4
	OpenButton.BackgroundColor3 = Color3.fromRGB(0, 0, 10)
	OpenButton.Text = ""
	OpenButton.MouseButton1Click:Connect(function()
		if tween ~= nil then return end
		if Frame.Visible then
			tween = TweenService:Create(Frame, TweenInfo.new(0.25), {Size = UDim2.new(0.5, 0, 0, 0)})
			tween:Play()
			tween.Completed:Connect(function()
				tween = nil
				Frame.Visible = false
			end)
		else
			Frame.Visible = true
			tween = TweenService:Create(Frame, TweenInfo.new(0.5), {Size = UDim2.new(0.5, 0, 0.65, 0)})
			tween:Play()
			tween.Completed:Connect(function()
				tween = nil
			end)
		end
	end)

	local btnCorner = Instance.new("UICorner", OpenButton)
	btnCorner.CornerRadius = UDim.new(1, 0)

	Label.Name = "Icon"
	Label.Image = "https://www.roblox.com/asset-thumbnail/image?assetId=16149179369&width=420&height=420&format=png"
	Label.Size = UDim2.new(0, 24, 0, 24)
	Label.BackgroundTransparency = 1
	Label.AnchorPoint = Vector2.new(0.5, 0.5)
	Label.Position = UDim2.new(0.5, 0, 0.5, 0)

	-- ── Main window ─────────────────────────────────────────────────────────
	Frame.Name = "MainFrame"
	Frame.AnchorPoint = Vector2.new(0.5, 0.5)
	Frame.Position = UDim2.new(0.5, 0, 0.45, 0)
	Frame.Size = UDim2.new(0.5, 0, 0, 0)
	Frame.BackgroundTransparency = 0.5
	Frame.BackgroundColor3 = Color3.new(1, 1, 1)
	Frame.Visible = false
	Frame.ClipsDescendants = false

	local frameCorner = Instance.new("UICorner", Frame)
	frameCorner.CornerRadius = UDim.new(0, 8)
	
	--== UI SHINING EFFECT ==--
	Gradient.Color = ColorSequence.new({
	    ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 0, 0)), 
	    ColorSequenceKeypoint.new(0.3, Color3.fromRGB(50, 50, 50)), 
	    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(150, 150, 150)), 
	    ColorSequenceKeypoint.new(0.7, Color3.fromRGB(50, 50, 50)), 
	    ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 0, 0))
	})
	
	Gradient.Transparency = NumberSequence.new({
	    NumberSequenceKeypoint.new(0, 0),
	    NumberSequenceKeypoint.new(0.5, 0.2),
	    NumberSequenceKeypoint.new(1, 0)
	})
	
	local tweenInfo = TweenInfo.new(
	    10, 
	    Enum.EasingStyle.Linear,
	    Enum.EasingDirection.Out,
	    -1, 
	    false
	)
	
	Gradient.Offset = Vector2.new(0, -2)
	Gradient.Rotation = 50
	local tween = TweenService:Create(Gradient, tweenInfo, {
	    Offset = Vector2.new(0, 2)
	})
	
	tween:Play()
	
	Background.Name = "ImageBackground"
	Background.Size = UDim2.new(1, 0, 1, 0)
	Background.BackgroundTransparency = 1
	Background.Image = ""
	Background.ImageTransparency = 0.5
	
	local bgCorner = Instance.new("UICorner", Background)
	bgCorner.CornerRadius = UDim.new(0, 8)
	
	-- ── Drag handle ──────────────────────────────────────────────────────────
	local DragLine = Instance.new("Frame", Frame)
	DragLine.Size = UDim2.new(0.6, 0, 0, 20)
	DragLine.Position = UDim2.new(0.5, 0, 1, 6)
	DragLine.AnchorPoint = Vector2.new(0.5, 0)
	DragLine.BackgroundTransparency = 1
	DragLine.Active = true

	local dragIndicator = Instance.new("Frame", DragLine)
	dragIndicator.Size = UDim2.new(0.4, 0, 0, 4)
	dragIndicator.AnchorPoint = Vector2.new(0.5, 0.5)
	dragIndicator.Position = UDim2.new(0.5, 0, 0.5, 0)
	dragIndicator.BackgroundTransparency = 0.5
	dragIndicator.BackgroundColor3 = Color3.fromRGB(180, 180, 180)

	local dragCorner = Instance.new("UICorner", dragIndicator)
	dragCorner.CornerRadius = UDim.new(1, 0)

	local dragging = false
	local dragStart, startPos

	DragLine.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1
			or input.UserInputType == Enum.UserInputType.Touch then
			dragging = true
			dragStart = input.Position
			startPos = Frame.Position
			input.Changed:Connect(function()
				if input.UserInputState == Enum.UserInputState.End then
					dragging = false
				end
			end)
		end
	end)

	UserInputService.InputChanged:Connect(function(input)
		if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement
			or input.UserInputType == Enum.UserInputType.Touch) then
			local delta = input.Position - dragStart
			Frame.Position = UDim2.new(
				startPos.X.Scale, startPos.X.Offset + delta.X,
				startPos.Y.Scale, startPos.Y.Offset + delta.Y
			)
		end
	end)

	-- ── Tab sidebar ──────────────────────────────────────────────────────────
	Scroll.Name = "ScrollFrame"
	Scroll.Size = UDim2.new(0.2, 0, 1, 0)
	Scroll.AnchorPoint = Vector2.new(0, 0)
	Scroll.Position = UDim2.new(1, 8, 0, 0)
	Scroll.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
	Scroll.BackgroundTransparency = 1

	local scrollCorner = Instance.new("UICorner", Scroll)
	scrollCorner.CornerRadius = UDim.new(0, 12)
	
	ScrollBG.Name = "ScrollBackground"
	ScrollBG.Size = UDim2.new(1, 0, 1, 0)
	ScrollBG.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
	ScrollBG.BackgroundTransparency = 0.4
	ScrollBG.ScaleType = Enum.ScaleType.Crop

	TabsScroll.Name = "TabsBar"
	TabsScroll.AnchorPoint = Vector2.new(0, 0)
	TabsScroll.Position = UDim2.new(0, 0, 0, 0)
	TabsScroll.Size = UDim2.new(1, 0, 1, -28)
	TabsScroll.BackgroundTransparency = 1
	TabsScroll.BorderSizePixel = 0
	TabsScroll.ScrollBarThickness = 0
	TabsScroll.ScrollingDirection = "Y"
	TabsScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
	TabsScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
	TabsScroll.ClipsDescendants = true

	UIListLayout.Padding = UDim.new(0, 4)
	UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
	UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder

	local UIPadding = Instance.new("UIPadding", TabsScroll)
	UIPadding.PaddingTop = UDim.new(0, 4)
	UIPadding.PaddingLeft = UDim.new(0, 4)
	UIPadding.PaddingRight = UDim.new(0, 4)

	-- ── Sidebar collapse button ──────────────────────────────────────────────
	local scrolltween = nil
	TabClose.Name = "TabClose"
	TabClose.AnchorPoint = Vector2.new(0, 1)
	TabClose.Size = UDim2.new(1, 0, 0, 28)
	TabClose.Position = UDim2.new(0, 0, 1, 0)
	TabClose.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
	TabClose.BackgroundTransparency = 0.4
	TabClose.BorderSizePixel = 0
	TabClose.Image = ""
	TabClose.MouseButton1Click:Connect(function()
		scrolltween = TweenService:Create(Scroll, TweenInfo.new(0.15), {Size = UDim2.new(0, 22, 1, 0)})
		scrolltween:Play()
		scrolltween.Completed:Connect(function()
			scrolltween = nil
			Scroll.Visible = false
			TabBarOpen.Visible = true
		end)
	end)

	local function MakeBarLine(parent, yOffset)
		local l = Instance.new("Frame", parent)
		l.Size = UDim2.new(0.45, 0, 0, 2)
		l.AnchorPoint = Vector2.new(0.5, 0.5)
		l.Position = UDim2.new(0.5, 0, 0.5, yOffset)
		l.BackgroundTransparency = 0.4
		l.BackgroundColor3 = Color3.fromRGB(200, 200, 200)
		local c = Instance.new("UICorner", l)
		c.CornerRadius = UDim.new(1, 0)
	end
	MakeBarLine(TabClose, -3)
	MakeBarLine(TabClose, 3)

	-- ── Sidebar expand button ────────────────────────────────────────────────
	TabBarOpen.Name = "TabBarOpenButton"
	TabBarOpen.AnchorPoint = Vector2.new(0, 0)
	TabBarOpen.Size = UDim2.new(0, 22, 1, 0)
	TabBarOpen.Position = UDim2.new(1, 6, 0, 0)
	TabBarOpen.Visible = false
	TabBarOpen.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
	TabBarOpen.BackgroundTransparency = 0.4
	TabBarOpen.Image = ""
	TabBarOpen.MouseButton1Click:Connect(function()
		TabBarOpen.Visible = false
		Scroll.Visible = true
		scrolltween = TweenService:Create(Scroll, TweenInfo.new(0.15), {Size = UDim2.new(0.2, 0, 1, 0)})
		scrolltween:Play()
		scrolltween.Completed:Connect(function()
			scrolltween = nil
		end)
	end)

	local openCorner = Instance.new("UICorner", TabBarOpen)
	openCorner.CornerRadius = UDim.new(0, 10)

	MakeBarLine(TabBarOpen, -3)
	MakeBarLine(TabBarOpen, 3)

	-- ────────────────────────────────────────────────────────────────────────
	-- Helper: create a consistent component row container inside a tab page
	-- ────────────────────────────────────────────────────────────────────────
	local function MakeRow(parent, height)
		local row = Instance.new("Frame", parent)
		row.Size = UDim2.new(1, 0, 0, height or 38)
		row.BackgroundTransparency = 1
		return row
	end

	-- ────────────────────────────────────────────────────────────────────────
	-- Helper: shared label style (left-side name + sub-info)
	-- ────────────────────────────────────────────────────────────────────────
	local function MakeLabel(parent, name, info)
		local lbl = Instance.new("TextLabel", parent)
		lbl.Size = UDim2.new(0.55, 0, 0, 16)
		lbl.Position = UDim2.new(0, 10, 0, 5)
		lbl.BackgroundTransparency = 1
		lbl.Text = name or ""
		lbl.TextColor3 = Color3.fromRGB(230, 230, 230)
		lbl.TextSize = 13
		lbl.Font = Enum.Font.GothamMedium
		lbl.TextXAlignment = Enum.TextXAlignment.Left
		lbl.TextTruncate = Enum.TextTruncate.AtEnd

		if info and info ~= "" then
			local sub = Instance.new("TextLabel", parent)
			sub.Size = UDim2.new(0.55, 0, 0, 12)
			sub.Position = UDim2.new(0, 10, 0, 22)
			sub.BackgroundTransparency = 1
			sub.Text = info
			sub.TextColor3 = Color3.fromRGB(130, 130, 135)
			sub.TextSize = 10
			sub.Font = Enum.Font.Gotham
			sub.TextXAlignment = Enum.TextXAlignment.Left
			sub.TextTruncate = Enum.TextTruncate.AtEnd
		end
		return lbl
	end
	
	-- ────────────────────────────────────────────────────────────────────────
	-- Helper: make fading effect
	-- ────────────────────────────────────────────────────────────────────────
	function MakeFade(parent, height, position)
		local pos = position == "bottom" and 1 or 0
		local frame = Instance.new("Frame", parent)
		frame.BackgroundTransparency = 0.4
		frame.BackgroundColor3 = Color3.new(1, 1, 1)
		frame.Size = UDim2.new(1, 0, 0, height or 40)
		frame.Position = UDim2.new(0, 0, pos, 0)
		frame.AnchorPoint = Vector2.new(0, pos)
		frame.BorderSizePixel = 0
		
		local corner = parent:FindFirstChildOfClass("UICorner")
		if corner then
			corner:Clone().Parent = frame
		end
		
		local gradient = Instance.new("UIGradient", frame)
		gradient.Rotation = position == "bottom" and -90 or 90
		gradient.Color = ColorSequence.new({
		    ColorSequenceKeypoint.new(0, Color3.fromRGB(20, 20, 20)),
		    ColorSequenceKeypoint.new(1, Color3.fromRGB(20, 20, 20))
		})
		
		gradient.Transparency = NumberSequence.new({
		    NumberSequenceKeypoint.new(0, 0),
		    NumberSequenceKeypoint.new(1, 1)
		})
		return frame
	end
	MakeFade(Scroll, 50)
	local bottomFade = MakeFade(Scroll, 50, "bottom")
	bottomFade.Position = UDim2.new(0, 0, 1, -28)
	bottomFade:FindFirstChildOfClass("UICorner"):Destroy()

	-- ────────────────────────────────────────────────────────────────────────
	-- Lib
	-- ────────────────────────────────────────────────────────────────────────
	local Lib = {}

	--[[
		Lib:AddTab(image, labelText, mode)
		  image     – Roblox asset ID (number) or nil
		  labelText – string label shown on the sidebar button
		  mode      – nil / "scroll"  → default ScrollingFrame content area
		              "full"          → raw Frame (you control layout entirely)
	--]]
	function Lib:AddTab(labelText, image, mode)
		local indexnumber = tostring(#TabsScroll:GetChildren() - 1)
		labelText = labelText or ("Tab_" .. indexnumber)

		-- ── Tab sidebar button ─────────────────────────────────────────────
		local TabButton = Instance.new("TextButton", TabsScroll)
		TabButton.Name = "TabButton_" .. indexnumber
		TabButton.LayoutOrder = tonumber(indexnumber)
		TabButton.Size = UDim2.new(1, 0, 0, 30)
		-- Start fully transparent (idle state)
		TabButton.BackgroundColor3 = COL_TAB_BG_SEL
		TabButton.BackgroundTransparency = TRAN_TAB_IDLE
		TabButton.Text = labelText
		TabButton.TextColor3 = COL_TAB_IDLE
		TabButton.TextSize = 12
		TabButton.Font = Enum.Font.GothamMedium
		TabButton.TextXAlignment = Enum.TextXAlignment.Left
		TabButton.TextTruncate = Enum.TextTruncate.AtEnd
		TabButton.AutoButtonColor = false
		-- No TextStroke, no UIStroke – just plain text

		local pad = Instance.new("UIPadding", TabButton)
		pad.PaddingLeft = UDim.new(0, image and 36 or 8)
		pad.PaddingRight = UDim.new(0, 6)

		local tabCorner = Instance.new("UICorner", TabButton)
		tabCorner.CornerRadius = UDim.new(0, 10)
		
		local stroke = Instance.new("UIStroke", TabButton)
		stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
		stroke.Color = Color3.fromRGB(255, 255, 255)
		stroke.Thickness = 1
		stroke.Transparency = 0.2

		local Icon = Instance.new("ImageLabel", TabButton)
		Icon.Name = "Icon"
		Icon.AnchorPoint = Vector2.new(0, 0.5)
		Icon.Position = UDim2.new(0, 6, 0.5, 0)
		Icon.Size = UDim2.new(0, 24, 0, 24)
		Icon.BackgroundTransparency = 1
		Icon.Image = image
			and ("https://www.roblox.com/asset-thumbnail/image?assetId=" .. tostring(image) .. "&width=420&height=420&format=png")
			or ""

		-- ── Tab page ───────────────────────────────────────────────────────
		--   mode == nil or "scroll"  →  ScrollingFrame (default)
		--   mode == "full"           →  plain Frame (full/custom)

		local TabPage   -- the visible container placed inside FrameTabs
		local ContentParent  -- where AddButton/AddToggle/etc. put their rows

		if mode == "full" then
			-- ── Full / custom mode ─────────────────────────────────────────
			TabPage = Instance.new("Frame", FrameTabs)
			TabPage.Name = "TabFrame" .. indexnumber
			TabPage.Visible = false
			TabPage.Size = UDim2.new(1, 0, 1, 0)
			TabPage.BackgroundTransparency = 1
			TabPage.ClipsDescendants = true
			-- In full mode the caller owns the layout; ContentParent == TabPage
			ContentParent = TabPage
		else
			-- ── Default scroll mode ────────────────────────────────────────
			TabPage = Instance.new("Frame", FrameTabs)
			TabPage.Name = "TabFrame" .. indexnumber
			TabPage.Visible = false
			TabPage.Size = UDim2.new(1, 0, 1, 0)
			TabPage.BackgroundTransparency = 1
			TabPage.ClipsDescendants = true

			local sf = Instance.new("ScrollingFrame", TabPage)
			sf.Name = "ContentScroll"
			sf.Size = UDim2.new(1, 0, 1, 0)
			sf.Position = UDim2.new(0, 0, 0, 0)
			sf.BackgroundTransparency = 1
			sf.ScrollBarThickness = 0
			sf.ScrollBarImageColor3 = Color3.fromRGB(100, 100, 100)
			sf.ScrollingDirection = Enum.ScrollingDirection.Y
			sf.CanvasSize = UDim2.new(0, 0, 0, 0)
			sf.AutomaticCanvasSize = Enum.AutomaticSize.Y
			sf.ClipsDescendants = true

			local sfLayout = Instance.new("UIListLayout", sf)
			sfLayout.Padding = UDim.new(0, 6)
			sfLayout.SortOrder = Enum.SortOrder.LayoutOrder
			sfLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center

			local sfPad = Instance.new("UIPadding", sf)
			sfPad.PaddingTop = UDim.new(0, 8)
			sfPad.PaddingLeft = UDim.new(0, 8)
			sfPad.PaddingRight = UDim.new(0, 8)
			sfPad.PaddingBottom = UDim.new(0, 8)

			ContentParent = sf
		end

		-- ── Tab API object ─────────────────────────────────────────────────
		local Tab = {Frame = TabPage, Content = ContentParent}
		local componentOrder = 0
		local function nextOrder()
			componentOrder = componentOrder + 1
			return componentOrder
		end
		
		function Tab:Select()
			-- Deselect all tabs
			for _, child in TabsScroll:GetChildren() do
				if child:IsA("TextButton") then
					TweenService:Create(child, TWEEN_FAST, {
						BackgroundTransparency = TRAN_TAB_IDLE,
						TextColor3 = COL_TAB_IDLE,
					}):Play()
				end
			end
			-- Hide all pages
			for _, tab in FrameTabs:GetChildren() do
				tab.Visible = false
			end
			-- Select this tab
			TweenService:Create(TabButton, TWEEN_MEDIUM, {
				BackgroundTransparency = TRAN_TAB_SEL,
				TextColor3 = COL_TAB_SEL,
			}):Play()
			TabPage.Visible = true
		end
		
		-- ── Tab button click: deselect all, select this one (tweened) ──────
		TabButton.MouseButton1Click:Connect(function()
			Tab:Select()
		end)

		-- ── AddButton ─────────────────────────────────────────────────────
		--   name     – button label
		--   info     – small subtitle text (can be nil)
		--   callback – called on click
		function Tab:AddButton(name, info, callback)
			local row = MakeRow(ContentParent, 38)
			row.LayoutOrder = nextOrder()
			row.BackgroundColor3 = Color3.fromRGB(25, 25, 28)
			row.BackgroundTransparency = 0.3

			local rowCorner = Instance.new("UICorner", row)
			rowCorner.CornerRadius = UDim.new(0, 10)

			local titleLbl = MakeLabel(row, name, info)

			local btn = Instance.new("TextButton", row)
			btn.Name = "ActionBtn"
			btn.Size = UDim2.new(1, 0, 1, 0)
			btn.BackgroundTransparency = 1
			btn.Text = ""
			btn.AutoButtonColor = false
			
			local icon = Instance.new("ImageLabel", row)
			icon.Name = "TapIcon"
			icon.Size = UDim2.new(0, 20, 0, 20)
			icon.Position = UDim2.new(1, -8, 0.5, 0)
			icon.AnchorPoint = Vector2.new(1, 0.5)
			icon.BackgroundTransparency = 1
			icon.Image = "rbxassetid://3926305904"
			icon.ImageRectSize = Vector2.new(36, 36)
			icon.ImageRectOffset = Vector2.new(84, 204)

			-- Hover / press feedback
			btn.MouseEnter:Connect(function()
				TweenService:Create(row, TWEEN_FAST, {BackgroundColor3 = Color3.fromRGB(80, 80, 88)}):Play()
			end)
			btn.MouseLeave:Connect(function()
				TweenService:Create(row, TWEEN_FAST, {BackgroundColor3 = Color3.fromRGB(25, 25, 28)}):Play()
			end)
			btn.MouseButton1Down:Connect(function()
				TweenService:Create(row, TWEEN_FAST, {BackgroundColor3 = Color3.fromRGB(40, 40, 45)}):Play()
			end)
			btn.MouseButton1Up:Connect(function()
				TweenService:Create(row, TWEEN_FAST, {BackgroundColor3 = Color3.fromRGB(25, 25, 28)}):Play()
			end)
			btn.MouseButton1Click:Connect(function()
				if callback then callback() end
			end)

			local ButtonFunction = {}
			function ButtonFunction:UpdateButton(newTitle)
				btn.Text = tostring(newTitle)
				titleLbl.Text = tostring(newTitle)
			end
			return ButtonFunction
		end

		-- ── AddToggle ─────────────────────────────────────────────────────
		--   name     – label
		--   info     – subtitle (can be nil)
		--   callback – called with (bool) on change
		function Tab:AddToggle(name, info, callback)
			local row = MakeRow(ContentParent, 38)
			row.LayoutOrder = nextOrder()
			row.BackgroundColor3 = Color3.fromRGB(25, 25, 28)
			row.BackgroundTransparency = 0.3

			local rowCorner = Instance.new("UICorner", row)
			rowCorner.CornerRadius = UDim.new(0, 10)

			MakeLabel(row, name, info)

			-- Track pill
			local trackW, trackH = 44, 24
			local track = Instance.new("Frame", row)
			track.Name = "Track"
			track.Size = UDim2.new(0, trackW, 0, trackH)
			track.AnchorPoint = Vector2.new(1, 0.5)
			track.Position = UDim2.new(1, -10, 0.5, 0)
			track.BackgroundColor3 = Color3.fromRGB(55, 55, 60)
			track.BackgroundTransparency = 0

			local trackCorner = Instance.new("UICorner", track)
			trackCorner.CornerRadius = UDim.new(1, 0)

			-- Knob
			local knob = Instance.new("Frame", track)
			knob.Name = "Knob"
			knob.Size = UDim2.new(0, trackH - 6, 0, trackH - 6)
			knob.AnchorPoint = Vector2.new(0, 0.5)
			knob.Position = UDim2.new(0, 3, 0.5, 0)
			knob.BackgroundColor3 = Color3.fromRGB(200, 200, 205)

			local knobCorner = Instance.new("UICorner", knob)
			knobCorner.CornerRadius = UDim.new(1, 0)

			local toggled = false

			local function SetToggle(state)
				toggled = state
				local knobX   = state and (trackW - (trackH - 6) - 3) or 3
				local trackBG = state and Color3.fromRGB(100, 180, 255) or Color3.fromRGB(55, 55, 60)
				TweenService:Create(knob,  TWEEN_MEDIUM, {Position = UDim2.new(0, knobX, 0.5, 0)}):Play()
				TweenService:Create(track, TWEEN_MEDIUM, {BackgroundColor3 = trackBG}):Play()
				if callback then callback(toggled) end
			end

			-- Clicking anywhere on the row flips the toggle
			local hitBtn = Instance.new("TextButton", row)
			hitBtn.Size = UDim2.new(1, 0, 1, 0)
			hitBtn.BackgroundTransparency = 1
			hitBtn.Text = ""
			hitBtn.ZIndex = 5
			hitBtn.MouseButton1Click:Connect(function()
				SetToggle(not toggled)
			end)

			local ToggleFunction = {}
			function ToggleFunction:UpdateToggle(state)
				SetToggle(state ~= nil and state or not toggled)
			end
			function ToggleFunction:GetValue()
				return toggled
			end
			return ToggleFunction
		end

		-- ── AddSlider ─────────────────────────────────────────────────────
		--   name     – label
		--   info     – subtitle (can be nil)
		--   min      – minimum value  (default 0)
		--   max      – maximum value  (default 100)
		--   default  – starting value (default min)
		--   callback – called with (number) on change
		function Tab:AddSlider(name, info, min, max, default, callback)
			min     = min     or 0
			max     = max     or 100
			default = default or min

			local rowH = info and 62 or 52
			local row = MakeRow(ContentParent, rowH)
			row.LayoutOrder = nextOrder()
			row.BackgroundColor3 = Color3.fromRGB(25, 25, 28)
			row.BackgroundTransparency = 0.3

			local rowCorner = Instance.new("UICorner", row)
			rowCorner.CornerRadius = UDim.new(0, 10)

			MakeLabel(row, name, info)

			-- Value readout
			local valLabel = Instance.new("TextLabel", row)
			valLabel.Size = UDim2.new(0, 36, 0, 16)
			valLabel.AnchorPoint = Vector2.new(1, 0)
			valLabel.Position = UDim2.new(1, -10, 0, 6)
			valLabel.BackgroundTransparency = 1
			valLabel.Text = tostring(default)
			valLabel.TextColor3 = Color3.fromRGB(180, 180, 185)
			valLabel.TextSize = 11
			valLabel.Font = Enum.Font.GothamMedium
			valLabel.TextXAlignment = Enum.TextXAlignment.Right

			-- Track bar
			local trackBar = Instance.new("Frame", row)
			trackBar.Name = "SliderTrack"
			trackBar.Size = UDim2.new(1, -20, 0, 6)
			trackBar.Position = UDim2.new(0, 10, 1, -14)
			trackBar.AnchorPoint = Vector2.new(0, 1)
			trackBar.BackgroundColor3 = Color3.fromRGB(55, 55, 60)

			local trackC = Instance.new("UICorner", trackBar)
			trackC.CornerRadius = UDim.new(1, 0)

			-- Fill
			local fill = Instance.new("Frame", trackBar)
			fill.Name = "Fill"
			fill.Size = UDim2.new(0, 0, 1, 0)
			fill.BackgroundColor3 = Color3.fromRGB(100, 180, 255)
			fill.ClipsDescendants = false

			local fillC = Instance.new("UICorner", fill)
			fillC.CornerRadius = UDim.new(1, 0)

			-- Knob
			local knob = Instance.new("Frame", trackBar)
			knob.Name = "Knob"
			knob.Size = UDim2.new(0, 14, 0, 14)
			knob.AnchorPoint = Vector2.new(0.5, 0.5)
			knob.Position = UDim2.new(0, 0, 0.5, 0)
			knob.BackgroundColor3 = Color3.fromRGB(220, 220, 225)

			local knobC = Instance.new("UICorner", knob)
			knobC.CornerRadius = UDim.new(1, 0)

			local currentValue = default
			local function SetValue(v)
				v = math.clamp(math.round(v), min, max)
				currentValue = v
				local t = (v - min) / (max - min)
				fill.Size = UDim2.new(t, 0, 1, 0)
				knob.Position = UDim2.new(t, 0, 0.5, 0)
				valLabel.Text = tostring(v)
				if callback then callback(v) end
			end
			SetValue(default)

			-- Drag interaction
			local sliderDragging = false
			local function CalcValue(inputX)
				local absSize = trackBar.AbsoluteSize.X
				local relX = inputX - trackBar.AbsolutePosition.X
				local t = math.clamp(relX / absSize, 0, 1)
				return min + t * (max - min)
			end

			trackBar.InputBegan:Connect(function(inp)
				if inp.UserInputType == Enum.UserInputType.MouseButton1
					or inp.UserInputType == Enum.UserInputType.Touch then
					sliderDragging = true
					SetValue(CalcValue(inp.Position.X))
				end
			end)
			UserInputService.InputChanged:Connect(function(inp)
				if sliderDragging and (inp.UserInputType == Enum.UserInputType.MouseMovement
					or inp.UserInputType == Enum.UserInputType.Touch) then
					SetValue(CalcValue(inp.Position.X))
				end
			end)
			UserInputService.InputEnded:Connect(function(inp)
				if inp.UserInputType == Enum.UserInputType.MouseButton1
					or inp.UserInputType == Enum.UserInputType.Touch then
					sliderDragging = false
				end
			end)

			local SliderFunction = {}
			function SliderFunction:SetValue(v)  SetValue(v) end
			function SliderFunction:GetValue()   return currentValue end
			return SliderFunction
		end

		-- ── AddDropdown ───────────────────────────────────────────────────
		--   name     – label
		--   info     – subtitle (can be nil)
		--   options  – array of strings  e.g. {"Apple","Banana","Cherry"}
		--   callback – called with (selectedString) on change
		function Tab:AddDropdown(name, info, options, callback)
			options = options or {}
			local closedH = 38
			local openedH = closedH + math.min(#options, 5) * 28 + 4

			local row = MakeRow(ContentParent, closedH)
			row.LayoutOrder = nextOrder()
			row.BackgroundColor3 = Color3.fromRGB(25, 25, 28)
			row.BackgroundTransparency = 0.3
			row.ClipsDescendants = true

			local rowCorner = Instance.new("UICorner", row)
			rowCorner.CornerRadius = UDim.new(0, 10)

			MakeLabel(row, name, info)

			-- Selected display
			local selLabel = Instance.new("TextLabel", row)
			selLabel.Size = UDim2.new(0, 100, 0, 22)
			selLabel.AnchorPoint = Vector2.new(1, 0.5)
			selLabel.Position = UDim2.new(1, -30, 0, 20)
			selLabel.BackgroundTransparency = 1
			selLabel.Text = options[1] or "None"
			selLabel.TextColor3 = Color3.fromRGB(200, 200, 205)
			selLabel.TextSize = 12
			selLabel.Font = Enum.Font.GothamMedium
			selLabel.TextXAlignment = Enum.TextXAlignment.Right
			selLabel.TextTruncate = Enum.TextTruncate.AtEnd

			-- Arrow
			local arrow = Instance.new("TextLabel", row)
			arrow.Size = UDim2.new(0, 16, 0, 16)
			arrow.AnchorPoint = Vector2.new(1, 0.5)
			arrow.Position = UDim2.new(1, -10, 0, 20)
			arrow.BackgroundTransparency = 1
			arrow.Text = "▾"
			arrow.TextColor3 = Color3.fromRGB(160, 160, 165)
			arrow.TextSize = 14
			arrow.Font = Enum.Font.GothamBold

			-- Drop list
			local list = Instance.new("Frame", row)
			list.Name = "DropList"
			list.Size = UDim2.new(1, -20, 0, math.min(#options, 5) * 28)
			list.Position = UDim2.new(0, 10, 0, closedH + 2)
			list.BackgroundColor3 = Color3.fromRGB(35, 35, 38)
			list.BackgroundTransparency = 0
			list.ClipsDescendants = true
			list.Visible = false

			local listC = Instance.new("UICorner", list)
			listC.CornerRadius = UDim.new(0, 8)

			local listLayout = Instance.new("UIListLayout", list)
			listLayout.SortOrder = Enum.SortOrder.LayoutOrder
			listLayout.Padding = UDim.new(0, 0)

			local selectedVal = options[1]
			local isOpen = false

			for i, opt in ipairs(options) do
				local optBtn = Instance.new("TextButton", list)
				optBtn.LayoutOrder = i
				optBtn.Size = UDim2.new(1, 0, 0, 28)
				optBtn.BackgroundTransparency = 1
				optBtn.Text = opt
				optBtn.TextColor3 = Color3.fromRGB(200, 200, 205)
				optBtn.TextSize = 12
				optBtn.Font = Enum.Font.Gotham
				optBtn.TextXAlignment = Enum.TextXAlignment.Left
				optBtn.AutoButtonColor = false

				local optPad = Instance.new("UIPadding", optBtn)
				optPad.PaddingLeft = UDim.new(0, 8)

				optBtn.MouseEnter:Connect(function()
					TweenService:Create(optBtn, TWEEN_FAST, {BackgroundTransparency = 0.7}):Play()
					optBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 65)
				end)
				optBtn.MouseLeave:Connect(function()
					TweenService:Create(optBtn, TWEEN_FAST, {BackgroundTransparency = 1}):Play()
				end)
				optBtn.MouseButton1Click:Connect(function()
					selectedVal = opt
					selLabel.Text = opt
					-- Close
					isOpen = false
					list.Visible = false
					arrow.Text = "▾"
					TweenService:Create(row, TWEEN_MEDIUM, {Size = UDim2.new(1, 0, 0, closedH)}):Play()
					if callback then callback(opt) end
				end)
			end

			-- Toggle open/close
			local hitBtn = Instance.new("TextButton", row)
			hitBtn.Size = UDim2.new(1, 0, 0, closedH)
			hitBtn.BackgroundTransparency = 1
			hitBtn.Text = ""
			hitBtn.ZIndex = 5
			hitBtn.MouseButton1Click:Connect(function()
				isOpen = not isOpen
				if isOpen then
					list.Visible = true
					arrow.Text = "▴"
					TweenService:Create(row, TWEEN_MEDIUM, {Size = UDim2.new(1, 0, 0, openedH)}):Play()
				else
					arrow.Text = "▾"
					TweenService:Create(row, TWEEN_MEDIUM, {Size = UDim2.new(1, 0, 0, closedH)}):Play()
					task.delay(TWEEN_MEDIUM.Time, function() list.Visible = false end)
				end
			end)

			local DropFunction = {}
			function DropFunction:SetOptions(newOpts)
				-- Clear old option buttons
				for _, c in list:GetChildren() do
					if c:IsA("TextButton") then c:Destroy() end
				end
				options = newOpts
				for i, opt in ipairs(options) do
					local ob = Instance.new("TextButton", list)
					ob.LayoutOrder = i
					ob.Size = UDim2.new(1, 0, 0, 28)
					ob.BackgroundTransparency = 1
					ob.Text = opt
					ob.TextColor3 = Color3.fromRGB(200, 200, 205)
					ob.TextSize = 12
					ob.Font = Enum.Font.Gotham
					ob.TextXAlignment = Enum.TextXAlignment.Left
					ob.AutoButtonColor = false
					local p = Instance.new("UIPadding", ob)
					p.PaddingLeft = UDim.new(0, 8)
					ob.MouseButton1Click:Connect(function()
						selectedVal = opt
						selLabel.Text = opt
						isOpen = false
						list.Visible = false
						arrow.Text = "▾"
						TweenService:Create(row, TWEEN_MEDIUM, {Size = UDim2.new(1, 0, 0, closedH)}):Play()
						if callback then callback(opt) end
					end)
				end
			end
			function DropFunction:GetSelected() return selectedVal end
			return DropFunction
		end

		-- ── AddTextBox ────────────────────────────────────────────────────
		--   name        – label
		--   info        – subtitle (can be nil)
		--   placeholder – placeholder string (can be nil)
		--   callback    – called with (text) when Enter or focus lost
		function Tab:AddTextBox(name, info, placeholder, callback)
			local row = MakeRow(ContentParent, 38)
			row.LayoutOrder = nextOrder()
			row.BackgroundColor3 = Color3.fromRGB(25, 25, 28)
			row.BackgroundTransparency = 0.3

			local rowCorner = Instance.new("UICorner", row)
			rowCorner.CornerRadius = UDim.new(0, 10)

			MakeLabel(row, name, info)

			local box = Instance.new("TextBox", row)
			box.Name = "InputBox"
			box.Size = UDim2.new(0.42, 0, 0, 26)
			box.AnchorPoint = Vector2.new(1, 0.5)
			box.Position = UDim2.new(1, -6, 0.5, 0)
			box.BackgroundColor3 = Color3.fromRGB(40, 40, 44)
			box.BackgroundTransparency = 0
			box.PlaceholderText = placeholder or "Type here…"
			box.PlaceholderColor3 = Color3.fromRGB(100, 100, 105)
			box.Text = ""
			box.TextColor3 = Color3.fromRGB(220, 220, 225)
			box.TextSize = 12
			box.TextWrapped = true
			box.Font = Enum.Font.Gotham
			box.ClearTextOnFocus = false

			local boxCorner = Instance.new("UICorner", box)
			boxCorner.CornerRadius = UDim.new(0, 7)

			-- Focus outline
			box.Focused:Connect(function()
				TweenService:Create(box, TWEEN_FAST, {BackgroundColor3 = Color3.fromRGB(55, 55, 60)}):Play()
			end)
			box.FocusLost:Connect(function(enterPressed)
				TweenService:Create(box, TWEEN_FAST, {BackgroundColor3 = Color3.fromRGB(40, 40, 44)}):Play()
				if callback then callback(box.Text, enterPressed) end
			end)

			local TextBoxFunction = {}
			function TextBoxFunction:GetText() return box.Text end
			function TextBoxFunction:SetText(t) box.Text = tostring(t) end
			return TextBoxFunction
		end

		-- ── AddTextLabel ──────────────────────────────────────────────────
		--   text  – string to display
		--   size  – font size (default 13)
		--   color – Color3 (default white)
		function Tab:AddTextLabel(text, size, color)
			local row = MakeRow(ContentParent, 14)
			row.LayoutOrder = nextOrder()
			row.BackgroundTransparency = 1

			local lbl = Instance.new("TextLabel", row)
			lbl.Name = "TextLabel"
			lbl.Size = UDim2.new(1, -20, 1, 0)
			lbl.Position = UDim2.new(0, 5, 0, 0)
			lbl.BackgroundTransparency = 1
			lbl.Text = text or ""
			lbl.TextColor3 = color or Color3.fromRGB(230, 230, 230)
			lbl.TextSize = size or 13
			lbl.Font = Enum.Font.Gotham
			lbl.TextXAlignment = Enum.TextXAlignment.Left
			lbl.TextWrapped = true

			local LabelFunction = {}
			function LabelFunction:SetText(t) lbl.Text = tostring(t) end
			function LabelFunction:SetColor(c) lbl.TextColor3 = c end
			return LabelFunction
		end
		
		return Tab
	end
	
	--=== Set Window Background ===--
	function Lib:SetBackground(image, transparency)
		pcall(writefile, SAVE_DIR .. "/bg.json", jsonencode({image, transparency}))
		local image = image
			and ("https://www.roblox.com/asset-thumbnail/image?assetId=" .. tostring(image) .. "&width=420&height=420&format=png")
			or ""
		local transparency = transparency or 0.5
		
		Background.Image = image
		Background.ImageTransparency = transparency
		
		ScrollBG.Image = image
		ScrollBG.ImageTransparency = transparency
	end
	
	--=== Set Background Image from Save ===--
	local success, content = pcall(readfile, SAVE_DIR .. "/bg.json")
	if success then
		Lib:SetBackground(unpack(jsondecode(content)))
	end
	
	getgenv().DARK_EXECUTOR_LIB = Lib
	return Lib
end

getgenv().DARK_EXECUTOR = Dark
return Dark
