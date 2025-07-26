local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local CoreGui = game:GetService("CoreGui")

-- Event tam yolları
local KickEventPath = "GameEvents.Misk.KickPlayer"
local BanEventPath = "GameEvents.Misk.BanReceived"

local function getRemoteEventByPath(path)
    local current = ReplicatedStorage
    for part in string.gmatch(path, "[^%.]+") do
        current = current:FindFirstChild(part)
        if not current then
            return nil
        end
    end
    if current:IsA("RemoteEvent") then
        return current
    else
        return nil
    end
end

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "AdminKickBanGui"
screenGui.ResetOnSpawn = false
screenGui.Parent = CoreGui

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 350, 0, 450)
mainFrame.Position = UDim2.new(0.5, -175, 0.5, -225)
mainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
mainFrame.Parent = screenGui

local titleLabel = Instance.new("TextLabel")
titleLabel.Size = UDim2.new(1, 0, 0, 40)
titleLabel.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
titleLabel.Text = "Kick & Ban Panel"
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

local function createPlayerRow(player)
    local container = Instance.new("Frame")
    container.Size = UDim2.new(1, 0, 0, 40)
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

    local kickBtn = Instance.new("TextButton")
    kickBtn.Size = UDim2.new(0.25, -5, 1, 0)
    kickBtn.Position = UDim2.new(0.5, 0, 0, 0)
    kickBtn.Text = "Kick"
    kickBtn.BackgroundColor3 = Color3.fromRGB(255, 80, 80)
    kickBtn.TextColor3 = Color3.new(1,1,1)
    kickBtn.Font = Enum.Font.GothamBold
    kickBtn.TextSize = 18
    kickBtn.Parent = container

    kickBtn.MouseButton1Click:Connect(function()
        local kickEvent = getRemoteEventByPath(KickEventPath)
        if kickEvent then
            kickEvent:FireServer(player)
        else
            warn("Kick Event bulunamadı: "..KickEventPath)
        end
    end)

    local banBtn = Instance.new("TextButton")
    banBtn.Size = UDim2.new(0.25, -5, 1, 0)
    banBtn.Position = UDim2.new(0.75, 5, 0, 0)
    banBtn.Text = "Ban"
    banBtn.BackgroundColor3 = Color3.fromRGB(255, 180, 80)
    banBtn.TextColor3 = Color3.new(1,1,1)
    banBtn.Font = Enum.Font.GothamBold
    banBtn.TextSize = 18
    banBtn.Parent = container

    banBtn.MouseButton1Click:Connect(function()
        local banEvent = getRemoteEventByPath(BanEventPath)
        if banEvent then
            banEvent:FireServer(player)
        else
            warn("Ban Event bulunamadı: "..BanEventPath)
        end
    end)
end

local function refreshPlayers()
    scrollingFrame:ClearAllChildren()
    listLayout.Parent = scrollingFrame

    for _, player in pairs(Players:GetPlayers()) do
        if player ~= Players.LocalPlayer then
            createPlayerRow(player)
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

refreshPlayers()

Players.PlayerAdded:Connect(refreshPlayers)
Players.PlayerRemoving:Connect(refreshPlayers)
