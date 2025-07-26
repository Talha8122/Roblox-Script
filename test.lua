local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local CoreGui = game:GetService("CoreGui")
local HttpService = game:GetService("HttpService")
local TextService = game:GetService("TextService")

-- Improved GUI with better organization and functionality
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "AdvancedRemoteEventSender"
screenGui.ResetOnSpawn = false
screenGui.Parent = CoreGui

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 650, 0, 500) -- More compact size
mainFrame.Position = UDim2.new(0.5, -325, 0.5, -250)
mainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
mainFrame.BorderSizePixel = 0
mainFrame.Parent = screenGui
mainFrame.Active = true
mainFrame.Draggable = true
Instance.new("UICorner", mainFrame).CornerRadius = UDim.new(0, 8)

-- Title Bar with minimize button
local titleBar = Instance.new("Frame")
titleBar.Size = UDim2.new(1, 0, 0, 40)
titleBar.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
titleBar.Parent = mainFrame
Instance.new("UICorner", titleBar).CornerRadius = UDim.new(0, 8)

local titleLabel = Instance.new("TextLabel")
titleLabel.Size = UDim2.new(1, -100, 1, 0)
titleLabel.Position = UDim2.new(0, 10, 0, 0)
titleLabel.BackgroundTransparency = 1
titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
titleLabel.Text = "🚀 Advanced Remote Event Sender"
titleLabel.Font = Enum.Font.GothamBold
titleLabel.TextSize = 16
titleLabel.TextXAlignment = Enum.TextXAlignment.Left
titleLabel.Parent = titleBar

-- Minimize Button
local minimizeButton = Instance.new("TextButton")
minimizeButton.Size = UDim2.new(0, 30, 0, 30)
minimizeButton.Position = UDim2.new(1, -70, 0.5, -15)
minimizeButton.BackgroundColor3 = Color3.fromRGB(100, 100, 120)
minimizeButton.TextColor3 = Color3.new(1, 1, 1)
minimizeButton.Text = "_"
minimizeButton.Font = Enum.Font.GothamBold
minimizeButton.TextSize = 16
minimizeButton.Parent = titleBar
Instance.new("UICorner", minimizeButton).CornerRadius = UDim.new(1, 0)

local closeButton = Instance.new("TextButton")
closeButton.Size = UDim2.new(0, 30, 0, 30)
closeButton.Position = UDim2.new(1, -35, 0.5, -15)
closeButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
closeButton.TextColor3 = Color3.new(1, 1, 1)
closeButton.Text = "X"
closeButton.Font = Enum.Font.GothamBold
closeButton.TextSize = 16
closeButton.Parent = titleBar
Instance.new("UICorner", closeButton).CornerRadius = UDim.new(1, 0)

-- Main content
local contentFrame = Instance.new("Frame")
contentFrame.Size = UDim2.new(1, -20, 1, -60)
contentFrame.Position = UDim2.new(0, 10, 0, 50)
contentFrame.BackgroundTransparency = 1
contentFrame.Parent = mainFrame

-- Players List with search functionality
local usersLabel = Instance.new("TextLabel")
usersLabel.Size = UDim2.new(0.3, -10, 0, 20)
usersLabel.Position = UDim2.new(0, 0, 0, 0)
usersLabel.BackgroundTransparency = 1
usersLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
usersLabel.Text = "Players:"
usersLabel.Font = Enum.Font.GothamBold
usersLabel.TextSize = 14
usersLabel.TextXAlignment = Enum.TextXAlignment.Left
usersLabel.Parent = contentFrame

local playerSearchBox = Instance.new("TextBox")
playerSearchBox.Size = UDim2.new(0.3, -10, 0, 25)
playerSearchBox.Position = UDim2.new(0, 0, 0, 25)
playerSearchBox.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
playerSearchBox.TextColor3 = Color3.fromRGB(255, 255, 255)
playerSearchBox.PlaceholderText = "Search players..."
playerSearchBox.Font = Enum.Font.Gotham
playerSearchBox.TextSize = 14
playerSearchBox.Parent = contentFrame
Instance.new("UICorner", playerSearchBox).CornerRadius = UDim.new(0, 4)

local usersScrolling = Instance.new("ScrollingFrame")
usersScrolling.Size = UDim2.new(0.3, -10, 0.7, -55)
usersScrolling.Position = UDim2.new(0, 0, 0, 55)
usersScrolling.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
usersScrolling.ScrollBarThickness = 6
usersScrolling.AutomaticCanvasSize = Enum.AutomaticSize.Y
usersScrolling.Parent = contentFrame
Instance.new("UICorner", usersScrolling).CornerRadius = UDim.new(0, 6)

