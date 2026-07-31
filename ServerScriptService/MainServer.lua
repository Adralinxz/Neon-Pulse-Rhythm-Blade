// Server-side systems for Neon Pulse: Rhythm Blade
-- Handles player data, currency, upgrades, and leaderboards

local Players = game:GetService("Players")
local DataStoreService = game:GetService("DataStoreService")
local RunService = game:GetService("RunService")

-- Data stores
local playerDataStore = DataStoreService:GetDataStore("PlayerDataV1")
local leaderboardStore = DataStoreService:GetOrderedDataStore("GlobalLeaderboard")

-- Configuration
local STARTING_CREDITS = 0
local SAVE_INTERVAL = 60 -- seconds

-- Player data structure
local function createDefaultPlayerData()
	return {
		Credits = STARTING_CREDITS,
		TotalCreditsEarned = STARTING_CREDITS,
		BestStreak = 0,
		HighestStrike = 0,
		Upgrades = {
			DamageMultiplier = 1,
			ChargeSpeed = 1,
			AutoCharger = 0,
			CreditBoost = 1,
			IdleGain = 0
		},
		Cosmetics = {
			BladeColor = "Default",
			HiltStyle = "Standard",
			TrailEffect = "Basic"
		},
		Prestige = 0,
		PrestigePoints = 0
	}
end

-- Player data storage
local playerData = {}

-- Load player data
local function loadPlayerData(player)
	local success, data = pcall(function()
		return playerDataStore:GetAsync(tostring(player.UserId))
	end)
	
	if success and data then
		playerData[player] = data
	else
		playerData[player] = createDefaultPlayerData()
	end
	
	-- Set up leaderstats
	local leaderstats = Instance.new("Folder")
	leaderstats.Name = "leaderstats"
	leaderstats.Parent = player
	
	local credits = Instance.new("IntValue")
	credits.Name = "Credits"
	credits.Value = playerData[player].Credits
	credits.Parent = leaderstats
	
	local totalCredits = Instance.new("IntValue")
	totalCredits.Name = "TotalCreditsEarned"
	totalCredits.Value = playerData[player].TotalCreditsEarned
	totalCredits.Parent = leaderstats
	
	local bestStreak = Instance.new("IntValue")
	bestStreak.Name = "BestStreak"
	bestStreak.Value = playerData[player].BestStreak
	bestStreak.Parent = leaderstats
	
	local highestStrike = Instance.new("IntValue")
	highestStrike.Name = "HighestStrike"
	highestStrike.Value = playerData[player].HighestStrike
	highestStrike.Parent = leaderstats
end

-- Save player data
local function savePlayerData(player)
	if not playerData[player] then return end
	
	local success, err = pcall(function()
		playerDataStore:SetAsync(tostring(player.UserId), playerData[player])
	end)
	
	if not success then
		warn("Failed to save data for "..player.Name..": "..tostring(err))
	end
end

-- Auto-save loop
spawn(function()
	while true do
		wait(SAVE_INTERVAL)
		for player, data in pairs(playerData) do
			if player and player.Parent then
				savePlayerData(player)
			end
		end
	end
end)

-- Player added/removed
Players.PlayerAdded:Connect(function(player)
	loadPlayerData(player)
end)

Players.PlayerRemoving:Connect(function(player)
	if playerData[player] then
		savePlayerData(player)
		playerData[player] = nil
	end
end)

-- Remote Events for gameplay
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local bladeStrikeEvent = Instance.new("RemoteEvent")
bladeStrikeEvent.Name = "BladeStrike"
bladeStrikeEvent.Parent = ReplicatedStorage

local purchaseUpgradeEvent = Instance.new("RemoteEvent")
purchaseUpgradeEvent.Name = "PurchaseUpgrade"
purchaseUpgradeEvent.Parent = ReplicatedStorage

local purchaseCosmeticEvent = Instance.new("RemoteEvent")
purchaseCosmeticEvent.Name = "PurchaseCosmetic"
purchaseCosmeticEvent.Parent = ReplicatedStorage

