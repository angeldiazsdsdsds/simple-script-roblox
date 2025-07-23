local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local localPlayer = Players.LocalPlayer

-- Create ScreenGui
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "AngelsHub"
ScreenGui.Parent = localPlayer:WaitForChild("PlayerGui")

-- Main Frame
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 450, 0, 320)
MainFrame.Position = UDim2.new(0.3, 0, 0.3, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
MainFrame.BorderSizePixel = 0
MainFrame.Parent = ScreenGui
MainFrame.Active = true
MainFrame.Draggable = true

-- Title Bar
local TitleBar = Instance.new("Frame")
TitleBar.Size = UDim2.new(1, 0, 0, 30)
TitleBar.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
TitleBar.Parent = MainFrame

-- Title Label
local TitleLabel = Instance.new("TextLabel")
TitleLabel.Size = UDim2.new(1, -70, 1, 0)
TitleLabel.Position = UDim2.new(0, 10, 0, 0)
TitleLabel.Text = "Angel's Hub"
TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
TitleLabel.BackgroundTransparency = 1
TitleLabel.Font = Enum.Font.SourceSansBold
TitleLabel.TextSize = 18
TitleLabel.Parent = TitleBar

-- Minimize Button
local MinimizeButton = Instance.new("TextButton")
MinimizeButton.Size = UDim2.new(0, 30, 1, 0)
MinimizeButton.Position = UDim2.new(1, -35, 0, 0)
MinimizeButton.Text = "-"
MinimizeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
MinimizeButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
MinimizeButton.Parent = TitleBar

-- Close Button
local CloseButton = Instance.new("TextButton")
CloseButton.Size = UDim2.new(0, 30, 1, 0)
CloseButton.Position = UDim2.new(1, -65, 0, 0)
CloseButton.Text = "X"
CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseButton.BackgroundColor3 = Color3.fromRGB(180, 50, 50)
CloseButton.Parent = TitleBar

-- Side Panel for Tabs
local SidePanel = Instance.new("Frame")
SidePanel.Size = UDim2.new(0, 100, 1, -30)
SidePanel.Position = UDim2.new(0, 0, 0, 30)
SidePanel.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
SidePanel.Parent = MainFrame

-- Content Frame
local ContentFrame = Instance.new("Frame")
ContentFrame.Size = UDim2.new(1, -100, 1, -30)
ContentFrame.Position = UDim2.new(0, 100, 0, 30)
ContentFrame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
ContentFrame.Parent = MainFrame

-- Tabs Setup
local tabs = {}
local currentTab

local tabNames = {"Visuals", "Player", "PvP"}

local function createTab(name, posY)
	local tabButton = Instance.new("TextButton")
	tabButton.Size = UDim2.new(1, 0, 0, 40)
	tabButton.Position = UDim2.new(0, 0, 0, posY)
	tabButton.Text = name
	tabButton.TextColor3 = Color3.fromRGB(255, 255, 255)
	tabButton.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
	tabButton.Parent = SidePanel

	local tabFrame = Instance.new("Frame")
	tabFrame.Size = UDim2.new(1, 0, 1, 0)
	tabFrame.Position = UDim2.new(0, 0, 0, 0)
	tabFrame.BackgroundTransparency = 1
	tabFrame.Visible = false
	tabFrame.Parent = ContentFrame

	tabButton.MouseButton1Click:Connect(function()
		if currentTab then
			currentTab.Visible = false
		end
		tabFrame.Visible = true
		currentTab = tabFrame
	end)

	tabs[name] = tabFrame
	return tabFrame
end

local tabFrames = {}
for i, name in ipairs(tabNames) do
	tabFrames[name] = createTab(name, (i - 1) * 40)
end

-- Show first tab by default
tabFrames["Visuals"].Visible = true
currentTab = tabFrames["Visuals"]

------------------
-- VISUALS TAB ESP (Optimized with tool role detection)
------------------

local espFolder = Instance.new("Folder")
espFolder.Name = "ESP"
espFolder.Parent = game.CoreGui

local espEnabled = false
local espObjects = {}  -- store per player ESP objects

local espToggleBtn = Instance.new("TextButton")
espToggleBtn.Size = UDim2.new(0, 150, 0, 40)
espToggleBtn.Position = UDim2.new(0, 10, 0, 50)
espToggleBtn.Text = "Toggle ESP: OFF"
espToggleBtn.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
espToggleBtn.TextColor3 = Color3.new(1, 1, 1)
espToggleBtn.Parent = tabFrames["Visuals"]

local function getRoleByTool(player)
    local char = player.Character
    if not char then return "Innocent" end
    for _, tool in ipairs(char:GetChildren()) do
        if tool:IsA("Tool") then
            local toolName = tool.Name:lower()
            if toolName:find("knife") or toolName:find("murder") then
                return "Murderer"
            elseif toolName:find("gun") or toolName:find("pistol") or toolName:find("revolver") then
                return "Sheriff"
            end
        end
    end
    return "Innocent"
end

local function createESP(player)
    if espObjects[player] then return end
    
    local char = player.Character
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    local head = char:FindFirstChild("Head")
    if not hrp or not head then return end
    
    local box = Instance.new("BoxHandleAdornment")
    box.Name = player.Name
    box.Adornee = hrp
    box.AlwaysOnTop = true
    box.ZIndex = 10
    box.Transparency = 0.6
    box.Size = Vector3.new(4, 6, 1)
    box.Parent = espFolder
    
    local billboard = Instance.new("BillboardGui")
    billboard.Name = player.Name .. "_Billboard"
    billboard.Adornee = head
    billboard.AlwaysOnTop = true
    billboard.Size = UDim2.new(0, 100, 0, 40)
    billboard.StudsOffset = Vector3.new(0, 2, 0)
    billboard.Parent = espFolder
    
    local nameLabel = Instance.new("TextLabel")
    nameLabel.Size = UDim2.new(1, 0, 1, 0)
    nameLabel.BackgroundTransparency = 1
    nameLabel.TextStrokeTransparency = 0
    nameLabel.Text = player.Name
    nameLabel.Font = Enum.Font.SourceSansBold
    nameLabel.TextSize = 16
    nameLabel.Parent = billboard
    
    local role = getRoleByTool(player)
    
    if role == "Murderer" then
        box.Color3 = Color3.fromRGB(255, 0, 0)
        nameLabel.TextColor3 = Color3.fromRGB(255, 0, 0)
    elseif role == "Sheriff" then
        box.Color3 = Color3.fromRGB(0, 0, 255)
        nameLabel.TextColor3 = Color3.fromRGB(0, 0, 255)
    else
        box.Color3 = Color3.fromRGB(0, 255, 0)
        nameLabel.TextColor3 = Color3.fromRGB(0, 255, 0)
    end
    
    espObjects[player] = {box = box, billboard = billboard}
end

local function removeESP(player)
    if espObjects[player] then
        for _, obj in pairs(espObjects[player]) do
            obj:Destroy()
        end
        espObjects[player] = nil
    end
end

local function clearAllESP()
    for player, _ in pairs(espObjects) do
        removeESP(player)
    end
end

local function updateAllESP()
    if not espEnabled then return end
    for _, player in pairs(Players:GetPlayers()) do
        if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            createESP(player)
        else
            removeESP(player)
        end
    end
end

espToggleBtn.MouseButton1Click:Connect(function()
    espEnabled = not espEnabled
    espToggleBtn.Text = "Toggle ESP: " .. (espEnabled and "ON" or "OFF")
    if espEnabled then
        updateAllESP()
    else
        clearAllESP()
    end
end)

Players.PlayerAdded:Connect(function(player)
    if espEnabled then
        player.CharacterAdded:Connect(function()
            createESP(player)
        end)
    end
end)

Players.PlayerRemoving:Connect(function(player)
    removeESP(player)
end)

------------------
-- PLAYER TAB CONTENT (Speed + Fly + Teleport + Noclip + Teleport to Spawn + Teleport Point)
------------------

local playerTab = tabFrames["Player"]

-- Speed UI
local speedBox = Instance.new("TextBox")
speedBox.Size = UDim2.new(0, 100, 0, 30)
speedBox.Position = UDim2.new(0, 10, 0, 10)
speedBox.PlaceholderText = "Speed"
speedBox.Text = ""
speedBox.Parent = playerTab

local setSpeedBtn = Instance.new("TextButton")
setSpeedBtn.Size = UDim2.new(0, 100, 0, 30)
setSpeedBtn.Position = UDim2.new(0, 120, 0, 10)
setSpeedBtn.Text = "Set Speed"
setSpeedBtn.Parent = playerTab

setSpeedBtn.MouseButton1Click:Connect(function()
	local speed = tonumber(speedBox.Text)
	local char = localPlayer.Character
	if char and char:FindFirstChild("Humanoid") and speed then
		char.Humanoid.WalkSpeed = speed
	end
end)

-- Fly Button
local flyBtn = Instance.new("TextButton")
flyBtn.Size = UDim2.new(0, 100, 0, 30)
flyBtn.Position = UDim2.new(0, 10, 0, 50)
flyBtn.Text = "Fly"
flyBtn.Parent = playerTab

local flying = false
local velocity

flyBtn.MouseButton1Click:Connect(function()
	local char = localPlayer.Character or localPlayer.CharacterAdded:Wait()
	local humanoidRoot = char:WaitForChild("HumanoidRootPart")

	flying = not flying

	if flying then
		velocity = Instance.new("BodyVelocity")
		velocity.Name = "FlyVelocity"
		velocity.MaxForce = Vector3.new(1e5, 1e5, 1e5)
		velocity.Velocity = Vector3.new(0, 0, 0)
		velocity.P = 1250
		velocity.Parent = humanoidRoot

		local direction = { w = false, a = false, s = false, d = false }

		local inputBeganConn
		local inputEndedConn
		local flyLoop

		inputBeganConn = UIS.InputBegan:Connect(function(input)
			if input.KeyCode == Enum.KeyCode.W then direction.w = true end
			if input.KeyCode == Enum.KeyCode.A then direction.a = true end
			if input.KeyCode == Enum.KeyCode.S then direction.s = true end
			if input.KeyCode == Enum.KeyCode.D then direction.d = true end
		end)

		inputEndedConn = UIS.InputEnded:Connect(function(input)
			if input.KeyCode == Enum.KeyCode.W then direction.w = false end
			if input.KeyCode == Enum.KeyCode.A then direction.a = false end
			if input.KeyCode == Enum.KeyCode.S then direction.s = false end
			if input.KeyCode == Enum.KeyCode.D then direction.d = false end
		end)

		flyLoop = RunService.RenderStepped:Connect(function()
			if not flying then
				flyLoop:Disconnect()
				inputBeganConn:Disconnect()
				inputEndedConn:Disconnect()
				if velocity then
					velocity:Destroy()
				end
				return
			end

			local moveVec = Vector3.new(
				(direction.d and 1 or 0) - (direction.a and 1 or 0),
				0,
				(direction.s and 1 or 0) - (direction.w and 1 or 0)
			)

			moveVec = workspace.CurrentCamera.CFrame:VectorToWorldSpace(moveVec)

			if moveVec.Magnitude > 0 then
				velocity.Velocity = moveVec.Unit * 50
			else
				velocity.Velocity = Vector3.new(0, 0, 0)
			end
		end)
	else
		if velocity then
			velocity:Destroy()
		end
	end
end)

-- Noclip Button with continuous disabling collisions
local noclipBtn = Instance.new("TextButton")
noclipBtn.Size = UDim2.new(0, 100, 0, 30)
noclipBtn.Position = UDim2.new(0, 120, 0, 50)
noclipBtn.Text = "Noclip: OFF"
noclipBtn.Parent = playerTab

local noclipEnabled = false
local noclipLoop

noclipBtn.MouseButton1Click:Connect(function()
    noclipEnabled = not noclipEnabled
    noclipBtn.Text = "Noclip: " .. (noclipEnabled and "ON" or "OFF")

    if noclipEnabled then
        -- Disable collisions every frame
        noclipLoop = RunService.RenderStepped:Connect(function()
            local char = localPlayer.Character
            if char then
                for _, part in ipairs(char:GetChildren()) do
                    if part:IsA("BasePart") then
                        part.CanCollide = false
                    end
                end
            end
        end)
    else
        if noclipLoop then
            noclipLoop:Disconnect()
            noclipLoop = nil
        end
    end
end)

-- Teleport to Player UI
local tpLabel = Instance.new("TextLabel")
tpLabel.Text = "Teleport to Player:"
tpLabel.Size = UDim2.new(0, 200, 0, 20)
tpLabel.Position = UDim2.new(0, 10, 0, 90)
tpLabel.TextColor3 = Color3.new(1, 1, 1)
tpLabel.BackgroundTransparency = 1
tpLabel.Parent = playerTab

local playerDropdown = Instance.new("TextBox")
player
