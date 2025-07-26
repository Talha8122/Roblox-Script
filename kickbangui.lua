local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local CoreGui = game:GetService("CoreGui")
local HttpService = game:GetService("HttpService")

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "RemoteEventSenderMini"
screenGui.ResetOnSpawn = false
screenGui.Parent = CoreGui

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 300, 0, 300)
mainFrame.Position = UDim2.new(0.5, -150, 0.5, -150)
mainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.Parent = screenGui
Instance.new("UICorner", mainFrame)

local titleLabel = Instance.new("TextLabel")
titleLabel.Size = UDim2.new(1, 0, 0, 25)
titleLabel.Text = "🚀 Remote Event Sender"
titleLabel.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
titleLabel.Font = Enum.Font.GothamBold
titleLabel.TextSize = 12
titleLabel.Parent = mainFrame

local usersScrolling = Instance.new("ScrollingFrame")
usersScrolling.Size = UDim2.new(0.5, -5, 0.4, -5)
usersScrolling.Position = UDim2.new(0, 5, 0, 30)
usersScrolling.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
usersScrolling.ScrollBarThickness = 4
usersScrolling.Parent = mainFrame
Instance.new("UICorner", usersScrolling)

local eventsScrolling = Instance.new("ScrollingFrame")
eventsScrolling.Size = UDim2.new(0.5, -10, 0.4, -5)
eventsScrolling.Position = UDim2.new(0.5, 5, 0, 30)
eventsScrolling.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
eventsScrolling.ScrollBarThickness = 4
eventsScrolling.Parent = mainFrame
Instance.new("UICorner", eventsScrolling)

local usersLayout = Instance.new("UIListLayout", usersScrolling)
usersLayout.Padding = UDim.new(0, 2)
local eventsLayout = Instance.new("UIListLayout", eventsScrolling)
eventsLayout.Padding = UDim.new(0, 2)

local dataInput = Instance.new("TextBox")
dataInput.Size = UDim2.new(1, -10, 0, 60)
dataInput.Position = UDim2.new(0, 5, 0.42, 0)
dataInput.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
dataInput.TextColor3 = Color3.fromRGB(255, 255, 255)
dataInput.Text = ""
dataInput.PlaceholderText = "Veri: string ya da {\"key\":\"value\"}"
dataInput.TextWrapped = true
dataInput.TextYAlignment = Enum.TextYAlignment.Top
dataInput.Font = Enum.Font.Gotham
dataInput.TextSize = 12
dataInput.ClearTextOnFocus = false
dataInput.Parent = mainFrame
Instance.new("UICorner", dataInput)

local sendButton = Instance.new("TextButton")
sendButton.Size = UDim2.new(0.45, -5, 0, 30)
sendButton.Position = UDim2.new(0.05, 0, 1, -35)
sendButton.BackgroundColor3 = Color3.fromRGB(50, 150, 50)
sendButton.Text = "Gönder"
sendButton.Font = Enum.Font.GothamBold
sendButton.TextSize = 12
sendButton.TextColor3 = Color3.new(1,1,1)
sendButton.Parent = mainFrame
Instance.new("UICorner", sendButton)

local refreshButton = Instance.new("TextButton")
refreshButton.Size = UDim2.new(0.45, -5, 0, 30)
refreshButton.Position = UDim2.new(0.5, 5, 1, -35)
refreshButton.BackgroundColor3 = Color3.fromRGB(70, 70, 90)
refreshButton.Text = "Yenile"
refreshButton.Font = Enum.Font.GothamBold
refreshButton.TextSize = 12
refreshButton.TextColor3 = Color3.new(1,1,1)
refreshButton.Parent = mainFrame
Instance.new("UICorner", refreshButton)

-- Değişkenler
local selectedPlayer = nil
local selectedEvent = nil

local function createUserButton(player)
	local btn = Instance.new("TextButton")
	btn.Size = UDim2.new(1, -4, 0, 20)
	btn.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
	btn.TextColor3 = Color3.new(1, 1, 1)
	btn.Text = player.Name
	btn.Font = Enum.Font.Gotham
	btn.TextSize = 12
	btn.Parent = usersScrolling
	Instance.new("UICorner", btn)

	btn.MouseButton1Click:Connect(function()
		selectedPlayer = player
		for _, child in pairs(usersScrolling:GetChildren()) do
			if child:IsA("TextButton") then
				child.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
			end
		end
		btn.BackgroundColor3 = Color3.fromRGB(90, 90, 120)
	end)
end

local function createEventButton(path)
	local btn = Instance.new("TextButton")
	btn.Size = UDim2.new(1, -4, 0, 20)
	btn.BackgroundColor3 = Color3.fromRGB(60, 80, 60)
	btn.TextColor3 = Color3.new(1, 1, 1)
	btn.Text = path
	btn.Font = Enum.Font.Gotham
	btn.TextSize = 11
	btn.Parent = eventsScrolling
	Instance.new("UICorner", btn)

	btn.MouseButton1Click:Connect(function()
		selectedEvent = path
		for _, child in pairs(eventsScrolling:GetChildren()) do
			if child:IsA("TextButton") then
				child.BackgroundColor3 = Color3.fromRGB(60, 80, 60)
			end
		end
		btn.BackgroundColor3 = Color3.fromRGB(90, 120, 90)
	end)
end

local function refreshUsers()
	for _, v in ipairs(usersScrolling:GetChildren()) do
		if v:IsA("TextButton") then v:Destroy() end
	end
	for _, player in ipairs(Players:GetPlayers()) do
		createUserButton(player)
	end
end

local function refreshEvents()
	for _, v in ipairs(eventsScrolling:GetChildren()) do
		if v:IsA("TextButton") then v:Destroy() end
	end

	local function scan(folder, path)
		for _, item in ipairs(folder:GetChildren()) do
			if item:IsA("RemoteEvent") then
				local fullPath = path .. item.Name
				createEventButton(fullPath)
			elseif item:IsA("Folder") then
				scan(item, path .. item.Name .. ".")
			end
		end
	end

	scan(ReplicatedStorage, "")
end

local function sendData()
	if not selectedPlayer or not selectedEvent then return end
	local dataText = dataInput.Text
	local data
	local ok, result = pcall(function() return HttpService:JSONDecode(dataText) end)
	if ok then
		data = result
	else
		data = dataText
	end

	local pathParts = selectedEvent:split(".")
	local current = ReplicatedStorage
	for _, part in ipairs(pathParts) do
		current = current:FindFirstChild(part)
		if not current then return warn("Event bulunamadı!") end
	end

	if current and current:IsA("RemoteEvent") then
		current:FireClient(selectedPlayer, data)
		print(`{selectedPlayer.Name} oyuncusuna {selectedEvent} eventi gönderildi.`)
	end
end

refreshButton.MouseButton1Click:Connect(function()
	refreshUsers()
	refreshEvents()
end)

sendButton.MouseButton1Click:Connect(sendData)

-- Başlangıç
refreshUsers()
refreshEvents()
