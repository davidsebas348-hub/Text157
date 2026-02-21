-- ======================
-- AUTO GRAB GUN OPTIMIZADO
-- ======================

local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")

local LocalPlayer = Players.LocalPlayer
local GUN_NAME = "GunDrop"
local MAX_DISTANCE = 1000
local DISTANCE_ABOVE = 0

if _G.AutoGrabGunActive == nil then
    _G.AutoGrabGunActive = false
end

-- Toggle
if _G.AutoGrabGunActive then
    _G.AutoGrabGunActive = false
    if _G._AutoGrabGunConnection then
        _G._AutoGrabGunConnection:Disconnect()
        _G._AutoGrabGunConnection = nil
    end
    print("❌ Auto Grab Gun desactivado")
    return
end

_G.AutoGrabGunActive = true
print("✅ Auto Grab Gun activado")

local gun = nil
local angle = 0
local searchCooldown = 0

local function isMurderer()
    local char = LocalPlayer.Character
    local backpack = LocalPlayer:FindFirstChild("Backpack")

    if char then
        for _, t in ipairs(char:GetChildren()) do
            if t:IsA("Tool") and t.Name == "Knife" then
                return true
            end
        end
    end

    if backpack then
        for _, t in ipairs(backpack:GetChildren()) do
            if t:IsA("Tool") and t.Name == "Knife" then
                return true
            end
        end
    end

    return false
end

local function findGun()
    for _, obj in ipairs(Workspace:GetDescendants()) do
        if obj.Name == GUN_NAME and obj:IsA("BasePart") then
            return obj
        end
    end
    return nil
end

_G._AutoGrabGunConnection = RunService.RenderStepped:Connect(function(delta)
    if not _G.AutoGrabGunActive then return end
    if isMurderer() then return end

    local char = LocalPlayer.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return end
    local hrp = char.HumanoidRootPart

    -- Buscar gun solo cada 0.5 segundos
    searchCooldown = searchCooldown - delta
    if searchCooldown <= 0 then
        gun = findGun()
        searchCooldown = 0.5
    end

    if gun and gun.Parent then
        if (gun.Position - hrp.Position).Magnitude <= MAX_DISTANCE then
            angle += delta * 2

            local x = math.cos(angle)
            local z = math.sin(angle)
            local y = DISTANCE_ABOVE

            gun.CFrame = CFrame.new(hrp.Position + Vector3.new(x, y, z))
        end
    end
end)
