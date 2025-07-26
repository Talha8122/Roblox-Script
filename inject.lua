local ReplicatedStorage = game:GetService("ReplicatedStorage")
local CoreGui = game:GetService("CoreGui")

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "RemoteEventFinderGui"
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
title.Text = "🔍 Remote Event & Function Bulucu"
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
layout.Padding = UDim.new(0, 6)
layout.SortOrder = Enum.SortOrder.LayoutOrder

local function listRemoteObjects(parent)
    -- Temizle
    for _, child in pairs(scrollingFrame:GetChildren()) do
        if child:IsA("TextLabel") then
            child:Destroy()
        end
    end

    local function recurse(obj)
        for _, child in pairs(obj:GetChildren()) do
            if child:IsA("RemoteEvent") then
                local label = Instance.new("TextLabel")
                label.Size = UDim2.new(1, -10, 0, 25)
                label.BackgroundColor3 = Color3.fromRGB(70, 130, 180) -- RemoteEvent: mavi
                label.TextColor3 = Color3.new(1, 1, 1)
                label.Text = "[RemoteEvent] " .. child:GetFullName()
                label.Font = Enum.Font.Gotham
                label.TextSize = 14
                label.Parent = scrollingFrame
            elseif child:IsA("RemoteFunction") then
                local label = Instance.new("TextLabel")
                label.Size = UDim2.new(1, -10, 0, 25)
                label.BackgroundColor3 = Color3.fromRGB(180, 130, 70) -- RemoteFunction: turuncu
                label.TextColor3 = Color3.new(1, 1, 1)
                label.Text = "[RemoteFunction] " .. child:GetFullName()
                label.Font = Enum.Font.Gotham
                label.TextSize = 14
                label.Parent = scrollingFrame
            end

            recurse(child) -- Alt objelere bak
        end
    end

    recurse(parent)
end

listRemoteObjects(ReplicatedStorage)

-- İstersen başka parentlar da eklenebilir:
-- Örneğin: game:GetService("StarterPlayer").StarterPlayerScripts, game:GetService("Players").LocalPlayer.PlayerGui, vb.

