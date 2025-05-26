local Library = {}

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

local function makeDraggable(frame)
	local dragging, dragInput, dragStart, startPos
	frame.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			dragging = true
			dragStart = input.Position
			startPos = frame.Position
			input.Changed:Connect(function()
				if input.UserInputState == Enum.UserInputState.End then dragging = false end
			end)
		end
	end)
	UserInputService.InputChanged:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseMovement then dragInput = input end
	end)
	UserInputService.InputChanged:Connect(function(input)
		if input == dragInput and dragging then
			local delta = input.Position - dragStart
			frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X,
				startPos.Y.Scale, startPos.Y.Offset + delta.Y)
		end
	end)
end

function Library:CreateWindow(title)
	local gui = Instance.new("ScreenGui", game:GetService("CoreGui"))
	gui.Name = "CleanUILib_" .. title
	gui.ResetOnSpawn = false

	local Main = Instance.new("Frame", gui)
	Main.Size = UDim2.new(0, 500, 0, 400)
	Main.Position = UDim2.new(0.5, -250, 0.5, -200)
	Main.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
	Main.BorderSizePixel = 0
	Main.Active = true
	Main.Draggable = false
	Main.ClipsDescendants = true
	Main.AnchorPoint = Vector2.new(0.5, 0.5)
	Main.Name = "Main"
	Main.BackgroundTransparency = 0
	Main.AutomaticSize = Enum.AutomaticSize.None
	Main.ZIndex = 2
	makeDraggable(Main)

	local UICorner = Instance.new("UICorner", Main)
	UICorner.CornerRadius = UDim.new(0, 10)

	local Title = Instance.new("TextLabel", Main)
	Title.Size = UDim2.new(1, 0, 0, 40)
	Title.BackgroundTransparency = 1
	Title.Text = title
	Title.TextColor3 = Color3.fromRGB(255, 255, 255)
	Title.Font = Enum.Font.GothamBold
	Title.TextSize = 24
	Title.TextXAlignment = Enum.TextXAlignment.Center

	local TabHolder = Instance.new("Frame", Main)
	TabHolder.Size = UDim2.new(0, 130, 1, -40)
	TabHolder.Position = UDim2.new(0, 0, 0, 40)
	TabHolder.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
	Instance.new("UICorner", TabHolder).CornerRadius = UDim.new(0, 8)

	local TabLayout = Instance.new("UIListLayout", TabHolder)
	TabLayout.SortOrder = Enum.SortOrder.LayoutOrder
	TabLayout.Padding = UDim.new(0, 5)

	local Content = Instance.new("Frame", Main)
	Content.Size = UDim2.new(1, -140, 1, -50)
	Content.Position = UDim2.new(0, 140, 0, 45)
	Content.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
	Content.Name = "Content"
	Instance.new("UICorner", Content).CornerRadius = UDim.new(0, 8)

	local Tabs = {}

	function Library:CreateTab(tabName)
		local Button = Instance.new("TextButton", TabHolder)
		Button.Size = UDim2.new(1, -10, 0, 35)
		Button.Text = tabName
		Button.Font = Enum.Font.Gotham
		Button.TextSize = 16
		Button.TextColor3 = Color3.fromRGB(255, 255, 255)
		Button.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
		Button.BorderSizePixel = 0
		Instance.new("UICorner", Button).CornerRadius = UDim.new(0, 6)

		local TabFrame = Instance.new("ScrollingFrame", Content)
		TabFrame.Size = UDim2.new(1, 0, 1, 0)
		TabFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
		TabFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
		TabFrame.ScrollBarThickness = 5
		TabFrame.Visible = false
		TabFrame.Name = tabName
		TabFrame.BackgroundTransparency = 1

		local Layout = Instance.new("UIListLayout", TabFrame)
		Layout.Padding = UDim.new(0, 6)
		Layout.SortOrder = Enum.SortOrder.LayoutOrder

		local tab = {}

		function tab:CreateButton(text, callback)
			local Btn = Instance.new("TextButton", TabFrame)
			Btn.Size = UDim2.new(1, -10, 0, 35)
			Btn.Text = text
			Btn.Font = Enum.Font.Gotham
			Btn.TextSize = 16
			Btn.TextColor3 = Color3.fromRGB(255, 255, 255)
			Btn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
			Instance.new("UICorner", Btn).CornerRadius = UDim.new(0, 6)
			Btn.MouseButton1Click:Connect(function()
				pcall(callback)
			end)
		end

		function tab:CreateToggle(text, default, callback)
			local Toggle = Instance.new("TextButton", TabFrame)
			Toggle.Size = UDim2.new(1, -10, 0, 35)
			Toggle.Font = Enum.Font.Gotham
			Toggle.TextSize = 16
			Toggle.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
			Instance.new("UICorner", Toggle).CornerRadius = UDim.new(0, 6)

			local state = default
			local function update()
				Toggle.Text = text .. ": " .. (state and "ON" or "OFF")
			end
			update()

			Toggle.MouseButton1Click:Connect(function()
				state = not state
				update()
				pcall(callback, state)
			end)
		end

		function tab:CreateLabel(text)
			local Label = Instance.new("TextLabel", TabFrame)
			Label.Size = UDim2.new(1, -10, 0, 30)
			Label.Text = text
			Label.TextColor3 = Color3.fromRGB(220, 220, 220)
			Label.Font = Enum.Font.Gotham
			Label.TextSize = 15
			Label.BackgroundTransparency = 1
		end

		Button.MouseButton1Click:Connect(function()
			for _, t in pairs(Tabs) do
				t.Frame.Visible = false
			end
			TabFrame.Visible = true
		end)

		tab.Frame = TabFrame
		Tabs[tabName] = tab
		return tab
	end

	return Library
end

return Library
