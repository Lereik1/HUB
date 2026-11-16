local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local Remotes = ReplicatedStorage:WaitForChild("Remotes")
local JumpKick = Remotes:WaitForChild("JumpKick")
local HandKick = Remotes:WaitForChild("HandKick")
local DoubleReg = Remotes:WaitForChild("DoubleReg")
local Stun = Remotes:WaitForChild("Stun")

local INTERVAL = 0

-- Detener una versión anterior
if _G.LereikHubCleanup then
    _G.LereikHubCleanup()
end

local oldGui = playerGui:FindFirstChild("LereikHub")
if oldGui then
    oldGui:Destroy()
end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "LereikHub"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = playerGui

local Main = Instance.new("Frame")
Main.Size = UDim2.new(0,270,0,245)
Main.Position = UDim2.new(0.5,-135,0.5,-122)
Main.BackgroundColor3 = Color3.fromRGB(18,18,25)
Main.BorderSizePixel = 0
Main.Parent = ScreenGui

Instance.new("UICorner",Main).CornerRadius = UDim.new(0,12)

local Stroke = Instance.new("UIStroke",Main)
Stroke.Color = Color3.fromRGB(145,85,255)
Stroke.Thickness = 1.5

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1,-85,0,45)
Title.Position = UDim2.new(0,12,0,0)
Title.BackgroundTransparency = 1
Title.Text = "LEREIK HUB"
Title.TextColor3 = Color3.fromRGB(190,150,255)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 21
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = Main

local function createButton(text,x,color)
    local b = Instance.new("TextButton")
    b.Size = UDim2.new(0,30,0,30)
    b.Position = UDim2.new(1,x,0,7)
    b.AnchorPoint = Vector2.new(1,0)
    b.BackgroundColor3 = color
    b.Text = text
    b.TextColor3 = Color3.new(1,1,1)
    b.Font = Enum.Font.GothamBold
    b.TextSize = 14
    b.Parent = Main

    Instance.new("UICorner",b).CornerRadius = UDim.new(0,6)
    return b
end

local Hide = createButton("-", -43, Color3.fromRGB(65,65,85))
local Close = createButton("X", -8, Color3.fromRGB(170,55,75))

local running = true
local controllers = {}

local function createOption(name,note,y,remoteEvents)
    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(0,165,0,25)
    Label.Position = UDim2.new(0,15,0,y)
    Label.BackgroundTransparency = 1
    Label.Text = name
    Label.TextColor3 = Color3.fromRGB(225,220,240)
    Label.Font = Enum.Font.GothamBold
    Label.TextSize = 14
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.Parent = Main

    local Note = Instance.new("TextLabel")
    Note.Size = UDim2.new(0,175,0,20)
    Note.Position = UDim2.new(0,15,0,y+23)
    Note.BackgroundTransparency = 1
    Note.Text = note
    Note.TextColor3 = Color3.fromRGB(130,130,145)
    Note.Font = Enum.Font.Gotham
    Note.TextSize = 10
    Note.TextXAlignment = Enum.TextXAlignment.Left
    Note.Parent = Main

    local Toggle = Instance.new("TextButton")
    Toggle.Size = UDim2.new(0,55,0,27)
    Toggle.Position = UDim2.new(1,-70,0,y+7)
    Toggle.BackgroundColor3 = Color3.fromRGB(65,65,80)
    Toggle.Text = "OFF"
    Toggle.TextColor3 = Color3.new(1,1,1)
    Toggle.Font = Enum.Font.GothamBold
    Toggle.TextSize = 12
    Toggle.Parent = Main

    Instance.new("UICorner",Toggle).CornerRadius = UDim.new(0,7)

    local Active = false
    local generation = 0

    local function updateVisual()
        Toggle.Text = Active and "ON" or "OFF"
        Toggle.BackgroundColor3 = Active
            and Color3.fromRGB(115,65,190)
            or Color3.fromRGB(65,65,80)
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
                    if not running
                        or not Active
                        or generation ~= currentGeneration then
                        break
                    end

                    action.remote:FireServer(
                        table.unpack(action.args or {})
                    )
                end

                task.wait(INTERVAL)
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

    table.insert(controllers,stop)

    return function()
        return Active
    end
end

-- KILL AURA: cuatro acciones
local KillAuraEnabled = createOption(
    "KILL AURA",
    "Strength farm",
    65,
    {
        {remote = JumpKick},
        {remote = HandKick},
        {remote = JumpKick, args = {2}},
        {remote = DoubleReg}
    }
)

-- SPAM SWEEP: Stun
local SpamSweepEnabled = createOption(
    "SPAM SWEEP",
    "-",
    145,
    {
        {remote = Stun}
    }
)

-- Menú minimizado
local Mini = Instance.new("TextButton")
Mini.Size = UDim2.new(0,110,0,38)
Mini.Position = UDim2.new(0,15,0.5,0)
Mini.AnchorPoint = Vector2.new(0,0.5)
Mini.BackgroundColor3 = Color3.fromRGB(30,24,45)
Mini.Text = "LEREIK HUB  +"
Mini.TextColor3 = Color3.fromRGB(190,150,255)
Mini.Font = Enum.Font.GothamBold
Mini.TextSize = 12
Mini.Visible = false
Mini.Parent = ScreenGui

Instance.new("UICorner",Mini).CornerRadius = UDim.new(0,8)

Hide.MouseButton1Click:Connect(function()
    Main.Visible = false
    Mini.Visible = true
end)

Mini.MouseButton1Click:Connect(function()
    Main.Visible = true
    Mini.Visible = false
end)

local function cleanup()
    if not running then
        return
    end

    running = false

    for _,stop in ipairs(controllers) do
        stop()
    end
end

_G.LereikHubCleanup = cleanup

Close.MouseButton1Click:Connect(function()
    cleanup()
    ScreenGui:Destroy()
end)

ScreenGui.Destroying:Connect(cleanup)