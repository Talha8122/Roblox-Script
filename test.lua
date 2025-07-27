local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")

local remoteEvent = ReplicatedStorage:WaitForChild("GameEvents"):WaitForChild("Misk"):WaitForChild("BanReceived")

-- GUI oluştur
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "BanPlayerGUI"
screenGui.ResetOnSpawn = false
screenGui.IgnoreGuiInset = true
screenGui.Parent = CoreGui

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 300, 0, 400)
mainFrame.Position = UDim2.new(0, 100, 0.5, -200)
mainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
mainFrame.BorderSizePixel = 0
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.Parent = screenGui
Instance.new("UICorner", mainFrame)

local titleLabel = Instance.new("TextLabel")
titleLabel.Size = UDim2.new(1, 0, 0, 40)
titleLabel.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
titleLabel.Text = "Oyuncu Seç - Ban Gönder"
titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
titleLabel.Font = Enum.Font.GothamBold
titleLabel.TextSize = 18
titleLabel.Parent = mainFrame

local scrollingFrame = Instance.new("ScrollingFrame")
scrollingFrame.Size = UDim2.new(1, -10, 1, -50)
scrollingFrame.Position = UDim2.new(0, 5, 0, 45)
scrollingFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
scrollingFrame.ScrollBarThickness = 6
scrollingFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
scrollingFrame.BorderSizePixel = 0
scrollingFrame.Parent = mainFrame

local listLayout = Instance.new("UIListLayout")
listLayout.Padding = UDim.new(0, 4)
listLayout.Parent = scrollingFrame

-- Buton oluşturma
local function createPlayerButton(targetPlayer)
	local button = Instance.new("TextButton")
	button.Size = UDim2.new(1, -10, 0, 30)
	button.Text = targetPlayer.Name
	button.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
	button.TextColor3 = Color3.fromRGB(255, 255, 255)
	button.Font = Enum.Font.SourceSans
	button.TextSize = 18
	button.Parent = scrollingFrame

	button.MouseButton1Click:Connect(function()
		-- Event gönder
		remoteEvent:FireServer({
			reason = "Exploit",
			duration = 30
		})
	end)
end

-- GUI'yi doldur
local function populatePlayers()
	for _, child in pairs(scrollingFrame:GetChildren()) do
		if child:IsA("TextButton") then
			child:Destroy()
		end
	end

	for _, player in pairs(Players:GetPlayers()) do
		if player ~= Players.LocalPlayer then
			createPlayerButton(player)
		end
	end

	-- Scroll ayarı
	task.wait()
	local totalHeight = 0
	for _, button in pairs(scrollingFrame:GetChildren()) do
		if button:IsA("TextButton") then
			totalHeight += button.Size.Y.Offset + listLayout.Padding.Offset
		end
	end
	scrollingFrame.CanvasSize = UDim2.new(0, 0, 0, totalHeight)
end

-- Otomatik güncelle
Players.PlayerAdded:Connect(populatePlayers)
Players.PlayerRemoving:Connect(populatePlayers)

populatePlayers()
