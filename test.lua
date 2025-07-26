local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local HttpService = game:GetService("HttpService")
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- GUI oluştur
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "RemoteEventSender"
screenGui.ResetOnSpawn = false
screenGui.Parent = playerGui

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 800, 0, 600)
mainFrame.Position = UDim2.new(0.5, -400, 0.5, -300)
mainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
mainFrame.BorderSizePixel = 0
mainFrame.Parent = screenGui
mainFrame.Active = true
mainFrame.Draggable = true
Instance.new("UICorner", mainFrame)

-- Başlık çubuğu
local titleBar = Instance.new("Frame", mainFrame)
titleBar.Size = UDim2.new(1, 0, 0, 40)
titleBar.BackgroundColor3 = Color3.fromRGB(20, 20, 30)

local titleLabel = Instance.new("TextLabel", titleBar)
titleLabel.Size = UDim2.new(1, -40, 1, 0)
titleLabel.Position = UDim2.new(0, 10, 0, 0)
titleLabel.BackgroundTransparency = 1
titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
titleLabel.Text = "🚀 Remote Event Sender"
titleLabel.Font = Enum.Font.GothamBold
titleLabel.TextSize = 18
titleLabel.TextXAlignment = Enum.TextXAlignment.Left

local closeButton = Instance.new("TextButton", titleBar)
closeButton.Size = UDim2.new(0, 30, 0, 30)
closeButton.Position = UDim2.new(1, -35, 0.5, -15)
closeButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
closeButton.TextColor3 = Color3.new(1, 1, 1)
closeButton.Text = "X"
closeButton.Font = Enum.Font.GothamBold
closeButton.TextSize = 16
Instance.new("UICorner", closeButton)

closeButton.MouseButton1Click:Connect(function()
    screenGui:Destroy()
end)

-- İçerik çerçevesi
local contentFrame = Instance.new("Frame", mainFrame)
contentFrame.Size = UDim2.new(1, -20, 1, -60)
contentFrame.Position = UDim2.new(0, 10, 0, 50)
contentFrame.BackgroundTransparency = 1

-- Kullanıcılar listesi
local usersLabel = Instance.new("TextLabel", contentFrame)
usersLabel.Size = UDim2.new(0.3, -10, 0, 30)
usersLabel.Position = UDim2.new(0, 0, 0, 0)
usersLabel.BackgroundTransparency = 1
usersLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
usersLabel.Text = "Kullanıcılar:"
usersLabel.Font = Enum.Font.GothamBold
usersLabel.TextSize = 16
usersLabel.TextXAlignment = Enum.TextXAlignment.Left

local usersScrolling = Instance.new("ScrollingFrame", contentFrame)
usersScrolling.Size = UDim2.new(0.3, -10, 0.8, -40)
usersScrolling.Position = UDim2.new(0, 0, 0, 35)
usersScrolling.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
usersScrolling.ScrollBarThickness = 6
usersScrolling.AutomaticCanvasSize = Enum.AutomaticSize.Y
Instance.new("UICorner", usersScrolling)

local usersListLayout = Instance.new("UIListLayout", usersScrolling)
usersListLayout.Padding = UDim.new(0, 5)

-- Eventler listesi
local eventsLabel = Instance.new("TextLabel", contentFrame)
eventsLabel.Size = UDim2.new(0.3, -10, 0, 30)
eventsLabel.Position = UDim2.new(0.35, 10, 0, 0)
eventsLabel.BackgroundTransparency = 1
eventsLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
eventsLabel.Text = "Eventler:"
eventsLabel.Font = Enum.Font.GothamBold
eventsLabel.TextSize = 16
eventsLabel.TextXAlignment = Enum.TextXAlignment.Left

local eventsScrolling = Instance.new("ScrollingFrame", contentFrame)
eventsScrolling.Size = UDim2.new(0.3, -10, 0.8, -40)
eventsScrolling.Position = UDim2.new(0.35, 10, 0, 35)
eventsScrolling.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
eventsScrolling.ScrollBarThickness = 6
eventsScrolling.AutomaticCanvasSize = Enum.AutomaticSize.Y
Instance.new("UICorner", eventsScrolling)

local eventsListLayout = Instance.new("UIListLayout", eventsScrolling)
eventsListLayout.Padding = UDim.new(0, 5)

-- Veri girişi
local dataLabel = Instance.new("TextLabel", contentFrame)
dataLabel.Size = UDim2.new(0.3, -10, 0, 30)
dataLabel.Position = UDim2.new(0.7, 10, 0, 0)
dataLabel.BackgroundTransparency = 1
dataLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
dataLabel.Text = "Gönderilecek Veri:"
dataLabel.Font = Enum.Font.GothamBold
dataLabel.TextSize = 16
dataLabel.TextXAlignment = Enum.TextXAlignment.Left

local dataInput = Instance.new("TextBox", contentFrame)
dataInput.Size = UDim2.new(0.3, -10, 0.8, -40)
dataInput.Position = UDim2.new(0.7, 10, 0, 35)
dataInput.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
dataInput.TextColor3 = Color3.fromRGB(255, 255, 255)
dataInput.Font = Enum.Font.Gotham
dataInput.TextSize = 14
dataInput.TextWrapped = true
dataInput.TextXAlignment = Enum.TextXAlignment.Left
dataInput.TextYAlignment = Enum.TextYAlignment.Top
dataInput.PlaceholderText = '{"key": "value"} veya "string"'
Instance.new("UICorner", dataInput)

