local UILib = {}

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

local function MakeDraggable(frame)
	local dragToggle = nil
	local dragInput, dragStart, startPos

	frame.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			dragToggle = true
			dragStart = input.Position
			startPos = frame.Position
			input.Changed:Connect(function()
				if input.UserInputState == Enum.UserInputState.End then
					dragToggle = false
				end
			end)
		end
	end)

	frame.InputChanged:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseMovement then
			dragInput = input
		end
	end)

	UserInputService.InputChanged:Connect(function(input)
		if input == dragInput and dragToggle then
			local delta = input.Position - dragStart
			frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
		end
	end)
end

function UILib:CreateWindow(title)
	local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
	ScreenGui.Name = "UILib_" .. title
	ScreenGui.ResetOnSpawn = false

	local Main = Instance.new("Frame", ScreenGui)
	Main.Size = UDim2.new(0, 500, 0, 350)
	Main.Position = UDim2.new(0.5, -250, 0.5, -175)
	Main.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
	Main.BorderSizePixel = 0
	Main.Name = "Main"
	Main.Active = true
	Main.Draggable = false
	MakeDraggable(Main)

	local Title = Instance.new("TextLabel", Main)
	Title.Text = title
	Title.Size = UDim2.new(1, 0, 0, 40)
	Title.BackgroundTransparency = 1
	Title.TextColor3 = Color3.fromRGB(255, 255, 255)
	Title.Font = Enum.Font.SourceSansBold
	Title.TextSize = 24

	local TabHolder = Instance.new("Frame", Main)
	TabHolder.Size = UDim2.new(0, 120, 1, -40)
	TabHolder.Position = UDim2.new(0, 0, 0, 40)
	TabHolder.BackgroundColor3 = Color3.fromRGB(20, 20, 20)

	local ContentHolder = Instance.new("Frame", Main)
	ContentHolder.Size = UDim2.new(1, -120, 1, -40)
	ContentHolder.Position = UDim2.new(0, 120, 0, 40)
	ContentHolder.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
	ContentHolder.Name = "ContentHolder"

	local tabs = {}

	local function CreateTab(name)
		local TabBtn = Instance.new("TextButton", TabHolder)
		TabBtn.Text = name
		TabBtn.Size = UDim2.new(1, 0, 0, 30)
		TabBtn.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
		TabBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
		TabBtn.Font = Enum.Font.SourceSans
		TabBtn.TextSize = 20

		local TabFrame = Instance.new("ScrollingFrame", ContentHolder)
		TabFrame.Size = UDim2.new(1, 0, 1, 0)
		TabFrame.BackgroundTransparency = 1
		TabFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
		TabFrame.ScrollBarThickness = 6
		TabFrame.Visible = false
		TabFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
		TabFrame.Name = name

		local UIList = Instance.new("UIListLayout", TabFrame)
		UIList.Padding = UDim.new(0, 6)
		UIList.SortOrder = Enum.SortOrder.LayoutOrder

		TabBtn.MouseButton1Click:Connect(function()
			for _, tab in pairs(tabs) do
				tab.Frame.Visible = false
			end
			TabFrame.Visible = true
		end)

		local tabObject = {}

		function tabObject:CreateButton(text, callback)
			local Btn = Instance.new("TextButton", TabFrame)
			Btn.Size = UDim2.new(1, -10, 0, 30)
			Btn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
			Btn.TextColor3 = Color3.fromRGB(255, 255, 255)
			Btn.Font = Enum.Font.SourceSans
			Btn.Text = text
			Btn.TextSize = 20
			Btn.AutoButtonColor = true

			Btn.MouseButton1Click:Connect(function()
				pcall(callback)
			end)
		end

		function tabObject:CreateToggle(text, default, callback)
			local Toggle = Instance.new("TextButton", TabFrame)
			Toggle.Size = UDim2.new(1, -10, 0, 30)
			Toggle.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
			Toggle.TextColor3 = Color3.fromRGB(255, 255, 255)
			Toggle.Font = Enum.Font.SourceSans
			Toggle.Text = text .. ": " .. (default and "ON" or "OFF")
			Toggle.TextSize = 20

			local toggled = default

			Toggle.MouseButton1Click:Connect(function()
				toggled = not toggled
				Toggle.Text = text .. ": " .. (toggled and "ON" or "OFF")
				pcall(callback, toggled)
			end)
		end

		function tabObject:CreateLabel(text)
			local Label = Instance.new("TextLabel", TabFrame)
			Label.Size = UDim2.new(1, -10, 0, 25)
			Label.BackgroundTransparency = 1
			Label.TextColor3 = Color3.fromRGB(200, 200, 200)
			Label.Font = Enum.Font.SourceSans
			Label.Text = text
			Label.TextSize = 18
		end

		tabObject.Frame = TabFrame
		table.insert(tabs, tabObject)

		return tabObject
	end

	local window = {}
	function window:CreateTab(name)
		return CreateTab(name)
	end

	return window
end

return UILib
