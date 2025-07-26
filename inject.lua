-- Geliştirilmiş Admin GUI (Delta uyumlu)

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local CoreGui = game:GetService("CoreGui")

-- Eski GUI varsa sil
pcall(function()
    CoreGui:FindFirstChild("FakeAdminGUI"):Destroy()
end)

-- GUI Oluştur
local gui = Instance.new("ScreenGui")
gui.Name = "FakeAdminGUI"
gui.ResetOnSpawn = false
gui.Parent = CoreGui

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 400, 0, 300)
frame.Position = UDim2.new(0.5, -200, 0.5, -150)
frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
frame.Parent = gui

local uicorner = Instance.new("UICorner", frame)
uicorner.CornerRadius = UDim.new(0, 10)

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 40)
title.Text = "Admin Kontrol Paneli"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
title.Font = Enum.Font.GothamBold
title.TextSize = 16
title.Parent = frame

local scroll = Instance.new("ScrollingFrame")
scroll.Size = UDim2.new(1, -10, 1, -50)
scroll.Position = UDim2.new(0, 5, 0, 45)
scroll.CanvasSize = UDim2.new(0, 0, 0, 0)
scroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
scroll.BackgroundTransparency = 1
scroll.ScrollBarThickness = 4
scroll.Parent = frame

local UIListLayout = Instance.new("UIListLayout")
UIListLayout.Padding = UDim.new(0, 5)
UIListLayout.Parent = scroll

local autoDeleteList = {}

-- Her oyuncu için buton oluştur
local function createPlayerButton(plr)
	local container = Instance.new("Frame")
	container.Size = UDim2.new(1, 0, 0, 40)
	container.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
	container.Parent = scroll

	local nameLabel = Instance.new("TextLabel")
	nameLabel.Size = UDim2.new(0.5, 0, 1, 0)
	nameLabel.Text = plr.Name
	nameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
	nameLabel.BackgroundTransparency = 1
	nameLabel.Font = Enum.Font.Gotham
	nameLabel.TextSize = 14
	nameLabel.Parent = container

	local kickButton = Instance.new("TextButton")
	kickButton.Size = UDim2.new(0.2, 0, 1, 0)
	kickButton.Position = UDim2.new(0.5, 0, 0, 0)
	kickButton.Text = "Kick"
	kickButton.BackgroundColor3 = Color3.fromRGB(255, 80, 80)
	kickButton.Font = Enum.Font.GothamBold
	kickButton.TextColor3 = Color3.new(1, 1, 1)
	kickButton.TextSize = 13
	kickButton.Parent = container
	kickButton.MouseButton1Click:Connect(function()
		local remote = game.ReplicatedStorage:FindFirstChild("KickEvent")
		if remote then
			remote:FireServer(plr)
		end
	end)

	local banButton = Instance.new("TextButton")
	banButton.Size = UDim2.new(0.2, -5, 1, 0)
	banButton.Position = UDim2.new(0.7, 5, 0, 0)
	banButton.Text = "Ban (Fake)"
	banButton.BackgroundColor3 = Color3.fromRGB(255, 180, 80)
	banButton.Font = Enum.Font.GothamBold
	banButton.TextColor3 = Color3.new(1, 1, 1)
	banButton.TextSize = 13
	banButton.Parent = container
	banButton.MouseButton1Click:Connect(function()
		LocalPlayer:Kick("Hile tespit edildi. (Fake Ban)")
	end)

	local autoDeleteToggle = Instance.new("TextButton")
	autoDeleteToggle.Size = UDim2.new(0.1, -5, 1, 0)
	autoDeleteToggle.Position = UDim2.new(0.9, 0, 0, 0)
	autoDeleteToggle.Text = "🗑️"
	autoDeleteToggle.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
	autoDeleteToggle.Font = Enum.Font.Gotham
	autoDeleteToggle.TextColor3 = Color3.new(1, 1, 1)
	autoDeleteToggle.TextSize = 14
	autoDeleteToggle.Parent = container

	local toggled = false
	autoDeleteToggle.MouseButton1Click:Connect(function()
		toggled = not toggled
		if toggled then
			table.insert(autoDeleteList, plr)
			autoDeleteToggle.Text = "❌"
		else
			for i, p in pairs(autoDeleteList) do
				if p == plr then
					table.remove(autoDeleteList, i)
					break
				end
			end
			autoDeleteToggle.Text = "🗑️"
		end
	end)
end

-- Oyuncuları yenileme fonksiyonu
local function refreshPlayers()
	scroll:ClearAllChildren()
	UIListLayout.Parent = scroll
	for _, plr in ipairs(Players:GetPlayers()) do
		if plr ~= LocalPlayer then
			createPlayerButton(plr)
		end
	end
end

-- 10 saniyede bir yenile (Thread kullanımı donmayı engeller)
task.spawn(function()
	while true do
		refreshPlayers()
		task.wait(10)
	end
end)
