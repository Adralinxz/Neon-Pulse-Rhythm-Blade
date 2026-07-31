// Client-side blade controller and UI
-- Handles local player input, visual effects, and UI for the Pulse Blade

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local camera = workspace.CurrentCamera

-- Blade tool reference (will be set when equipped)
local bladeTool = nil
local isEquipped = false

-- Charge state
local isCharging = false
local chargeLevel = 0
local chargeStartTime = 0
local chargeConnection = nil

-- Configuration
local BASE_CHARGE_RATE = 1.0
local CHARGE_TIME = 2.0 -- seconds to full charge
local MIN_CHARGE_FOR_STRIKE = 0.1

-- References to blade parts (will be set when tool is equipped)
local handle = nil
local bladeMesh = nil
local bladeLight = nil
local bladeTrail = nil
local chargeParticles = nil
local strikeParticles = nil

-- Sound references
local chargeSound = nil
local strikeSound = nil

-- Initialize when character is available
local function initializeBlade(tool)
	bladeTool = tool
	handle = tool:WaitForChild("Handle")
	bladeMesh = handle:WaitForChild("BladeMesh")
	bladeLight = handle:WaitForChild("BladeLight")
	bladeTrail = handle:WaitForChild("BladeTrail")
	chargeParticles = handle:WaitForChild("ChargeParticles")
	strikeParticles = handle:WaitForChild("StrikeParticles")
	
	-- Find or create sounds
	chargeSound = tool:FindFirstChild("ChargeSound")
	if not chargeSound then
		chargeSound = Instance.new("Sound")
		chargeSound.Name = "ChargeSound"
		chargeSound.SoundId = "rbxassetid://1843135242" -- Synth charge
		chargeSound.Volume = 0.5
		chargeSound.Looped = true
		chargeSound.Parent = tool
	end
	
	strikeSound = tool:FindFirstChild("StrikeSound")
	if not strikeSound then
		strikeSound = Instance.new("Sound")
		strikeSound.Name = "StrikeSound"
		strikeSound.SoundId = "rbxassetid://1843135243" -- Synth strike
		strikeSound.Volume = 1.0
		strikeSound.Looped = false
		strikeSound.Parent = tool
	end
	
	-- Update visuals
	updateBladeAppearance()
end

-- Update blade appearance based on charge level
local function updateBladeAppearance()
	if not bladeMesh then return end
	
	-- Scale from 0 (no charge) to 1 (full charge)
	local brightness = 0.2 + (chargeLevel * 0.8) -- 0.2 to 1.0
	local size = 0.2 + (chargeLevel * 0.3) -- 0.2 to 0.5
	
	-- Update blade color/intensity
	if bladeLight then
		bladeLight.Brightness = brightness * 3
		bladeLight.Color = Color3.new(0, 0.4 + chargeLevel * 0.6, 0.8 + chargeLevel * 0.2)
	end
	
	-- Update mesh scale
	if bladeMesh then
		bladeMesh.Scale = Vector3.new(size, size, 2)
	end
	
	-- Update trail
	if bladeTrail then
		bladeTrail.Enabled = chargeLevel > 0.1
	end
	
	-- Update charge particles
	if chargeParticles then
		chargeParticles.Enabled = chargeLevel > 0
		if chargeLevel > 0 then
			chargeParticles.Rate = 5 + (chargeLevel * 15) -- 5 to 20
		end
	end
end

-- Handle input started (hold to charge)
local function onInputBegan(inputObject, gameProcessedEvent)
	if gameProcessedEvent then return end
	if not isEquipped then return end
	
	-- Check if it's a valid input for charging (mouse click, touch, or gamepad trigger)
	if inputObject.UserInputType == Enum.UserInputType.MouseButton1 or
	   inputObject.UserInputType == Enum.UserInputType.Touch or
	   (inputObject.UserInputType == Enum.UserInputType.Gamepad1 and 
	    (inputObject.KeyCode == Enum.KeyCode.ButtonR2 or inputObject.KeyCode == Enum.KeyCode.ButtonRTrigger)) then
		
		isCharging = true
		chargeLevel = 0
		chargeStartTime = tick()
		
		-- Play charge sound
		if chargeSound then
			chargeSound:Play()
		end
		
		-- Start charging update
		if not chargeConnection then
			chargeConnection = RunService.RenderStepped:Connect(function()
				if isCharging then
					local elapsed = tick() - chargeStartTime
					chargeLevel = math.min(elapsed * BASE_CHARGE_RATE / CHARGE_TIME, 1.0)
					updateBladeAppearance()
				end
			end)
		end
	end
