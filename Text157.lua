-- ======================
-- ESP DROPPED GUN (BORDE NEGRO EN TEXTO)
-- ======================

local Workspace = game:GetService("Workspace")

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

    -- 🔥 BORDE NEGRO
    text.TextStrokeTransparency = 0
    text.TextStrokeColor3 = Color3.fromRGB(0,0,0)

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
-- DESACTIVAR
-- ======================
if not _G.GunESP then
    ClearAllGuns()
    warn("❌ ESP DROPPED GUN DESACTIVADO")
    return
end

warn("✅ ESP DROPPED GUN ACTIVADO")

-- ======================
-- LOOP CADA 1 SEGUNDO
-- ======================
task.spawn(function()
    while _G.GunESP do
        for _, obj in ipairs(Workspace:GetDescendants()) do
            if obj.Name == GUN_NAME and obj:IsA("BasePart") then
                addGunESP(obj)
            end
        end

        for obj, _ in pairs(trackedGuns) do
            if not obj or not obj.Parent then
                removeGunESP(obj)
            end
        end

        task.wait(0.5)
    end
end)
