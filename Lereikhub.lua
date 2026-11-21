-- no lo voy a ofuscar porque me da flojera xdxdxdxdxd

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")
local Remotes = ReplicatedStorage:WaitForChild("Remotes")

local JumpKick = Remotes:WaitForChild("JumpKick")
local HandKick = Remotes:WaitForChild("HandKick")
local DoubleReg = Remotes:WaitForChild("DoubleReg")
local Stun = Remotes:WaitForChild("Stun")
local PushUp = Remotes:WaitForChild("PushUp")
local Bench = Remotes:WaitForChild("Bench")
local Dumbell = Remotes:WaitForChild("Dumbell")

local INTERVAL = 0


-- colors pa que se vea bien
local BG = Color3.fromRGB(13, 13, 18)
local PANEL = Color3.fromRGB(23, 23, 32)
local PURPLE = Color3.fromRGB(155, 90, 255)
local TEXT = Color3.fromRGB(235, 235, 245)
local MUTED = Color3.fromRGB(135, 135, 155)
local OFF = Color3.fromRGB(48, 48, 62)

-- guisante
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "LereikHub"
ScreenGui.ResetOnSpawn = false
ScreenGui.IgnoreGuiInset = true
ScreenGui.Parent = playerGui

local Main = Instance.new("Frame")
Main.Name = "Main"
Main.Size = UDim2.new(0, 290, 0, 390)
Main.Position = UDim2.new(0.5, -145, 0.5, -195)
Main.BackgroundColor3 = BG
Main.BorderSizePixel = 0
Main.Parent = ScreenGui

local MainStroke = Instance.new("UIStroke")
MainStroke.Color = PURPLE
MainStroke.Thickness = 1
MainStroke.Parent = Main

-- BARRA SUPERIOR
local Header = Instance.new("Frame")
Header.Size = UDim2.new(1, 0, 0, 49)
Header.BackgroundColor3 = PANEL
Header.BorderSizePixel = 0
Header.Parent = Main

local Accent = Instance.new("Frame")
Accent.Size = UDim2.new(1, 0, 0, 3)
Accent.BackgroundColor3 = PURPLE
Accent.BorderSizePixel = 0
Accent.Parent = Header

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, -95, 0, 28)
Title.Position = UDim2.new(0, 13, 0, 11)
Title.BackgroundTransparency = 1
Title.Text = "LereiK HUB"
Title.TextColor3 = TEXT
Title.Font = Enum.Font.GothamBold
Title.TextSize = 19
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = Header

local Version = Instance.new("TextLabel")
Version.Size = UDim2.new(0, 40, 0, 15)
Version.Position = UDim2.new(0, 150, 0, 19)
Version.BackgroundTransparency = 1
Version.Text = "v1.3"
Version.TextColor3 = PURPLE
Version.Font = Enum.Font.GothamBold
Version.TextSize = 10
Version.Parent = Header

local function createHeaderButton(text, x, color)
    local b = Instance.new("TextButton")
    b.Size = UDim2.new(0, 30, 0, 29)
    b.Position = UDim2.new(1, x, 0, 11)
    b.BackgroundColor3 = color
    b.BorderSizePixel = 0
    b.Text = text
    b.TextColor3 = TEXT
    b.Font = Enum.Font.GothamBold
    b.TextSize = 15
    b.Parent = Header
    return b
end

local Hide = createHeaderButton("-", -72, OFF)
local Close = createHeaderButton("X", -37, Color3.fromRGB(145, 42, 65))


local running = true
local controllers = {}

-- opciones ekisde
local function createOption(name, note, y, remoteEvents, interval)
    interval = interval or INTERVAL

    local Option = Instance.new("Frame")
    Option.Name = name
    Option.Size = UDim2.new(1, -26, 0, 62)
    Option.Position = UDim2.new(0, 13, 0, y)
    Option.BackgroundColor3 = PANEL
    Option.BorderSizePixel = 0
    Option.Parent = Main

    local Indicator = Instance.new("Frame")
    Indicator.Size = UDim2.new(0, 3, 1, 0)
    Indicator.BackgroundColor3 = OFF
    Indicator.BorderSizePixel = 0
    Indicator.Parent = Option

    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(0, 170, 0, 24)
    Label.Position = UDim2.new(0, 12, 0, 9)
    Label.BackgroundTransparency = 1
    Label.Text = name
    Label.TextColor3 = TEXT
    Label.Font = Enum.Font.GothamBold
    Label.TextSize = 13
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.Parent = Option

    local Note = Instance.new("TextLabel")
    Note.Size = UDim2.new(0, 175, 0, 18)
    Note.Position = UDim2.new(0, 12, 0, 32)
    Note.BackgroundTransparency = 1
    Note.Text = note
    Note.TextColor3 = MUTED
    Note.Font = Enum.Font.Code
    Note.TextSize = 11
    Note.TextXAlignment = Enum.TextXAlignment.Left
    Note.Parent = Option

    local Toggle = Instance.new("TextButton")
    Toggle.Size = UDim2.new(0, 56, 0, 29)
    Toggle.Position = UDim2.new(1, -68, 0, 16)
    Toggle.BackgroundColor3 = OFF
    Toggle.BorderSizePixel = 0
    Toggle.Text = "OFF"
    Toggle.TextColor3 = TEXT
    Toggle.Font = Enum.Font.GothamBold
    Toggle.TextSize = 12
    Toggle.Parent = Option

    local Active = false
    local generation = 0

    local function updateVisual()
        Toggle.Text = Active and "ON" or "OFF"
        Toggle.BackgroundColor3 = Active and PURPLE or OFF
        Indicator.BackgroundColor3 = Active and PURPLE or OFF
    end

    local function stop()
        Active = false
        generation += 1

        if Toggle.Parent then
            updateVisual()
        end
    end

    local function start()
        if Active or not running then
            return
        end

        Active = true
        generation += 1

        local currentGeneration = generation
        updateVisual()

        task.spawn(function()
            while running
                and Active
                and generation == currentGeneration
                and ScreenGui.Parent do

                for _, action in ipairs(remoteEvents) do
                    -- Cada evento se ejecuta dos veces
                    for i = 1, (action.repetitions or 2) do
                        if not running
                            or not Active
                            or generation ~= currentGeneration then
                            break
                        end

                        action.remote:FireServer(
                            table.unpack(action.args or {})
                        )
                    end

                    if not running or not Active then
                        break
                    end
                end

                task.wait(interval)
            end
        end)
    end

    Toggle.MouseButton1Click:Connect(function()
        if Active then
            stop()
        else
            start()
        end
    end)

    table.insert(controllers, stop)

    return function()
        return Active
    end
