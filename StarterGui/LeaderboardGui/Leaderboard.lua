// Leaderboard GUI for Neuro Pulse: Rhythm Blade

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local StarterGui = game:GetService("StarterGui")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Create the leaderboard GUI
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "LeaderboardGui"
screenGui.Parent = playerGui

-- Main frame
local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 300, 0, 400)
mainFrame.Position = UDim2.new(0.5, -150, 0.5, -200)
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
titleLabel.Text = "Neuro Leaderboard"
titleLabel.Font = Enum.Font.SourceSansBold
titleLabel.TextSize = 24
titleLabel.TextColor3 = Color3.new(0, 0.8, 1)
titleLabel.Parent = mainFrame

-- Column headers
local headersFrame = Instance.new("Frame")
headersFrame.Name = "HeadersFrame"
headersFrame.Size = UDim2.new(1, -20, 0, 30)
headersFrame.Position = UDim2.new(0, 10, 0, 60)
headersFrame.BackgroundTransparency = 1
headersFrame.Parent = mainFrame

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
entriesFrame.Parent = mainFrame

-- Scrolling frame for entries
local scrollFrame = Instance.new("ScrollingFrame")
scrollFrame.Name = "ScrollFrame"
scrollFrame.Size = UDim2.new(1, 0, 1, 0)
scrollFrame.BackgroundTransparency = 1
scrollFrame.ScrollBarThickness = 4
scrollFrame.Parent = entriesFrame

-- Layout
local layout = Instance.new("UIListLayout")
layout.Name = "EntryLayout"
layout.Padding = UDim.new(0, 5)
layout.Parent = scrollFrame

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

-- Make GUI toggleable with L key
local UserInputService = game:GetService("UserInputService")
UserInputService.InputBegan:Connect(function(input, gameProcessed)
	if not gameProcessed and input.KeyCode == Enum.KeyCode.L then
		screenGui.Enabled = not screenGui.Enabled
	end
end)

print("Leaderboard GUI created")
