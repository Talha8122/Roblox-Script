local ReplicatedStorage = game:GetService("ReplicatedStorage")
local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "AdvancedRemoteFinderGui"
screenGui.ResetOnSpawn = false
screenGui.Parent = CoreGui

local frame = Instance.new("Frame", screenGui)
frame.Size = UDim2.new(0.6, 0, 0, 650) -- Genişlik %60, yükseklik 650px
frame.Position = UDim2.new(0.2, 0, 0.5, -325) -- Ekranın ortasında
frame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
frame.BorderSizePixel = 0
frame.Active = true
frame.Draggable = true
Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 8)

-- Başlık çubuğu
local titleBar = Instance.new("Frame", frame)
titleBar.Size = UDim2.new(1, 0, 0, 50)
titleBar.Position = UDim2.new(0, 0, 0, 0)
titleBar.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
titleBar.BorderSizePixel = 0
Instance.new("UICorner", titleBar).CornerRadius = UDim.new(0, 8)

local title = Instance.new("TextLabel", titleBar)
title.Size = UDim2.new(1, -100, 1, 0)
title.Position = UDim2.new(0, 10, 0, 0)
title.BackgroundTransparency = 1
title.TextColor3 = Color3.new(1, 1, 1)
title.Text = "🔍 Advanced Remote Finder"
title.Font = Enum.Font.GothamBold
title.TextSize = 24
title.TextXAlignment = Enum.TextXAlignment.Left

-- Kapatma butonu
local closeButton = Instance.new("TextButton", titleBar)
closeButton.Size = UDim2.new(0, 40, 0, 40)
closeButton.Position = UDim2.new(1, -45, 0.5, -20)
closeButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
closeButton.TextColor3 = Color3.new(1, 1, 1)
closeButton.Text = "X"
closeButton.Font = Enum.Font.GothamBold
closeButton.TextSize = 18
Instance.new("UICorner", closeButton).CornerRadius = UDim.new(1, 0)

closeButton.MouseButton1Click:Connect(function()
    screenGui:Destroy()
end)

-- Arama çubuğu
local searchFrame = Instance.new("Frame", frame)
searchFrame.Size = UDim2.new(1, -20, 0, 50)
searchFrame.Position = UDim2.new(0, 10, 0, 55)
searchFrame.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
searchFrame.BorderSizePixel = 0
Instance.new("UICorner", searchFrame).CornerRadius = UDim.new(0, 6)

local searchBox = Instance.new("TextBox", searchFrame)
searchBox.Size = UDim2.new(1, -20, 0.8, 0)
searchBox.Position = UDim2.new(0, 10, 0.1, 0)
searchBox.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
searchBox.TextColor3 = Color3.new(1, 1, 1)
searchBox.PlaceholderText = "Arama yapın..."
searchBox.PlaceholderColor3 = Color3.fromRGB(180, 180, 180)
searchBox.Font = Enum.Font.Gotham
searchBox.TextSize = 16
searchBox.ClearTextOnFocus = false
searchBox.Text = ""
Instance.new("UICorner", searchBox).CornerRadius = UDim.new(0, 4)

local searchIcon = Instance.new("TextLabel", searchBox)
searchIcon.Size = UDim2.new(0, 30, 1, 0)
searchIcon.Position = UDim2.new(1, -35, 0, 0)
searchIcon.BackgroundTransparency = 1
searchIcon.Text = "🔍"
searchIcon.TextColor3 = Color3.new(1, 1, 1)
searchIcon.Font = Enum.Font.Gotham
searchIcon.TextSize = 16
searchIcon.TextXAlignment = Enum.TextXAlignment.Right

-- Liste çerçevesi
local scrollingFrame = Instance.new("ScrollingFrame", frame)
scrollingFrame.Size = UDim2.new(1, -20, 1, -130)
scrollingFrame.Position = UDim2.new(0, 10, 0, 115)
scrollingFrame.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
scrollingFrame.BorderSizePixel = 0
scrollingFrame.ScrollBarThickness = 8
scrollingFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
Instance.new("UICorner", scrollingFrame).CornerRadius = UDim.new(0, 6)