end

-- PESTAÑAS: se conserva la función createOption sin modificaciones
local sections = { Farming = {}, PVP = {}, Utilities = {} }
local tabs = {}
local currentSection = "Farming"

local function addToSection(section, name, identifier)
    local item = Main:FindFirstChild(name)
    if item then
        item.Name = identifier
        item.Visible = (section == currentSection)
        table.insert(sections[section], item)
    end
end

local function createTab(name, index)
    local tab = Instance.new("TextButton")
    tab.Name = "Tab_" .. name
    tab.Size = UDim2.new(0, 83, 0, 29)
    tab.Position = UDim2.new(0, 13 + (index - 1) * 91, 0, 58)
    tab.BackgroundColor3 = PANEL
    tab.BorderSizePixel = 0
    tab.Text = name
    tab.TextColor3 = MUTED
    tab.Font = Enum.Font.GothamMedium
    tab.TextSize = 12
    tab.Parent = Main
    tabs[name] = tab
    return tab
end

createTab("Farming", 1)
createTab("PVP", 2)
createTab("Utilities", 3)

-- Area desplazable exclusiva de PVP (sin aumentar el tamano del HUB)
local PVPScroll = Instance.new("ScrollingFrame")
PVPScroll.Name = "PVPScroll"
PVPScroll.Size = UDim2.new(1, 0, 0, 285)
PVPScroll.Position = UDim2.new(0, 0, 0, 94)
PVPScroll.BackgroundTransparency = 1
PVPScroll.BorderSizePixel = 0
PVPScroll.ScrollBarThickness = 3
PVPScroll.ScrollBarImageColor3 = PURPLE
PVPScroll.ScrollingDirection = Enum.ScrollingDirection.Y
PVPScroll.CanvasSize = UDim2.new(0, 0, 0, 470)
PVPScroll.Visible = false
PVPScroll.Parent = Main

local function showSection(section)
    currentSection = section
    PVPScroll.Visible = (section == "PVP")
    for name, items in pairs(sections) do
        for _, option in ipairs(items) do
            option.Visible = (name == section)
        end
    end
    for name, tab in pairs(tabs) do
        local selected = (name == section)
        tab.BackgroundColor3 = selected and PURPLE or PANEL
        tab.TextColor3 = selected and TEXT or MUTED
    end
end

for name, tab in pairs(tabs) do
    tab.MouseButton1Click:Connect(function()
        showSection(name)
    end)
end

-- FARMING: AUTO DUMBELL
local AutoDumbellEnabled = createOption(
    "AUTO DUMBELL", "farm strength", 101,
    {{remote = Dumbell, args = {"Rep", 1}}}, 0
)
addToSection("Farming", "AUTO DUMBELL", "Farming_AutoDumbell")

-- FARMING: AUTO BENCH (se mantiene el orden de eventos original)
local AutoBenchEnabled = createOption(
    "AUTO BENCH", "Health farm", 173,
    {
        {remote = PushUp},
        {remote = Bench},
        {remote = PushUp},
        {remote = Bench},
        {remote = PushUp},
        {remote = Bench},
        {remote = PushUp},
        {remote = Bench},
        {remote = PushUp},
        {remote = Bench},
        {remote = PushUp},
        {remote = Bench},
        {remote = PushUp},
        {remote = Bench},
        {remote = PushUp},
        {remote = Bench}
    }
)
addToSection("Farming", "AUTO BENCH", "Farming_AutoBench")

-- FARMING: KILL AURA
local KillAuraEnabled = createOption(
    "KILL AURA", "Strength farm", 245,
    {
        {remote = JumpKick},
        {remote = HandKick},
        {remote = JumpKick, args = {2}},
        {remote = DoubleReg}
    }
)
addToSection("Farming", "KILL AURA", "Farming_KillAura")

