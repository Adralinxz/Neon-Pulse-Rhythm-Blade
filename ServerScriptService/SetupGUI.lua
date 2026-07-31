// ServerScriptService/SetupGUI.lua
-- Script to create GUI elements in StarterGui
-- This runs when the server starts

local StarterGui = game:GetService("StarterGui")

-- Remove existing GUIs if they exist (to avoid duplicates on reload)
local existingUpgrade = StarterGui:FindFirstChild("UpgradeGui")
if existingUpgrade then
	existingUpgrade:Destroy()
end
local existingLeaderboard = StarterGui:FindFirstChild("LeaderboardGui")
if existingLeaderboard then
	existingLeaderboard:Destroy()
end

-- Create UpgradeGui
local upgradeGui = Instance.new("ScreenGui")
upgradeGui.Name = "UpgradeGui"
upgradeGui.ResetOnSpawn = false
upgradeGui.Parent = StarterGui

-- Main frame for upgrade GUI
local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 400, 0, 500)
mainFrame.Position = UDim2.new(0.5, -200, 0.5, -250)
mainFrame.BackgroundColor3 = Color3.new(0.1, 0.1, 0.2)
mainFrame.BackgroundTransparency = 0.2
mainFrame.BorderSizePixel = 0
mainFrame.Parent = upgradeGui

-- Title label
local titleLabel = Instance.new("TextLabel")
titleLabel.Name = "TitleLabel"
titleLabel.Size = UDim2.new(1, 0, 0, 50)
titleLabel.Position = UDim2.new(0, 0, 0, 0)
titleLabel.BackgroundTransparency = 1
titleLabel.Text = "Neuro Upgrade Lab"
titleLabel.Font = Enum.Font.SourceSansBold
titleLabel.TextSize = 24
titleLabel.TextColor3 = Color3.new(0, 0.8, 1)
titleLabel.Parent = mainFrame

-- Credits frame
local creditsFrame = Instance.new("Frame")
creditsFrame.Name = "CreditsFrame"
creditsFrame.Size = UDim2.new(1, -20, 0, 40)
creditsFrame.Position = UDim2.new(0, 10, 0, 60)
creditsFrame.BackgroundColor3 = Color3.new(0, 0.2, 0.4)
creditsFrame.BackgroundTransparency = 0.5
creditsFrame.BorderSizePixel = 0
creditsFrame.Parent = mainFrame

local creditsIcon = Instance.new("ImageLabel")
creditsIcon.Name = "CreditsIcon"
creditsIcon.Size = UDim2.new(0, 30, 0, 30)
creditsIcon.Position = UDim2.new(0, 10, 0.5, -15)
creditsIcon.BackgroundTransparency = 1
creditsIcon.Image = "rbxassetid://1234567890" -- Placeholder for credit icon
creditsIcon.Parent = creditsFrame

local creditsLabel = Instance.new("TextLabel")
creditsLabel.Name = "CreditsLabel"
creditsLabel.Size = UDim2.new(1, -50, 1, 0)
creditsLabel.Position = UDim2.new(0, 50, 0, 0)
creditsLabel.BackgroundTransparency = 1
creditsLabel.Text = "Credits: 0"
creditsLabel.Font = Enum.Font.SourceSansBold
creditsLabel.TextSize = 18
creditsLabel.TextColor3 = Color3.new(0, 0.8, 1)
creditsLabel.Parent = creditsFrame

-- Upgrades container
local upgradesFrame = Instance.new("Frame")
upgradesFrame.Name = "UpgradesFrame"
upgradesFrame.Size = UDim2.new(1, -20, 1, -120)
upgradesFrame.Position = UDim2.new(0, 10, 0, 110)
upgradesFrame.BackgroundTransparency = 1
upgradesFrame.Parent = mainFrame

-- Scrolling frame for upgrades
local scrollFrame = Instance.new("ScrollingFrame")
scrollFrame.Name = "ScrollFrame"
scrollFrame.Size = UDim2.new(1, 0, 1, 0)
scrollFrame.BackgroundTransparency = 1
scrollFrame.ScrollBarThickness = 4
scrollFrame.Parent = upgradesFrame

-- Layout for upgrade buttons
local layout = Instance.new("UIListLayout")
layout.Name = "UpgradeLayout"
layout.Padding = UDim.new(0, 10)
layout.Parent = scrollFrame

-- Define upgrades
local upgrades = {
	{name = "Damage Multiplier", desc = "Increases credit gain per strike", maxLevel = 5, baseCost = 100},
	{name = "Charge Speed", desc = "Increases how fast you charge", maxLevel = 5, baseCost = 150},
	{name = "Auto-Charger", desc = "Passively charges when not equipped", maxLevel = 5, baseCost = 200},
	{name = "Credit Boost", desc = "Increases credits earned per strike", maxLevel = 5, baseCost = 120},
	{name = "Idle Gain", desc = "Earn credits while idle", maxLevel = 5, baseCost = 500}
}