local usersListLayout = Instance.new("UIListLayout")
usersListLayout.Parent = usersScrolling
usersListLayout.Padding = UDim.new(0, 5)

-- Remote Event Path Input with suggestions
local eventLabel = Instance.new("TextLabel")
eventLabel.Size = UDim2.new(0.4, -10, 0, 20)
eventLabel.Position = UDim2.new(0.32, 10, 0, 0)
eventLabel.BackgroundTransparency = 1
eventLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
eventLabel.Text = "Remote Event Path:"
eventLabel.Font = Enum.Font.GothamBold
eventLabel.TextSize = 14
eventLabel.TextXAlignment = Enum.TextXAlignment.Left
eventLabel.Parent = contentFrame

local eventInput = Instance.new("TextBox")
eventInput.Size = UDim2.new(0.4, -10, 0, 25)
eventInput.Position = UDim2.new(0.32, 10, 0, 25)
eventInput.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
eventInput.TextColor3 = Color3.fromRGB(255, 255, 255)
eventInput.Font = Enum.Font.Gotham
eventInput.TextSize = 14
eventInput.PlaceholderText = "e.g., Folder1.MyEvent"
eventInput.ClearTextOnFocus = false
eventInput.Parent = contentFrame
Instance.new("UICorner", eventInput).CornerRadius = UDim.new(0, 4)

-- Remote Event Suggestions
local eventSuggestions = Instance.new("ScrollingFrame")
eventSuggestions.Size = UDim2.new(0.4, -10, 0, 100)
eventSuggestions.Position = UDim2.new(0.32, 10, 0, 55)
eventSuggestions.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
eventSuggestions.ScrollBarThickness = 6
eventSuggestions.Visible = false
eventSuggestions.Parent = contentFrame
Instance.new("UICorner", eventSuggestions).CornerRadius = UDim.new(0, 6)

local suggestionsLayout = Instance.new("UIListLayout")
suggestionsLayout.Parent = eventSuggestions

-- Data Input with syntax highlighting
local dataLabel = Instance.new("TextLabel")
dataLabel.Size = UDim2.new(0.28, -10, 0, 20)
dataLabel.Position = UDim2.new(0.74, 10, 0, 0)
dataLabel.BackgroundTransparency = 1
dataLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
dataLabel.Text = "Data to Send:"
dataLabel.Font = Enum.Font.GothamBold
dataLabel.TextSize = 14
dataLabel.TextXAlignment = Enum.TextXAlignment.Left
dataLabel.Parent = contentFrame

local dataInput = Instance.new("TextBox")
dataInput.Size = UDim2.new(0.28, -10, 0.7, -55)
dataInput.Position = UDim2.new(0.74, 10, 0, 25)
dataInput.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
dataInput.TextColor3 = Color3.fromRGB(255, 255, 255)
dataInput.Font = Enum.Font.Code
dataInput.TextSize = 14
dataInput.TextWrapped = true
dataInput.TextXAlignment = Enum.TextXAlignment.Left
dataInput.TextYAlignment = Enum.TextYAlignment.Top
dataInput.PlaceholderText = '{"key": "value"} or "string"'
dataInput.Parent = contentFrame
Instance.new("UICorner", dataInput).CornerRadius = UDim.new(0, 6)

-- Buttons
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
Instance.new("UICorner", refreshButton).CornerRadius = UDim.new(0, 6)

local sendButton = Instance.new("TextButton")
sendButton.Size = UDim2.new(0.2, 0, 1, 0)
sendButton.Position = UDim2.new(0.7, 0, 0, 0)
sendButton.BackgroundColor3 = Color3.fromRGB(50, 150, 50)
sendButton.TextColor3 = Color3.fromRGB(255, 255, 255)
sendButton.Text = "Send"
sendButton.Font = Enum.Font.GothamBold
sendButton.TextSize = 14
sendButton.Parent = buttonsFrame
Instance.new("UICorner", sendButton).CornerRadius = UDim.new(0, 6)

-- Variables
local selectedPlayer = nil
local remoteEventsCache = {}

-- Player Button Creation
local function createUserButton(player)
    local button = Instance.new("TextButton")
    button.Size = UDim2.new(1, -10, 0, 30)
    button.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
    button.TextColor3 = Color3.fromRGB(255, 255, 255)
    button.Text = player.Name
    button.Font = Enum.Font.Gotham
    button.TextSize = 14
    button.Parent = usersScrolling
    Instance.new("UICorner", button).CornerRadius = UDim.new(0, 4)

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