-- PVP: KILL AURA (mismos eventos; interruptor independiente)
local PvpKillAuraEnabled = createOption(
    "KILL AURA", "Strength farm", 101,
    {
        {remote = JumpKick},
        {remote = HandKick},
        {remote = JumpKick, args = {2}},
        {remote = DoubleReg}
    }
)
addToSection("PVP", "KILL AURA", "PVP_KillAura")

-- PVP: SPAM SWEEP
local SpamSweepEnabled = createOption(
    "SPAM SWEEP", "Test version", 173,
    {{remote = Stun, repetitions = 1}},
    0.5
)
addToSection("PVP", "SPAM SWEEP", "PVP_SpamSweep")

-- PVP: ANTI FLING
-- Proteccion actualizada, colisiones desactivadas y limites nuevos.
local RunService = game:GetService("RunService")
local MAX_SPEED = 140
local MAX_SPIN = 70
local SafePos
local Targets = {}

local FlingOption = Instance.new("Frame")
FlingOption.Name = "PVP_AntiFling"
FlingOption.Size = UDim2.new(1, -26, 0, 62)
FlingOption.Position = UDim2.new(0, 13, 0, 245)
FlingOption.BackgroundColor3 = PANEL
FlingOption.BorderSizePixel = 0
FlingOption.Parent = Main
table.insert(sections.PVP, FlingOption)

local FlingIndicator = Instance.new("Frame")
FlingIndicator.Size = UDim2.new(0, 3, 1, 0)
FlingIndicator.BackgroundColor3 = OFF
FlingIndicator.BorderSizePixel = 0
FlingIndicator.Parent = FlingOption

local FlingLabel = Instance.new("TextLabel")
FlingLabel.Size = UDim2.new(0, 170, 0, 24)
FlingLabel.Position = UDim2.new(0, 12, 0, 9)
FlingLabel.BackgroundTransparency = 1
FlingLabel.Text = "ANTI FLING"
FlingLabel.TextColor3 = TEXT
FlingLabel.Font = Enum.Font.GothamBold
FlingLabel.TextSize = 13
FlingLabel.TextXAlignment = Enum.TextXAlignment.Left
FlingLabel.Parent = FlingOption

local FlingNote = Instance.new("TextLabel")
FlingNote.Size = UDim2.new(0, 175, 0, 18)
FlingNote.Position = UDim2.new(0, 12, 0, 32)
FlingNote.BackgroundTransparency = 1
FlingNote.Text = "Fling protection"
FlingNote.TextColor3 = MUTED
FlingNote.Font = Enum.Font.Code
FlingNote.TextSize = 11
FlingNote.TextXAlignment = Enum.TextXAlignment.Left
FlingNote.Parent = FlingOption

local FlingToggle = Instance.new("TextButton")
FlingToggle.Size = UDim2.new(0, 56, 0, 29)
FlingToggle.Position = UDim2.new(1, -68, 0, 16)
FlingToggle.BackgroundColor3 = OFF
FlingToggle.BorderSizePixel = 0
FlingToggle.Text = "OFF"
FlingToggle.TextColor3 = TEXT
FlingToggle.Font = Enum.Font.GothamBold
FlingToggle.TextSize = 12
FlingToggle.Parent = FlingOption

local flingActive = false
local flingHeartbeatConnection
local flingSimulationConnection
local flingCharacterConnection
local flingPlayerAddedConnection
local flingPlayerRemovingConnection
local flingPlayerConnections = {}
local flingDescendantConnections = {}

local function disconnectTarget(playerToClear)
    local connections = flingPlayerConnections[playerToClear]
    if connections then
        for _, connection in ipairs(connections) do
            connection:Disconnect()
        end
        flingPlayerConnections[playerToClear] = nil
    end
    if flingDescendantConnections[playerToClear] then
        flingDescendantConnections[playerToClear]:Disconnect()
        flingDescendantConnections[playerToClear] = nil
    end
    local parts = Targets[playerToClear]
    if parts then
        for part, originalCanCollide in pairs(parts) do
            if part.Parent then
                part.CanCollide = originalCanCollide
            end
        end
        Targets[playerToClear] = nil
    end
end

local function protectPlayer(otherPlayer)
    if otherPlayer == player or flingPlayerConnections[otherPlayer] then return end

    local connections = {}
    flingPlayerConnections[otherPlayer] = connections

    local function onCharacter(char)
        if flingDescendantConnections[otherPlayer] then
            flingDescendantConnections[otherPlayer]:Disconnect()
            flingDescendantConnections[otherPlayer] = nil
        end
        local oldParts = Targets[otherPlayer]
        if oldParts then
            for part, original in pairs(oldParts) do
                if part.Parent then part.CanCollide = original end
            end
        end
        local parts = {}
        Targets[otherPlayer] = parts

        local function addPart(obj)
            if not flingActive then return end
            if obj:IsA("BasePart") then
                if parts[obj] == nil then
                    parts[obj] = obj.CanCollide
                end
                obj.CanCollide = false
            end
        end

        for _, obj in ipairs(char:GetDescendants()) do
            addPart(obj)
        end
        flingDescendantConnections[otherPlayer] = char.DescendantAdded:Connect(addPart)
    end

    table.insert(connections, otherPlayer.CharacterAdded:Connect(onCharacter))
    if otherPlayer.Character then
        onCharacter(otherPlayer.Character)
    end
