local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local HttpService = game:GetService("HttpService")
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- GUI oluştur
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "SimpleRemoteSender"
screenGui.ResetOnSpawn = false
screenGui.Parent = playerGui

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 400, 0, 180)
mainFrame.Position = UDim2.new(0.5, -200, 0.5, -90)
mainFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 40)
mainFrame.BorderSizePixel = 0
mainFrame.Parent = screenGui
mainFrame.Active = true
mainFrame.Draggable = true
Instance.new("UICorner", mainFrame)

-- Başlık
local title = Instance.new("TextLabel", mainFrame)
title.Size = UDim2.new(1, 0, 0, 30)
title.BackgroundTransparency = 1
title.Text = "🚀 Remote Event Manual Sender"
title.TextColor3 = Color3.new(1,1,1)
title.Font = Enum.Font.GothamBold
title.TextSize = 18

-- Event ismi girişi
local eventInput = Instance.new("TextBox", mainFrame)
eventInput.PlaceholderText = "Event tam path'i (örnek: Folder1.RemoteEventName)"
eventInput.Size = UDim2.new(1, -20, 0, 40)
eventInput.Position = UDim2.new(0, 10, 0, 40)
eventInput.BackgroundColor3 = Color3.fromRGB(45,45,50)
eventInput.TextColor3 = Color3.new(1,1,1)
eventInput.ClearTextOnFocus = false
eventInput.Font = Enum.Font.Gotham
eventInput.TextSize = 16
Instance.new("UICorner", eventInput)

-- Veri girişi
local dataInput = Instance.new("TextBox", mainFrame)
dataInput.PlaceholderText = 'Gönderilecek veri (JSON formatında veya string)'
dataInput.Size = UDim2.new(1, -20, 0, 60)
dataInput.Position = UDim2.new(0, 10, 0, 90)
dataInput.BackgroundColor3 = Color3.fromRGB(45,45,50)
dataInput.TextColor3 = Color3.new(1,1,1)
dataInput.ClearTextOnFocus = false
dataInput.Font = Enum.Font.Gotham
dataInput.TextSize = 14
dataInput.TextWrapped = true
Instance.new("UICorner", dataInput)

-- Gönder butonu
local sendButton = Instance.new("TextButton", mainFrame)
sendButton.Size = UDim2.new(0.5, -15, 0, 30)
sendButton.Position = UDim2.new(0.5, 10, 1, -40)
sendButton.BackgroundColor3 = Color3.fromRGB(70,150,70)
sendButton.TextColor3 = Color3.new(1,1,1)
sendButton.Text = "Gönder"
sendButton.Font = Enum.Font.GothamBold
sendButton.TextSize = 18
Instance.new("UICorner", sendButton)

-- Fonksiyon: Event bulma
local function findEventByPath(path)
    local current = ReplicatedStorage
    for name in string.gmatch(path, "[^%.]+") do
        current = current:FindFirstChild(name)
        if not current then return nil end
    end
    if current and current:IsA("RemoteEvent") then
        return current
    else
        return nil
    end
end

-- Gönderme işlemi
sendButton.MouseButton1Click:Connect(function()
    local eventPath = eventInput.Text
    if eventPath == "" then
        warn("Lütfen event path girin!")
        return
    end

    local remoteEvent = findEventByPath(eventPath)
    if not remoteEvent then
        warn("Event bulunamadı: " .. eventPath)
        return
    end

    local rawData = dataInput.Text
    local success, data = pcall(function()
        return HttpService:JSONDecode(rawData)
    end)
    if not success then
        data = rawData -- JSON değilse string olarak al
    end

    -- FireServer ile event'i tetikle
    remoteEvent:FireServer(data)
    print("Event gönderildi:", eventPath, "Veri:", data)
end)
