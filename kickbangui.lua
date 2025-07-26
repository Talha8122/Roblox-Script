local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")

-- Kullanıcılar için gösterilecek event isimleri (örnek)
local eventNameForEachPlayer = {} -- key: player, value: eventname

-- Örnek sabit event isimleri (dilersen dinamik yapabilirsin)
local defaultEventName = "KickPlayer" 

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "UserEventGui"
screenGui.ResetOnSpawn = false
screenGui.Parent = Players.LocalPlayer:WaitForChild("PlayerGui")

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 400, 0, 500)
mainFrame.Position = UDim2.new(0.5, -200, 0.5, -250)
mainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
mainFrame.Parent = screenGui

local titleLabel = Instance.new("TextLabel")
titleLabel.Size = UDim2.new(1, 0, 0, 40)
titleLabel.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
titleLabel.Text = "Kullanıcılar ve Eventler"
titleLabel.TextColor3 = Color3.new(1,1,1)
titleLabel.Font = Enum.Font.GothamBold
titleLabel.TextSize = 24
titleLabel.Parent = mainFrame

local scrollingFrame = Instance.new("ScrollingFrame")
scrollingFrame.Size = UDim2.new(1, -20, 1, -50)
scrollingFrame.Position = UDim2.new(0, 10, 0, 45)
scrollingFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
scrollingFrame.BorderSizePixel = 0
scrollingFrame.ScrollBarThickness = 8
scrollingFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
scrollingFrame.Parent = mainFrame

local listLayout = Instance.new("UIListLayout")
listLayout.Padding = UDim.new(0, 5)
listLayout.Parent = scrollingFrame

-- Satır oluşturma fonksiyonu
local function createPlayerRow(player, eventName)
    local container = Instance.new("Frame")
    container.Size = UDim2.new(1, 0, 0, 30)
    container.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    container.Parent = scrollingFrame

    local nameLabel = Instance.new("TextLabel")
    nameLabel.Size = UDim2.new(0.5, 0, 1, 0)
    nameLabel.BackgroundTransparency = 1
    nameLabel.TextColor3 = Color3.new(1, 1, 1)
    nameLabel.Text = player.Name
    nameLabel.Font = Enum.Font.Gotham
    nameLabel.TextSize = 18
    nameLabel.Parent = container

    local eventLabel = Instance.new("TextLabel")
    eventLabel.Size = UDim2.new(0.5, 0, 1, 0)
    eventLabel.Position = UDim2.new(0.5, 0, 0, 0)
    eventLabel.BackgroundTransparency = 1
    eventLabel.TextColor3 = Color3.new(1, 1, 1)
    eventLabel.Text = eventName or defaultEventName
    eventLabel.Font = Enum.Font.Gotham
    eventLabel.TextSize = 18
    eventLabel.Parent = container
end

-- 1 saniyede bir GUI'yi yenileyen fonksiyon
local function refreshGui()
    scrollingFrame:ClearAllChildren()
    listLayout.Parent = scrollingFrame

    for _, player in pairs(Players:GetPlayers()) do
        if player ~= Players.LocalPlayer then
            local eventName = eventNameForEachPlayer[player.UserId] or defaultEventName
            createPlayerRow(player, eventName)
        end
    end

    -- CanvasSize ayarla
    local totalHeight = 0
    for _, child in pairs(scrollingFrame:GetChildren()) do
        if child:IsA("Frame") then
            totalHeight = totalHeight + child.Size.Y.Offset + listLayout.Padding.Offset
        end
    end
    scrollingFrame.CanvasSize = UDim2.new(0, 0, 0, totalHeight)
end

-- Örnek: Oyunculara dinamik event atama (dilersen bunu değiştirebilirsin)
Players.PlayerAdded:Connect(function(player)
    eventNameForEachPlayer[player.UserId] = math.random(1,2) == 1 and "KickPlayer" or "BanReceived"
    refreshGui()
end)

Players.PlayerRemoving:Connect(function(player)
    eventNameForEachPlayer[player.UserId] = nil
    refreshGui()
end)

-- Başlangıçta GUI'yi doldur
refreshGui()

-- 1 saniyede bir güncelle
while true do
    refreshGui()
    task.wait(1)
end
