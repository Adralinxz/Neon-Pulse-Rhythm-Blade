// Upgrade GUI for Neuro Pulse: Rhythm Blade
-- Simple version that creates the UI elements directly

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local StarterGui = game:GetService("StarterGui")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Create the upgrade GUI
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "UpgradeGui"
screenGui.Parent = playerGui

-- Main frame
local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 400, 0, 500)
mainFrame.Position = UDim2.new(0.5, -200, 0.5, -250)
mainFrame.BackgroundColor3 = Color3.new(0.1, 0.1, 0.2)
mainFrame.BackgroundTransparency = 0.2
mainFrame.BorderSizePixel = 0
mainFrame.Parent = screenGui

-- Title
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

-- Credits display
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
creditsIcon.Image = "rbxassetid://1234567890" -- Placeholder
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

-- Layout
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

-- Make GUI toggleable with U key
local UserInputService = game:GetService("UserInputService")
UserInputService.InputBegan:Connect(function(input, gameProcessed)
	if not gameProcessed and input.KeyCode == Enum.KeyCode.U then
		screenGui.Enabled = not screenGui.Enabled
	end
end)

print("Upgrade GUI created")