-- Butonlar çerçevesi
local buttonsFrame = Instance.new("Frame", contentFrame)
buttonsFrame.Size = UDim2.new(1, 0, 0, 40)
buttonsFrame.Position = UDim2.new(0, 0, 0.85, 0)
buttonsFrame.BackgroundTransparency = 1

local refreshButton = Instance.new("TextButton", buttonsFrame)
refreshButton.Size = UDim2.new(0.2, 0, 1, 0)
refreshButton.Position = UDim2.new(0.1, 0, 0, 0)
refreshButton.BackgroundColor3 = Color3.fromRGB(70, 70, 90)
refreshButton.TextColor3 = Color3.fromRGB(255, 255, 255)
refreshButton.Text = "Yenile"
refreshButton.Font = Enum.Font.GothamBold
refreshButton.TextSize = 16
Instance.new("UICorner", refreshButton)

local sendButton = Instance.new("TextButton", buttonsFrame)
sendButton.Size = UDim2.new(0.2, 0, 1, 0)
sendButton.Position = UDim2.new(0.7, 0, 0, 0)
sendButton.BackgroundColor3 = Color3.fromRGB(50, 150, 50)
sendButton.TextColor3 = Color3.fromRGB(255, 255, 255)
sendButton.Text = "Gönder"
sendButton.Font = Enum.Font.GothamBold
sendButton.TextSize = 16
Instance.new("UICorner", sendButton)

-- Seçim değişkenleri
local selectedPlayer = nil
local selectedEvent = nil

-- Kullanıcı butonu oluşturma
local function createUserButton(player)
    local button = Instance.new("TextButton")
    button.Size = UDim2.new(1, -10, 0, 40)
    button.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
    button.TextColor3 = Color3.fromRGB(255, 255, 255)
    button.Text = player.Name
    button.Font = Enum.Font.Gotham
    button.TextSize = 14
    button.Parent = usersScrolling
    Instance.new("UICorner", button)

    button.MouseButton1Click:Connect(function()
        selectedPlayer = player
        for _, child in ipairs(usersScrolling:GetChildren()) do
            if child:IsA("TextButton") then
                child.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
            end
        end
        button.BackgroundColor3 = Color3.fromRGB(80, 80, 120)
    end)
end

-- Event butonu oluşturma
local function createEventButton(eventName)
    local button = Instance.new("TextButton")
    button.Size = UDim2.new(1, -10, 0, 40)
    button.BackgroundColor3 = Color3.fromRGB(60, 80, 60)
    button.TextColor3 = Color3.fromRGB(255, 255, 255)
    button.Text = eventName
    button.Font = Enum.Font.Gotham
    button.TextSize = 14
    button.Parent = eventsScrolling
    Instance.new("UICorner", button)

    button.MouseButton1Click:Connect(function()
        selectedEvent = eventName
        for _, child in ipairs(eventsScrolling:GetChildren()) do
            if child:IsA("TextButton") then
                child.BackgroundColor3 = Color3.fromRGB(60, 80, 60)
            end
        end
        button.BackgroundColor3 = Color3.fromRGB(80, 120, 80)
    end)
end

-- Kullanıcı listesini yenile
local function refreshUsers()
    for _, child in ipairs(usersScrolling:GetChildren()) do
        if child:IsA("TextButton") then
            child:Destroy()
        end
    end
    for _, player in ipairs(Players:GetPlayers()) do
        createUserButton(player)
    end
end

-- Event listesini yenile
local function refreshEvents()
    for _, child in ipairs(eventsScrolling:GetChildren()) do
        if child:IsA("TextButton") then
            child:Destroy()
        end
    end

    local function scanFolder(folder, path)
        for _, item in ipairs(folder:GetChildren()) do
            if item:IsA("RemoteEvent") then
                createEventButton(path .. item.Name)
            elseif item:IsA("Folder") then
                scanFolder(item, path .. item.Name .. ".")
            end
        end
    end

    scanFolder(ReplicatedStorage, "")
end

-- Veri gönderme fonksiyonu
local function sendData()
    if not selectedPlayer then
        warn("Lütfen bir kullanıcı seçin!")
        return
    end
    if not selectedEvent then
        warn("Lütfen bir event seçin!")
        return
    end

    local dataText = dataInput.Text
    local success, data = pcall(function()
        return HttpService:JSONDecode(dataText)
    end)

    if not success then
        data = dataText
    end

    local eventPath = selectedEvent:split(".")
    local current = ReplicatedStorage
    for _, name in ipairs(eventPath) do
        current = current:FindFirstChild(name)
        if not current then break end
    end

    if current and current:IsA("RemoteEvent") then
        current:FireClient(selectedPlayer, data)
        print(string.format("[%s] kullanıcısına [%s] eventi gönderildi: %s",
            selectedPlayer.Name, selectedEvent, tostring(data)))
    else
        warn("Event bulunamadı: " .. selectedEvent)
    end
end

-- Buton bağlantıları
refreshButton.MouseButton1Click:Connect(function()
    refreshUsers()
    refreshEvents()
end)

sendButton.MouseButton1Click:Connect(sendData)

-- Başlangıçta listeyi doldur
refreshUsers()
refreshEvents()
