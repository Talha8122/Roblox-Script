local ReplicatedStorage = game:GetService("ReplicatedStorage")
local CoreGui = game:GetService("CoreGui")

local gui = Instance.new("ScreenGui")
gui.Name = "EventFinderGui"
gui.ResetOnSpawn = false
gui.Parent = CoreGui

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 800, 0, 600)
frame.Position = UDim2.new(0.5, -400, 0.5, -300)
frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
frame.BorderSizePixel = 0
frame.Active = true
frame.Draggable = true
Instance.new("UICorner", frame)

local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1, 0, 0, 40)
title.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
title.Text = "ReplicatedStorage Event Bulucu"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.Font = Enum.Font.GothamBold
title.TextSize = 22

local listFrame = Instance.new("ScrollingFrame", frame)
listFrame.Size = UDim2.new(0, 350, 1, -50)
listFrame.Position = UDim2.new(0, 20, 0, 50)
listFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
listFrame.BorderSizePixel = 0
listFrame.ScrollBarThickness = 6
local listLayout = Instance.new("UIListLayout", listFrame)
listLayout.SortOrder = Enum.SortOrder.LayoutOrder
listLayout.Padding = UDim.new(0, 5)

local selectedLabel = Instance.new("TextLabel", frame)
selectedLabel.Size = UDim2.new(0, 400, 0, 40)
selectedLabel.Position = UDim2.new(0, 400, 0, 60)
selectedLabel.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
selectedLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
selectedLabel.Font = Enum.Font.GothamBold
selectedLabel.TextSize = 18
selectedLabel.Text = "Seçilen Event: Yok"
selectedLabel.TextWrapped = true

local fireBtn = Instance.new("TextButton", frame)
fireBtn.Size = UDim2.new(0, 200, 0, 40)
fireBtn.Position = UDim2.new(0, 400, 0, 110)
fireBtn.Text = "Event'i Sunucuya Gönder"
fireBtn.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
fireBtn.TextColor3 = Color3.new(1,1,1)
fireBtn.Font = Enum.Font.GothamBold
fireBtn.TextSize = 18
fireBtn.Visible = false

local selectedEventName = nil

local function trimReplicatedStoragePrefix(name)
    -- Eğer isim "ReplicatedStorage." ile başlıyorsa onu kes
    local prefix = "ReplicatedStorage."
    if string.sub(name, 1, #prefix) == prefix then
        return string.sub(name, #prefix + 1)
    else
        return name
    end
end

local function populateEventList()
    for _, child in pairs(listFrame:GetChildren()) do
        if child:IsA("TextButton") then
            child:Destroy()
        end
    end

    for _, obj in pairs(ReplicatedStorage:GetChildren()) do
        if obj:IsA("RemoteEvent") or obj:IsA("RemoteFunction") then
            local displayName = trimReplicatedStoragePrefix("ReplicatedStorage." .. obj.Name)
            
            local btn = Instance.new("TextButton")
            btn.Size = UDim2.new(1, -10, 0, 35)
            btn.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
            btn.TextColor3 = Color3.fromRGB(255, 255, 255)
            btn.Font = Enum.Font.Gotham
            btn.TextSize = 16
            btn.Text = displayName
            btn.Parent = listFrame

            btn.MouseButton1Click:Connect(function()
                selectedEventName = obj.Name
                selectedLabel.Text = "Seçilen Event: " .. obj.Name
                fireBtn.Visible = true
            end)
        end
    end
end

fireBtn.MouseButton1Click:Connect(function()
    if selectedEventName then
        local eventToFire = ReplicatedStorage:FindFirstChild(selectedEventName)
        if eventToFire and eventToFire:IsA("RemoteEvent") then
            eventToFire:FireServer()
            print("Event tetiklendi: " .. selectedEventName)
        else
            warn("Seçilen event bulunamadı veya RemoteEvent değil.")
        end
    end
end)

populateEventList()
