local CoreGui = game:GetService("CoreGui")

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "SimpleInfoDisplay"
screenGui.ResetOnSpawn = false
screenGui.Parent = CoreGui

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 400, 0, 50)
frame.Position = UDim2.new(0.5, -200, 0.1, 0)
frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
frame.BorderSizePixel = 0
frame.Parent = screenGui
Instance.new("UICorner", frame)

local infoLabel = Instance.new("TextLabel")
infoLabel.Size = UDim2.new(1, -20, 1, 0)
infoLabel.Position = UDim2.new(0, 10, 0, 0)
infoLabel.BackgroundTransparency = 1
infoLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
infoLabel.Font = Enum.Font.GothamBold
infoLabel.TextSize = 20
infoLabel.TextXAlignment = Enum.TextXAlignment.Left
infoLabel.Text = "Kullanıcı - Event - Veri"
infoLabel.Parent = frame

local function showInfo(playerName, eventName, data)
    infoLabel.Text = string.format("%s - %s - %s", playerName, eventName, tostring(data))
end