local layout = Instance.new("UIListLayout", scrollingFrame)
layout.Padding = UDim.new(0, 8)
layout.SortOrder = Enum.SortOrder.LayoutOrder

-- Remote verilerini saklamak için tablo
local remoteData = {}

local function getRelativePath(obj)
    local fullPath = obj:GetFullName()
    return string.gsub(fullPath, "^ReplicatedStorage%.", "")
end

local function createRemoteLabel(remoteType, path)
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -15, 0, 40)
    label.BackgroundColor3 = remoteType == "RemoteEvent" and Color3.fromRGB(70, 130, 180) or Color3.fromRGB(180, 130, 70)
    label.TextColor3 = Color3.new(1, 1, 1)
    label.Text = string.format("[%s]  %s", remoteType, path)
    label.Font = Enum.Font.Gotham
    label.TextSize = 16
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.BorderSizePixel = 0
    label.Parent = scrollingFrame
    Instance.new("UICorner", label).CornerRadius = UDim.new(0, 4)
    
    -- Kopyalama butonu
    local copyButton = Instance.new("TextButton", label)
    copyButton.Size = UDim2.new(0, 80, 0.8, 0)
    copyButton.Position = UDim2.new(1, -85, 0.1, 0)
    copyButton.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
    copyButton.TextColor3 = Color3.new(1, 1, 1)
    copyButton.Text = "Kopyala"
    copyButton.Font = Enum.Font.GothamMedium
    copyButton.TextSize = 14
    Instance.new("UICorner", copyButton).CornerRadius = UDim.new(0, 4)
    
    copyButton.MouseButton1Click:Connect(function()
        setclipboard(path)
        copyButton.Text = "Kopyalandı!"
        task.wait(1)
        copyButton.Text = "Kopyala"
    end)
    
    return label
end

local function filterRemotes(searchText)
    for _, child in pairs(scrollingFrame:GetChildren()) do
        if child:IsA("TextLabel") then
            child:Destroy()
        end
    end
    
    local searchLower = string.lower(searchText or "")
    
    for _, data in pairs(remoteData) do
        local pathLower = string.lower(data.path)
        if searchText == "" or string.find(pathLower, searchLower, 1, true) then
            createRemoteLabel(data.type, data.path)
        end
    end
end

local function scanRemoteObjects(parent)
    remoteData = {}
    
    local function recurse(obj)
        for _, child in pairs(obj:GetChildren()) do
            if child:IsA("RemoteEvent") or child:IsA("RemoteFunction") then
                table.insert(remoteData, {
                    type = child.ClassName,
                    path = getRelativePath(child),
                    object = child
                })
            end
            recurse(child)
        end
    end
    
    recurse(parent)
    filterRemotes(searchBox.Text)
end

-- Arama kutusu dinleyicisi
searchBox:GetPropertyChangedSignal("Text"):Connect(function()
    filterRemotes(searchBox.Text)
end)

-- Yenileme butonu
local refreshButton = Instance.new("TextButton", frame)
refreshButton.Size = UDim2.new(0.2, 0, 0, 40)
refreshButton.Position = UDim2.new(0.4, 0, 1, -45)
refreshButton.BackgroundColor3 = Color3.fromRGB(65, 105, 225)
refreshButton.TextColor3 = Color3.new(1, 1, 1)
refreshButton.Text = "Yenile"
refreshButton.Font = Enum.Font.GothamBold
refreshButton.TextSize = 16
Instance.new("UICorner", refreshButton).CornerRadius = UDim.new(0, 6)

refreshButton.MouseButton1Click:Connect(function()
    scanRemoteObjects(ReplicatedStorage)
end)

-- Başlangıç taraması
scanRemoteObjects(ReplicatedStorage)
