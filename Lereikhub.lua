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
Version.Text = "v1.1"
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
                    for i = 1, 2 do
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

-- OPCION 1: KILL AURA
local KillAuraEnabled = createOption(
    "KILL AURA",
    "Strength farm",
    85,
    {
        {remote = JumpKick},
        {remote = HandKick},
        {remote = JumpKick, args = {2}},
        {remote = DoubleReg}
    }
)

-- OPCION 2: SPAM SWEEP
local SpamSweepEnabled = createOption(
    "SPAM SWEEP",
    "Test version",
    157,
    {
        {remote = Stun}
    }
)

-- OPCION 3: AUTO BENCH
local AutoBenchEnabled = createOption(
    "AUTO BENCH",
    "Health farm",
    229,
    {
        {remote = PushUp},
        {remote = Bench},
        {remote = PushUp},
        {remote = Bench}
        {remote = PushUp},
        {remote = Bench}
        {remote = PushUp},
        {remote = Bench}
        {remote = PushUp},
        {remote = Bench}
        {remote = PushUp},
        {remote = Bench}
        {remote = PushUp},
        {remote = Bench}
        {remote = PushUp},
        {remote = Bench}
   
    }
)

-- OPCION 4: AUTO DUMBELL
local AutoDumbellEnabled = createOption(
    "AUTO DUMBELL",
    "farm strength",
    301,
    {
        {remote = Dumbell, args = {"Rep", 1}}
    },
    0
)

-- boton chido
local Mini = Instance.new("TextButton")
Mini.Name = "Mini"
Mini.Size = UDim2.new(0, 160, 0, 42)
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
MiniTitle.Size = UDim2.new(1, -45, 1, 0)
MiniTitle.Position = UDim2.new(0, 13, 0, 0)
MiniTitle.BackgroundTransparency = 1
MiniTitle.Text = "LereiK HUB"
MiniTitle.TextColor3 = Color3.fromRGB(225, 215, 245)
MiniTitle.Font = Enum.Font.GothamMedium
MiniTitle.TextSize = 13
MiniTitle.TextXAlignment = Enum.TextXAlignment.Left
MiniTitle.Parent = Mini

local MiniPlus = Instance.new("TextLabel")
MiniPlus.Size = UDim2.new(0, 30, 1, 0)
MiniPlus.Position = UDim2.new(1, -34, 0, 0)
MiniPlus.BackgroundTransparency = 1
MiniPlus.Text = "+"
MiniPlus.TextColor3 = PURPLE
MiniPlus.Font = Enum.Font.Gotham
MiniPlus.TextSize = 23
MiniPlus.Parent = Mini

-- Minimizarekisde
Hide.MouseButton1Click:Connect(function()
    Main.Visible = false
    Mini.Visible = true
end)

-- Restoree
Mini.MouseButton1Click:Connect(function()
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
