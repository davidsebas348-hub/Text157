repeat task.wait() until game:IsLoaded()

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

repeat task.wait() until LocalPlayer
repeat task.wait() until LocalPlayer.Character
repeat task.wait() until LocalPlayer.Character:FindFirstChild("Humanoid")

task.wait(2)

-- ======================
-- GUN ESP ORIGINAL (SIN LAG)
-- ======================

local Workspace = game:GetService("Workspace")

local GUN_NAME = "GunDrop"

if _G.GunESPActive == nil then
    _G.GunESPActive = false
end

-- Toggle
if _G.GunESPActive then
    _G.GunESPActive = false

    if _G._GunESPObjects then
        for _, v in pairs(_G._GunESPObjects) do
            if v then v:Destroy() end
        end
        _G._GunESPObjects = nil
    end

    if _G._GunESPConnection then
        _G._GunESPConnection:Disconnect()
        _G._GunESPConnection = nil
    end

    print("❌ Gun ESP desactivado")
    return
end

_G.GunESPActive = true
_G._GunESPObjects = {}
print("✅ Gun ESP activado")

local function applyESP(gun)

    -- Highlight amarillo
    local highlight = Instance.new("Highlight")
    highlight.FillColor = Color3.fromRGB(255, 255, 0)
    highlight.OutlineColor = Color3.fromRGB(255, 255, 0)
    highlight.FillTransparency = 0.5
    highlight.OutlineTransparency = 0
    highlight.Adornee = gun
    highlight.Parent = gun

    -- Billboard GUI
    local billboard = Instance.new("BillboardGui")
    billboard.Size = UDim2.new(0, 120, 0, 50) -- tamaño fijo
    billboard.StudsOffset = Vector3.new(0, 2.5, 0)
    billboard.AlwaysOnTop = true
    billboard.Parent = gun

    local text = Instance.new("TextLabel")
    text.Size = UDim2.new(1, 0, 1, 0)
    text.BackgroundTransparency = 1
    text.TextScaled = true
    text.Font = Enum.Font.GothamBold
    text.TextColor3 = Color3.fromRGB(255, 255, 0)
    text.TextStrokeTransparency = 0
    text.Text = "DROPPED\nGUN"
    text.Parent = billboard

    table.insert(_G._GunESPObjects, highlight)
    table.insert(_G._GunESPObjects, billboard)
end

-- Detectar GunDrop sin escanear cada frame
local function monitorModel(model)
    if model:IsA("Model") and model:FindFirstChild("Spawns") then

        -- Si ya existe
        for _, obj in ipairs(model:GetDescendants()) do
            if obj.Name == GUN_NAME and obj:IsA("BasePart") then
                applyESP(obj)
            end
        end

        -- Cuando aparezca
        model.DescendantAdded:Connect(function(obj)
            if obj.Name == GUN_NAME and obj:IsA("BasePart") then
                applyESP(obj)
            end
        end)
    end
end

-- Revisar mapas actuales
for _, child in ipairs(Workspace:GetChildren()) do
    monitorModel(child)
end

-- Detectar nuevo mapa
_G._GunESPConnection = Workspace.ChildAdded:Connect(function(child)
    monitorModel(child)
end)
