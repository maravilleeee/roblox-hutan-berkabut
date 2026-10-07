-- Model dengan tag "Ghost" (butuh Humanoid + PrimaryPart) berpatroli,
-- mengejar pemain yang dekat, dan mengembalikan pemain ke checkpoint kalau tertangkap.
local CollectionService = game:GetService("CollectionService")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Config = require(game.ReplicatedStorage.Shared.Config)
local Checkpoints = require(script.Parent.Checkpoints)

local G = Config.Ghost
local Ghosts = {}

local function nearestPlayer(root: BasePart)
	local best, bestDist = nil, math.huge
	for _, player in Players:GetPlayers() do
		local char = player.Character
		local hrp = char and char:FindFirstChild("HumanoidRootPart")
		local hum = char and char:FindFirstChildOfClass("Humanoid")
		if hrp and hum and hum.Health > 0 then
			local d = (hrp.Position - root.Position).Magnitude
			if d < bestDist then
				best, bestDist = player, d
			end
		end
	end
	return best, bestDist
end

local function sendBack(player: Player)
	local char = player.Character
	if not char then
		return
	end
	local cf = Checkpoints.GetSpawnCFrame(player)
	char:PivotTo(cf or CFrame.new(0, 10, 0))
end

local function runGhost(model: Model)
	local hum = model:FindFirstChildOfClass("Humanoid")
	local root = model.PrimaryPart
	if not hum or not root then
		warn("Ghost butuh Humanoid dan PrimaryPart: " .. model:GetFullName())
		return
	end
	local home = root.Position
	local chasing: Player? = nil
	local cooldownUntil = 0
	local nextPatrol = 0

	local conn
	conn = RunService.Heartbeat:Connect(function()
		if not model.Parent then
			conn:Disconnect()
			return
		end
		local now = os.clock()
		local player, dist = nearestPlayer(root)

		if chasing and (not player or player ~= chasing or dist > G.LoseRange) then
			chasing = nil
		end
		if not chasing and player and dist < G.DetectRange and now > cooldownUntil then
			chasing = player
		end

		if chasing then
			hum.WalkSpeed = G.ChaseSpeed
			local hrp = chasing.Character and chasing.Character:FindFirstChild("HumanoidRootPart")
			if hrp then
				hum:MoveTo(hrp.Position)
				if dist < G.CatchDistance then
					sendBack(chasing)
					chasing = nil
					cooldownUntil = now + 5 -- jeda supaya pemain sempat kabur
					hum:MoveTo(home)
				end
			end
		elseif now > nextPatrol then
			hum.WalkSpeed = G.PatrolSpeed
			local angle = math.random() * math.pi * 2
			local offset = Vector3.new(math.cos(angle), 0, math.sin(angle)) * math.random(5, G.PatrolRadius)
			hum:MoveTo(home + offset)
			nextPatrol = now + math.random(3, 6)
		end
	end)
end

function Ghosts.Init()
	for _, model in CollectionService:GetTagged(Config.Tags.Ghost) do
		task.spawn(runGhost, model)
	end
	CollectionService:GetInstanceAddedSignal(Config.Tags.Ghost):Connect(function(model)
		task.spawn(runGhost, model)
	end)
end

return Ghosts
