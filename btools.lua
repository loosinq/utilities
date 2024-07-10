local Players = game:GetService("Players")
local player = Players.LocalPlayer

local function giveBTools(player)
  
    local copyTool = Instance.new("HopperBin")
    copyTool.BinType = Enum.BinType.Clone
    copyTool.Parent = player.Backpack

    local deleteTool = Instance.new("HopperBin")
    deleteTool.BinType = Enum.BinType.Hammer
    deleteTool.Parent = player.Backpack

    local moveTool = Instance.new("HopperBin")
    moveTool.BinType = Enum.BinType.Grab
    moveTool.Parent = player.Backpack
end

player.CharacterAdded:Connect(function()
    giveBTools(player)
end)

if player.Character then
    giveBTools(player)
end
