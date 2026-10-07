-- Part dengan tag "Checkpoint" menyimpan titik respawn pemain.
local CollectionService = game:GetService("CollectionService")
local Players = game:GetService("Players")
local Config = require(game.ReplicatedStorage.Shared.Config)

local Checkpoints = {}
local lastCheckpoint: { [Player]: BasePart } = {}

function Checkpoints.GetSpawnCFrame(player: Player): CFrame?
	local part = lastCheckpoint[player]
	if part and part.Parent then
		return part.CFrame + Vector3.new(0, 4, 0)
	end
	return nil
end

local function hookCheckpoint(part: BasePart)
	part.Touched:Connect(function(hit)
		local player = Players:GetPlayerFromCharacter(hit.Parent)
		if player and lastCheckpoint[player] ~= part then
			lastCheckpoint[player] = part
			part.Color = Color3.fromRGB(255, 220, 120)
		end
	end)
end

function Checkpoints.Init()
	for _, part in CollectionService:GetTagged(Config.Tags.Checkpoint) do
		hookCheckpoint(part)
	end
	CollectionService:GetInstanceAddedSignal(Config.Tags.Checkpoint):Connect(hookCheckpoint)

	Players.PlayerRemoving:Connect(function(player)
		lastCheckpoint[player] = nil
	end)

	-- Respawn di checkpoint terakhir
	Players.PlayerAdded:Connect(function(player)
		player.CharacterAdded:Connect(function(character)
			local cf = Checkpoints.GetSpawnCFrame(player)
			if cf then
				character:PivotTo(cf)
			end
		end)
	end)
end

return Checkpoints
