local ReplicatedStorage = game:GetService("ReplicatedStorage")
local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "RemoteEventFinderGui"
screenGui.ResetOnSpawn = false
screenGui.Parent = CoreGui

local frame = Instance.new("Frame", screenGui)
frame.Size = UDim2.new(0, 1000, 0, 600)
frame.Position = UDim2.new(0, 0, 0.5, -300) -- ekranın üstünde ortala dikeyde
frame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
frame.BorderSizePixel = 0
frame.Active = true
frame.Draggable = true
Instance.new("UICorner", frame)

local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1, 0, 0, 50)
title.Position = UDim2.new(0, 0, 0, 0)
title.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
title.TextColor3 = Color3.new(1, 1, 1)
title.Text = "🔎 Remote Event & Function Finder"
title.Font = Enum.Font.GothamBold
title.TextSize = 28
title.BorderSizePixel = 0

local scrollingFrame = Instance.new("ScrollingFrame", frame)
scrollingFrame.Size = UDim2.new(1, -20, 1, -70)
scrollingFrame.Position = UDim2.new(0, 10, 0, 60)
scrollingFrame.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
scrollingFrame.BorderSizePixel = 0
scrollingFrame.ScrollBarThickness = 8
scrollingFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
Instance.new("UICorner", scrollingFrame)

local layout = Instance.new("UIListLayout", scrollingFrame)
layout.Padding = UDim.new(0, 8)
layout.SortOrder = Enum.SortOrder.LayoutOrder

local function listRemoteObjects(parent)
	for _, child in pairs(scrollingFrame:GetChildren()) do
		if child:IsA("TextLabel") then
			child:Destroy()
		end
	end

	local function recurse(obj)
		for _, child in pairs(obj:GetChildren()) do
			if child:IsA("RemoteEvent") then
				local label = Instance.new("TextLabel")
				label.Size = UDim2.new(1, -15, 0, 30)
				label.BackgroundColor3 = Color3.fromRGB(70, 130, 180)
				label.TextColor3 = Color3.new(1, 1, 1)
				label.Text = "[RemoteEvent]  " .. child:GetFullName()
				label.Font = Enum.Font.Gotham
				label.TextSize = 16
				label.TextXAlignment = Enum.TextXAlignment.Left
				label.BorderSizePixel = 0
				label.Parent = scrollingFrame
			elseif child:IsA("RemoteFunction") then
				local label = Instance.new("TextLabel")
				label.Size = UDim2.new(1, -15, 0, 30)
				label.BackgroundColor3 = Color3.fromRGB(180, 130, 70)
				label.TextColor3 = Color3.new(1, 1, 1)
				label.Text = "[RemoteFunction]  " .. child:GetFullName()
				label.Font = Enum.Font.Gotham
				label.TextSize = 16
				label.TextXAlignment = Enum.TextXAlignment.Left
				label.BorderSizePixel = 0
				label.Parent = scrollingFrame
			end

			recurse(child)
		end
	end

	recurse(parent)
end

listRemoteObjects(ReplicatedStorage)