end

local function stopAntiFling()
    flingActive = false
    if flingHeartbeatConnection then
        flingHeartbeatConnection:Disconnect()
        flingHeartbeatConnection = nil
    end
    if flingSimulationConnection then
        flingSimulationConnection:Disconnect()
        flingSimulationConnection = nil
    end
    if flingCharacterConnection then
        flingCharacterConnection:Disconnect()
        flingCharacterConnection = nil
    end
    if flingPlayerAddedConnection then
        flingPlayerAddedConnection:Disconnect()
        flingPlayerAddedConnection = nil
    end
    if flingPlayerRemovingConnection then
        flingPlayerRemovingConnection:Disconnect()
        flingPlayerRemovingConnection = nil
    end
    for otherPlayer in pairs(flingPlayerConnections) do
        disconnectTarget(otherPlayer)
    end
    SafePos = nil
    if FlingToggle.Parent then
        FlingToggle.Text = "OFF"
        FlingToggle.BackgroundColor3 = OFF
        FlingIndicator.BackgroundColor3 = OFF
    end
end

FlingToggle.MouseButton1Click:Connect(function()
    if not running then return end
    if flingActive then
        stopAntiFling()
        return
    end

    flingActive = true
    SafePos = nil

    for _, otherPlayer in ipairs(Players:GetPlayers()) do
        protectPlayer(otherPlayer)
    end
    flingPlayerAddedConnection = Players.PlayerAdded:Connect(protectPlayer)
    flingPlayerRemovingConnection = Players.PlayerRemoving:Connect(disconnectTarget)

    flingSimulationConnection = RunService.PreSimulation:Connect(function()
        for _, parts in pairs(Targets) do
            for part in pairs(parts) do
                if part.Parent then
                    part.CanCollide = false
                else
                    parts[part] = nil
                end
            end
        end
    end)

    flingCharacterConnection = player.CharacterAdded:Connect(function()
        SafePos = nil
    end)

    flingHeartbeatConnection = RunService.Heartbeat:Connect(function()
        local char = player.Character
        local root = char and char:FindFirstChild("HumanoidRootPart")
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        if not root or not hum or hum.Health <= 0 then return end

        local speed = root.AssemblyLinearVelocity.Magnitude
        local spin = root.AssemblyAngularVelocity.Magnitude

        if speed > MAX_SPEED or spin > MAX_SPIN then
            root.AssemblyLinearVelocity = Vector3.zero
            root.AssemblyAngularVelocity = Vector3.zero
            if SafePos then
                char:PivotTo(SafePos)
            end
        elseif speed < 45 and spin < 25
            and hum.FloorMaterial ~= Enum.Material.Air then
            SafePos = root.CFrame
        end
    end)

    FlingToggle.Text = "ON"
    FlingToggle.BackgroundColor3 = PURPLE
    FlingIndicator.BackgroundColor3 = PURPLE
end)

table.insert(controllers, stopAntiFling)

-- PVP: BLOCK (cada 0.5 segundos mientras este activado)
local BlockEvent = Remotes:WaitForChild("Block")

local BlockOption = Instance.new("Frame")
BlockOption.Name = "PVP_Block"
BlockOption.Size = UDim2.new(1, -26, 0, 62)
BlockOption.Position = UDim2.new(0, 13, 0, 317)
BlockOption.BackgroundColor3 = PANEL
BlockOption.BorderSizePixel = 0
BlockOption.Parent = Main
table.insert(sections.PVP, BlockOption)

local BlockIndicator = Instance.new("Frame")
BlockIndicator.Size = UDim2.new(0, 3, 1, 0)
BlockIndicator.BackgroundColor3 = OFF
BlockIndicator.BorderSizePixel = 0
BlockIndicator.Parent = BlockOption

local BlockLabel = Instance.new("TextLabel")
BlockLabel.Size = UDim2.new(0, 170, 0, 24)
BlockLabel.Position = UDim2.new(0, 12, 0, 9)
BlockLabel.BackgroundTransparency = 1
BlockLabel.Text = "BLOCK"
BlockLabel.TextColor3 = TEXT
BlockLabel.Font = Enum.Font.GothamBold
BlockLabel.TextSize = 13
BlockLabel.TextXAlignment = Enum.TextXAlignment.Left
BlockLabel.Parent = BlockOption

local BlockNote = Instance.new("TextLabel")
BlockNote.Size = UDim2.new(0, 175, 0, 18)
BlockNote.Position = UDim2.new(0, 12, 0, 32)
BlockNote.BackgroundTransparency = 1
BlockNote.Text = "always block on"
BlockNote.TextColor3 = MUTED
BlockNote.Font = Enum.Font.Code
BlockNote.TextSize = 11
BlockNote.TextXAlignment = Enum.TextXAlignment.Left
BlockNote.Parent = BlockOption

local BlockToggle = Instance.new("TextButton")
BlockToggle.Size = UDim2.new(0, 56, 0, 29)
BlockToggle.Position = UDim2.new(1, -68, 0, 16)
BlockToggle.BackgroundColor3 = OFF
BlockToggle.BorderSizePixel = 0
BlockToggle.Text = "OFF"
BlockToggle.TextColor3 = TEXT
BlockToggle.Font = Enum.Font.GothamBold
BlockToggle.TextSize = 12
BlockToggle.Parent = BlockOption

