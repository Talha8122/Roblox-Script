local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local CoreGui = game:GetService("CoreGui")
local HttpService = game:GetService("HttpService")

-- Ana GUI
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "RemoteEventSender"
screenGui.ResetOnSpawn = false
screenGui.Parent = CoreGui

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 800, 0, 600)
mainFrame.Position = UDim2.new(0.5, -400, 0.5, -300)
mainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
mainFrame.BorderSizePixel = 0
mainFrame.Parent = screenGui
mainFrame.Active = true
mainFrame.Draggable = true
Instance.new("UICorner", mainFrame)

-- Başlık
local titleBar = Instance.new("Frame")
titleBar.Size = UDim2.new(1, 0, 0, 40)
titleBar.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
titleBar.Parent = mainFrame

local titleLabel = Instance.new("TextLabel")
titleLabel.Size = UDim2.new(1, -40, 1, 0)
titleLabel.Position = UDim2.new(0, 10, 0, 0)
titleLabel.BackgroundTransparency = 1
titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
titleLabel.Text = "🚀 Remote Event Sender"
titleLabel.Font = Enum.Font.GothamBold
titleLabel.TextSize = 18
titleLabel.TextXAlignment = Enum.TextXAlignment.Left
titleLabel.Parent = titleBar

local closeButton = Instance.new("TextButton")
closeButton.Size = UDim2.new(0, 30, 0, 30)
closeButton.Position = UDim2.new(1, -35, 0.5, -15)
closeButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
closeButton.TextColor3 = Color3.new(1, 1, 1)
closeButton.Text = "X"
closeButton.Font = Enum.Font.GothamBold
closeButton.TextSize = 16
closeButton.Parent = titleBar
Instance.new("UICorner", closeButton)

closeButton.MouseButton1Click:Connect(function()
    screenGui:Destroy()
end)

-- Ana içerik
local contentFrame = Instance.new("Frame")
contentFrame.Size = UDim2.new(1, -20, 1, -60)
contentFrame.Position = UDim2.new(0, 10, 0, 50)
contentFrame.BackgroundTransparency = 1
contentFrame.Parent = mainFrame

-- Kullanıcılar listesi
local usersLabel = Instance.new("TextLabel")
usersLabel.Size = UDim2.new(0.3, -10, 0, 30)
usersLabel.Position = UDim2.new(0, 0, 0, 0)
usersLabel.BackgroundTransparency = 1
usersLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
usersLabel.Text = "Kullanıcılar:"
usersLabel.Font = Enum.Font.GothamBold
usersLabel.TextSize = 16
usersLabel.TextXAlignment = Enum.TextXAlignment.Left
usersLabel.Parent = contentFrame

local usersScrolling = Instance.new("ScrollingFrame")
usersScrolling.Size = UDim2.new(0.3, -10, 0.8, -40)
usersScrolling.Position = UDim2.new(0, 0, 0, 35)
usersScrolling.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
usersScrolling.ScrollBarThickness = 6
usersScrolling.AutomaticCanvasSize = Enum.AutomaticSize.Y
usersScrolling.Parent = contentFrame
Instance.new("UICorner", usersScrolling)

local usersListLayout = Instance.new("UIListLayout")
usersListLayout.Parent = usersScrolling
usersListLayout.Padding = UDim.new(0, 5)

-- Event yazma label ve TextBox (seçmek yerine yazma)
local eventLabel = Instance.new("TextLabel")
eventLabel.Size = UDim2.new(0.3, -10, 0, 30)
eventLabel.Position = UDim2.new(0.35, 10, 0, 0)
eventLabel.BackgroundTransparency = 1
eventLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
eventLabel.Text = "Event (Yol olarak yazın):"
eventLabel.Font = Enum.Font.GothamBold
eventLabel.TextSize = 16
eventLabel.TextXAlignment = Enum.TextXAlignment.Left
eventLabel.Parent = contentFrame