end

-- Handle input ended (release to strike)
local function onInputEnded(inputObject, gameProcessedEvent)
	if gameProcessedEvent then return end
	if not isEquipped then return end
	
	-- Check if it's the same input that started charging
	if (inputObject.UserInputType == Enum.UserInputType.MouseButton1 and isCharging) or
	   (inputObject.UserInputType == Enum.UserInputType.Touch and isCharging) or
	   (inputObject.UserInputType == Enum.UserInputType.Gamepad1 and 
	    (inputObject.KeyCode == Enum.KeyCode.ButtonR2 or inputObject.KeyCode == Enum.KeyCode.ButtonRTrigger) and isCharging) then
		
		isCharging = false
		
		-- Stop charge sound
		if chargeSound then
			chargeSound:Stop()
		end
		
		-- Fire strike
		if chargeLevel >= MIN_CHARGE_FOR_STRIKE then
			fireStrike(chargeLevel)
		else
			-- Reset visuals if charge too low
			updateBladeAppearance()
		end
		
		-- Clean up connection
		if chargeConnection then
			chargeConnection:Disconnect()
			chargeConnection = nil
		end
	end
end

-- Fire the blade strike
function fireStrike(finalChargeLevel)
	-- Play strike sound with pitch based on charge
	if strikeSound then
		strikeSound.Pitch = 0.5 + (finalChargeLevel * 1.5) -- 0.5 to 2.0
		strikeSound:Play()
	end
	
	-- Visual strike effect
	if strikeParticles then
		strikeParticles.Enabled = true
		wait(0.1)
		strikeParticles.Enabled = false
	end
	
	-- Screen flash effect
	local playerGui = player:WaitForChild("PlayerGui")
	local screenFlash = playerGui:FindFirstChild("ScreenFlash")
	if not screenFlash then
		screenFlash = Instance.new("Frame")
		screenFlash.Name = "ScreenFlash"
		screenFlash.Size = UDim2.new(1, 0, 1, 0)
		screenFlash.BackgroundColor3 = Color3.new(1, 1, 1)
		screenFlash.BackgroundTransparency = 1
		screenFlash.Parent = playerGui
	end
	
	-- Animate screen flash
	local tweenInfo = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
	local tween = TweenService:Create(screenFlash, tweenInfo, {BackgroundTransparency = 0.7})
	tween:Play()
	tween.Completed:Connect(function()
		local tweenOut = TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
		local tweenOut = TweenService:Create(screenFlash, tweenOut, {BackgroundTransparency = 1})
		tweenOut:Play()
	end)
	
	-- Tell server we struck (for credits, etc.)
	local bladeStrikeEvent = ReplicatedStorage:WaitForChild("BladeStrike")
	if bladeStrikeEvent then
		bladeStrikeEvent:FireServer(finalChargeLevel)
	end
	
	-- Reset visuals
	chargeLevel = 0
	updateBladeAppearance()
end

-- Tool equipped/unequipped handling
local function onToolEquipped()
	isEquipped = true
	initializeBlade(script.Parent.Parent) -- Tool is parent of this script when equipped
	
	-- Connect input events
	UserInputService.InputBegan:Connect(onInputBegan)
	UserInputService.InputEnded:Connect(onInputEnded)
end

local function onToolUnequipped()
	isEquipped = false
	isCharging = false
	
	if chargeSound then
		chargeSound:Stop()
	end
	
	if chargeConnection then
		chargeConnection:Disconnect()
		chargeConnection = nil
	end
	
	-- Reset visuals
	updateBladeAppearance()
end

-- Initialize when script runs (tool may already be equipped)
local function initialize()
	local tool = script.Parent.Parent
	if tool:IsA("Tool") then
		if tool.Parent == player.Backpack or tool.Parent == character then
			if tool.Parent == character then
				onToolEquipped()
			end
			
			tool.Equipped:Connect(onToolEquipped)
			tool.Unequipped:Connect(onToolUnequipped)
		end
	end
end

-- Start
initialize()

print("Pulse Blade client script loaded")
