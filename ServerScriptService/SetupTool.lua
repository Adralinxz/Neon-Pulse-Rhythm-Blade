// ServerScriptService/SetupTool.lua
-- Script to create the Pulse Blade tool in StarterPack
-- This runs when the server starts

local StarterPack = game:GetService("StarterPack")

-- Check if the tool already exists
if StarterPack:FindFirstChild("Pulse Blade") then
	StarterPack:FindFirstChild("Pulse Blade"):Destroy()
end

-- Create the tool
local tool = Instance.new("Tool")
tool.Name = "Pulse Blade"
tool.ToolTip = "Hold to charge, release to strike!"
tool.Grip = CFrame.new(0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1)
tool.GripPos = Vector3.new(0, 0, 0)
tool.Parent = StarterPack

-- Create the handle
local handle = Instance.new("Part")
handle.Name = "Handle"
handle.Size = Vector3.new(0.5, 0.5, 5)
handle.Position = Vector3.new(0, 1.5, 0) -- This will be adjusted by the grip
handle.Anchored = false
handle.CanCollide = false
handle.Material = Enum.Material.SmoothPlastic
handle.Color = Color3.new(0.1, 0.1, 0.1) -- Dark gray
handle.Parent = tool

-- Create a cylinder mesh for the blade (as a placeholder)
local mesh = Instance.new("CylinderMesh")
mesh.Name = "BladeMesh"
mesh.Scale = Vector3.new(0.2, 0.2, 2)
mesh.Parent = handle

-- Add a point light for the blade glow
local light = Instance.new("PointLight")
light.Name = "BladeLight"
light.Color = Color3.new(0, 0.8, 1) -- Cyan
light.Brightness = 2
light.Range = 10
light.Parent = handle

-- Add a trail for the blade
local trail = Instance.new("Trail")
trail.Name = "BladeTrail"
trail.Attachment0 = Instance.new("Attachment")
trail.Attachment0.Name = "TrailStart"
trail.Attachment0.Position = Vector3.new(0, 0, 2) -- Near the tip
trail.Attachment0.Parent = handle
trail.Attachment1 = Instance.new("Attachment")
trail.Attachment1.Name = "TrailEnd"
trail.Attachment1.Position = Vector3.new(0, 0, -2) -- Near the hilt
trail.Attachment1.Parent = handle
trail.Color = ColorSequence.new{
	ColorSequenceKeypoint.new(0, Color3.new(0, 0.8, 1)),
	ColorSequenceKeypoint.new(1, Color3.new(0, 0.8, 1, 0)) -- Fade to transparent
}
trail.Lifetime = 0.5
trail.Width = 0.2
trail.Parent = handle

-- Add charge particles
local chargeParticles = Instance.new("ParticleEmitter")
chargeParticles.Name = "ChargeParticles"
chargeParticles.Texture = "rbxassetid://241877341" -- Sparkle
chargeParticles.Color = ColorSequence.new(Color3.new(0, 0.6, 1))
chargeParticles.LightEmission = 0.5
chargeParticles.Rate = 10
chargeParticles.Lifetime = NumberRange.new(0.5)
chargeParticles.Speed = NumberRange.new(0)
chargeParticles.Enabled = false
chargeParticles.Parent = handle

-- Add strike particles
local strikeParticles = Instance.new("ParticleEmitter")
strikeParticles.Name = "StrikeParticles"
strikeParticles.Texture = "rbxassetid://259368336" -- Explosion
strikeParticles.Color = ColorSequence.new(Color3.new(0, 0.8, 1))
strikeParticles.LightEmission = 0.5
strikeParticles.Rate = 50
strikeParticles.Lifetime = NumberRange.new(0.3)
strikeParticles.Speed = NumberRange.new(10)
strikeParticles.SpreadAngle = Vector2.new(45, 45)
strikeParticles.Enabled = false
strikeParticles.Parent = handle

-- Add sounds
local chargeSound = Instance.new("Sound")
chargeSound.Name = "ChargeSound"
chargeSound.SoundId = "rbxassetid://1843135242" -- Synth charge loop
chargeSound.Volume = 0.5
chargeSound.Looped = true
chargeSound.Parent = tool

local strikeSound = Instance.new("Sound")
strikeSound.Name = "StrikeSound"
strikeSound.SoundId = "rbxassetid://1843135243" -- Synth strike
strikeSound.Volume = 1.0
strikeSound.Looped = false
strikeSound.Parent = tool

print("Pulse Blade tool created in StarterPack")