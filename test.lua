local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local CoreGui = game:GetService("CoreGui")
local HttpService = game:GetService("HttpService")

-- GUI oluşturma
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "RemoteEventSenderPro"
screenGui.ResetOnSpawn = false
screenGui.Parent = CoreGui

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 700, 0, 550)
mainFrame.Position = UDim2.new(0.5, -350, 0.5, -275)
mainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
mainFrame.BorderSizePixel = 0
mainFrame.Parent = screenGui
mainFrame.Active = true
mainFrame.Draggable = true
Instance.new("UICorner", mainFrame)

-- Başlık çubuğu
local titleBar = Instance.new("Frame")
titleBar.Size = UDim2.new(1, 0, 0, 40)
titleBar.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
titleBar.Parent = mainFrame

local titleLabel = Instance.new("TextLabel")
titleLabel.Size = UDim2.new(1, -100, 1, 0)
titleLabel.Position = UDim2.new(0, 10, 0, 0)
titleLabel.BackgroundTransparency = 1
titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
titleLabel.Text = "🚀 Remote Event Sender Pro"
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
usersLabel.Size = UDim2.new(0.3, -10, 0, 25)
usersLabel.Position = UDim2.new(0, 0, 0, 0)
usersLabel.BackgroundTransparency = 1
usersLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
usersLabel.Text = "Players:"
usersLabel.Font = Enum.Font.GothamBold
usersLabel.TextSize = 14
usersLabel.TextXAlignment = Enum.TextXAlignment.Left
usersLabel.Parent = contentFrame

local usersScrolling = Instance.new("ScrollingFrame")
usersScrolling.Size = UDim2.new(0.3, -10, 0.75, -40)
usersScrolling.Position = UDim2.new(0, 0, 0, 30)
usersScrolling.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
usersScrolling.ScrollBarThickness = 6
usersScrolling.AutomaticCanvasSize = Enum.AutomaticSize.Y
usersScrolling.Parent = contentFrame
Instance.new("UICorner", usersScrolling)

local usersListLayout = Instance.new("UIListLayout")
usersListLayout.Padding = UDim.new(0, 5)
usersListLayout.Parent = usersScrolling

-- Event input with hybrid selection
local eventsLabel = Instance.new("TextLabel")
eventsLabel.Size = UDim2.new(0.4, -10, 0, 25)
eventsLabel.Position = UDim2.new(0.32, 10, 0, 0)
eventsLabel.BackgroundTransparency = 1
eventsLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
eventsLabel.Text = "Remote Event:"
eventsLabel.Font = Enum.Font.GothamBold
eventsLabel.TextSize = 14
eventsLabel.TextXAlignment = Enum.TextXAlignment.Left
eventsLabel.Parent = contentFrame

local eventInput = Instance.new("TextBox")
eventInput.Size = UDim2.new(0.4, -10, 0, 30)
eventInput.Position = UDim2.new(0.32, 10, 0, 30)
eventInput.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
eventInput.TextColor3 = Color3.fromRGB(255, 255, 255)
eventInput.Font = Enum.Font.Gotham
eventInput.TextSize = 14
eventInput.PlaceholderText = "Type or select from list"
eventInput.ClearTextOnFocus = false
eventInput.Parent = contentFrame
Instance.new("UICorner", eventInput)

-- Event list (shows when typing)
local eventsScrolling = Instance.new("ScrollingFrame")
eventsScrolling.Size = UDim2.new(0.4, -10, 0.65, -45)
eventsScrolling.Position = UDim2.new(0.32, 10, 0, 65)
eventsScrolling.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
eventsScrolling.ScrollBarThickness = 6
eventsScrolling.AutomaticCanvasSize = Enum.AutomaticSize.Y
eventsScrolling.Visible = false
eventsScrolling.Parent = contentFrame
Instance.new("UICorner", eventsScrolling)

local eventsListLayout = Instance.new("UIListLayout")
eventsListLayout.Padding = UDim.new(0, 5)
eventsListLayout.Parent = eventsScrolling

-- Veri girişi
local dataLabel = Instance.new("TextLabel")
dataLabel.Size = UDim2.new(0.28, -10, 0, 25)
dataLabel.Position = UDim2.new(0.74, 10, 0, 0)
dataLabel.BackgroundTransparency = 1
dataLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
dataLabel.Text = "Data:"
dataLabel.Font = Enum.Font.GothamBold
dataLabel.TextSize = 14
dataLabel.TextXAlignment = Enum.TextXAlignment.Left
dataLabel.Parent = contentFrame

local dataInput = Instance.new("TextBox")
dataInput.Size = UDim2.new(0.28, -10, 0.75, -40)
dataInput.Position = UDim2.new(0.74, 10, 0, 30)
dataInput.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
dataInput.TextColor3 = Color3.fromRGB(255, 255, 255)
dataInput.Font = Enum.Font.Code
dataInput.TextSize = 14
dataInput.TextWrapped = true
dataInput.TextXAlignment = Enum.TextXAlignment.Left
dataInput.TextYAlignment = Enum.TextYAlignment.Top
dataInput.PlaceholderText = '{"key":"value"} or any value'
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
refreshButton.Text = "Refresh"
refreshButton.Font = Enum.Font.GothamBold
refreshButton.TextSize = 14
refreshButton.Parent = buttonsFrame
Instance.new("UICorner", refreshButton)

