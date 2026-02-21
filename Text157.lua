-- ======================
-- AUTO GRAB GUN SIN DISTANCIA
-- ======================

local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")

local LocalPlayer = Players.LocalPlayer
local GUN_NAME = "GunDrop"
local DISTANCE_ABOVE = 2

-- Toggle global
if _G.AutoGrabGunActive == nil then
    _G.AutoGrabGunActive = false
end

-- Si ya estaba activo, desactivar
if _G.AutoGrabGunActive then
    _G.AutoGrabGunActive = false
    if _G._AutoGrabGunConnection then
        _G._AutoGrabGunConnection:Disconnect()
        _G._AutoGrabGunConnection = nil
    end
    print("❌ Auto Grab Gun desactivado")
    return
end

-- Activar
_G.AutoGrabGunActive = true
print("✅ Auto Grab Gun activado")

local gun = nil

-- Buscar gun en el workspace
local function findGun()
    for _, obj in ipairs(Workspace:GetDescendants()) do
        if obj.Name == GUN_NAME and obj:IsA("BasePart") then
            return obj
        end
    end
    return nil
end

-- Loop principal
_G._AutoGrabGunConnection = RunService.RenderStepped:Connect(function(delta)
    if not _G.AutoGrabGunActive then return end

    local char = LocalPlayer.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return end
    local hrp = char.HumanoidRootPart

    -- Buscar gun si no hay una detectada
    if not gun or not gun.Parent then
        gun = findGun()
    end

    if gun and gun.Parent then
        -- Posicionar gun encima tuyo
        gun.CFrame = CFrame.new(hrp.Position + Vector3.new(0, DISTANCE_ABOVE, 0))
    end
end)