local eventInput = Instance.new("TextBox")
eventInput.Size = UDim2.new(0.3, -10, 0.8, -40)
eventInput.Position = UDim2.new(0.35, 10, 0, 35)
eventInput.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
eventInput.TextColor3 = Color3.fromRGB(255, 255, 255)
eventInput.Font = Enum.Font.Gotham
eventInput.TextSize = 14
eventInput.TextWrapped = false
eventInput.PlaceholderText = "örnek: Folder1.MyEvent"
eventInput.TextXAlignment = Enum.TextXAlignment.Left
eventInput.TextYAlignment = Enum.TextYAlignment.Top
eventInput.ClearTextOnFocus = false
eventInput.Parent = contentFrame
Instance.new("UICorner", eventInput)

-- Veri girişi
local dataLabel = Instance.new("TextLabel")
dataLabel.Size = UDim2.new(0.3, -10, 0, 30)
dataLabel.Position = UDim2.new(0.7, 10, 0, 0)
dataLabel.BackgroundTransparency = 1
dataLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
dataLabel.Text = "Gönderilecek Veri:"
dataLabel.Font = Enum.Font.GothamBold
dataLabel.TextSize = 16
dataLabel.TextXAlignment = Enum.TextXAlignment.Left
dataLabel.Parent = contentFrame

local dataInput = Instance.new("TextBox")
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
dataInput.Parent = contentFrame
Instance.new("UICorner", dataInput)

-- Butonlar
local buttonsFrame = Instance.new("Frame")
buttonsFrame.Size = UDim2.new(1, 0, 0, 40)
buttonsFrame.Position = UDim2.new(0, 0, 0.85, 0)
buttonsFrame.BackgroundTransparency = 1
buttonsFrame.Parent = contentFrame

local refreshButton = Instance.new("TextButton")
refreshButton.Size = UDim2.new(0.2, 0, 1, 0)
refreshButton.Position = UDim2.new(0.1, 0, 0, 0)
refreshButton.BackgroundColor3 = Color3.fromRGB(70, 70, 90)
refreshButton.TextColor3 = Color3.fromRGB(255, 255, 255)
refreshButton.Text = "Yenile"
refreshButton.Font = Enum.Font.GothamBold
refreshButton.TextSize = 16
refreshButton.Parent = buttonsFrame
Instance.new("UICorner", refreshButton)

local sendButton = Instance.new("TextButton")
sendButton.Size = UDim2.new(0.2, 0, 1, 0)
sendButton.Position = UDim2.new(0.7, 0, 0, 0)
sendButton.BackgroundColor3 = Color3.fromRGB(50, 150, 50)
sendButton.TextColor3 = Color3.fromRGB(255, 255, 255)
sendButton.Text = "Gönder"
sendButton.Font = Enum.Font.GothamBold
sendButton.TextSize = 16
sendButton.Parent = buttonsFrame
Instance.new("UICorner", sendButton)

-- Seçim değişkenleri
local selectedPlayer = nil

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
        -- Tüm butonları sıfırla
        for _, child in ipairs(usersScrolling:GetChildren()) do
            if child:IsA("TextButton") then
                child.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
            end
        end
        -- Seçili butonu vurgula
        button.BackgroundColor3 = Color3.fromRGB(80, 80, 120)
    end)
end

-- Kullanıcı listesini yenileme
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

-- Veri gönderme
local function sendData()
    if not selectedPlayer then
        warn("Lütfen bir kullanıcı seçin!")
        return
    end

    local eventName = eventInput.Text
    if eventName == "" then
        warn("Lütfen bir event yazın!")
        return
    end

    local dataText = dataInput.Text
    local success, data = pcall(function()
        return HttpService:JSONDecode(dataText)
    end)
    if not success then
        data = dataText
    end

    local eventPath = eventName:split(".")
    local current = ReplicatedStorage
    for _, name in ipairs(eventPath) do
        current = current:FindFirstChild(name)
        if not current then break end
    end

    if current and current:IsA("RemoteEvent") then
        current:FireClient(selectedPlayer, data)
        print(string.format("[%s] kullanıcısına [%s] eventi gönderildi: %s",
            selectedPlayer.Name, eventName, tostring(data)))
    else
        warn("Event bulunamadı: " .. eventName)
    end
end

-- Buton bağlantıları
refreshButton.MouseButton1Click:Connect(function()
    refreshUsers()
end)

sendButton.MouseButton1Click:Connect(sendData)

-- Başlangıçta kullanıcı listesini doldur
refreshUsers()