local sendButton = Instance.new("TextButton")
sendButton.Size = UDim2.new(0.2, 0, 1, 0)
sendButton.Position = UDim2.new(0.7, 0, 0, 0)
sendButton.BackgroundColor3 = Color3.fromRGB(50, 150, 50)
sendButton.TextColor3 = Color3.fromRGB(255, 255, 255)
sendButton.Text = "Send"
sendButton.Font = Enum.Font.GothamBold
sendButton.TextSize = 14
sendButton.Parent = buttonsFrame
Instance.new("UICorner", sendButton)

-- Variables
local selectedPlayer = nil
local remoteEventsCache = {}

-- Player button creation
local function createUserButton(player)
    local button = Instance.new("TextButton")
    button.Size = UDim2.new(1, -10, 0, 35)
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

-- Event button creation
local function createEventButton(eventName)
    local button = Instance.new("TextButton")
    button.Size = UDim2.new(1, -10, 0, 35)
    button.BackgroundColor3 = Color3.fromRGB(60, 80, 60)
    button.TextColor3 = Color3.fromRGB(255, 255, 255)
    button.Text = eventName
    button.Font = Enum.Font.Gotham
    button.TextSize = 14
    button.Parent = eventsScrolling
    Instance.new("UICorner", button)

    button.MouseButton1Click:Connect(function()
        eventInput.Text = eventName
        eventsScrolling.Visible = false
    end)
end

-- Refresh player list
local function refreshPlayers()
    for _, child in ipairs(usersScrolling:GetChildren()) do
        if child:IsA("TextButton") then
            child:Destroy()
        end
    end

    for _, player in ipairs(Players:GetPlayers()) do
        createUserButton(player)
    end
end

-- Scan and cache remote events
local function refreshEvents()
    remoteEventsCache = {}
    for _, child in ipairs(eventsScrolling:GetChildren()) do
        if child:IsA("TextButton") then
            child:Destroy()
        end
    end

    local function scanFolder(folder, path)
        for _, item in ipairs(folder:GetChildren()) do
            if item:IsA("RemoteEvent") then
                local fullPath = path .. item.Name
                table.insert(remoteEventsCache, fullPath)
                createEventButton(fullPath)
            elseif item:IsA("Folder") then
                scanFolder(item, path .. item.Name .. ".")
            end
        end
    end

    scanFolder(ReplicatedStorage, "")
end

-- Show matching event suggestions
local function showEventSuggestions(text)
    if text == "" then
        for _, child in ipairs(eventsScrolling:GetChildren()) do
            child.Visible = true
        end
        return
    end
    
    local textLower = string.lower(text)
    local anyVisible = false
    
    for _, child in ipairs(eventsScrolling:GetChildren()) do
        if child:IsA("TextButton") then
            if string.find(string.lower(child.Text), textLower, 1, true) then
                child.Visible = true
                anyVisible = true
            else
                child.Visible = false
            end
        end
    end
    
    eventsScrolling.Visible = anyVisible
end

-- Send data to player
local function sendData()
    if not selectedPlayer then
        warn("Please select a player first!")
        return
    end

    local eventPath = eventInput.Text
    if eventPath == "" then
        warn("Please enter a remote event path!")
        return
    end

    local dataText = dataInput.Text
    local success, data = pcall(function()
        return HttpService:JSONDecode(dataText)
    end)
    
    if not success then
        -- Try to evaluate as Lua code if not JSON
        success, data = pcall(loadstring("return "..dataText))
        if not success then
            data = dataText -- Fallback to raw string
        end
    end

    -- Find the remote event
    local pathParts = eventPath:split(".")
    local current = ReplicatedStorage
    for _, name in ipairs(pathParts) do
        current = current:FindFirstChild(name)
        if not current then break end
    end

    if current and current:IsA("RemoteEvent") then
        current:FireClient(selectedPlayer, data)
        print(string.format("Sent to [%s]: %s | Data: %s",
            selectedPlayer.Name, eventPath, HttpService:JSONEncode(data)))
    else
        warn("RemoteEvent not found: " .. eventPath)
    end
end

-- UI Connections
eventInput.Focused:Connect(function()
    eventsScrolling.Visible = true
    showEventSuggestions(eventInput.Text)
end)

eventInput.FocusLost:Connect(function()
    task.wait(0.2) -- Allow time for selection
    eventsScrolling.Visible = false
end)

eventInput:GetPropertyChangedSignal("Text"):Connect(function()
    showEventSuggestions(eventInput.Text)
end)

closeButton.MouseButton1Click:Connect(function()
    screenGui:Destroy()
end)

refreshButton.MouseButton1Click:Connect(function()
    refreshPlayers()
    refreshEvents()
end)

sendButton.MouseButton1Click:Connect(sendData)

-- Initialize
refreshPlayers()
refreshEvents()
