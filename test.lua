local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "ToolRemoverGUI"
screenGui.ResetOnSpawn = false
screenGui.IgnoreGuiInset = true
screenGui.Parent = CoreGui

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 300, 0, 400)
mainFrame.Position = UDim2.new(0, 0, 0.5, -200)
mainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
mainFrame.BorderSizePixel = 0
mainFrame.Active = true
mainFrame.Draggable = false
mainFrame.Parent = screenGui
Instance.new("UICorner", mainFrame)

local titleLabel = Instance.new("TextLabel")
titleLabel.Size = UDim2.new(1, 0, 0, 40)
titleLabel.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
titleLabel.Text = "isnone weapon remover beta"
titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
titleLabel.Font = Enum.Font.SourceSansBold
titleLabel.TextSize = 20
titleLabel.Parent = mainFrame

local scrollingFrame = Instance.new("ScrollingFrame")
scrollingFrame.Size = UDim2.new(1, -10, 1, -50)
scrollingFrame.Position = UDim2.new(0, 5, 0, 45)
scrollingFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
scrollingFrame.ScrollBarThickness = 8
scrollingFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
scrollingFrame.BorderSizePixel = 0
scrollingFrame.Parent = mainFrame

local listLayout = Instance.new("UIListLayout")
listLayout.Padding = UDim.new(0, 5)
listLayout.Parent = scrollingFrame

local dragging = false
local dragStart, startPos

mainFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = mainFrame.Position

        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
        local delta = input.Position - dragStart
        mainFrame.Position = UDim2.new(
            startPos.X.Scale,
            startPos.X.Offset + delta.X,
            startPos.Y.Scale,
            startPos.Y.Offset + delta.Y
        )
    end
end)

local function createToolButton(tool, player)
    local button = Instance.new("TextButton")
    button.Size = UDim2.new(1, -10, 0, 30)
    button.Text = player.Name .. " - " .. tool.Name
    button.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
    button.TextColor3 = Color3.fromRGB(255, 255, 255)
    button.Font = Enum.Font.SourceSans
    button.TextSize = 18

    button.MouseButton1Click:Connect(function()
        if tool and tool.Parent then
            local remote = tool:FindFirstChild("ClientEvent")
            if remote then
                remote:FireServer("BanReceived", {
                    reason = "Exploit",
                    duration = 30
                })
            end
        end
    end)

    button.Parent = scrollingFrame
end

local function populateTools()
    for _, child in pairs(scrollingFrame:GetChildren()) do
        if child:IsA("TextButton") then
            child:Destroy()
        end
    end

    for _, player in pairs(Players:GetPlayers()) do
        if player:FindFirstChild("Backpack") then
            for _, tool in pairs(player.Backpack:GetChildren()) do
                if tool:IsA("Tool") and (tool.Name == "Knife" or tool.Name == "Revolver") then
                    createToolButton(tool, player)
                end
            end
        end

        local char = player.Character
        if char then
            for _, tool in pairs(char:GetDescendants()) do
                if tool:IsA("Tool") and (tool.Name == "Knife" or tool.Name == "Revolver") then
                    createToolButton(tool, player)
                end
            end
        end
    end

    task.wait()
    local totalHeight = 0
    for _, button in pairs(scrollingFrame:GetChildren()) do
        if button:IsA("TextButton") then
            totalHeight += button.Size.Y.Offset + listLayout.Padding.Offset
        end
    end
    scrollingFrame.CanvasSize = UDim2.new(0, 0, 0, totalHeight)
end

for _, player in pairs(Players:GetPlayers()) do
    if player:FindFirstChild("Backpack") then
        player.Backpack.ChildAdded:Connect(populateTools)
        player.Backpack.ChildRemoved:Connect(populateTools)
    end
end

task.spawn(function()
    while true do
        populateTools()
        wait(0.5)
    end
end)