-- Refresh Players with search filter
local function refreshUsers(searchTerm)
    for _, child in ipairs(usersScrolling:GetChildren()) do
        if child:IsA("TextButton") then
            child:Destroy()
        end
    end

    searchTerm = searchTerm and string.lower(searchTerm) or ""
    
    for _, player in ipairs(Players:GetPlayers()) do
        if searchTerm == "" or string.find(string.lower(player.Name), searchTerm, 1, true) then
            createUserButton(player)
        end
    end
end

-- Find all remote events and cache them
local function cacheRemoteEvents()
    remoteEventsCache = {}
    
    local function scanFolder(folder, path)
        for _, item in ipairs(folder:GetChildren()) do
            if item:IsA("RemoteEvent") then
                table.insert(remoteEventsCache, path .. item.Name)
            elseif item:IsA("Folder") then
                scanFolder(item, path .. item.Name .. ".")
            end
        end
    end
    
    scanFolder(ReplicatedStorage, "")
end

-- Show event suggestions
local function showEventSuggestions(text)
    eventSuggestions:ClearAllChildren()
    
    if text == "" then
        eventSuggestions.Visible = false
        return
    end
    
    local textLower = string.lower(text)
    local foundAny = false
    
    for _, eventPath in ipairs(remoteEventsCache) do
        if string.find(string.lower(eventPath), textLower, 1, true) then
            local suggestion = Instance.new("TextButton")
            suggestion.Size = UDim2.new(1, -10, 0, 30)
            suggestion.Position = UDim2.new(0, 5, 0, 0)
            suggestion.BackgroundColor3 = Color3.fromRGB(70, 70, 90)
            suggestion.TextColor3 = Color3.fromRGB(255, 255, 255)
            suggestion.Text = eventPath
            suggestion.Font = Enum.Font.Gotham
            suggestion.TextSize = 14
            suggestion.TextXAlignment = Enum.TextXAlignment.Left
            suggestion.Parent = eventSuggestions
            Instance.new("UICorner", suggestion).CornerRadius = UDim.new(0, 4)
            
            suggestion.MouseButton1Click:Connect(function()
                eventInput.Text = eventPath
                eventSuggestions.Visible = false
            end)
            
            foundAny = true
        end
    end
    
    eventSuggestions.Visible = foundAny
end

-- Send data to selected player
local function sendData()
    if not selectedPlayer then
        warn("Please select a player first!")
        return
    end

    local eventName = eventInput.Text
    if eventName == "" then
        warn("Please enter a remote event path!")
        return
    end

    local dataText = dataInput.Text
    local success, data = pcall(function()
        return HttpService:JSONDecode(dataText)
    end)
    
    if not success then
        -- If not JSON, try to interpret as Lua value
        success, data = pcall(loadstring("return " .. dataText))
        if not success then
            data = dataText -- Fall back to raw string
        end
    end

    local eventPath = eventName:split(".")
    local current = ReplicatedStorage
    for _, name in ipairs(eventPath) do
        current = current:FindFirstChild(name)
        if not current then break end
    end

    if current and current:IsA("RemoteEvent") then
        current:FireClient(selectedPlayer, data)
        print(string.format("Sent to [%s]: %s\nData: %s",
            selectedPlayer.Name, eventName, HttpService:JSONEncode(data)))
    else
        warn("RemoteEvent not found: " .. eventName)
    end
end

-- UI Connections
closeButton.MouseButton1Click:Connect(function()
    screenGui:Destroy()
end)

minimizeButton.MouseButton1Click:Connect(function()
    mainFrame.Visible = not mainFrame.Visible
    minimizeButton.Text = mainFrame.Visible and "_" or "+"
end)

playerSearchBox:GetPropertyChangedSignal("Text"):Connect(function()
    refreshUsers(playerSearchBox.Text)
end)

eventInput:GetPropertyChangedSignal("Text"):Connect(function()
    showEventSuggestions(eventInput.Text)
end)

eventInput.FocusLost:Connect(function()
    task.wait(0.2)
    eventSuggestions.Visible = false
end)

refreshButton.MouseButton1Click:Connect(function()
    refreshUsers(playerSearchBox.Text)
    cacheRemoteEvents()
end)

sendButton.MouseButton1Click:Connect(sendData)

-- Initialize
refreshUsers()
cacheRemoteEvents()
