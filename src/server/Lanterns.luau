-- Kumpulkan semua lentera (tag "Lantern") untuk menang.
local CollectionService = game:GetService("CollectionService")
local Players = game:GetService("Players")
local Config = require(game.ReplicatedStorage.Shared.Config)

local Lanterns = {}
local collected: { [Player]: number } = {}

local function setupLeaderstats(player: Player)
	local stats = Instance.new("Folder")
	stats.Name = "leaderstats"
	local value = Instance.new("IntValue")
	value.Name = "Lentera"
	value.Parent = stats
	stats.Parent = player
end

local function hookLantern(part: BasePart)
	local taken: { [Player]: boolean } = {}
	part.Touched:Connect(function(hit)
		local player = Players:GetPlayerFromCharacter(hit.Parent)
		if not player or taken[player] then
			return
		end
		taken[player] = true
		collected[player] = (collected[player] or 0) + 1
		local stats = player:FindFirstChild("leaderstats")
		if stats then
			stats.Lentera.Value = collected[player]
		end
		part.Transparency = 0.8 -- lentera tetap terlihat redup untuk pemain lain
		if collected[player] >= Config.LanternsToWin then
			print(player.Name .. " menang! Semua lentera terkumpul.")
			-- TODO: tampilkan layar kemenangan
		end
	end)
end

function Lanterns.Init()
	Players.PlayerAdded:Connect(setupLeaderstats)
	for _, player in Players:GetPlayers() do
		setupLeaderstats(player)
	end
	for _, part in CollectionService:GetTagged(Config.Tags.Lantern) do
		hookLantern(part)
	end
	CollectionService:GetInstanceAddedSignal(Config.Tags.Lantern):Connect(hookLantern)
	Players.PlayerRemoving:Connect(function(player)
		collected[player] = nil
	end)
end

return Lanterns
