local Players = game:GetService("Players")

local Checkpoints = require(script.Checkpoints)
local Lanterns = require(script.Lanterns)
local Ghosts = require(script.Ghosts)

Checkpoints.Init()
Lanterns.Init()
Ghosts.Init()

Players.PlayerAdded:Connect(function(player)
	print(player.Name .. " masuk ke Hutan Berkabut")
end)
