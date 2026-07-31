// BladeController.lua
-- LocalScript handling blade charge/release mechanics, visuals, audio, and server communication

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local StarterGui = game:GetService("StarterGui")

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local camera = workspace.CurrentCamera

-- References (set when tool equipped)
local bladeTool = nil
local handle = nil
local bladeMesh = nil
local bladeLight = nil
local bladeTrail = nil
local chargeParticles = nil
local strikeParticles = nil
local chargeSound = nil
local strikeSound = nil

-- State
local isEquipped = false
local isCharging = false
local chargeLevel = 0
local chargeStartTime = 0
local chargeConnection = nil

-- Configuration
local BASE_CHARGE_RATE = 1.0          -- charge per second
local CHARGE_TIME = 2.0               -- seconds to full charge
local MIN_CHARGE_FOR_STRIKE = 0.1
local CHARGE_SOUND_PITCH_MIN = 0.5
local CHARGE_SOUND_PITCH_MAX = 2.0
local STRIKE_SOUND_PITCH_MIN = 0.5
local STRIKE_SOUND_PITCH_MAX = 2.0

-- Initialize blade parts and sounds
local function initializeBlade(tool)
    bladeTool = tool
    handle = tool:WaitForChild("Handle")
    bladeMesh = handle:WaitForChild("BladeMesh")
    bladeLight = handle:WaitForChild("BladeLight")
    bladeTrail = handle:WaitForChild("BladeTrail")
    chargeParticles = handle:WaitForChild("ChargeParticles")
    strikeParticles = handle:WaitForChild("StrikeParticles")

    -- Ensure sounds exist
    chargeSound = tool:FindFirstChild("ChargeSound")
    if not chargeSound then
        chargeSound = Instance.new("Sound")
        chargeSound.Name = "ChargeSound"
        chargeSound.SoundId = "rbxassetid://1843135242" -- synth charge loop
        chargeSound.Volume = 0.5
        chargeSound.Looped = true
        chargeSound.Parent = tool
    end

    strikeSound = tool:FindFirstChild("StrikeSound")
    if not strikeSound then
        strikeSound = Instance.new("Sound")
        strikeSound.Name = "StrikeSound"
        strikeSound.SoundId = "rbxassetid://1843135243" -- synth strike
        strikeSound.Volume = 1.0
        strikeSound.Looped = false
        strikeSound.Parent = tool
    end

    updateBladeAppearance() -- set to zero charge initially
end

-- Update blade visuals based on charge level (0-1)
local function updateBladeAppearance()
    if not bladeMesh then return end

    local brightness = 0.2 + (chargeLevel * 0.8)   -- 0.2 to 1.0
    local size = 0.2 + (chargeLevel * 0.3)        -- 0.2 to 0.5

    -- Blade light (color shifts from blue to cyan)
    if bladeLight then
        bladeLight.Brightness = brightness * 3
        bladeLight.Color = Color3.new(0, 0.4 + chargeLevel * 0.6, 0.8 + chargeLevel * 0.2)
    end

    -- Mesh scale
    if bladeMesh then
        bladeMesh.Scale = Vector3.new(size, size, 2)
    end

    -- Trail
    if bladeTrail then
        bladeTrail.Enabled = chargeLevel > 0.1
    end

    -- Charge particles
    if chargeParticles then
        chargeParticles.Enabled = chargeLevel > 0
        if chargeLevel > 0 then
            chargeParticles.Rate = 5 + (chargeLevel * 15) -- 5 to 20
        end
    end
end

-- Input began (hold to charge)
local function onInputBegan(inputObject, gameProcessedEvent)
    if gameProcessedEvent then return end
    if not isEquipped then return end

    -- Accept mouse click, touch, or gamepad right trigger
    if inputObject.UserInputType == Enum.UserInputType.MouseButton1 or
       inputObject.UserInputType == Enum.UserInputType.Touch or
       (inputObject.UserInputType == Enum.UserInputType.Gamepad1 and
        (inputObject.KeyCode == Enum.KeyCode.ButtonR2 or inputObject.KeyCode == Enum.KeyCode.ButtonRTrigger)) then

        isCharging = true
        chargeLevel = 0
        chargeStartTime = tick()

        if chargeSound then
            chargeSound:Play()
        end

        if not chargeConnection then
            chargeConnection = RunService.RenderStepped:Connect(function()
                if not isCharging then
                    if chargeConnection then
                        chargeConnection:Disconnect()
                        chargeConnection = nil
                    end
                    return
                end
                local elapsed = tick() - chargeStartTime
                chargeLevel = math.min(elapsed * BASE_CHARGE_RATE / CHARGE_TIME, 1.0)
                updateBladeAppearance()
            end)
        end
    end
end

-- Input ended (release to strike)
local function onInputEnded(inputObject, gameProcessedEvent)
    if gameProcessedEvent then return end
    if not isEquipped then return end

    -- Check if this input matches the one that started charging
    local isSameInput = false
    if inputObject.UserInputType == Enum.UserInputType.MouseButton1 and isCharging then
        isSameInput = true
    elseif inputObject.UserInputType == Enum.UserInputType.Touch and isCharging then
        isSameInput = true
    elseif inputObject.UserInputType == Enum.UserInputType.Gamepad1 and isCharging then
        if inputObject.KeyCode == Enum.KeyCode.ButtonR2 or inputObject.KeyCode == Enum.KeyCode.ButtonRTrigger then
            isSameInput = true
        end
    end

    if isSameInput then
        isCharging = false

        if chargeSound then
            chargeSound:Stop()
        end

        if chargeLevel >= MIN_CHARGE_FOR_STRIKE then
            fireStrike(chargeLevel)
        else
            -- Not enough charge, just reset visuals
            updateBladeAppearance()
        end

        if chargeConnection then
            chargeConnection:Disconnect()
            chargeConnection = nil
        end
    end
end

-- Fire the strike: play effects, tell server
function fireStrike(finalChargeLevel)
    -- Strike sound pitch based on charge
    if strikeSound then
        strikeSound.Pitch = STRIKE_SOUND_PITCH_MIN + (finalChargeLevel * (STRIKE_SOUND_PITCH_MAX - STRIKE_SOUND_PITCH_MIN))
        strikeSound:Play()
    end

    -- Strike particles burst
    if strikeParticles then
        strikeParticles.Enabled = true
        -- Delay then disable
        delay(0.1, function()
            if strikeParticles then
                strikeParticles.Enabled = false
            end
        end)
    end

    -- Screen flash effect (white overlay fade out)
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

    local tweenIn = TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    local tweenInGoal = {BackgroundTransparency = 0.7}
    local tweenIn = TweenService:Create(screenFlash, tweenIn, tweenInGoal)
    tweenIn:Play()

    tweenIn.Completed:Connect(function()
        local tweenOut = TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
        local tweenOutGoal = {BackgroundTransparency = 1}
        local tweenOut = TweenService:Create(screenFlash, tweenOut, tweenOutGoal)
        tweenOut:Play()
    end)

    -- Notify server of strike
    local bladeStrikeEvent = ReplicatedStorage:WaitForChild("BladeStrike")
    if bladeStrikeEvent then
        bladeStrikeEvent:FireServer(finalChargeLevel)
    end

    -- Reset charge visuals immediately
    chargeLevel = 0
    updateBladeAppearance()
end

-- Tool equipped/unequipped handling
local function onToolEquipped()
    isEquipped = true
    initializeBlade(script.Parent.Parent) -- script is inside Tool, so Parent.Parent is Tool

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

    updateBladeAppearance() -- reset to zero
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

print("BladeController loaded")