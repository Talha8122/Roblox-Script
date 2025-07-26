local Players = game:GetService("Players")
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "InfoDisplayGui"
screenGui.ResetOnSpawn = false
screenGui.Parent = playerGui

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 400, 0, 50)
frame.Position = UDim2.new(0.5, -200, 0.1, 0)
frame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
frame.BorderSizePixel = 0
frame.Parent = screenGui
Instance.new("UICorner", frame)

local label = Instance.new("TextLabel")
label.Size = UDim2.new(1, -20, 1, 0)
label.Position = UDim2.new(0, 10, 0, 0)
label.BackgroundTransparency = 1
label.TextColor3 = Color3.fromRGB(255, 255, 255)
label.Font = Enum.Font.GothamBold
label.TextSize = 20
label.TextXAlignment = Enum.TextXAlignment.Left
label.Text = "Kullanıcı - Event - Veri"
label.Parent = frame

-- Bilgiyi güncelleyen fonksiyon
local function showInfo(playerName, eventName, data)
    label.Text = string.format("%s - %s - %s", playerName, eventName, tostring(data))
end

-- Örnek kullanım (bunu istediğin yerden çağırabilirsin)
showInfo(player.Name, "GameEvents.Misk.BanReceived", "{ reason = 'Hile' }")