-- Create upgrade buttons
for i, upgrade in ipairs(upgrades) do
	local upgradeFrame = Instance.new("Frame")
	upgradeFrame.Name = upgrade.name .. "Frame"
	upgradeFrame.Size = UDim2.new(1, -10, 0, 80)
	upgradeFrame.BackgroundColor3 = Color3.new(0, 0.2, 0.4)
	upgradeFrame.BackgroundTransparency = 0.5
	upgradeFrame.BorderSizePixel = 0
	upgradeFrame.Parent = scrollFrame

	-- Upgrade name
	local nameLabel = Instance.new("TextLabel")
	nameLabel.Name = "NameLabel"
	nameLabel.Size = UDim2.new(0.5, -10, 0, 20)
	nameLabel.Position = UDim2.new(0, 10, 0, 10)
	nameLabel.BackgroundTransparency = 1
	nameLabel.Text = upgrade.name
	nameLabel.Font = Enum.Font.SourceSansBold
	nameLabel.TextSize = 16
	nameLabel.TextColor3 = Color3.new(0, 0.8, 1)
	nameLabel.TextXAlignment = Enum.TextXAlignment.Left
	nameLabel.Parent = upgradeFrame

	-- Level
	local levelLabel = Instance.new("TextLabel")
	levelLabel.Name = "LevelLabel"
	levelLabel.Size = UDim2.new(0.2, 0, 0, 20)
	levelLabel.Position = UDim2.new(0.5, 0, 0, 10)
	levelLabel.BackgroundTransparency = 1
	levelLabel.Text = "Lv. 0/5"
	levelLabel.Font = Enum.Font.SourceSansBold
	levelLabel.TextSize = 16
	levelLabel.TextColor3 = Color3.new(0.8, 0.8, 0.8)
	levelLabel.Parent = upgradeFrame

	-- Description
	local descLabel = Instance.new("TextLabel")
	descLabel.Name = "DescLabel"
	descLabel.Size = UDim2.new(0.7, -10, 0, 30)
	descLabel.Position = UDim2.new(0, 10, 0, 35)
	descLabel.BackgroundTransparency = 1
	descLabel.Text = upgrade.desc
	descLabel.Font = Enum.Font.SourceSans
	descLabel.TextSize = 14
	descLabel.TextColor3 = Color3.new(0.7, 0.7, 0.7)
	descLabel.TextWrapped = true
	descLabel.TextXAlignment = Enum.TextXAlignment.Left
	descLabel.Parent = upgradeFrame

	-- Cost
	local costLabel = Instance.new("TextLabel")
	costLabel.Name = "CostLabel"
	costLabel.Size = UDim2.new(0.2, 0, 0, 20)
	costLabel.Position = UDim2.new(0.7, 0, 0, 35)
	costLabel.BackgroundTransparency = 1
	costLabel.Text = "Cost: 0"
	costLabel.Font = Enum.Font.SourceSansBold
	costLabel.TextSize = 14
	costLabel.TextColor3 = Color3.new(0.8, 0.8, 0.2)
	costLabel.Parent = upgradeFrame

	-- Purchase button
	local purchaseButton = Instance.new("TextButton")
	purchaseButton.Name = "PurchaseButton"
	purchaseButton.Size = UDim2.new(0.2, -10, 0, 30)
	purchaseButton.Position = UDim2.new(0.8, 0, 0, 35)
	purchaseButton.BackgroundColor3 = Color3.new(0, 0.4, 0.6)
	purchaseButton.BackgroundTransparency = 0
	purchaseButton.BorderSizePixel = 0
	purchaseButton.Text = "Purchase"
	purchaseButton.Font = Enum.Font.SourceSansBold
	purchaseButton.TextSize = 14
	purchaseButton.TextColor3 = Color3.new(1, 1, 1)
	purchaseButton.Parent = upgradeFrame
end

-- Close button
local closeButton = Instance.new("TextButton")
closeButton.Name = "CloseButton"
closeButton.Size = UDim2.new(0, 30, 0, 30)
closeButton.Position = UDim2.new(1, -40, 0, 10)
closeButton.BackgroundColor3 = Color3.new(0.6, 0, 0)
closeButton.Text = "X"
closeButton.Font = Enum.Font.SourceSansBold
closeButton.TextSize = 18
closeButton.TextColor3 = Color3.new(1, 1, 1)
closeButton.Parent = mainFrame

-- Create LeaderboardGui
local leaderboardGui = Instance.new("ScreenGui")
leaderboardGui.Name = "LeaderboardGui"
leaderboardGui.ResetOnSpawn = false
leaderboardGui.Parent = StarterGui

