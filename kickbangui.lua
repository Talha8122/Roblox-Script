local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local CoreGui = game:GetService("CoreGui")

local LocalPlayer = Players.LocalPlayer

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "CustomEventTriggerGui"
screenGui.ResetOnSpawn = false
screenGui.Parent = CoreGui

local frame = Instance.new("Frame", screenGui)
frame.Size = UDim2.new(0, 400, 0, 500)
frame.Position = UDim2.new(0.5, -200, 0.5, -250)
frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
frame.BorderSizePixel = 0
frame.Active = true
frame.Draggable = true
Instance.new("UICorner", frame)

local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1, 0, 0, 40)
title.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
title.TextColor3 = Color3.new(1, 1, 1)
title.Text = "📋 Event Trigger Panel"
title.Font = Enum.Font.GothamBold
title.TextSize = 24
title.BorderSizePixel = 0

local scrollingFrame = Instance.new("ScrollingFrame", frame)
scrollingFrame.Size = UDim2.new(1, -20, 1, -50)
scrollingFrame.Position = UDim2.new(0, 10, 0, 45)
scrollingFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
scrollingFrame.BorderSizePixel = 0
scrollingFrame.ScrollBarThickness = 6
scrollingFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
Instance.new("UICorner", scrollingFrame)

local layout = Instance.new("UIListLayout", scrollingFrame)
layout.Padding = UDim.new(0, 8)
layout.SortOrder = Enum.SortOrder.LayoutOrder

-- Her oyuncu için buton ve event name inputu oluştur
local function createPlayerEntry(player)
    local container = Instance.new("Frame")
    container.Size = UDim2.new(1, 0, 0, 40)
    container.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    container.BorderSizePixel = 0
    container.Parent = scrollingFrame
    Instance.new("UICorner", container)

    local nameLabel = Instance.new("TextLabel")
    nameLabel.Size = UDim2.new(0.4, 0, 1, 0)
    nameLabel.Position = UDim2.new(0, 8, 0, 0)
    nameLabel.BackgroundTransparency = 1
    nameLabel.Text = player.Name
    nameLabel.TextColor3 = Color3.new(1, 1, 1)
    nameLabel.Font = Enum.Font.Gotham
    nameLabel.TextSize = 18
    nameLabel.Parent = container

    local eventInput = Instance.new("TextBox")
    eventInput.Size = UDim2.new(0.4, -10, 0.6, 0)
    eventInput.Position = UDim2.new(0.4, 10, 0.2, 0)
    eventInput.PlaceholderText = "RemoteEvent İsmi (ör. BanPlayer)"
    eventInput.ClearTextOnFocus = false
    eventInput.Text = ""
    eventInput.Font = Enum.Font.Gotham
    eventInput.TextSize = 16
    eventInput.Parent = container

    local triggerBtn = Instance.new("TextButton")
    triggerBtn.Size = UDim2.new(0.15, 0, 0.6, 0)
    triggerBtn.Position = UDim2.new(0.85, 0, 0.2, 0)
    triggerBtn.Text = "Gönder"
    triggerBtn.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
    triggerBtn.TextColor3 = Color3.new(1, 1, 1)
    triggerBtn.Font = Enum.Font.GothamBold
    triggerBtn.TextSize = 16
    triggerBtn.Parent = container
    Instance.new("UICorner", triggerBtn)

    triggerBtn.MouseButton1Click:Connect(function()
        local eventName = eventInput.Text
        if eventName and eventName ~= "" then
            local remoteEvent = ReplicatedStorage:FindFirstChild(eventName)
            if remoteEvent and remoteEvent:IsA("RemoteEvent") then
                -- Burada player'i argüman olarak atıyoruz, bazı eventler farklı argüman isteyebilir
                remoteEvent:FireServer(player)
            else
                warn("RemoteEvent bulunamadı: "..eventName)
            end
        else
            warn("Lütfen RemoteEvent ismini girin.")
        end
    end)
end

-- Listeyi temizleyip tekrar oluştur
local function refreshPlayerList()
    for _, child in pairs(scrollingFrame:GetChildren()) do
        if child:IsA("Frame") then
            child:Destroy()
        end
    end
    for _, player in pairs(Players:GetPlayers()) do
        createPlayerEntry(player)
    end
end

refreshPlayerList()

-- Oyuncu liste değişikliklerini takip et (oyuncu giriş/çıkış)
Players.PlayerAdded:Connect(refreshPlayerList)
Players.PlayerRemoving:Connect(refreshPlayerList)
