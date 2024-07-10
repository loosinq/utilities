local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local UserInputService = game:GetService("UserInputService")

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "PlayerTeleportGui"
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 250, 0, 80)
MainFrame.Position = UDim2.new(1, -260, 0, 10)
MainFrame.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
MainFrame.BorderSizePixel = 0
MainFrame.Parent = ScreenGui

local TitleLabel = Instance.new("TextLabel")
TitleLabel.Size = UDim2.new(1, 0, 0, 40)
TitleLabel.Position = UDim2.new(0, 0, 0, 0)
TitleLabel.BackgroundColor3 = Color3.fromRGB(55, 55, 55)
TitleLabel.BorderSizePixel = 0
TitleLabel.Text = "Player Teleport"
TitleLabel.Font = Enum.Font.GothamSemibold
TitleLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
TitleLabel.TextSize = 20
TitleLabel.Parent = MainFrame

local CloseButton = Instance.new("TextButton")
CloseButton.Size = UDim2.new(0, 25, 0, 25)
CloseButton.Position = UDim2.new(1, -35, 0, 7)
CloseButton.BackgroundColor3 = Color3.fromRGB(255, 70, 70)
CloseButton.BorderSizePixel = 0
CloseButton.Text = "X"
CloseButton.Font = Enum.Font.GothamSemibold
CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseButton.TextSize = 18
CloseButton.Parent = MainFrame

local PlayerListFrame = Instance.new("Frame")
PlayerListFrame.Size = UDim2.new(1, -20, 1, -50)
PlayerListFrame.Position = UDim2.new(0, 10, 0, 45)
PlayerListFrame.BackgroundColor3 = Color3.fromRGB(55, 55, 55)
PlayerListFrame.BorderSizePixel = 0
PlayerListFrame.Parent = MainFrame

local PlayerListLayout = Instance.new("UIListLayout")
PlayerListLayout.Parent = PlayerListFrame
PlayerListLayout.SortOrder = Enum.SortOrder.LayoutOrder
PlayerListLayout.Padding = UDim.new(0, 5)

local function updateMainFrameSize()
    local playerButtonCount = 0
    for _, child in pairs(PlayerListFrame:GetChildren()) do
        if child:IsA("TextButton") then
            playerButtonCount = playerButtonCount + 1
        end
    end
    local newHeight = 80 + (playerButtonCount * 30)
    MainFrame.Size = UDim2.new(0, 250, 0, newHeight)
end

local function createPlayerButton(player)
    local PlayerButton = Instance.new("TextButton")
    PlayerButton.Size = UDim2.new(1, 0, 0, 25)
    PlayerButton.BackgroundColor3 = Color3.fromRGB(75, 75, 75)
    PlayerButton.BorderSizePixel = 0
    PlayerButton.Text = player.DisplayName
    PlayerButton.Font = Enum.Font.Gotham -- Change font
    PlayerButton.TextColor3 = Color3.fromRGB(200, 200, 200)
    PlayerButton.TextSize = 16
    PlayerButton.Parent = PlayerListFrame
    
    PlayerButton.MouseButton1Click:Connect(function()
        if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            LocalPlayer.Character:SetPrimaryPartCFrame(player.Character.HumanoidRootPart.CFrame)
        end
    end)
    
    updateMainFrameSize()
end

for _, player in pairs(Players:GetPlayers()) do
    createPlayerButton(player)
end

Players.PlayerAdded:Connect(function(player)
    createPlayerButton(player)
end)

Players.PlayerRemoving:Connect(function(player)
    for _, button in pairs(PlayerListFrame:GetChildren()) do
        if button:IsA("TextButton") and button.Text == player.DisplayName then
            button:Destroy()
        end
    end
    updateMainFrameSize()
end)

updateMainFrameSize()

CloseButton.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)

ScreenGui.ResetOnSpawn = false

local dragging = false
local dragInput
local dragStart
local startPos

local function updateInput(input)
    local delta = input.Position - dragStart
    MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
end

MainFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = MainFrame.Position
        
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

MainFrame.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement then
        dragInput = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if dragging and input == dragInput then
        updateInput(input)
    end
end)
