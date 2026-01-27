-- ======================
-- ESP DROPPED GUN (TOGGLE POR EJECUCIÓN)
-- ======================

local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")

local GUN_NAME = "GunDrop"
local gunColor = Color3.fromRGB(255, 255, 0)

-- ======================
-- TOGGLE GLOBAL
-- ======================
if _G.GunESP == nil then
    _G.GunESP = true
else
    _G.GunESP = not _G.GunESP
end

-- ======================
-- TABLA PARA SEGUIR LAS GUNS
-- ======================
if not _G.trackedGuns then _G.trackedGuns = {} end
local trackedGuns = _G.trackedGuns

-- ======================
-- FUNCIONES
-- ======================
local function addGunESP(obj)
    if trackedGuns[obj] then return end
    if not obj:IsA("BasePart") then return end

    local hl = Instance.new("Highlight")
    hl.Name = "GunESP"
    hl.Adornee = obj
    hl.FillColor = gunColor
    hl.OutlineColor = gunColor
    hl.FillTransparency = 0.5
    hl.OutlineTransparency = 0
    hl.Parent = obj

    local gui = Instance.new("BillboardGui")
    gui.Name = "GunLabel"
    gui.Adornee = obj
    gui.Size = UDim2.new(0,150,0,50)
    gui.StudsOffset = Vector3.new(0,2,0)
    gui.AlwaysOnTop = true
    gui.Parent = obj

    local text = Instance.new("TextLabel")
    text.Size = UDim2.new(1,0,1,0)
    text.BackgroundTransparency = 1
    text.TextColor3 = gunColor
    text.TextScaled = true
    text.Font = Enum.Font.SourceSansBold
    text.Text = "Dropped\ngun!!"
    text.RichText = true
    text.Parent = gui

    trackedGuns[obj] = {highlight = hl, gui = gui}
end

local function removeGunESP(obj)
    local data = trackedGuns[obj]
    if data then
        if data.highlight and data.highlight.Parent then data.highlight:Destroy() end
        if data.gui and data.gui.Parent then data.gui:Destroy() end
        trackedGuns[obj] = nil
    end
end

local function ClearAllGuns()
    for obj, _ in pairs(trackedGuns) do
        removeGunESP(obj)
    end
end

-- ======================
-- DESACTIVAR ESP SI TOGGLE OFF
-- ======================
if not _G.GunESP then
    ClearAllGuns()
    if _G.GunESPConnection then
        _G.GunESPConnection:Disconnect()
        _G.GunESPConnection = nil
    end
    warn("❌ ESP DROPPED GUN DESACTIVADO")
    return
end

warn("✅ ESP DROPPED GUN ACTIVADO")

-- ======================
-- CONEXIONES
-- ======================
local function TrackNew(obj)
    if obj.Name == GUN_NAME and obj:IsA("BasePart") then
        addGunESP(obj)
    end
end

Workspace.DescendantAdded:Connect(function(obj)
    if _G.GunESP then TrackNew(obj) end
end)

Workspace.DescendantRemoving:Connect(function(obj)
    if obj.Name == GUN_NAME then
        removeGunESP(obj)
    end
end)

-- Loop seguro para limpiar Guns desaparecidas
_G.GunESPConnection = RunService.RenderStepped:Connect(function()
    if not _G.GunESP then return end
    for obj, _ in pairs(trackedGuns) do
        if not obj or not obj.Parent then
            removeGunESP(obj)
        end
    end
end)

-- Inicializar ESP para Guns existentes
for _, obj in pairs(Workspace:GetDescendants()) do
    if obj.Name == GUN_NAME and obj:IsA("BasePart") and _G.GunESP then
        addGunESP(obj)
    end
end
