pcall(function() game.CoreGui:FindFirstChild("FakeAdminGUI"):Destroy() end)

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer = Players.LocalPlayer

-- RemoteEvent'leri bul
local KickEvent = ReplicatedStorage:FindFirstChild("KickPlayerEvent")
local BanEvent = ReplicatedStorage:FindFirstChild("BanPlayerEvent")

if not KickEvent or not BanEvent then
	warn("Kick veya Ban eventi bulunamadı!")
	return
end

-- GUI Başlat
local gui = Instance.new("ScreenGui", game.CoreGui)
gui.Name = "FakeAdminGUI"
gui.ResetOnSpawn = false

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 400, 0, 500)
frame.Position = UDim2.new(1, -410, 0.5, -250)
frame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
frame.BorderSizePixel = 0
frame.Active = true
frame.Draggable = true
Instance.new("UICorner", frame)

local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1, 0, 0, 40)
title.Text = "🛡️ Yönetici Paneli"
title.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
title.TextColor3 = Color3.new(1, 1, 1)
title.Font = Enum.Font.GothamBold
title.TextSize = 20
Instance.new("UICorner", title)

local scroll = Instance.new("ScrollingFrame", frame)
scroll.Size = UDim2.new(1, -20, 1, -50)
scroll.Position = UDim2.new(0, 10, 0, 45)
scroll.CanvasSize = UDim2.new(0, 0, 0, 0)
scroll.BackgroundTransparency = 1
scroll.ScrollBarThickness = 6

local UIList = Instance.new("UIListLayout", scroll)
UIList.Padding = UDim.new(0, 6)

-- Yenileme fonksiyonu
local function refreshList()
	scroll:ClearAllChildren()
	UIList.Parent = scroll
	for _, plr in pairs(Players:GetPlayers()) do
		if plr ~= LocalPlayer then
			local container = Instance.new("Frame")
			container.Size = UDim2.new(1, 0, 0, 40)
			container.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
			Instance.new("UICorner", container)

			local nameLabel = Instance.new("TextLabel", container)
			nameLabel.Text = plr.Name
			nameLabel.Size = UDim2.new(0.5, -10, 1, 0)
			nameLabel.BackgroundTransparency = 1
			nameLabel.TextColor3 = Color3.new(1,1,1)
			nameLabel.Font = Enum.Font.Gotham
			nameLabel.TextSize = 16
			nameLabel.TextXAlignment = Enum.TextXAlignment.Left

			local kickButton = Instance.new("TextButton", container)
			kickButton.Text = "🚫"
			kickButton.Size = UDim2.new(0, 40, 0, 30)
			kickButton.Position = UDim2.new(0.6, 0, 0.1, 0)
			kickButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
			kickButton.TextColor3 = Color3.new(1,1,1)
			kickButton.Font = Enum.Font.GothamBold
			kickButton.TextSize = 18
			Instance.new("UICorner", kickButton)

			local banButton = Instance.new("TextButton", container)
			banButton.Text = "🔨"
			banButton.Size = UDim2.new(0, 40, 0, 30)
			banButton.Position = UDim2.new(0.75, 0, 0.1, 0)
			banButton.BackgroundColor3 = Color3.fromRGB(255, 170, 0)
			banButton.TextColor3 = Color3.new(1,1,1)
			banButton.Font = Enum.Font.GothamBold
			banButton.TextSize = 18
			Instance.new("UICorner", banButton)

			kickButton.MouseButton1Click:Connect(function()
				KickEvent:FireServer(plr.Name)
			end)

			banButton.MouseButton1Click:Connect(function()
				BanEvent:FireServer(plr.Name)
			end)

			nameLabel.Parent = container
			kickButton.Parent = container
			banButton.Parent = container
			container.Parent = scroll
		end
	end
	scroll.CanvasSize = UDim2.new(0, 0, 0, UIList.AbsoluteContentSize.Y + 10)
end

refreshList()

-- Otomatik güncelleme
while gui.Parent do
	refreshList()
	wait(10)
end
