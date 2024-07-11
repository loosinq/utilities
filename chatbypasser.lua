local ScreenGui = Instance.new("ScreenGui")
local Frame = Instance.new("Frame")
local ChatTextBox = Instance.new("TextBox")
local CloseButton = Instance.new("TextButton")

ScreenGui.Name = "ChatGui"
ScreenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")

Frame.Name = "MainFrame"
Frame.Parent = ScreenGui
Frame.BackgroundColor3 = Color3.new(0.5, 0.5, 0.5)
Frame.Position = UDim2.new(0.3, 0, 0.3, 0)
Frame.Size = UDim2.new(0.2, 0, 0.2, 0)
Frame.Active = true
Frame.Draggable = true

CloseButton.Name = "CloseButton"
CloseButton.Parent = Frame
CloseButton.BackgroundColor3 = Color3.new(1, 0, 0)
CloseButton.Position = UDim2.new(0.9, 0, 0, 0) -- Top right corner
CloseButton.Size = UDim2.new(0.1, 0, 0.1, 0)
CloseButton.Text = "X"

ChatTextBox.Name = "ChatTextBox"
ChatTextBox.Parent = Frame
ChatTextBox.BackgroundColor3 = Color3.new(1, 1, 1)
ChatTextBox.Position = UDim2.new(0.1, 0, 0.3, 0)
ChatTextBox.Size = UDim2.new(0.8, 0, 0.2, 0)
ChatTextBox.Text = ""
ChatTextBox.PlaceholderText = "Type your message here"

local transformations = {
    {"A", "А"}, {"B", "В"}, {"C", "С"}, {"D", "Đ"}, {"E", "Е"}, {"G", "Ǧ"},
    {"H", "Н"}, {"I", "I"}, {"K", "K"}, {"M", "М"}, {"O", "О"}, {"P", "Р"},
    {"R", "Ř"}, {"S", "Ș"}, {"T", "Т"}, {"X", "Х"}, {"Y", "У"}
}

local function transformMessage(message)
    for _, pair in ipairs(transformations) do
        message = message:gsub(pair[1], pair[2]):gsub(string.lower(pair[1]), string.lower(pair[2]))
    end
    return message
end

CloseButton.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)

local ReplicatedStorage = game:GetService("ReplicatedStorage")

ChatTextBox.FocusLost:Connect(function(enterPressed)
    if enterPressed and ChatTextBox.Text ~= "" then
        local transformedMessage = transformMessage(ChatTextBox.Text)
        ReplicatedStorage.DefaultChatSystemChatEvents.SayMessageRequest:FireServer(transformedMessage, "All")
        ChatTextBox.Text = ""
    end
end)

print("Number of transformations:", #transformations)
