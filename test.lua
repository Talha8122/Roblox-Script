-- Event Deneyici Frame
local testFrame = Instance.new("Frame", frame)
testFrame.Size = UDim2.new(1, -20, 0, 150)
testFrame.Position = UDim2.new(0, 10, 1, -200)
testFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
testFrame.BorderSizePixel = 0
Instance.new("UICorner", testFrame).CornerRadius = UDim.new(0, 8)

local titleLabel = Instance.new("TextLabel", testFrame)
titleLabel.Size = UDim2.new(1, 0, 0, 30)
titleLabel.BackgroundTransparency = 1
titleLabel.Text = "🧪 RemoteEvent Test Aracı"
titleLabel.TextColor3 = Color3.new(1, 1, 1)
titleLabel.Font = Enum.Font.GothamBold
titleLabel.TextSize = 18

-- RemoteEvent adı girişi
local eventNameBox = Instance.new("TextBox", testFrame)
eventNameBox.PlaceholderText = "RemoteEvent tam ismi (ör. GameEvents.Misk.BanReceived)"
eventNameBox.Size = UDim2.new(1, -20, 0, 30)
eventNameBox.Position = UDim2.new(0, 10, 0, 40)
eventNameBox.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
eventNameBox.TextColor3 = Color3.new(1, 1, 1)
eventNameBox.Font = Enum.Font.Gotham
eventNameBox.TextSize = 16
eventNameBox.ClearTextOnFocus = false
Instance.new("UICorner", eventNameBox).CornerRadius = UDim.new(0, 6)

-- Veri girişi (string format)
local dataBox = Instance.new("TextBox", testFrame)
dataBox.PlaceholderText = "Payload (Lua tablosu ya da değerleri örn: {\"reason\", 9999})"
dataBox.Size = UDim2.new(1, -20, 0, 30)
dataBox.Position = UDim2.new(0, 10, 0, 80)
dataBox.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
dataBox.TextColor3 = Color3.new(1, 1, 1)
dataBox.Font = Enum.Font.Gotham
dataBox.TextSize = 16
dataBox.ClearTextOnFocus = false
Instance.new("UICorner", dataBox).CornerRadius = UDim.new(0, 6)

-- Gönder butonu
local sendButton = Instance.new("TextButton", testFrame)
sendButton.Size = UDim2.new(0.3, 0, 0, 30)
sendButton.Position = UDim2.new(0.35, 0, 0, 120)
sendButton.BackgroundColor3 = Color3.fromRGB(80, 170, 80)
sendButton.TextColor3 = Color3.new(1, 1, 1)
sendButton.Text = "Gönder"
sendButton.Font = Enum.Font.GothamBold
sendButton.TextSize = 16
Instance.new("UICorner", sendButton).CornerRadius = UDim.new(0, 6)

sendButton.MouseButton1Click:Connect(function()
    local eventName = eventNameBox.Text
    local payloadText = dataBox.Text
    
    if eventName == "" then
        warn("Lütfen RemoteEvent tam ismini girin.")
        return
    end

    -- Olası payload'u yüklemeye çalışalım (dikkat, eval tehlikeli ama burada kolaylık için kullanıyoruz)
    local success, payload = pcall(function()
        return load("return " .. payloadText)()
    end)
    
    if not success then
        warn("Payload Lua formatında değil veya hata var.")
        return
    end
    
    -- RemoteEvent objesini bulmaya çalış
    local parts = {}
    for part in string.gmatch(eventName, "[%w_]+") do
        table.insert(parts, part)
    end
    
    local obj = game
    for _, part in ipairs(parts) do
        obj = obj:FindFirstChild(part)
        if not obj then
            warn("RemoteEvent bulunamadı: " .. eventName)
            return
        end
    end
    
    -- FireServer varsa kullan, yoksa Fire
    if obj.FireServer then
        if type(payload) == "table" then
            obj:FireServer(table.unpack(payload))
        else
            obj:FireServer(payload)
        end
        print("FireServer gönderildi:", eventName, payloadText)
    elseif obj.Fire then
        if type(payload) == "table" then
            obj:Fire(table.unpack(payload))
        else
            obj:Fire(payload)
        end
        print("Fire gönderildi:", eventName, payloadText)
    else
        warn("Bu obje bir RemoteEvent ya da BindableEvent değil.")
    end
end)

