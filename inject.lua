local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local CoreGui = game:GetService("CoreGui")

-- GUI oluştur
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "FakeAdminGUI"
screenGui.ResetOnSpawn = false
screenGui.Parent = CoreGui

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 350, 0, 400)
mainFrame.Position = UDim2.new(0.5, -175, 0.5, -200)
mainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
mainFrame.BorderSizePixel = 0
mainFrame.Parent = screenGui

local titleLabel = Instance.new("TextLabel")
titleLabel.Size = UDim2.new(1, 0, 0, 40)
titleLabel.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
titleLabel.Text = "👑 Admin Paneli (Fake)"
titleLabel.TextColor3 = Color3.new(1, 1, 1)
titleLabel.Font = Enum.Font.GothamBold
titleLabel.TextSize = 18
titleLabel.Parent = mainFrame

local scrollingFrame = Instance.new("ScrollingFrame")
scrollingFrame.Size = UDim2.new(1, -10, 1, -50)
scrollingFrame.Position = UDim2.new(0, 5, 0, 45)
scrollingFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
scrollingFrame.ScrollBarThickness = 6
scrollingFrame.BackgroundTransparency = 1
scrollingFrame.BorderSizePixel = 0
scrollingFrame.Parent = mainFrame

local listLayout = Instance.new("UIListLayout")
listLayout.Padding = UDim.new(0, 5)
listLayout.Parent = scrollingFrame

-- Oyuncu satırı oluştur
local function createPlayerRow(player)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, 0, 0, 40)
    frame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    frame.Parent = scrollingFrame

    local nameLabel = Instance.new("TextLabel")
    nameLabel.Size = UDim2.new(0.5, 0, 1, 0)
    nameLabel.Position = UDim2.new(0, 5, 0, 0)
    nameLabel.BackgroundTransparency = 1
    nameLabel.TextColor3 = Color3.new(1,1,1)
    nameLabel.Text = player.Name
    nameLabel.Font = Enum.Font.Gotham
    nameLabel.TextSize = 16
    nameLabel.Parent = frame

    local kickBtn = Instance.new("TextButton")
    kickBtn.Size = UDim2.new(0.2, -5, 0.8, 0)
    kickBtn.Position = UDim2.new(0.55, 0, 0.1, 0)
    kickBtn.Text = "Kick"
    kickBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
    kickBtn.TextColor3 = Color3.new(1,1,1)
    kickBtn.Font = Enum.Font.GothamBold
    kickBtn.TextSize = 14
    kickBtn.Parent = frame

    kickBtn.MouseButton1Click:Connect(function()
        -- Kick işlemi (Fake olarak sadece mesaj verip kickleme simülasyonu)
        -- Gerçek kick için: player:Kick("Atıldınız")
        -- Burada sadece uyarı veriyoruz (fake)
        print("Fake kick atıldı: "..player.Name)
        -- Dilersen gerçek kick de yapabilirsin:
        -- player:Kick("Admin tarafından atıldınız.")
    end)

    local banBtn = Instance.new("TextButton")
    banBtn.Size = UDim2.new(0.2, -5, 0.8, 0)
    banBtn.Position = UDim2.new(0.78, 0, 0.1, 0)
    banBtn.Text = "Ban"
    banBtn.BackgroundColor3 = Color3.fromRGB(200, 140, 0)
    banBtn.TextColor3 = Color3.new(1,1,1)
    banBtn.Font = Enum.Font.GothamBold
    banBtn.TextSize = 14
    banBtn.Parent = frame

    banBtn.MouseButton1Click:Connect(function()
        -- Ban işlemi (Fake olarak local player kickleniyor, diğer oyunculara dokunmaz)
        if player == LocalPlayer then
            LocalPlayer:Kick("Banlandınız (fake)")
        else
            print("Fake ban atıldı: "..player.Name)
            -- Gerçek ban için servera event yollanmalı (burada fake)
        end
    end)
end

-- Listeyi güncelle
local function refreshPlayerList()
    -- Önce tüm satırları temizle
    for _, child in ipairs(scrollingFrame:GetChildren()) do
        if child:IsA("Frame") then
            child:Destroy()
        end
    end

    -- Yeni satırları oluştur
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then -- Kendi ismini listeye alma dilersen kaldırabilirsin
            createPlayerRow(player)
        end
    end

    -- CanvasSize'ı güncelle
    local totalHeight = 0
    for _, child in ipairs(scrollingFrame:GetChildren()) do
        if child:IsA("Frame") then
            totalHeight = totalHeight + child.Size.Y.Offset + listLayout.Padding.Offset
        end
    end
    scrollingFrame.CanvasSize = UDim2.new(0, 0, 0, totalHeight)
end

-- 10 saniyede bir liste yenile
while true do
    refreshPlayerList()
    wait(1)
end
