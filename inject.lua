local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local CoreGui = game:GetService("CoreGui")

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "FakeAdminGUI"
screenGui.Parent = CoreGui

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 350, 0, 400)
mainFrame.Position = UDim2.new(0.5, -175, 0.5, -200)
mainFrame.BackgroundColor3 = Color3.fromRGB(30,30,30)
mainFrame.Parent = screenGui
mainFrame.Active = true
mainFrame.Draggable = true
Instance.new("UICorner", mainFrame)

local title = Instance.new("TextLabel", mainFrame)
title.Size = UDim2.new(1, 0, 0, 40)
title.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
title.Text = "Admin Panel"
title.TextColor3 = Color3.fromRGB(1,1,1)
title.Font = Enum.Font.GothamBold
title.TextSize = 20

local scrollingFrame = Instance.new("ScrollingFrame", mainFrame)
scrollingFrame.Size = UDim2.new(1, -10, 1, -50)
scrollingFrame.Position = UDim2.new(0, 5, 0, 45)
scrollingFrame.BackgroundTransparency = 1
scrollingFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
scrollingFrame.ScrollBarThickness = 5

local UIListLayout = Instance.new("UIListLayout", scrollingFrame)
UIListLayout.Padding = UDim.new(0, 5)

local function createPlayerButton(player)
	local frame = Instance.new("Frame", scrollingFrame)
	frame.Size = UDim2.new(1, 0, 0, 40)
	frame.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
	Instance.new("UICorner", frame)

	local nameLabel = Instance.new("TextLabel", frame)
	nameLabel.Size = UDim2.new(0.5, 0, 1, 0)
	nameLabel.Position = UDim2.new(0, 5, 0, 0)
	nameLabel.BackgroundTransparency = 1
	nameLabel.Text = player.Name
	nameLabel.TextColor3 = Color3.fromRGB(255,255,255)
	nameLabel.Font = Enum.Font.Gotham
	nameLabel.TextSize = 16
	nameLabel.TextXAlignment = Enum.TextXAlignment.Left

	local kickButton = Instance.new("TextButton", frame)
	kickButton.Size = UDim2.new(0.2, -5, 0.7, 0)
	kickButton.Position = UDim2.new(0.55, 0, 0.15, 0)
	kickButton.Text = "Kick"
	kickButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
	kickButton.Font = Enum.Font.GothamBold
	kickButton.TextColor3 = Color3.new(1,1,1)
	kickButton.TextSize = 14
	Instance.new("UICorner", kickButton)
	kickButton.MouseButton1Click:Connect(function()
		player:Kick("Admin tarafından atıldınız.")
	end)

	local banButton = Instance.new("TextButton", frame)
	banButton.Size = UDim2.new(0.2, -5, 0.7, 0)
	banButton.Position = UDim2.new(0.8, 0, 0.15, 0)
	banButton.Text = "Ban (Fake)"
	banButton.BackgroundColor3 = Color3.fromRGB(255, 180, 50)
	banButton.Font = Enum.Font.GothamBold
	banButton.TextColor3 = Color3.new(1,1,1)
	banButton.TextSize = 14
	Instance.new("UICorner", banButton)
	banButton.MouseButton1Click:Connect(function()
		screenGui:Destroy()
		LocalPlayer:Kick("Banlandınız. (Fake ban)")
	end)
end

local function refreshList()
	for _, child in ipairs(scrollingFrame:GetChildren()) do
		if child:IsA("Frame") then
			child:Destroy()
		end
	end
	for _, plr in ipairs(Players:GetPlayers()) do
		if plr ~= LocalPlayer then
			createPlayerButton(plr)
		end
	end
	-- Canvas size ayarla
	local totalHeight = 0
	for _, child in ipairs(scrollingFrame:GetChildren()) do
		if child:IsA("Frame") then
			totalHeight = totalHeight + child.Size.Y.Offset + UIListLayout.Padding.Offset
		end
	end
	scrollingFrame.CanvasSize = UDim2.new(0, 0, 0, totalHeight)
end

refreshList()
while true do
	task.wait(10)
	refreshList()
end