-- Main frame for leaderboard
local leaderboardMainFrame = Instance.new("Frame")
leaderboardMainFrame.Name = "MainFrame"
leaderboardMainFrame.Size = UDim2.new(0, 300, 0, 400)
leaderboardMainFrame.Position = UDim2.new(0.5, -150, 0.5, -200)
leaderboardMainFrame.BackgroundColor3 = Color3.new(0.1, 0.1, 0.2)
leaderboardMainFrame.BackgroundTransparency = 0.2
leaderboardMainFrame.BorderSizePixel = 0
leaderboardMainFrame.Parent = leaderboardGui

-- Title label
local leaderboardTitleLabel = Instance.new("TextLabel")
leaderboardTitleLabel.Name = "TitleLabel"
leaderboardTitleLabel.Size = UDim2.new(1, 0, 0, 50)
leaderboardTitleLabel.Position = UDim2.new(0, 0, 0, 0)
leaderboardTitleLabel.BackgroundTransparency = 1
leaderboardTitleLabel.Text = "Neuro Leaderboard"
leaderboardTitleLabel.Font = Enum.Font.SourceSansBold
leaderboardTitleLabel.TextSize = 24
leaderboardTitleLabel.TextColor3 = Color3.new(0, 0.8, 1)
leaderboardTitleLabel.Parent = leaderboardMainFrame

-- Column headers
local headersFrame = Instance.new("Frame")
headersFrame.Name = "HeadersFrame"
headersFrame.Size = UDim2.new(1, -20, 0, 30)
headersFrame.Position = UDim2.new(0, 10, 0, 60)
headersFrame.BackgroundTransparency = 1
headersFrame.Parent = leaderboardMainFrame

local rankHeader = Instance.new("TextLabel")
rankHeader.Name = "RankHeader"
rankHeader.Size = UDim2.new(0.2, 0, 1, 0)
rankHeader.BackgroundTransparency = 1
rankHeader.Text = "Rank"
rankHeader.Font = Enum.Font.SourceSansBold
rankHeader.TextSize = 16
rankHeader.TextColor3 = Color3.new(0.7, 0.7, 0.7)
rankHeader.Parent = headersFrame

local nameHeader = Instance.new("TextLabel")
nameHeader.Name = "NameHeader"
nameHeader.Size = UDim2.new(0.5, 0, 1, 0)
nameHeader.Position = UDim2.new(0.2, 0, 0, 0)
nameHeader.BackgroundTransparency = 1
nameHeader.Text = "Player"
nameHeader.Font = Enum.Font.SourceSansBold
nameHeader.TextSize = 16
nameHeader.TextColor3 = Color3.new(0.7, 0.7, 0.7)
nameHeader.Parent = headersFrame

local scoreHeader = Instance.new("TextLabel")
scoreHeader.Name = "ScoreHeader"
scoreHeader.Size = UDim2.new(0.3, 0, 1, 0)
scoreHeader.Position = UDim2.new(0.7, 0, 0, 0)
scoreHeader.BackgroundTransparency = 1
scoreHeader.Text = "Credits"
scoreHeader.Font = Enum.Font.SourceSansBold
scoreHeader.TextSize = 16
scoreHeader.TextColor3 = Color3.new(0.7, 0.7, 0.7)
scoreHeader.Parent = headersFrame

-- Entries container
local entriesFrame = Instance.new("Frame")
entriesFrame.Name = "EntriesFrame"
entriesFrame.Size = UDim2.new(1, -20, 1, -100)
entriesFrame.Position = UDim2.new(0, 10, 0, 100)
entriesFrame.BackgroundTransparency = 1
entriesFrame.Parent = leaderboardMainFrame

-- Scrolling frame for entries
local leaderboardScrollFrame = Instance.new("ScrollingFrame")
leaderboardScrollFrame.Name = "ScrollFrame"
leaderboardScrollFrame.Size = UDim2.new(1, 0, 1, 0)
leaderboardScrollFrame.BackgroundTransparency = 1
leaderboardScrollFrame.ScrollBarThickness = 4
leaderboardScrollFrame.Parent = entriesFrame

-- Layout
local leaderboardLayout = Instance.new("UIListLayout")
leaderboardLayout.Name = "EntryLayout"
leaderboardLayout.Padding = UDim.new(0, 5)
leaderboardLayout.Parent = leaderboardScrollFrame

-- Close button
local leaderboardCloseButton = Instance.new("TextButton")
leaderboardCloseButton.Name = "CloseButton"
leaderboardCloseButton.Size = UDim2.new(0, 30, 0, 30)
leaderboardCloseButton.Position = UDim2.new(1, -40, 0, 10)
leaderboardCloseButton.BackgroundColor3 = Color3.new(0.6, 0, 0)
leaderboardCloseButton.Text = "X"
leaderboardCloseButton.Font = Enum.Font.SourceSansBold
leaderboardCloseButton.TextSize = 18
leaderboardCloseButton.TextColor3 = Color3.new(1, 1, 1)
leaderboardCloseButton.Parent = leaderboardMainFrame

print("GUI elements created in StarterGui")