-- Handle blade strike (award credits)
bladeStrikeEvent.OnServerEvent:Connect(function(player, chargeLevel)
	if not playerData[player] then return end
	
	local baseCredits = math.floor(10 * chargeLevel) -- Base 10 credits at full charge
	local creditMultiplier = playerData[player].Upgrades.CreditBoost
	local finalCredits = math.floor(baseCredits * creditMultiplier)
	
	-- Apply idle gain bonus if equipped
	if playerData[player].Upgrades.IdleGain > 0 then
		finalCredits = math.floor(finalCredits * (1 + playerData[player].Upgrades.IdleGain))
	end
	
	if finalCredits > 0 then
		playerData[player].Credits = playerData[player].Credits + finalCredits
		playerData[player].TotalCreditsEarned = playerData[player].TotalCreditsEarned + finalCredits
		
		-- Update leaderstats
		local leaderstats = player:FindFirstChild("leaderstats")
		if leaderstats then
			local credits = leaderstats:FindFirstChild("Credits")
			if credits then credits.Value = playerData[player].Credits end
			
			local totalCredits = leaderstats:FindFirstChild("TotalCreditsEarned")
			if totalCredits then totalCredits.Value = playerData[player].TotalCreditsEarned end
		end
		
		-- Update strike tracking
		local strikeDamage = math.floor(50 * chargeLevel) * playerData[player].Upgrades.DamageMultiplier
		if strikeDamage > playerData[player].HighestStrike then
			playerData[player].HighestStrike = strikeDamage
			
			local leaderstats = player:FindFirstChild("leaderstats")
			if leaderstats then
				local highestStrike = leaderstats:FindFirstChild("HighestStrike")
				if highestStrike then highestStrike.Value = strikeDamage end
			end
		end
		
		-- Update leaderboard
		leaderboardStore:SetAsync(tostring(player.UserId), playerData[player].TotalCreditsEarned)
	end
end)

-- Handle upgrade purchases
purchaseUpgradeEvent.OnServerEvent:Connect(function(player, upgradeType)
	if not playerData[player] then return end
	
	local upgradeCosts = {
		DamageMultiplier = {100, 500, 1500, 5000, 15000},
		ChargeSpeed = {150, 750, 2000, 6000, 18000},
		AutoCharger = {200, 1000, 3000, 9000, 27000},
		CreditBoost = {120, 600, 1800, 5400, 16200},
		IdleGain = {500, 2000, 6000, 18000, 54000}
	}
	
	local currentLevel = playerData[player].Upgrades[upgradeType] or 0
	if currentLevel >= 5 then
		return -- Max level reached
	end
	
	local cost = upgradeCosts[upgradeType][currentLevel + 1]
	if playerData[player].Credits >= cost then
		playerData[player].Credits = playerData[player].Credits - cost
		playerData[player].Upgrades[upgradeType] = currentLevel + 1
		
		-- Update leaderstats
		local leaderstats = player:FindFirstChild("leaderstats")
		if leaderstats then
			local credits = leaderstats:FindFirstChild("Credits")
			if credits then credits.Value = playerData[player].Credits end
		end
		
		-- Confirm purchase
		local purchaseEvent = Instance.new("RemoteEvent")
		purchaseEvent.Name = "UpgradePurchased"
		purchaseEvent.Parent = ReplicatedStorage
		purchaseEvent:FireClient(player, upgradeType, currentLevel + 1)
	end
end)

-- Auto-credit generation (for idle gain)
spawn(function()
	while true do
		wait(1) -- Check every second
		for player, data in pairs(playerData) do
			if data.Upgrades.IdleGain > 0 then
				local idleGain = math.floor(data.Upgrades.IdleGain * 10) -- 10 credits per second per level
				if idleGain > 0 then
					data.Credits = data.Credits + idleGain
					data.TotalCreditsEarned = data.TotalCreditsEarned + idleGain
					
					-- Update leaderstats
					local leaderstats = player:FindFirstChild("leaderstats")
					if leaderstats then
						local credits = leaderstats:FindFirstChild("Credits")
						if credits then credits.Value = data.Credits end
						
						local totalCredits = leaderstats:FindFirstChild("TotalCreditsEarned")
						if totalCredits then totalCredits.Value = data.TotalCreditsEarned end
					end
				end
			end
		end
	end
end)

-- Auto-charger (passive charge when not equipped)
spawn(function()
	while true do
		wait(0.1)
		for player, data in pairs(playerData) do
			if data.Upgrades.AutoCharger > 0 then
				-- This would typically be handled client-side when tool is equipped
				-- For now, we'll just note it's available
			end
		end
	end
end)

print("Neon Pulse: Rhythm Blade server systems initialized")