local blockActive = false
local blockGeneration = 0

local function stopBlock()
    blockActive = false
    blockGeneration += 1
    if BlockToggle.Parent then
        BlockToggle.Text = "OFF"
        BlockToggle.BackgroundColor3 = OFF
        BlockIndicator.BackgroundColor3 = OFF
    end
end

BlockToggle.MouseButton1Click:Connect(function()
    if not running then return end
    if blockActive then
        stopBlock()
        return
    end

    blockActive = true
    blockGeneration += 1
    local thisGeneration = blockGeneration
    BlockToggle.Text = "ON"
    BlockToggle.BackgroundColor3 = PURPLE
    BlockIndicator.BackgroundColor3 = PURPLE

    task.spawn(function()
        while running and blockActive and blockGeneration == thisGeneration and ScreenGui.Parent do
            task.wait(1.6)
            if not running or not blockActive or blockGeneration ~= thisGeneration or not ScreenGui.Parent then
                break
            end
            BlockEvent:FireServer("Begin")
        end
    end)
end)

table.insert(controllers, stopBlock)

-- PVP: HITBOX EXPANDER MULTIJUGADOR
-- Cada objetivo tiene su propio tamaño, interruptor y seguimiento del respawn.
local HitboxOption = Instance.new("Frame")
HitboxOption.Name = "PVP_HitboxExpander"
HitboxOption.Size = UDim2.new(1, -26, 0, 170)
HitboxOption.Position = UDim2.new(0, 13, 0, 389)
HitboxOption.BackgroundColor3 = PANEL
HitboxOption.BorderSizePixel = 0
HitboxOption.Parent = Main
table.insert(sections.PVP, HitboxOption)

local HitboxIndicator = Instance.new("Frame")
HitboxIndicator.Size = UDim2.new(0, 3, 1, 0)
HitboxIndicator.BackgroundColor3 = PURPLE
HitboxIndicator.BorderSizePixel = 0
HitboxIndicator.Parent = HitboxOption

local HitboxLabel = Instance.new("TextLabel")
HitboxLabel.Size = UDim2.new(1, -24, 0, 24)
HitboxLabel.Position = UDim2.new(0, 12, 0, 7)
HitboxLabel.BackgroundTransparency = 1
HitboxLabel.Text = "HITBOX EXPANDER"
HitboxLabel.TextColor3 = TEXT
HitboxLabel.Font = Enum.Font.GothamBold
HitboxLabel.TextSize = 13
HitboxLabel.TextXAlignment = Enum.TextXAlignment.Left
HitboxLabel.Parent = HitboxOption

local function makeHitboxField(parent, text, size, position, initial)
    local field = Instance.new("TextBox")
    field.Size = size
    field.Position = position
    field.BackgroundColor3 = BG
    field.BorderSizePixel = 0
    field.PlaceholderText = text
    field.PlaceholderColor3 = MUTED
    field.Text = initial or ""
    field.TextColor3 = TEXT
    field.Font = Enum.Font.GothamMedium
    field.TextSize = 12
    field.TextXAlignment = Enum.TextXAlignment.Left
    field.ClearTextOnFocus = false
    field.Parent = parent
    local padding = Instance.new("UIPadding")
    padding.PaddingLeft = UDim.new(0, 7)
    padding.PaddingRight = UDim.new(0, 7)
    padding.Parent = field
    return field
end

local HitboxName = makeHitboxField(
    HitboxOption, "Nombre del jugador",
    UDim2.new(1, -24, 0, 30), UDim2.new(0, 12, 0, 37), ""
)
local HitboxSize = makeHitboxField(
    HitboxOption, "Tamano (2 - 35)",
    UDim2.new(0, 148, 0, 30), UDim2.new(0, 12, 0, 74), "10"
)

local AddHitbox = Instance.new("TextButton")
AddHitbox.Size = UDim2.new(0, 92, 0, 30)
AddHitbox.Position = UDim2.new(1, -104, 0, 74)
AddHitbox.BackgroundColor3 = PURPLE
AddHitbox.BorderSizePixel = 0
AddHitbox.Text = "+ ANADIR"
AddHitbox.TextColor3 = TEXT
AddHitbox.Font = Enum.Font.GothamBold
AddHitbox.TextSize = 11
AddHitbox.Parent = HitboxOption

local HitboxStatus = Instance.new("TextLabel")
HitboxStatus.Size = UDim2.new(1, -24, 0, 18)
HitboxStatus.Position = UDim2.new(0, 12, 0, 110)
HitboxStatus.BackgroundTransparency = 1
HitboxStatus.Text = "Agrega jugadores con control individual"
HitboxStatus.TextColor3 = MUTED
HitboxStatus.Font = Enum.Font.Code
HitboxStatus.TextSize = 10
HitboxStatus.TextXAlignment = Enum.TextXAlignment.Left
HitboxStatus.Parent = HitboxOption

local hitboxEntries = {}
local hitboxOrder = {}
local HITBOX_ROW_HEIGHT = 52

