local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local CoreGui = game:GetService("CoreGui")

-- GUI Oluştur
local gui = Instance.new("ScreenGui", CoreGui)
gui.Name = "FakeAdminGUI"
gui.ResetOnSpawn = false

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 400, 0, 300)
frame.Position = UDim2.new(0.5, -200, 0.5, -150)
frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
frame.BorderSizePixel = 0

local uicorner = Instance.new("UICorner", frame)
uicorner.CornerRadius = UDim.new(0, 10)

local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1, 0, 0, 40)
title.Text = "Admin Kontrol Paneli"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
title.Font = Enum.Font.GothamBold
title.TextSize = 16

local scroll = Instance.new("ScrollingFrame", frame)
scroll.Size = UDim2.new(1, -10, 1, -50)
scroll.Position = UDim2.new(0, 5, 0, 45)
scroll.CanvasSize = UDim2.new(0, 0, 0, 0)
scroll.BackgroundTransparency = 1
scroll.BorderSizePixel = 0
scroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
scroll.ScrollBarThickness = 5

local UIListLayout = Instance.new("UIListLayout", scroll)
UIListLayout.Padding = UDim.new(0, 5)

-- Oyuncu Butonlarını Oluştur
function createPlayerButton(plr)
	local container = Instance.new("Frame", scroll)
	container.Size = UDim2.new(1, -10, 0, 40)
	container.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
	container.BorderSizePixel = 0

	local nameLabel = Instance.new("TextLabel", container)
	nameLabel.Size = UDim2.new(0.5, 0, 1, 0)
	nameLabel.Text = plr.Name
	nameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
	nameLabel.BackgroundTransparency = 1
	nameLabel.Font = Enum.Font.Gotham
	nameLabel.TextSize = 14

	local kickButton = Instance.new("TextButton", container)
	kickButton.Size = UDim2.new(0.2, 0, 1, 0)
	kickButton.Position = UDim2.new(0.5, 0, 0, 0)
	kickButton.Text = "Kick"
	kickButton.BackgroundColor3 = Color3.fromRGB(255, 80, 80)
	kickButton.Font = Enum.Font.GothamBold
	kickButton.TextColor3 = Color3.new(1, 1, 1)
	kickButton.TextSize = 13
	kickButton.MouseButton1Click:Connect(function()
		plr:Kick("Admin tarafından atıldınız.")  -- DOĞRU OYUNCUYU KİCKLER
	end)

	local banButton = Instance.new("TextButton", container)
	banButton.Size = UDim2.new(0.2, -5, 1, 0)
	banButton.Position = UDim2.new(0.7, 5, 0, 0)
	banButton.Text = "Ban (Fake)"
	banButton.BackgroundColor3 = Color3.fromRGB(255, 180, 80)
	banButton.Font = Enum.Font.GothamBold
	banButton.TextColor3 = Color3.new(1, 1, 1)
	banButton.TextSize = 13
	banButton.MouseButton1Click:Connect(function()
		gui:Destroy()
		LocalPlayer:Kick("Hile tespit edildi. (Banlanmış gibi gösterildi)")
	end)

	local autoDeleteToggle = Instance.new("TextButton", container)
	autoDeleteToggle.Size = UDim2.new(0.1, -5, 1, 0)
	autoDeleteToggle.Position = UDim2.new(0.9, 0, 0, 0)
	autoDeleteToggle.Text = "🗑️"
	autoDeleteToggle.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
	autoDeleteToggle.Font = Enum.Font.Gotham
	autoDeleteToggle.TextColor3 = Color3.new(1, 1, 1)
	autoDeleteToggle.TextSize = 14

	local toggled = false
	autoDeleteToggle.MouseButton1Click:Connect(function()
		toggled = not toggled
		if toggled then
			autoDeleteToggle.Text = "❌"
		else
			autoDeleteToggle.Text = "🗑️"
		end
	end)
end

-- Oyuncuları Yenile
function refreshPlayers()
	for _, child in ipairs(scroll:GetChildren()) do
		if child:IsA("Frame") then
			child:Destroy()
		end
	end
	UIListLayout.Parent = scroll
	for _, plr in ipairs(Players:GetPlayers()) do
		if plr ~= LocalPlayer then
			createPlayerButton(plr)
		end
	end
end

-- 10 saniyede bir yenile
while true do
	refreshPlayers()
	wait(10)
end
