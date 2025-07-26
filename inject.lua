local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local CoreGui = game:GetService("CoreGui")

-- Ana GUI
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "FakeAdminGUI"
screenGui.ResetOnSpawn = false
screenGui.Parent = CoreGui

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 350, 0, 400)
mainFrame.Position = UDim2.new(0.5, -175, 0.5, -200)
mainFrame.BackgroundColor3 = Color3.fromRGB(30,30,30)
mainFrame.BorderSizePixel = 0
mainFrame.Parent = screenGui
mainFrame.Active = true
mainFrame.Draggable = true
Instance.new("UICorner", mainFrame)

local titleLabel = Instance.new("TextLabel")
titleLabel.Size = UDim2.new(1, 0, 0, 40)
titleLabel.BackgroundColor3 = Color3.fromRGB(20,20,20)
titleLabel.TextColor3 = Color3.fromRGB(255,255,255)
titleLabel.Text = "🔧 Admin Control Panel"
titleLabel.Font = Enum.Font.GothamBold
titleLabel.TextSize = 18
titleLabel.Parent = mainFrame

local scrollingFrame = Instance.new("ScrollingFrame")
scrollingFrame.Size = UDim2.new(1, -10, 1, -50)
scrollingFrame.Position = UDim2.new(0, 5, 0, 45)
scrollingFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
scrollingFrame.ScrollBarThickness = 6
scrollingFrame.BackgroundTransparency = 1
scrollingFrame.Parent = mainFrame

local listLayout = Instance.new("UIListLayout")
listLayout.Parent = scrollingFrame
listLayout.SortOrder = Enum.SortOrder.LayoutOrder
listLayout.Padding = UDim.new(0, 6)

-- Her oyuncu için butonlar oluştur
local function createPlayerEntry(player)
    local container = Instance.new("Frame")
    container.Size = UDim2.new(1, 0, 0, 40)
    container.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    container.Parent = scrollingFrame
    Instance.new("UICorner", container)

    local nameLabel = Instance.new("TextLabel")
    nameLabel.Size = UDim2.new(0.5, 0, 1, 0)
    nameLabel.Position = UDim2.new(0, 10, 0, 0)
    nameLabel.BackgroundTransparency = 1
    nameLabel.TextColor3 = Color3.fromRGB(255,255,255)
    nameLabel.Font = Enum.Font.Gotham
    nameLabel.TextSize = 16
    nameLabel.Text = player.Name
    nameLabel.TextXAlignment = Enum.TextXAlignment.Left
    nameLabel.Parent = container

    local kickButton = Instance.new("TextButton")
    kickButton.Size = UDim2.new(0.2, -10, 0.8, 0)
    kickButton.Position = UDim2.new(0.55, 0, 0.1, 0)
    kickButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
    kickButton.TextColor3 = Color3.new(1,1,1)
    kickButton.Font = Enum.Font.GothamBold
    kickButton.TextSize = 14
    kickButton.Text = "Kick"
    kickButton.Parent = container
    Instance.new("UICorner", kickButton)

    kickButton.MouseButton1Click:Connect(function()
        player:Kick("Admin tarafından atıldınız.")
    end)

    local banButton = Instance.new("TextButton")
    banButton.Size = UDim2.new(0.2, -10, 0.8, 0)
    banButton.Position = UDim2.new(0.8, 0, 0.1, 0)
    banButton.BackgroundColor3 = Color3.fromRGB(255, 180, 50)
    banButton.TextColor3 = Color3.new(1,1,1)
    banButton.Font = Enum.Font.GothamBold
    banButton.TextSize = 14
    banButton.Text = "Ban (Fake)"
    banButton.Parent = container
    Instance.new("UICorner", banButton)

    banButton.MouseButton1Click:Connect(function()
        screenGui:Destroy()
        LocalPlayer:Kick("Banlandınız. (Fake ban)")
    end)
end

local function refreshPlayerList()
    -- Önce eski listeleri temizle
    for _, child in ipairs(scrollingFrame:GetChildren()) do
        if child:IsA("Frame") then
            child:Destroy()
        end
    end

    -- Oyuncuları listele (Kendini hariç tutabilirsin)
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            createPlayerEntry(player)
        end
    end

    -- Scroll çerçevesinin içeriğini ayarla
    local totalHeight = 0
    for _, child in ipairs(scrollingFrame:GetChildren()) do
        if child:IsA("Frame") then
            totalHeight = totalHeight + child.Size.Y.Offset + listLayout.Padding.Offset
        end
    end
    scrollingFrame.CanvasSize = UDim2.new(0, 0, 0, totalHeight)
end

-- Başlangıçta listeyi doldur
refreshPlayerList()

-- 10 saniyede bir yenile
while true do
    task.wait(10)
    refreshPlayerList()
end