local function findHitboxPlayer(query)
    query = query:lower():gsub("^%s+", ""):gsub("%s+$", "")
    if query == "" then return nil end
    for _, other in ipairs(Players:GetPlayers()) do
        if other ~= player and other.Name:lower() == query then
            return other
        end
    end
    local match
    for _, other in ipairs(Players:GetPlayers()) do
        if other ~= player and (
            other.Name:lower():sub(1, #query) == query
            or other.DisplayName:lower():sub(1, #query) == query
        ) then
            if match then return nil end
            match = other
        end
    end
    return match
end

local function updateHitboxLayout()
    for i, entry in ipairs(hitboxOrder) do
        entry.frame.Position = UDim2.new(0, 12, 0, 133 + (i - 1) * HITBOX_ROW_HEIGHT)
    end
    local h = 141 + #hitboxOrder * HITBOX_ROW_HEIGHT
    HitboxOption.Size = UDim2.new(1, -26, 0, h)
    PVPScroll.CanvasSize = UDim2.new(0, 0, 0, 295 + h + 18)
end

local function restoreEntry(entry)
    if entry.root and entry.root.Parent then
        pcall(function()
            entry.root.Size = entry.originalSize
            entry.root.Transparency = entry.originalTransparency
            entry.root.CanCollide = entry.originalCanCollide
        end)
    end
    entry.root = nil
    entry.originalSize = nil
    entry.originalTransparency = nil
    entry.originalCanCollide = nil
end

local function stopEntry(entry)
    entry.active = false
    entry.generation += 1
    if entry.respawnConnection then
        entry.respawnConnection:Disconnect()
        entry.respawnConnection = nil
    end
    restoreEntry(entry)
    if entry.toggle.Parent then
        entry.toggle.Text = "OFF"
        entry.toggle.BackgroundColor3 = OFF
        entry.indicator.BackgroundColor3 = OFF
    end
end

local function applyEntry(entry, character, generation)
    local root = character:WaitForChild("HumanoidRootPart", 8)
    if not running or not entry.active or entry.generation ~= generation
        or entry.target.Character ~= character or not root then return end
    restoreEntry(entry)
    entry.root = root
    entry.originalSize = root.Size
    entry.originalTransparency = root.Transparency
    entry.originalCanCollide = root.CanCollide
    local size = entry.size
    root.Size = Vector3.new(size, size, size)
    root.Transparency = 0.65
    root.CanCollide = false
end

local function startEntry(entry)
    if not running or entry.active then return end
    if entry.target.Parent ~= Players then
        HitboxStatus.Text = "Ese jugador ya no esta en el servidor"
        return
    end
    entry.active = true
    entry.generation += 1
    local generation = entry.generation
    entry.toggle.Text = "ON"
    entry.toggle.BackgroundColor3 = PURPLE
    entry.indicator.BackgroundColor3 = PURPLE
    entry.respawnConnection = entry.target.CharacterAdded:Connect(function(character)
        task.spawn(applyEntry, entry, character, generation)
    end)
    if entry.target.Character then
        task.spawn(applyEntry, entry, entry.target.Character, generation)
    end
end

local function removeEntry(entry)
    stopEntry(entry)
    hitboxEntries[entry.target.UserId] = nil
    for i, item in ipairs(hitboxOrder) do
        if item == entry then
            table.remove(hitboxOrder, i)
            break
        end
    end
    entry.frame:Destroy()
    updateHitboxLayout()
end

local function addHitboxPlayer()
    local target = findHitboxPlayer(HitboxName.Text)
    local size = tonumber(HitboxSize.Text)
    if not target then
        HitboxStatus.Text = "Jugador no encontrado o ambiguo"
        return
    end
    if not size or size < 2 or size > 35 then
        HitboxStatus.Text = "Tamano invalido: usa 2 a 35"
        return
    end
    if hitboxEntries[target.UserId] then
        HitboxStatus.Text = "Ya agregado: " .. target.Name
        return
    end

    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, -24, 0, 45)
    frame.BackgroundColor3 = BG
    frame.BorderSizePixel = 0
    frame.Parent = HitboxOption

    local indicator = Instance.new("Frame")
    indicator.Size = UDim2.new(0, 3, 1, 0)
    indicator.BackgroundColor3 = OFF
    indicator.BorderSizePixel = 0
    indicator.Parent = frame

    local name = Instance.new("TextLabel")
    name.Size = UDim2.new(0, 104, 0, 18)
    name.Position = UDim2.new(0, 9, 0, 4)
    name.BackgroundTransparency = 1
    name.Text = target.Name
    name.TextTruncate = Enum.TextTruncate.AtEnd
    name.TextColor3 = TEXT
    name.Font = Enum.Font.GothamMedium
    name.TextSize = 11
    name.TextXAlignment = Enum.TextXAlignment.Left
    name.Parent = frame

    local sizeField = makeHitboxField(
        frame, "Tamano", UDim2.new(0, 67, 0, 21),
        UDim2.new(0, 9, 0, 22), tostring(size)
    )
    sizeField.TextSize = 11

    local toggle = Instance.new("TextButton")
    toggle.Size = UDim2.new(0, 48, 0, 27)
    toggle.Position = UDim2.new(1, -87, 0, 9)
    toggle.BackgroundColor3 = OFF
    toggle.BorderSizePixel = 0
    toggle.Text = "OFF"
    toggle.TextColor3 = TEXT
    toggle.Font = Enum.Font.GothamBold
    toggle.TextSize = 11
    toggle.Parent = frame

    local remove = Instance.new("TextButton")
    remove.Size = UDim2.new(0, 28, 0, 27)
    remove.Position = UDim2.new(1, -33, 0, 9)
    remove.BackgroundColor3 = Color3.fromRGB(145, 42, 65)
    remove.BorderSizePixel = 0
    remove.Text = "X"
    remove.TextColor3 = TEXT
    remove.Font = Enum.Font.GothamBold
    remove.TextSize = 11
    remove.Parent = frame

    local entry = {
        target = target, size = size, frame = frame,
        indicator = indicator, toggle = toggle,
        active = false, generation = 0
    }
    hitboxEntries[target.UserId] = entry
    table.insert(hitboxOrder, entry)

    toggle.MouseButton1Click:Connect(function()
        if entry.active then stopEntry(entry) else startEntry(entry) end
    end)
    remove.MouseButton1Click:Connect(function()
        removeEntry(entry)
    end)
    sizeField.FocusLost:Connect(function()
        local nextSize = tonumber(sizeField.Text)
        if not nextSize or nextSize < 2 or nextSize > 35 then
            sizeField.Text = tostring(entry.size)
            HitboxStatus.Text = "Tamano invalido: usa 2 a 35"
            return
        end
        if nextSize ~= entry.size then
            local wasActive = entry.active
            if wasActive then stopEntry(entry) end
            entry.size = nextSize
            if wasActive then startEntry(entry) end
        end
    end)

    updateHitboxLayout()
    startEntry(entry)
    HitboxName.Text = ""
    HitboxStatus.Text = "Agregado: " .. target.Name .. " | " .. tostring(size)
end

AddHitbox.MouseButton1Click:Connect(addHitboxPlayer)

local playerRemovingConnection = Players.PlayerRemoving:Connect(function(leaving)
    local entry = hitboxEntries[leaving.UserId]
    if entry then removeEntry(entry) end
end)

local function stopAllHitboxes()
    playerRemovingConnection:Disconnect()
    for _, entry in ipairs(hitboxOrder) do
        stopEntry(entry)
    end
end
table.insert(controllers, stopAllHitboxes)
updateHitboxLayout()

-- Colocar las cuatro opciones originales y la nueva dentro del scroll PVP.
-- Se conservan sus coordenadas relativas, apariencia y funciones.
for _, option in ipairs(sections.PVP) do
    option.Position = UDim2.new(0, 13, 0, option.Position.Y.Offset - 94)
    option.Parent = PVPScroll
end

-- UTILITIES: ANTI AFK (nuevo; no modifica createOption)
local AFKOption = Instance.new("Frame")
AFKOption.Name = "Utilities_AntiAFK"
AFKOption.Size = UDim2.new(1, -26, 0, 62)
AFKOption.Position = UDim2.new(0, 13, 0, 101)
AFKOption.BackgroundColor3 = PANEL
AFKOption.BorderSizePixel = 0
AFKOption.Parent = Main

table.insert(sections.Utilities, AFKOption)

local AFKIndicator = Instance.new("Frame")
AFKIndicator.Size = UDim2.new(0, 3, 1, 0)
AFKIndicator.BackgroundColor3 = OFF
AFKIndicator.BorderSizePixel = 0
AFKIndicator.Parent = AFKOption

local AFKLabel = Instance.new("TextLabel")
AFKLabel.Size = UDim2.new(0, 170, 0, 24)
AFKLabel.Position = UDim2.new(0, 12, 0, 9)
AFKLabel.BackgroundTransparency = 1
AFKLabel.Text = "ANTI AFK"
AFKLabel.TextColor3 = TEXT
AFKLabel.Font = Enum.Font.GothamBold
AFKLabel.TextSize = 13
AFKLabel.TextXAlignment = Enum.TextXAlignment.Left
AFKLabel.Parent = AFKOption

local AFKNote = Instance.new("TextLabel")
AFKNote.Size = UDim2.new(0, 175, 0, 18)
AFKNote.Position = UDim2.new(0, 12, 0, 32)
AFKNote.BackgroundTransparency = 1
AFKNote.Text = "Idle protection"
AFKNote.TextColor3 = MUTED
AFKNote.Font = Enum.Font.Code
AFKNote.TextSize = 11
AFKNote.TextXAlignment = Enum.TextXAlignment.Left
AFKNote.Parent = AFKOption

local AFKToggle = Instance.new("TextButton")
AFKToggle.Size = UDim2.new(0, 56, 0, 29)
AFKToggle.Position = UDim2.new(1, -68, 0, 16)
AFKToggle.BackgroundColor3 = OFF
AFKToggle.BorderSizePixel = 0
AFKToggle.Text = "OFF"
AFKToggle.TextColor3 = TEXT
AFKToggle.Font = Enum.Font.GothamBold
AFKToggle.TextSize = 12
AFKToggle.Parent = AFKOption

local afkActive = false
local afkConnection = nil

local function stopAntiAFK()
    afkActive = false
    if afkConnection then
        afkConnection:Disconnect()
        afkConnection = nil
    end
    if AFKToggle.Parent then
        AFKToggle.Text = "OFF"
        AFKToggle.BackgroundColor3 = OFF
        AFKIndicator.BackgroundColor3 = OFF
    end
end

AFKToggle.MouseButton1Click:Connect(function()
    if not running then return end
    if afkActive then
        stopAntiAFK()
        return
    end
    local ok, connection = pcall(function()
        local VirtualUser = game:GetService("VirtualUser")
        return Players.LocalPlayer.Idled:Connect(function()
            if not afkActive then return end
            pcall(function()
                warn("anti-afk")
                VirtualUser:CaptureController()
                VirtualUser:ClickButton2(Vector2.new())
            end)
        end)
    end)
    if ok and connection then
        afkConnection = connection
        afkActive = true
        AFKToggle.Text = "ON"
        AFKToggle.BackgroundColor3 = PURPLE
        AFKIndicator.BackgroundColor3 = PURPLE
    else
        warn("No se pudo activar ANTI AFK")
    end
end)

table.insert(controllers, stopAntiAFK)
showSection("Farming")

-- boton chido
local Mini = Instance.new("TextButton")
Mini.Name = "Mini"
Mini.Size = UDim2.new(0, 142, 0, 36)
Mini.Position = UDim2.new(0, 15, 0.5, 0)
Mini.AnchorPoint = Vector2.new(0, 0.5)
Mini.BackgroundColor3 = BG
Mini.BorderSizePixel = 0
Mini.Text = ""
Mini.AutoButtonColor = true
Mini.Visible = false
Mini.Parent = ScreenGui

local MiniStroke = Instance.new("UIStroke")
MiniStroke.Color = PURPLE
MiniStroke.Thickness = 1
MiniStroke.Parent = Mini

local Accent = Instance.new("Frame")
Accent.Size = UDim2.new(0, 3, 1, 0)
Accent.BackgroundColor3 = PURPLE
Accent.BorderSizePixel = 0
Accent.Parent = Mini

local MiniTitle = Instance.new("TextLabel")
MiniTitle.Size = UDim2.new(1, -40, 1, 0)
MiniTitle.Position = UDim2.new(0, 13, 0, 0)
MiniTitle.BackgroundTransparency = 1
MiniTitle.Text = "LereiK HUB"
MiniTitle.TextColor3 = Color3.fromRGB(225, 215, 245)
MiniTitle.Font = Enum.Font.GothamMedium
MiniTitle.TextSize = 12
MiniTitle.TextXAlignment = Enum.TextXAlignment.Left
MiniTitle.Parent = Mini

local MiniPlus = Instance.new("TextLabel")
MiniPlus.Size = UDim2.new(0, 30, 1, 0)
MiniPlus.Position = UDim2.new(1, -34, 0, 0)
MiniPlus.BackgroundTransparency = 1
MiniPlus.Text = "+"
MiniPlus.TextColor3 = PURPLE
MiniPlus.Font = Enum.Font.Gotham
MiniPlus.TextSize = 20
MiniPlus.Parent = Mini

-- Minimizarekisde
Hide.MouseButton1Click:Connect(function()
    Main.Visible = false
    Mini.Visible = true
end)

-- Arrastrar boton minimizado (PC y movil)
local miniDragging = false
local miniDragStart
local miniStartPos
local miniDragInput
local miniWasDragged = false

Mini.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then

        miniDragging = true
        miniWasDragged = false
        miniDragStart = input.Position
        miniStartPos = Mini.Position

        if input.UserInputType == Enum.UserInputType.Touch then
            miniDragInput = input
        end

        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                miniDragging = false
            end
        end)
    end
end)

Mini.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement then
        miniDragInput = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if not miniDragging or input ~= miniDragInput then
        return
    end

    local delta = input.Position - miniDragStart
    if math.abs(delta.X) > 5 or math.abs(delta.Y) > 5 then
        miniWasDragged = true
    end

    if miniWasDragged then
        Mini.Position = UDim2.new(
            miniStartPos.X.Scale,
            miniStartPos.X.Offset + delta.X,
            miniStartPos.Y.Scale,
            miniStartPos.Y.Offset + delta.Y
        )
    end
end)

-- Restoree
Mini.MouseButton1Click:Connect(function()
    if miniWasDragged then
        return
    end
    Main.Visible = true
    Mini.Visible = false
end)

-- arrastrada
local dragging = false
local dragStart
local startPos
local dragInput

Header.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then

        dragging = true
        dragStart = input.Position
        startPos = Main.Position

        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

Header.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement
        or input.UserInputType == Enum.UserInputType.Touch then
        dragInput = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if dragging and input == dragInput then
        local delta = input.Position - dragStart

        Main.Position = UDim2.new(
            startPos.X.Scale,
            startPos.X.Offset + delta.X,
            startPos.Y.Scale,
            startPos.Y.Offset + delta.Y
        )
    end
end)

-- LIMPIEZA
local function cleanup()
    if not running then
        return
    end

    running = false

    for _, stop in ipairs(controllers) do
        stop()
    end
end

_G.LereikHubCleanup = cleanup

Close.MouseButton1Click:Connect(function()
    cleanup()
    ScreenGui:Destroy()
end)

ScreenGui.Destroying:Connect(cleanup)
