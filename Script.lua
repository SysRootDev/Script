-- FNAF Steal Script by Devs_Sync
-- VERSAO REFATORADA - 100% FUNCIONAL

local success, err = pcall(function()

local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- Obter o local correto para a GUI
local ScreenParent = LocalPlayer:WaitForChild("PlayerGui")
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local LogService = game:GetService("LogService")

-- Variaveis Globais
local SavedBasePosition = nil
local NoclipConnection = nil
local RagdollAuraConnection = nil
local SpeedConnection = nil
local AntiDamageConnection = nil
local FlyingConnection = nil
local DiscoveredLockMethod = nil -- Método de bloqueio descoberto pelo Debug
local ragdollCooldowns = {}
local isMinimized = false
local SavedMainSize = nil
local SavedMainPosition = nil
local FlyingData = {enabled = false, velocity = Vector3.new(0, 0, 0), speed = 50}


local CustomSettings = {
    SpeedEnabled = false,
    SpeedValue = 50,
    NoclipEnabled = false,
    RagdollAuraEnabled = false,
    RagdollDistance = 15,
    ESPEnabled = false,
    FunctionESPEnabled = false,
    ESPColor = Color3.fromRGB(255, 100, 100),
    BorderEnabled = false,
    BorderSpeed = 3,
    AntiDamageEnabled = false,
    InvisibilityEnabled = false,
    BaseTimerESPEnabled = false,
    FlyingEnabled = false,
    FlyingSpeed = 50
}

local foundFNAFs = {}
local isWorking = false
local isDragging = false
local dragStart = nil
local startPos = nil
local espElements = {}
local baseTimerElements = {}
local BaseTimerConnection = nil
local currentTab = "Main"
local SpotAutoLockThread = nil

-- Criar ScreenGui
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "Devs_SyncStealGUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = ScreenParent

-- Frame Principal
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 320, 0, 450)
MainFrame.Position = UDim2.new(0.5, -160, 0.5, -225)
MainFrame.BackgroundColor3 = Color3.fromRGB(18, 18, 22)
MainFrame.BorderSizePixel = 0
MainFrame.ClipsDescendants = true
MainFrame.Parent = ScreenGui

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 16)
MainCorner.Parent = MainFrame

-- Borda Gradiente
local BorderGradient = Instance.new("UIStroke")
BorderGradient.Name = "BorderGradient"
BorderGradient.Color = Color3.fromRGB(100, 100, 255)
BorderGradient.Thickness = 2
BorderGradient.Transparency = 0.3
BorderGradient.Parent = MainFrame

-- Barra de Titulo
local TitleBar = Instance.new("Frame")
TitleBar.Size = UDim2.new(1, 0, 0, 50)
TitleBar.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
TitleBar.BorderSizePixel = 0
TitleBar.Parent = MainFrame

local TitleBarCorner = Instance.new("UICorner")
TitleBarCorner.CornerRadius = UDim.new(0, 16)
TitleBarCorner.Parent = TitleBar

local TitleBarFix = Instance.new("Frame")
TitleBarFix.Size = UDim2.new(1, 0, 0, 16)
TitleBarFix.Position = UDim2.new(0, 0, 1, -16)
TitleBarFix.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
TitleBarFix.BorderSizePixel = 0
TitleBarFix.Parent = TitleBar

-- Logo
local LogoFrame = Instance.new("Frame")
LogoFrame.Size = UDim2.new(0, 36, 0, 36)
LogoFrame.Position = UDim2.new(0, 12, 0.5, -18)
LogoFrame.BackgroundColor3 = Color3.fromRGB(100, 100, 255)
LogoFrame.BorderSizePixel = 0
LogoFrame.Parent = TitleBar

local LogoCorner = Instance.new("UICorner")
LogoCorner.CornerRadius = UDim.new(0, 8)
LogoCorner.Parent = LogoFrame

local LogoGradient = Instance.new("UIGradient")
LogoGradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(120, 100, 255)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(80, 200, 255))
}
LogoGradient.Rotation = 45
LogoGradient.Parent = LogoFrame

local LogoText = Instance.new("TextLabel")
LogoText.Size = UDim2.new(1, 0, 1, 0)
LogoText.BackgroundTransparency = 1
LogoText.Text = "D"
LogoText.TextColor3 = Color3.fromRGB(255, 255, 255)
LogoText.TextSize = 20
LogoText.Font = Enum.Font.GothamBold
LogoText.Parent = LogoFrame

-- Titulo
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(0, 150, 1, 0)
Title.Position = UDim2.new(0, 56, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "Devs Sync"
Title.TextColor3 = Color3.fromRGB(240, 240, 245)
Title.TextSize = 16
Title.Font = Enum.Font.GothamBold
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = TitleBar

local Subtitle = Instance.new("TextLabel")
Subtitle.Size = UDim2.new(0, 150, 0, 14)
Subtitle.Position = UDim2.new(0, 56, 0, 26)
Subtitle.BackgroundTransparency = 1
Subtitle.Text = "Premium Edition"
Subtitle.TextColor3 = Color3.fromRGB(140, 140, 160)
Subtitle.TextSize = 9
Subtitle.Font = Enum.Font.Gotham
Subtitle.TextXAlignment = Enum.TextXAlignment.Left
Subtitle.Parent = TitleBar

-- Botao Minimizar
local MinimizeBtn = Instance.new("TextButton")
MinimizeBtn.Size = UDim2.new(0, 32, 0, 32)
MinimizeBtn.Position = UDim2.new(1, -76, 0.5, -16)
MinimizeBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
MinimizeBtn.BorderSizePixel = 0
MinimizeBtn.Text = "—"
MinimizeBtn.TextColor3 = Color3.fromRGB(200, 200, 220)
MinimizeBtn.TextSize = 16
MinimizeBtn.Font = Enum.Font.GothamBold
MinimizeBtn.Parent = TitleBar

local MinimizeCorner = Instance.new("UICorner")
MinimizeCorner.CornerRadius = UDim.new(0, 8)
MinimizeCorner.Parent = MinimizeBtn

-- Botao Fechar
local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 32, 0, 32)
CloseBtn.Position = UDim2.new(1, -38, 0.5, -16)
CloseBtn.BackgroundColor3 = Color3.fromRGB(220, 60, 80)
CloseBtn.BorderSizePixel = 0
CloseBtn.Text = "✕"
CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseBtn.TextSize = 16
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.Parent = TitleBar

local CloseCorner = Instance.new("UICorner")
CloseCorner.CornerRadius = UDim.new(0, 8)
CloseCorner.Parent = CloseBtn

-- Botao Fechar e Minimizar: implementar comportamento
CloseBtn.MouseButton1Click:Connect(function()
    pcall(function() ScreenGui:Destroy() end)
end)

MinimizeBtn.MouseButton1Click:Connect(function()
    if not isMinimized then
        SavedMainSize = MainFrame.Size
        SavedMainPosition = MainFrame.Position
        isMinimized = true
        TweenService:Create(MainFrame, TweenInfo.new(0.18), {Size = UDim2.new(0, 320, 0, 50)}):Play()
        TabsContainer.Visible = false
        ContentContainer.Visible = false
        BorderGradient.Transparency = 1
    else
        isMinimized = false
        if SavedMainSize then
            TweenService:Create(MainFrame, TweenInfo.new(0.18), {Size = SavedMainSize}):Play()
        end
        TabsContainer.Visible = true
        ContentContainer.Visible = true
        BorderGradient.Transparency = 0.3
    end
end)

-- Painel de Erros (toggle) para capturar mensagens do console
local recentErrors = {}
local function addRecentError(msg)
    table.insert(recentErrors, 1, msg)
    if #recentErrors > 30 then
        for i = 31, #recentErrors do recentErrors[i] = nil end
    end
end

local ErrorsBtn = Instance.new("TextButton")
ErrorsBtn.Size = UDim2.new(0, 28, 0, 28)
ErrorsBtn.Position = UDim2.new(1, -114, 0.5, -14)
ErrorsBtn.BackgroundColor3 = Color3.fromRGB(200, 150, 50)
ErrorsBtn.BorderSizePixel = 0
ErrorsBtn.Text = "!"
ErrorsBtn.TextColor3 = Color3.fromRGB(255,255,255)
ErrorsBtn.TextSize = 16
ErrorsBtn.Font = Enum.Font.GothamBold
ErrorsBtn.Parent = TitleBar

local ErrorFrame = Instance.new("Frame")
ErrorFrame.Size = UDim2.new(0, 420, 0, 220)
ErrorFrame.Position = UDim2.new(1, -440, 0, 60)
ErrorFrame.BackgroundColor3 = Color3.fromRGB(20,20,26)
ErrorFrame.BorderSizePixel = 0
ErrorFrame.Visible = false
ErrorFrame.Parent = MainFrame

local errCorner = Instance.new("UICorner")
errCorner.CornerRadius = UDim.new(0, 8)
errCorner.Parent = ErrorFrame

local errBox = Instance.new("TextBox")
errBox.MultiLine = true
errBox.ClearTextOnFocus = false
errBox.Size = UDim2.new(1, -12, 1, -12)
errBox.Position = UDim2.new(0, 6, 0, 6)
errBox.BackgroundTransparency = 1
errBox.TextColor3 = Color3.fromRGB(230,230,230)
errBox.TextWrapped = true
errBox.TextXAlignment = Enum.TextXAlignment.Left
errBox.TextYAlignment = Enum.TextYAlignment.Top
errBox.Font = Enum.Font.Gotham
errBox.TextSize = 12
errBox.Text = ""
errBox.Parent = ErrorFrame

ErrorsBtn.MouseButton1Click:Connect(function()
    ErrorFrame.Visible = not ErrorFrame.Visible
    if ErrorFrame.Visible then
        errBox.Text = table.concat(recentErrors, "\n\n")
    end
end)

LogService.MessageOut:Connect(function(message, messageType)
    if messageType == Enum.MessageType.MessageError or messageType == Enum.MessageType.MessageWarning or messageType == Enum.MessageType.MessageInfo then
        addRecentError(os.date("%X") .. " — " .. tostring(message))
        if ErrorFrame.Visible then
            errBox.Text = table.concat(recentErrors, "\n\n")
        end
    end
end)

-- Drag para mover o flutuante
TitleBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        isDragging = true
        dragStart = input.Position
        startPos = MainFrame.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                isDragging = false
            end
        end)
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if isDragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - dragStart
        MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

-- Sistema de Abas
local TabsContainer = Instance.new("Frame")
TabsContainer.Size = UDim2.new(1, -24, 0, 44)
TabsContainer.Position = UDim2.new(0, 12, 0, 62)
TabsContainer.BackgroundTransparency = 1
TabsContainer.Parent = MainFrame

local TabsList = Instance.new("UIListLayout")
TabsList.FillDirection = Enum.FillDirection.Horizontal
TabsList.Padding = UDim.new(0, 6)
TabsList.SortOrder = Enum.SortOrder.LayoutOrder
TabsList.Parent = TabsContainer

-- Conteudo das Abas
local ContentContainer = Instance.new("Frame")
ContentContainer.Size = UDim2.new(1, -24, 1, -118)
ContentContainer.Position = UDim2.new(0, 12, 0, 112)
ContentContainer.BackgroundTransparency = 1
ContentContainer.Parent = MainFrame

-- ==================== TODAS AS FUNCOES DE CORE ====================

-- Função auxiliar: SetCharacterCollisions
local function SetCharacterCollisions(char, canCollide)
    if not char then return end
    for _, part in pairs(char:GetDescendants()) do
        if part:IsA("BasePart") then
            part.CanCollide = canCollide
        end
    end
end

-- Função auxiliar: SafeTeleport
local function SafeTeleport(char, targetCFrame)
    if not char or not char:FindFirstChild("HumanoidRootPart") then return end
    local prevNoclip = CustomSettings.NoclipEnabled

    SetCharacterCollisions(char, false)
    pcall(function()
        local hrp = char:FindFirstChild("HumanoidRootPart")
        if hrp then
            hrp.CFrame = targetCFrame + Vector3.new(0, 5, 0)
            hrp.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
            hrp.AssemblyAngularVelocity = Vector3.new(0, 0, 0)
        end
    end)
    task.wait(0.12)
    
    pcall(function()
        local hrp = char:FindFirstChild("HumanoidRootPart")
        if hrp then
            hrp.CFrame = targetCFrame + Vector3.new(0, 3, 0)
            hrp.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
        end
    end)
    task.wait(0.08)

    -- Always restore collisions unless noclip is active
    if not prevNoclip then
        SetCharacterCollisions(char, true)
    end
end

-- Função auxiliar: RemoveExternalForces
local function RemoveExternalForces(char)
    if not char then return end
    for _, part in pairs(char:GetDescendants()) do
        if part:IsA("BasePart") then
            for _, fx in pairs(part:GetChildren()) do
                if fx:IsA("BodyVelocity") or fx:IsA("BodyForce") or fx:IsA("BodyGyro") or fx:IsA("BodyAngularVelocity") or fx:IsA("VectorForce") or fx:IsA("LinearVelocity") then
                    pcall(function() fx:Destroy() end)
                end
            end
            pcall(function()
                part.AssemblyLinearVelocity = Vector3.new(0,0,0)
                part.AssemblyAngularVelocity = Vector3.new(0,0,0)
            end)
        end
    end
end

-- ==================== FUNCOES GLOBAIS ====================

function CreateESP()
    ClearESP()
    if not CustomSettings.ESPEnabled then return end
    
    for _, data in pairs(foundFNAFs) do
        if data.FNaFPosition and data.FNaFPosition.Parent then
            local esp = Instance.new("BillboardGui")
            esp.Name = "FNaFESP"
            esp.Adornee = data.FNaFPosition
            esp.Size = UDim2.new(0, 120, 0, 50)
            esp.StudsOffset = Vector3.new(0, 2, 0)
            esp.AlwaysOnTop = true
            esp.Parent = data.FNaFPosition
            
            local frame = Instance.new("Frame")
            frame.Size = UDim2.new(1, 0, 1, 0)
            frame.BackgroundColor3 = CustomSettings.ESPColor
            frame.BackgroundTransparency = 0.6
            frame.BorderSizePixel = 0
            frame.Parent = esp
            
            local corner = Instance.new("UICorner")
            corner.CornerRadius = UDim.new(0, 8)
            corner.Parent = frame
            
            local text = Instance.new("TextLabel")
            text.Size = UDim2.new(1, -8, 1, -8)
            text.Position = UDim2.new(0, 4, 0, 4)
            text.BackgroundTransparency = 1
            text.Text = "🎮 " .. data.Owner .. "\n" .. data.SlotName
            text.TextColor3 = Color3.fromRGB(255, 255, 255)
            text.TextSize = 11
            text.Font = Enum.Font.GothamBold
            text.TextStrokeTransparency = 0.5
            text.TextWrapped = true
            text.Parent = frame
            
            table.insert(espElements, esp)
        end
    end
end

function ClearESP()
    for _, esp in pairs(espElements) do
        if esp and esp.Parent then
            esp:Destroy()
        end
    end
    espElements = {}
end

local functionESPElements = {}

function CreateFunctionESP()
    ClearFunctionESP()
    if not CustomSettings.FunctionESPEnabled then return end
    
    local function AddESPForObject(obj)
        if obj:IsDescendantOf(LocalPlayer.Character or Instance.new("Model")) then return end
        
        local adornee = nil
        local displayText = obj.Name
        
        -- Encontrar uma BasePart ou Model para colocar o adornee
        if obj:IsA("BasePart") then
            adornee = obj
        elseif obj:IsA("Model") and obj.PrimaryPart and obj.PrimaryPart:IsA("BasePart") then
            adornee = obj.PrimaryPart
        else
            -- Tentar encontrar uma BasePart dentro
            for _, desc in pairs(obj:GetDescendants()) do
                if desc:IsA("BasePart") then
                    adornee = desc
                    break
                end
            end
        end
        
        -- Para TextLabel, TextBox, etc, buscar a parte pai
        if not adornee and obj.Parent then
            if obj:IsA("TextLabel") or obj:IsA("TextBox") or obj:IsA("StringValue") or obj:IsA("NumberValue") then
                local par = obj.Parent
                while par and not adornee do
                    if par:IsA("BasePart") then
                        adornee = par
                    elseif par:IsA("Model") and par.PrimaryPart and par.PrimaryPart:IsA("BasePart") then
                        adornee = par.PrimaryPart
                    end
                    par = par.Parent
                end
            end
        end
        
        if adornee and adornee.Parent then
            -- Determinar o texto a exibir
            if obj:IsA("TextLabel") or obj:IsA("TextBox") then
                displayText = obj.Text or obj.Name
            elseif obj:IsA("StringValue") then
                displayText = obj.Name .. ": " .. (obj.Value or "")
            elseif obj:IsA("NumberValue") then
                displayText = obj.Name .. ": " .. tostring(obj.Value or 0)
            end
            
            -- Não exibir se vazio ou muito curto
            if displayText == "" or displayText == nil then return end
            
            local esp = Instance.new("BillboardGui")
            esp.Name = "FunctionESP"
            esp.Adornee = adornee
            esp.Size = UDim2.new(0, 140, 0, 40)
            esp.StudsOffset = Vector3.new(0, 3, 0)
            esp.AlwaysOnTop = true
            esp.Parent = adornee
            
            local frame = Instance.new("Frame")
            frame.Size = UDim2.new(1, 0, 1, 0)
            frame.BackgroundColor3 = Color3.fromRGB(100, 150, 255)
            frame.BackgroundTransparency = 0.4
            frame.BorderSizePixel = 0
            frame.Parent = esp
            
            local corner = Instance.new("UICorner")
            corner.CornerRadius = UDim.new(0, 6)
            corner.Parent = frame
            
            local text = Instance.new("TextLabel")
            text.Size = UDim2.new(1, -4, 1, -4)
            text.Position = UDim2.new(0, 2, 0, 2)
            text.BackgroundTransparency = 1
            text.Text = displayText
            text.TextColor3 = Color3.fromRGB(255, 255, 255)
            text.TextSize = 9
            text.Font = Enum.Font.GothamBold
            text.TextScaled = true
            text.TextWrapped = true
            text.TextStrokeTransparency = 0.5
            text.Parent = frame
            
            table.insert(functionESPElements, esp)
        end
    end
    
    -- Buscar em Bases e todos os seus descendentes
    local basesFolder = Workspace:FindFirstChild("Bases")
    if basesFolder then
        for _, base in pairs(basesFolder:GetChildren()) do
            AddESPForObject(base)
            -- Mostrar todos os itens dentro da base (BasePart, Model, TextLabel, StringValue, NumberValue, etc)
            for _, child in pairs(base:GetDescendants()) do
                if child:IsA("Model") or child:IsA("BasePart") or child:IsA("TextLabel") or child:IsA("TextBox") or child:IsA("StringValue") or child:IsA("NumberValue") or child:IsA("IntValue") or child:IsA("BoolValue") then
                    AddESPForObject(child)
                end
            end
        end
    end
    
    -- Também buscar em outras pastas importantes
    local searchFolders = {"Storage", "Doors", "Chests", "Locked", "Items"}
    for _, folderName in pairs(searchFolders) do
        local folder = Workspace:FindFirstChild(folderName)
        if folder then
            for _, obj in pairs(folder:GetChildren()) do
                AddESPForObject(obj)
                for _, child in pairs(obj:GetDescendants()) do
                    if child:IsA("Model") or child:IsA("BasePart") or child:IsA("TextLabel") or child:IsA("TextBox") or child:IsA("StringValue") or child:IsA("NumberValue") or child:IsA("IntValue") or child:IsA("BoolValue") then
                        AddESPForObject(child)
                    end
                end
            end
        end
    end
end

function ClearFunctionESP()
    for _, esp in pairs(functionESPElements) do
        if esp and esp.Parent then
            esp:Destroy()
        end
    end
    functionESPElements = {}
end

function CreateBaseTimerESP()
    ClearBaseTimerESP()
    if not CustomSettings.BaseTimerESPEnabled then return end
    if not Workspace:FindFirstChild("Bases") then return end

    local function FindAdorneeForModel(model)
        if not model then return nil end
        if model.PrimaryPart and model.PrimaryPart:IsA("BasePart") then
            return model.PrimaryPart
        end
        local names = {"Base", "Root", "HumanoidRootPart", "BasePart"}
        for _, name in pairs(names) do
            local part = model:FindFirstChild(name)
            if part and part:IsA("BasePart") then
                return part
            end
        end
        for _, desc in pairs(model:GetDescendants()) do
            if desc:IsA("BasePart") then
                return desc
            end
        end
        return nil
    end

    local function FormatTime(t)
        if not t then return "—" end
        if t <= 0 then return "Aberto" end
        local minutes = math.floor(t/60)
        local seconds = math.floor(t%60)
        return string.format("%02d:%02d", minutes, seconds)
    end

    for _, base in pairs(Workspace.Bases:GetChildren()) do
        local adornee = FindAdorneeForModel(base)
        if adornee then
            local gui = Instance.new("BillboardGui")
            gui.Name = "BaseTimerESP"
            gui.Adornee = adornee
            gui.Size = UDim2.new(0, 140, 0, 40)
            gui.StudsOffset = Vector3.new(0, 3, 0)
            gui.AlwaysOnTop = true
            gui.Parent = adornee

            local frame = Instance.new("Frame")
            frame.Size = UDim2.new(1, 0, 1, 0)
            frame.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
            frame.BackgroundTransparency = 0.3
            frame.BorderSizePixel = 0
            frame.Parent = gui

            local nameLabel = Instance.new("TextLabel")
            nameLabel.Size = UDim2.new(1, -8, 0, 16)
            nameLabel.Position = UDim2.new(0, 4, 0, 2)
            nameLabel.BackgroundTransparency = 1
            nameLabel.Text = base.Name
            nameLabel.TextColor3 = Color3.fromRGB(255,255,255)
            nameLabel.TextSize = 11
            nameLabel.Font = Enum.Font.GothamBold
            nameLabel.TextXAlignment = Enum.TextXAlignment.Center
            nameLabel.Parent = frame

            local timerLabel = Instance.new("TextLabel")
            timerLabel.Size = UDim2.new(1, -8, 0, 18)
            timerLabel.Position = UDim2.new(0, 4, 0, 18)
            timerLabel.BackgroundTransparency = 1
            timerLabel.Text = "--:--"
            timerLabel.TextColor3 = Color3.fromRGB(200,200,200)
            timerLabel.TextSize = 10
            timerLabel.Font = Enum.Font.Gotham
            timerLabel.TextXAlignment = Enum.TextXAlignment.Center
            timerLabel.Parent = frame

            table.insert(baseTimerElements, {Base = base, Gui = gui, TimerLabel = timerLabel})
        end
    end

    if BaseTimerConnection then BaseTimerConnection:Disconnect() end
    BaseTimerConnection = RunService.Heartbeat:Connect(function()
        for _, entry in pairs(baseTimerElements) do
            local base = entry.Base
            local timerLabel = entry.TimerLabel
            if base and base.Parent and timerLabel then
                local remaining = nil
                local nv = base:FindFirstChild("OpenTime") or base:FindFirstChild("OpenCooldown") or base:FindFirstChild("NextOpen")
                if nv and nv:IsA("NumberValue") then
                    remaining = nv.Value
                else
                        local attr = base:GetAttribute("NextOpen") or base:GetAttribute("OpenAt")
                    if type(attr) == "number" then
                        remaining = attr - tick()
                    end
                end

                local function FormatTimeInner(t)
                    if not t then return "—" end
                    if t <= 0 then return "Aberto" end
                    local minutes = math.floor(t/60)
                    local seconds = math.floor(t%60)
                    return string.format("%02d:%02d", minutes, seconds)
                end
                timerLabel.Text = FormatTimeInner(remaining)
            end
        end
    end)
end

function ClearBaseTimerESP()
    if BaseTimerConnection then
        BaseTimerConnection:Disconnect()
        BaseTimerConnection = nil
    end
    for _, entry in pairs(baseTimerElements) do
        if entry.Gui and entry.Gui.Parent then
            entry.Gui:Destroy()
        end
    end
    baseTimerElements = {}
end

function EnableNoclip()
    if NoclipConnection then return end
    
    NoclipConnection = RunService.Stepped:Connect(function()
        if CustomSettings.NoclipEnabled then
            local char = LocalPlayer.Character
            if char then
                for _, part in pairs(char:GetDescendants()) do
                    if part:IsA("BasePart") then
                        part.CanCollide = false
                    end
                end
            end
        end
    end)
end

function DisableNoclip()
    if NoclipConnection then
        NoclipConnection:Disconnect()
        NoclipConnection = nil
    end
    
    local char = LocalPlayer.Character
    if char then
        for _, part in pairs(char:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = true
            end
        end
    end
end

function EnableSpeed()
    if SpeedConnection then return end
    
    local char = LocalPlayer.Character
    if char and char:FindFirstChild("Humanoid") then
        char.Humanoid.WalkSpeed = CustomSettings.SpeedValue
    end
    
    SpeedConnection = RunService.Heartbeat:Connect(function()
        if CustomSettings.SpeedEnabled then
            local char = LocalPlayer.Character
            if char and char:FindFirstChild("Humanoid") then
                if char.Humanoid.WalkSpeed ~= CustomSettings.SpeedValue then
                    char.Humanoid.WalkSpeed = CustomSettings.SpeedValue
                end
            end
        end
    end)
end

function DisableSpeed()
    if SpeedConnection then
        SpeedConnection:Disconnect()
        SpeedConnection = nil
    end
    
    local char = LocalPlayer.Character
    if char and char:FindFirstChild("Humanoid") then
        char.Humanoid.WalkSpeed = 16
    end
end

-- ==================== FLYING CARPET ====================

function EnableFlying()
    if FlyingConnection then return end
    
    local char = LocalPlayer.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return end
    
    local hrp = char:FindFirstChild("HumanoidRootPart")
    local humanoid = char:FindFirstChild("Humanoid")
    
    -- Criar BodyVelocity para controlar a velocidade
    local bodyVelocity = Instance.new("BodyVelocity")
    bodyVelocity.Name = "FlyingVelocity"
    bodyVelocity.Parent = hrp
    bodyVelocity.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
    bodyVelocity.Velocity = Vector3.new(0, 0, 0)
    bodyVelocity.P = 10000
    
    -- Criar GUI de controle de voo
    local flyingGui = Instance.new("ScreenGui")
    flyingGui.Name = "FlyingControlGui"
    flyingGui.ResetOnSpawn = false
    flyingGui.Parent = ScreenParent
    
    -- Frame principal dos controles
    local controlFrame = Instance.new("Frame")
    controlFrame.Name = "ControlFrame"
    controlFrame.Size = UDim2.new(0, 120, 0, 140)
    controlFrame.Position = UDim2.new(1, -140, 0.5, -70)
    controlFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
    controlFrame.BorderSizePixel = 0
    controlFrame.Parent = flyingGui
    
    local cornerControl = Instance.new("UICorner")
    cornerControl.CornerRadius = UDim.new(0, 12)
    cornerControl.Parent = controlFrame
    
    local strokeControl = Instance.new("UIStroke")
    strokeControl.Color = Color3.fromRGB(100, 100, 255)
    strokeControl.Thickness = 2
    strokeControl.Transparency = 0.3
    strokeControl.Parent = controlFrame
    
    -- Título dos controles
    local titleLabel = Instance.new("TextLabel")
    titleLabel.Name = "Title"
    titleLabel.Size = UDim2.new(1, 0, 0, 30)
    titleLabel.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
    titleLabel.BorderSizePixel = 0
    titleLabel.Text = "🧞 Voo"
    titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    titleLabel.TextSize = 14
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.Parent = controlFrame
    
    local titleCorner = Instance.new("UICorner")
    titleCorner.CornerRadius = UDim.new(0, 12)
    titleCorner.Parent = titleLabel
    
    -- Botão de subir
    local upButton = Instance.new("TextButton")
    upButton.Name = "UpButton"
    upButton.Size = UDim2.new(1, -8, 0, 38)
    upButton.Position = UDim2.new(0, 4, 0, 36)
    upButton.BackgroundColor3 = Color3.fromRGB(50, 150, 255)
    upButton.BorderSizePixel = 0
    upButton.Text = "⬆️ Subir"
    upButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    upButton.TextSize = 12
    upButton.Font = Enum.Font.GothamBold
    upButton.Parent = controlFrame
    
    local upCorner = Instance.new("UICorner")
    upCorner.CornerRadius = UDim.new(0, 6)
    upCorner.Parent = upButton
    
    -- Botão de descer
    local downButton = Instance.new("TextButton")
    downButton.Name = "DownButton"
    downButton.Size = UDim2.new(1, -8, 0, 38)
    downButton.Position = UDim2.new(0, 4, 0, 78)
    downButton.BackgroundColor3 = Color3.fromRGB(255, 100, 100)
    downButton.BorderSizePixel = 0
    downButton.Text = "⬇️ Descer"
    downButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    downButton.TextSize = 12
    downButton.Font = Enum.Font.GothamBold
    downButton.Parent = controlFrame
    
    local downCorner = Instance.new("UICorner")
    downCorner.CornerRadius = UDim.new(0, 6)
    downCorner.Parent = downButton
    
    -- Variáveis de controle
    local keysPressed = {}
    local isPressingUp = false
    local isPressingDown = false
    
    -- Função para simular tecla space pressionada
    upButton.MouseButton1Down:Connect(function()
        isPressingUp = true
        keysPressed.Space = true
        upButton.BackgroundColor3 = Color3.fromRGB(30, 120, 200)
    end)
    
    upButton.MouseButton1Up:Connect(function()
        isPressingUp = false
        keysPressed.Space = false
        upButton.BackgroundColor3 = Color3.fromRGB(50, 150, 255)
    end)
    
    -- Função para simular tecla ctrl pressionada
    downButton.MouseButton1Down:Connect(function()
        isPressingDown = true
        keysPressed.LeftControl = true
        downButton.BackgroundColor3 = Color3.fromRGB(200, 80, 80)
    end)
    
    downButton.MouseButton1Up:Connect(function()
        isPressingDown = false
        keysPressed.LeftControl = false
        downButton.BackgroundColor3 = Color3.fromRGB(255, 100, 100)
    end)
    
    -- Detectar teclas pressionadas
    local inputConnection = UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if gameProcessed then return end
        
        if input.KeyCode == Enum.KeyCode.W then keysPressed.W = true end
        if input.KeyCode == Enum.KeyCode.A then keysPressed.A = true end
        if input.KeyCode == Enum.KeyCode.S then keysPressed.S = true end
        if input.KeyCode == Enum.KeyCode.D then keysPressed.D = true end
        if input.KeyCode == Enum.KeyCode.Space then keysPressed.Space = true end
        if input.KeyCode == Enum.KeyCode.LeftControl then keysPressed.LeftControl = true end
    end)
    
    -- Detectar teclas soltas
    local inputEndConnection = UserInputService.InputEnded:Connect(function(input, gameProcessed)
        if input.KeyCode == Enum.KeyCode.W then keysPressed.W = false end
        if input.KeyCode == Enum.KeyCode.A then keysPressed.A = false end
        if input.KeyCode == Enum.KeyCode.S then keysPressed.S = false end
        if input.KeyCode == Enum.KeyCode.D then keysPressed.D = false end
        if input.KeyCode == Enum.KeyCode.Space then keysPressed.Space = false end
        if input.KeyCode == Enum.KeyCode.LeftControl then keysPressed.LeftControl = false end
    end)
    
    -- Loop de voo
    FlyingConnection = RunService.RenderStepped:Connect(function()
        if not CustomSettings.FlyingEnabled then return end
        
        local char = LocalPlayer.Character
        if not char or not char:FindFirstChild("HumanoidRootPart") then return end
        
        local hrp = char:FindFirstChild("HumanoidRootPart")
        if not hrp or not bodyVelocity or not bodyVelocity.Parent then return end
        
        -- Obter a câmera para direção
        local camera = workspace.CurrentCamera
        local moveDirection = Vector3.new(0, 0, 0)
        
        -- Calcular direção baseado no que o usuário pressiona
        if keysPressed.W then
            moveDirection = moveDirection + (camera.CFrame.LookVector * Vector3.new(1, 0, 1)).Unit
        end
        if keysPressed.S then
            moveDirection = moveDirection - (camera.CFrame.LookVector * Vector3.new(1, 0, 1)).Unit
        end
        if keysPressed.D then
            moveDirection = moveDirection + camera.CFrame.RightVector
        end
        if keysPressed.A then
            moveDirection = moveDirection - camera.CFrame.RightVector
        end
        
        -- Movimento vertical
        if keysPressed.Space then
            moveDirection = moveDirection + Vector3.new(0, 1, 0)
        end
        if keysPressed.LeftControl then
            moveDirection = moveDirection + Vector3.new(0, -1, 0)
        end
        
        -- Normalizar e aplicar velocidade
        if moveDirection.Magnitude > 0 then
            moveDirection = moveDirection.Unit
        end
        
        bodyVelocity.Velocity = moveDirection * CustomSettings.FlyingSpeed
    end)
    
    -- Guardar as conexões para desconectar depois
    FlyingData.bodyVelocity = bodyVelocity
    FlyingData.inputConnection = inputConnection
    FlyingData.inputEndConnection = inputEndConnection
    FlyingData.flyingGui = flyingGui
end

function DisableFlying()
    if FlyingConnection then
        FlyingConnection:Disconnect()
        FlyingConnection = nil
    end
    
    if FlyingData.inputConnection then
        FlyingData.inputConnection:Disconnect()
        FlyingData.inputConnection = nil
    end
    
    if FlyingData.inputEndConnection then
        FlyingData.inputEndConnection:Disconnect()
        FlyingData.inputEndConnection = nil
    end
    
    if FlyingData.bodyVelocity and FlyingData.bodyVelocity.Parent then
        FlyingData.bodyVelocity:Destroy()
        FlyingData.bodyVelocity = nil
    end
    
    if FlyingData.flyingGui and FlyingData.flyingGui.Parent then
        FlyingData.flyingGui:Destroy()
        FlyingData.flyingGui = nil
    end
    
    local char = LocalPlayer.Character
    if char and char:FindFirstChild("Humanoid") then
        char.Humanoid.WalkSpeed = 16
    end
end

-- Invisibility helpers (robust storage + reconnect)
local invisSaved = {parts = {}, conn = nil, char = nil}

local function SaveAndHideCharacter(char)
    if not char then return end
    invisSaved.char = char
    invisSaved.parts = invisSaved.parts or {}
    for _, part in pairs(char:GetDescendants()) do
        if part:IsA("BasePart") then
            if not invisSaved.parts[part] then
                invisSaved.parts[part] = {
                    Transparency = part.Transparency,
                    LocalTransparencyModifier = part.LocalTransparencyModifier
                }
            end
            pcall(function()
                part.Transparency = 1
                pcall(function() part.LocalTransparencyModifier = 1 end)
            end)
        elseif part:IsA("Decal") or part:IsA("Texture") then
            if not invisSaved.parts[part] then
                invisSaved.parts[part] = {Transparency = part.Transparency}
            end
            pcall(function() part.Transparency = 1 end)
        end
    end
    pcall(function()
        local hrp = char:FindFirstChild("HumanoidRootPart")
        if hrp then pcall(function() hrp.LocalTransparencyModifier = 1 end) end
    end)
end

local function RestoreCharacterVisibility()
    local char = invisSaved.char
    if not char then return end
    for inst, vals in pairs(invisSaved.parts or {}) do
        if inst and inst.Parent then
            pcall(function()
                if vals.Transparency ~= nil then inst.Transparency = vals.Transparency end
                if vals.LocalTransparencyModifier ~= nil and inst:IsA("BasePart") then
                    pcall(function() inst.LocalTransparencyModifier = vals.LocalTransparencyModifier end)
                end
            end)
        end
    end
    invisSaved.parts = {}
    invisSaved.char = nil
    -- no humanoid changes restored; invisibility is visual-only to avoid physics issues
end

function EnableInvisibility()
    CustomSettings.InvisibilityEnabled = true
    local char = LocalPlayer.Character
    if char then SaveAndHideCharacter(char) end
    if invisSaved.conn then
        pcall(function() invisSaved.conn:Disconnect() end)
        invisSaved.conn = nil
    end
    if char then
        invisSaved.conn = char.DescendantAdded:Connect(function()
            if CustomSettings.InvisibilityEnabled then
                task.wait(0.02)
                SaveAndHideCharacter(LocalPlayer.Character)
            end
        end)
    end
end

function DisableInvisibility()
    CustomSettings.InvisibilityEnabled = false
    if invisSaved.conn then
        pcall(function() invisSaved.conn:Disconnect() end)
        invisSaved.conn = nil
    end
    RestoreCharacterVisibility()
end

local function RagdollPlayer(player)
    if player == LocalPlayer then return end
    
    local char = player.Character
    if not char then return end
    
    local humanoid = char:FindFirstChild("Humanoid")
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not humanoid or not hrp then return end
    
    spawn(function()
        pcall(function()
            local pushDir = (hrp.Position - (LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") and LocalPlayer.Character.HumanoidRootPart.Position or hrp.Position))
            if pushDir and pushDir.Magnitude > 0 then
                pushDir = pushDir.Unit
            else
                pushDir = Vector3.new(math.random(-1,1), 0.5, math.random(-1,1)).Unit
            end

            local bv = Instance.new("BodyVelocity")
            bv.MaxForce = Vector3.new(1e7, 1e7, 1e7)
            bv.Velocity = pushDir * 140 + Vector3.new(0, -40, 0)
            bv.P = 2000
            bv.Parent = hrp
            game:GetService("Debris"):AddItem(bv, 0.8)

            local ba = Instance.new("BodyAngularVelocity")
            ba.MaxTorque = Vector3.new(2e6, 2e6, 2e6)
            ba.AngularVelocity = Vector3.new(math.random(-120,120), math.random(-120,120), math.random(-120,120))
            ba.Parent = hrp
            game:GetService("Debris"):AddItem(ba, 0.8)

            -- small secondary shock after a short delay
            task.delay(0.08, function()
                pcall(function()
                    if hrp and hrp.Parent then
                        hrp.AssemblyLinearVelocity = (pushDir * 60) + Vector3.new(0, -120, 0)
                    end
                end)
            end)
        end)
    end)
    
    spawn(function()
        pcall(function()
            for _, joint in pairs(char:GetDescendants()) do
                if joint:IsA("Motor6D") or joint:IsA("Motor") then
                    joint.Enabled = false
                    task.delay(0.05, function()
                        if joint and joint.Parent then
                            joint.Enabled = true
                        end
                    end)
                end
            end
        end)
    end)
    
    spawn(function()
        pcall(function()
            pcall(function() humanoid:TakeDamage(20) end)
            pcall(function() humanoid:ChangeState(Enum.HumanoidStateType.Ragdoll) end)
            pcall(function() humanoid:SetStateEnabled(Enum.HumanoidStateType.GettingUp, false) end)
            pcall(function() humanoid.PlatformStand = true end)

            task.delay(1.2, function()
                if humanoid and humanoid.Parent then
                    pcall(function() humanoid:SetStateEnabled(Enum.HumanoidStateType.GettingUp, true) end)
                    pcall(function() humanoid.PlatformStand = false end)
                end
            end)
        end)
    end)
    
    spawn(function()
        pcall(function()
            hrp.AssemblyLinearVelocity = Vector3.new(math.random(-10,10), -40, math.random(-10,10))
            hrp.AssemblyAngularVelocity = Vector3.new(math.random(-30, 30), math.random(-30, 30), math.random(-30, 30))
        end)
    end)
    
    spawn(function()
        pcall(function()
            for _, part in pairs(char:GetDescendants()) do
                if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
                    local vb = Instance.new("BodyVelocity")
                    vb.MaxForce = Vector3.new(1e6, 1e6, 1e6)
                    vb.Velocity = Vector3.new(math.random(-60, 60), -80, math.random(-60, 60))
                    vb.P = 2000
                    vb.Parent = part
                    game:GetService("Debris"):AddItem(vb, 0.6)
                end
            end
        end)
    end)

    -- Forcar queda para o chao (tentativa extra)
    spawn(function()
        pcall(function()
            local down = Instance.new("BodyVelocity")
            down.MaxForce = Vector3.new(1e6, 1e6, 1e6)
            down.Velocity = Vector3.new(0, -150, 0)
            down.P = 1250
            down.Parent = hrp
            game:GetService("Debris"):AddItem(down, 0.6)
        end)
    end)

    spawn(function()
        task.delay(1.5, function()
            if humanoid and humanoid.Parent then
                pcall(function() humanoid.PlatformStand = false end)
            end
        end)
    end)
end

function EnableRagdollAura()
    if RagdollAuraConnection then return end
    
    RagdollAuraConnection = RunService.Heartbeat:Connect(function()
        if not CustomSettings.RagdollAuraEnabled then return end
        
        local char = LocalPlayer.Character
        if not char then return end
        
        local hrp = char:FindFirstChild("HumanoidRootPart")
        if not hrp then return end
        
        for _, player in pairs(Players:GetPlayers()) do
            if player ~= LocalPlayer then
                local targetChar = player.Character
                if targetChar then
                    local targetHrp = targetChar:FindFirstChild("HumanoidRootPart")
                    if targetHrp then
                        local distance = (hrp.Position - targetHrp.Position).Magnitude
                        if distance <= CustomSettings.RagdollDistance then
                            local currentTime = tick()
                            if not ragdollCooldowns[player.UserId] or (currentTime - ragdollCooldowns[player.UserId]) > 0.2 then
                                ragdollCooldowns[player.UserId] = currentTime
                                RagdollPlayer(player)
                            end
                        end
                    end
                end
            end
        end
    end)
end

function DisableRagdollAura()
    if RagdollAuraConnection then
        RagdollAuraConnection:Disconnect()
        RagdollAuraConnection = nil
    end
    ragdollCooldowns = {}
end

function LaunchAttacker(player)
    if not player or player == LocalPlayer then return end

    if type(player) ~= "userdata" or not player:IsA("Player") then return end

    local char = player.Character
    if not char then return end

    local hrp = char:FindFirstChild("HumanoidRootPart")
    local humanoid = char:FindFirstChild("Humanoid")
    if not hrp or not humanoid then return end

    spawn(function()
        pcall(function()
            local myHrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
            local dir = Vector3.new(math.random(-0.5,0.5), 1, math.random(-0.5,0.5)).Unit
            if myHrp then
                local diff = hrp.Position - myHrp.Position
                if diff.Magnitude > 0.1 then
                    dir = diff.Unit + Vector3.new(0, 0.6, 0)
                end
            end

            local launchVelocity = dir.Unit * 200 + Vector3.new(0, 200, 0)

            local bv = Instance.new("BodyVelocity")
            bv.MaxForce = Vector3.new(1e5, 1e5, 1e5)
            bv.Velocity = launchVelocity
            bv.P = 1250
            bv.Parent = hrp
            game:GetService("Debris"):AddItem(bv, 1)

            local ba = Instance.new("BodyAngularVelocity")
            ba.MaxTorque = Vector3.new(1e5, 1e5, 1e5)
            ba.AngularVelocity = Vector3.new(math.random(-50,50), math.random(-50,50), math.random(-50,50))
            ba.Parent = hrp
            game:GetService("Debris"):AddItem(ba, 1)

            pcall(function()
                humanoid:ChangeState(Enum.HumanoidStateType.Ragdoll)
                humanoid.Sit = true
                humanoid.PlatformStand = true
            end)

            pcall(function()
                hrp.AssemblyLinearVelocity = launchVelocity
                hrp.AssemblyAngularVelocity = Vector3.new(math.random(-20,20), math.random(-20,20), math.random(-20,20))
            end)

            task.delay(3, function()
                if humanoid and humanoid.Parent then
                    humanoid.PlatformStand = false
                end
            end)
        end)
    end)
end

local lastHealth = nil

function EnableAntiDamage()
    if AntiDamageConnection then return end
    
    local char = LocalPlayer.Character
    if not char then return end
    
    local humanoid = char:FindFirstChild("Humanoid")
    if not humanoid then return end
    
    lastHealth = humanoid.Health
    
    AntiDamageConnection = humanoid.HealthChanged:Connect(function(health)
        if not CustomSettings.AntiDamageEnabled then return end

        if health < lastHealth then
            local damageTaken = lastHealth - health

            pcall(function() humanoid.Health = humanoid.MaxHealth end)

            local myChar = LocalPlayer.Character
            if myChar then
                RemoveExternalForces(myChar)
                local myHrp = myChar:FindFirstChild("HumanoidRootPart")
                if myHrp then
                    pcall(function()
                        myHrp.AssemblyLinearVelocity = Vector3.new(0,0,0)
                        myHrp.AssemblyAngularVelocity = Vector3.new(0,0,0)
                        myHrp.Velocity = Vector3.new(0,0,0)
                    end)
                end

                -- Check for limbo fall immediately without extra PlatformStand
                task.delay(0.06, function()
                    local hrpNow = myChar and myChar:FindFirstChild("HumanoidRootPart")
                    if hrpNow and hrpNow.Parent then
                        if hrpNow.Position.Y < -50 then
                            if SavedBasePosition then
                                SafeTeleport(myChar, SavedBasePosition)
                            else
                                SafeTeleport(myChar, hrpNow.CFrame + Vector3.new(0,50,0))
                            end
                        end
                    end
                end)
            end

            spawn(function()
                pcall(function()
                    local myChar2 = LocalPlayer.Character
                    if not myChar2 then return end

                    local hrp = myChar2:FindFirstChild("HumanoidRootPart")
                    if not hrp then return end

                    local closestPlayer = nil
                    local closestDistance = 50

                    for _, player in pairs(Players:GetPlayers()) do
                        if player ~= LocalPlayer then
                            local targetChar = player.Character
                            if targetChar then
                                local targetHrp = targetChar:FindFirstChild("HumanoidRootPart")
                                if targetHrp then
                                    local distance = (hrp.Position - targetHrp.Position).Magnitude
                                    if distance < closestDistance then
                                        closestDistance = distance
                                        closestPlayer = player
                                    end
                                end
                            end
                        end
                    end

                    if closestPlayer then
                        LaunchAttacker(closestPlayer)
                    end
                end)
            end)
        end

        lastHealth = health
    end)
    
    local healthCheckConnection = RunService.Heartbeat:Connect(function()
        if not CustomSettings.AntiDamageEnabled then 
            healthCheckConnection:Disconnect()
            return 
        end
        
        local char = LocalPlayer.Character
        if not char then return end
        
        local humanoid = char:FindFirstChild("Humanoid")
        if not humanoid then return end
        
        if humanoid.Health < humanoid.MaxHealth and humanoid.Health > 0 then
            humanoid.Health = humanoid.MaxHealth
        end
    end)
end

function DisableAntiDamage()
    if AntiDamageConnection then
        AntiDamageConnection:Disconnect()
        AntiDamageConnection = nil
    end
    lastHealth = nil
end

function FindFNAFs()
    foundFNAFs = {}
    if not Workspace:FindFirstChild("Bases") then return end

    for _, base in pairs(Workspace.Bases:GetChildren()) do
        if base.Name == LocalPlayer.Name then
            -- skip own base
        else
            -- search for any part named or functioning as FNaFPosition inside the base
            for _, desc in pairs(base:GetDescendants()) do
                if desc:IsA("BasePart") and (desc.Name == "FNaFPosition" or (type(desc.Name) == "string" and desc.Name:lower():find("fnafposition"))) then
                    local slot = desc.Parent
                    local fnafPosition = desc
                    -- try to find an Attachment on the part
                    local attachment = nil
                    for _, c in pairs(fnafPosition:GetChildren()) do
                        if c:IsA("Attachment") then
                            attachment = c
                            break
                        end
                    end

                    -- try to find a proximity prompt (SellAndSteal) in the attachment or nearby
                    local sellAndSteal = nil
                    if attachment then
                        sellAndSteal = attachment:FindFirstChild("SellAndSteal") or attachment:FindFirstChildOfClass("ProximityPrompt")
                    end
                    if not sellAndSteal then
                        -- search descendants of the slot for a ProximityPrompt named SellAndSteal
                        if slot then
                            for _, sdesc in pairs(slot:GetDescendants()) do
                                if sdesc:IsA("ProximityPrompt") then
                                    sellAndSteal = sdesc
                                    break
                                end
                            end
                        end
                    end

                    -- determine if slot contains a FNAF model
                    local hasFNAF = false
                    if slot then
                        for _, child in pairs(slot:GetChildren()) do
                            if child:IsA("Model") and child.Name ~= "FNaFPosition" then
                                hasFNAF = true
                                break
                            end
                        end
                    end

                    if sellAndSteal and hasFNAF then
                        table.insert(foundFNAFs, {
                            Owner = base.Name,
                            SlotName = slot and slot.Name or "Unknown",
                            FNaFPosition = fnafPosition,
                            Prompt = sellAndSteal
                        })
                    end
                end
            end
        end
    end
end

function StealFNAF(data)
    if isWorking then return end
    
    if not SavedBasePosition then
        if StatusLabel then StatusLabel.Text = "❌ Salve a base primeiro!" StatusLabel.TextColor3 = Color3.fromRGB(220, 100, 100) end
        return
    end
    
    isWorking = true
    local char = LocalPlayer.Character
    
    if not char or not char:FindFirstChild("HumanoidRootPart") then
        if StatusLabel then StatusLabel.Text = "❌ Erro no personagem!" StatusLabel.TextColor3 = Color3.fromRGB(220, 100, 100) end
        isWorking = false
        return
    end
    
    if not data.FNaFPosition or not data.FNaFPosition.Parent or not data.Prompt or not data.Prompt.Parent then
        if StatusLabel then StatusLabel.Text = "⚠️ FNAF sumiu!" StatusLabel.TextColor3 = Color3.fromRGB(220, 150, 100) end
        isWorking = false
        UpdateList()
        return
    end
    
    if StatusLabel then StatusLabel.Text = "🚀 Indo para o FNAF..." StatusLabel.TextColor3 = Color3.fromRGB(255, 200, 100) end
    
    local fnafPos = data.FNaFPosition.Position
    SafeTeleport(char, CFrame.new(fnafPos + Vector3.new(0, 3, 3)))
    
    wait(0.2)
    
    if StatusLabel then StatusLabel.Text = "💎 Pegando FNAF..." StatusLabel.TextColor3 = Color3.fromRGB(255, 180, 100) end
    
    pcall(function()
        for i = 1, 3 do
            if data.Prompt and data.Prompt.Parent then
                fireproximityprompt(data.Prompt)
                wait(0.1)
            end
        end
    end)
    
    wait(0.15)
    
    if StatusLabel then StatusLabel.Text = "🏠 Voltando para base..." StatusLabel.TextColor3 = Color3.fromRGB(100, 180, 220) end
    
    SafeTeleport(char, SavedBasePosition)
    
    wait(0.3)
    
    if StatusLabel then StatusLabel.Text = "✅ FNAF roubado com sucesso!" StatusLabel.TextColor3 = Color3.fromRGB(100, 220, 100) end
    
    isWorking = false
    UpdateList()
end

function UpdateList()
    if not ScrollFrame or not ListLayout then return end
    
    for _, btn in pairs(ScrollFrame:GetChildren()) do
        if btn:IsA("TextButton") or btn:IsA("TextLabel") then
            btn:Destroy()
        end
    end
    
    FindFNAFs()
    
    if #foundFNAFs == 0 then
        local noFNAF = Instance.new("TextLabel")
        noFNAF.Size = UDim2.new(1, -8, 0, 38)
        noFNAF.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
        noFNAF.BorderSizePixel = 0
        noFNAF.Text = "😴 Nenhum FNAF encontrado"
        noFNAF.TextColor3 = Color3.fromRGB(160, 160, 180)
        noFNAF.TextSize = 10
        noFNAF.Font = Enum.Font.Gotham
        noFNAF.Parent = ScrollFrame
        
        local corner = Instance.new("UICorner")
        corner.CornerRadius = UDim.new(0, 8)
        corner.Parent = noFNAF
    else
        for _, fnafData in pairs(foundFNAFs) do
            CreateFNAFButton(fnafData)
        end
    end
    
    if ScrollFrame then
        ScrollFrame.CanvasSize = UDim2.new(0, 0, 0, ListLayout.AbsoluteContentSize.Y + 12)
    end
    
    if CustomSettings.ESPEnabled then
        CreateESP()
    end
end

-- ==================== AUTOLOCK (roubar automaticamente) ====================
-- (AutoLock and AutoBaseLock removed)

function CreateFNAFButton(data)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -8, 0, 38)
    btn.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
    btn.BorderSizePixel = 0
    btn.Text = ""
    btn.Parent = ScrollFrame
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = btn
    
    local icon = Instance.new("TextLabel")
    icon.Size = UDim2.new(0, 30, 0, 30)
    icon.Position = UDim2.new(0, 4, 0.5, -15)
    icon.BackgroundColor3 = Color3.fromRGB(100, 100, 255)
    icon.BorderSizePixel = 0
    icon.Text = "🎮"
    icon.TextSize = 16
    icon.Parent = btn
    
    local iconCorner = Instance.new("UICorner")
    iconCorner.CornerRadius = UDim.new(0, 6)
    iconCorner.Parent = icon
    
    local ownerLabel = Instance.new("TextLabel")
    ownerLabel.Size = UDim2.new(1, -46, 0, 16)
    ownerLabel.Position = UDim2.new(0, 40, 0, 4)
    ownerLabel.BackgroundTransparency = 1
    ownerLabel.Text = data.Owner
    ownerLabel.TextColor3 = Color3.fromRGB(240, 240, 250)
    ownerLabel.TextSize = 11
    ownerLabel.Font = Enum.Font.GothamBold
    ownerLabel.TextXAlignment = Enum.TextXAlignment.Left
    ownerLabel.Parent = btn
    
    local slotLabel = Instance.new("TextLabel")
    slotLabel.Size = UDim2.new(1, -46, 0, 14)
    slotLabel.Position = UDim2.new(0, 40, 0, 20)
    slotLabel.BackgroundTransparency = 1
    slotLabel.Text = data.SlotName
    slotLabel.TextColor3 = Color3.fromRGB(140, 140, 160)
    slotLabel.TextSize = 9
    slotLabel.Font = Enum.Font.Gotham
    slotLabel.TextXAlignment = Enum.TextXAlignment.Left
    slotLabel.Parent = btn
    
    btn.MouseButton1Click:Connect(function()
        if not isWorking then
            StealFNAF(data)
        end
    end)
    
    btn.MouseEnter:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.2), {
            BackgroundColor3 = Color3.fromRGB(45, 45, 55)
        }):Play()
    end)
    
    btn.MouseLeave:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.2), {
            BackgroundColor3 = Color3.fromRGB(35, 35, 45)
        }):Play()
    end)
end

-- ==================== FUNCOES DE UI ====================

-- Criar Aba
local function CreateTab(name, icon, order)
    local tab = Instance.new("TextButton")
    tab.Name = name
    tab.Size = UDim2.new(0, 70, 1, 0)
    tab.BackgroundColor3 = Color3.fromRGB(30, 30, 38)
    tab.BorderSizePixel = 0
    tab.Text = ""
    tab.LayoutOrder = order
    tab.Parent = TabsContainer
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 10)
    corner.Parent = tab
    
    local iconLabel = Instance.new("TextLabel")
    iconLabel.Size = UDim2.new(1, 0, 0, 22)
    iconLabel.Position = UDim2.new(0, 0, 0, 4)
    iconLabel.BackgroundTransparency = 1
    iconLabel.Text = icon
    iconLabel.TextColor3 = Color3.fromRGB(160, 160, 180)
    iconLabel.TextSize = 18
    iconLabel.Font = Enum.Font.GothamBold
    iconLabel.Parent = tab
    
    local nameLabel = Instance.new("TextLabel")
    nameLabel.Size = UDim2.new(1, 0, 0, 14)
    nameLabel.Position = UDim2.new(0, 0, 1, -16)
    nameLabel.BackgroundTransparency = 1
    nameLabel.Text = name
    nameLabel.TextColor3 = Color3.fromRGB(160, 160, 180)
    nameLabel.TextSize = 8
    nameLabel.Font = Enum.Font.GothamBold
    nameLabel.Parent = tab
    
    return tab, iconLabel, nameLabel
end

-- Criar Conteudo da Aba
local function CreateTabContent(name)
    local content = Instance.new("ScrollingFrame")
    content.Name = name .. "Content"
    content.Size = UDim2.new(1, 0, 1, 0)
    content.BackgroundTransparency = 1
    content.BorderSizePixel = 0
    content.ScrollBarThickness = 4
    content.ScrollBarImageColor3 = Color3.fromRGB(100, 100, 255)
    content.Visible = false
    content.Parent = ContentContainer
    
    local layout = Instance.new("UIListLayout")
    layout.Padding = UDim.new(0, 8)
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    layout.Parent = content
    
    return content
end

-- Criar Card
local function CreateCard(parent, title, description)
    local card = Instance.new("Frame")
    card.Size = UDim2.new(1, 0, 0, 0)
    card.AutomaticSize = Enum.AutomaticSize.Y
    card.BackgroundColor3 = Color3.fromRGB(25, 25, 32)
    card.BorderSizePixel = 0
    card.Parent = parent
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 12)
    corner.Parent = card
    
    local padding = Instance.new("UIPadding")
    padding.PaddingTop = UDim.new(0, 12)
    padding.PaddingBottom = UDim.new(0, 12)
    padding.PaddingLeft = UDim.new(0, 12)
    padding.PaddingRight = UDim.new(0, 12)
    padding.Parent = card
    
    local layout = Instance.new("UIListLayout")
    layout.Padding = UDim.new(0, 8)
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    layout.Parent = card
    
    local titleLabel = Instance.new("TextLabel")
    titleLabel.Size = UDim2.new(1, 0, 0, 16)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Text = title
    titleLabel.TextColor3 = Color3.fromRGB(240, 240, 250)
    titleLabel.TextSize = 13
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.LayoutOrder = 1
    titleLabel.Parent = card
    
    if description then
        local descLabel = Instance.new("TextLabel")
        descLabel.Size = UDim2.new(1, 0, 0, 12)
        descLabel.BackgroundTransparency = 1
        descLabel.Text = description
        descLabel.TextColor3 = Color3.fromRGB(140, 140, 160)
        descLabel.TextSize = 9
        descLabel.Font = Enum.Font.Gotham
        descLabel.TextXAlignment = Enum.TextXAlignment.Left
        descLabel.TextWrapped = true
        descLabel.LayoutOrder = 2
        descLabel.Parent = card
    end
    
    return card
end

-- Criar Toggle Moderno
local function CreateModernToggle(parent, text, default, callback)
    local container = Instance.new("Frame")
    container.Size = UDim2.new(1, 0, 0, 32)
    container.BackgroundTransparency = 1
    container.LayoutOrder = 100
    container.Parent = parent
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -50, 1, 0)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = Color3.fromRGB(200, 200, 220)
    label.TextSize = 11
    label.Font = Enum.Font.Gotham
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = container
    
    local toggleButton = Instance.new("TextButton")
    toggleButton.Size = UDim2.new(0, 44, 0, 24)
    toggleButton.Position = UDim2.new(1, -44, 0.5, -12)
    toggleButton.BackgroundColor3 = default and Color3.fromRGB(100, 220, 120) or Color3.fromRGB(60, 60, 75)
    toggleButton.BorderSizePixel = 0
    toggleButton.Text = ""
    toggleButton.Parent = container
    
    local toggleCorner = Instance.new("UICorner")
    toggleCorner.CornerRadius = UDim.new(1, 0)
    toggleCorner.Parent = toggleButton
    
    local toggleCircle = Instance.new("Frame")
    toggleCircle.Size = UDim2.new(0, 18, 0, 18)
    toggleCircle.Position = default and UDim2.new(1, -21, 0.5, -9) or UDim2.new(0, 3, 0.5, -9)
    toggleCircle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    toggleCircle.BorderSizePixel = 0
    toggleCircle.Parent = toggleButton
    
    local circleCorner = Instance.new("UICorner")
    circleCorner.CornerRadius = UDim.new(1, 0)
    circleCorner.Parent = toggleCircle
    
    local enabled = default
    
    toggleButton.MouseButton1Click:Connect(function()
        enabled = not enabled
        callback(enabled)
        
        TweenService:Create(toggleButton, TweenInfo.new(0.2), {
            BackgroundColor3 = enabled and Color3.fromRGB(100, 220, 120) or Color3.fromRGB(60, 60, 75)
        }):Play()
        
        TweenService:Create(toggleCircle, TweenInfo.new(0.2), {
            Position = enabled and UDim2.new(1, -21, 0.5, -9) or UDim2.new(0, 3, 0.5, -9)
        }):Play()
    end)
    
    return container
end

-- Criar Slider Moderno
local function CreateModernSlider(parent, text, min, max, default, callback)
    local container = Instance.new("Frame")
    container.Size = UDim2.new(1, 0, 0, 44)
    container.BackgroundTransparency = 1
    container.LayoutOrder = 101
    container.Parent = parent
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, 0, 0, 16)
    label.BackgroundTransparency = 1
    label.Text = text .. ": " .. default
    label.TextColor3 = Color3.fromRGB(200, 200, 220)
    label.TextSize = 10
    label.Font = Enum.Font.Gotham
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = container
    
    local sliderBg = Instance.new("TextButton")
    sliderBg.Size = UDim2.new(1, 0, 0, 20)
    sliderBg.Position = UDim2.new(0, 0, 0, 20)
    sliderBg.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
    sliderBg.BorderSizePixel = 0
    sliderBg.Text = ""
    sliderBg.AutoButtonColor = false
    sliderBg.Parent = container
    
    local bgCorner = Instance.new("UICorner")
    bgCorner.CornerRadius = UDim.new(1, 0)
    bgCorner.Parent = sliderBg
    
    local sliderFill = Instance.new("Frame")
    sliderFill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
    sliderFill.BackgroundColor3 = Color3.fromRGB(100, 100, 255)
    sliderFill.BorderSizePixel = 0
    sliderFill.Parent = sliderBg
    
    local fillCorner = Instance.new("UICorner")
    fillCorner.CornerRadius = UDim.new(1, 0)
    fillCorner.Parent = sliderFill
    
    local dragging = false
    
    local function update(input)
        local pos = math.clamp((input.Position.X - sliderBg.AbsolutePosition.X) / sliderBg.AbsoluteSize.X, 0, 1)
        local value = math.floor(min + (max - min) * pos)
        sliderFill.Size = UDim2.new(pos, 0, 1, 0)
        label.Text = text .. ": " .. value
        callback(value)
    end
    
    sliderBg.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            update(input)
        end
    end)
    
    sliderBg.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            update(input)
        end
    end)
    
    return container
end

-- Criar Botao
local function CreateButton(parent, text, icon, callback)
    local button = Instance.new("TextButton")
    button.Size = UDim2.new(1, 0, 0, 38)
    button.BackgroundColor3 = Color3.fromRGB(100, 100, 255)
    button.BorderSizePixel = 0
    button.Text = ""
    button.LayoutOrder = 102
    button.Parent = parent
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 10)
    corner.Parent = button
    
    local gradient = Instance.new("UIGradient")
    gradient.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, Color3.fromRGB(120, 100, 255)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(80, 180, 255))
    }
    gradient.Rotation = 45
    gradient.Parent = button
    
    local buttonText = Instance.new("TextLabel")
    buttonText.Size = UDim2.new(1, -40, 1, 0)
    buttonText.Position = UDim2.new(0, 40, 0, 0)
    buttonText.BackgroundTransparency = 1
    buttonText.Text = text
    buttonText.TextColor3 = Color3.fromRGB(255, 255, 255)
    buttonText.TextSize = 12
    buttonText.Font = Enum.Font.GothamBold
    buttonText.Parent = button
    
    local iconLabel = Instance.new("TextLabel")
    iconLabel.Size = UDim2.new(0, 30, 1, 0)
    iconLabel.Position = UDim2.new(0, 8, 0, 0)
    iconLabel.BackgroundTransparency = 1
    iconLabel.Text = icon
    iconLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    iconLabel.TextSize = 16
    iconLabel.Font = Enum.Font.GothamBold
    iconLabel.Parent = button
    
    button.MouseButton1Click:Connect(callback)
    
    button.MouseEnter:Connect(function()
        TweenService:Create(button, TweenInfo.new(0.2), {
            BackgroundColor3 = Color3.fromRGB(120, 120, 255)
        }):Play()
    end)
    
    button.MouseLeave:Connect(function()
        TweenService:Create(button, TweenInfo.new(0.2), {
            BackgroundColor3 = Color3.fromRGB(100, 100, 255)
        }):Play()
    end)
    
    return button
end

-- ==================== CRIAR ABAS ====================

local mainTab, mainIcon, mainName = CreateTab("Main", "🏠", 1)
local movementTab, movementIcon, movementName = CreateTab("Move", "🚀", 2)
local combatTab, combatIcon, combatName = CreateTab("Combat", "⚔️", 3)
local visualTab, visualIcon, visualName = CreateTab("Visual", "👁️", 4)

local mainContent = CreateTabContent("Main")
local movementContent = CreateTabContent("Move")
local combatContent = CreateTabContent("Combat")
local visualContent = CreateTabContent("Visual")

-- Trocar Aba
local function SwitchTab(tabName)
    currentTab = tabName
    
    -- Esconder todos os conteudos
    mainContent.Visible = false
    movementContent.Visible = false
    combatContent.Visible = false
    visualContent.Visible = false
    
    -- Resetar cores das abas
    for _, tab in pairs(TabsContainer:GetChildren()) do
        if tab:IsA("TextButton") then
            tab.BackgroundColor3 = Color3.fromRGB(30, 30, 38)
            for _, child in pairs(tab:GetChildren()) do
                if child:IsA("TextLabel") then
                    child.TextColor3 = Color3.fromRGB(160, 160, 180)
                end
            end
        end
    end
    
    -- Ativar aba selecionada
    if tabName == "Main" then
        mainContent.Visible = true
        mainTab.BackgroundColor3 = Color3.fromRGB(100, 100, 255)
        mainIcon.TextColor3 = Color3.fromRGB(255, 255, 255)
        mainName.TextColor3 = Color3.fromRGB(255, 255, 255)
    elseif tabName == "Move" then
        movementContent.Visible = true
        movementTab.BackgroundColor3 = Color3.fromRGB(100, 100, 255)
        movementIcon.TextColor3 = Color3.fromRGB(255, 255, 255)
        movementName.TextColor3 = Color3.fromRGB(255, 255, 255)
    elseif tabName == "Combat" then
        combatContent.Visible = true
        combatTab.BackgroundColor3 = Color3.fromRGB(100, 100, 255)
        combatIcon.TextColor3 = Color3.fromRGB(255, 255, 255)
        combatName.TextColor3 = Color3.fromRGB(255, 255, 255)
    elseif tabName == "Visual" then
        visualContent.Visible = true
        visualTab.BackgroundColor3 = Color3.fromRGB(100, 100, 255)
        visualIcon.TextColor3 = Color3.fromRGB(255, 255, 255)
        visualName.TextColor3 = Color3.fromRGB(255, 255, 255)
    end
end

-- Conectar cliques das abas
mainTab.MouseButton1Click:Connect(function() SwitchTab("Main") end)
movementTab.MouseButton1Click:Connect(function() SwitchTab("Move") end)
combatTab.MouseButton1Click:Connect(function() SwitchTab("Combat") end)
visualTab.MouseButton1Click:Connect(function() SwitchTab("Visual") end)

-- ==================== ABA MAIN ====================

local statusCard = CreateCard(mainContent, "📍 Status", nil)

local StatusLabel = Instance.new("TextLabel")
StatusLabel.Size = UDim2.new(1, 0, 0, 28)
StatusLabel.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
StatusLabel.BorderSizePixel = 0
StatusLabel.Text = "💾 Salve sua base primeiro!"
StatusLabel.TextColor3 = Color3.fromRGB(255, 200, 100)
StatusLabel.TextSize = 11
StatusLabel.Font = Enum.Font.GothamBold
StatusLabel.LayoutOrder = 103
StatusLabel.Parent = statusCard

local statusCorner = Instance.new("UICorner")
statusCorner.CornerRadius = UDim.new(0, 8)
statusCorner.Parent = StatusLabel

local baseCard = CreateCard(mainContent, "🏠 Controle de Base", "Salve a posição da sua base")

CreateButton(baseCard, "Salvar Base", "💾", function()
    local char = LocalPlayer.Character
    if char and char:FindFirstChild("HumanoidRootPart") then
        SavedBasePosition = char.HumanoidRootPart.CFrame
        StatusLabel.Text = "✅ Base salva com sucesso!"
        StatusLabel.TextColor3 = Color3.fromRGB(100, 220, 100)
    else
        StatusLabel.Text = "❌ Erro ao salvar base!"
        StatusLabel.TextColor3 = Color3.fromRGB(220, 100, 100)
    end
end)

CreateButton(baseCard, "Voltar para Base", "🏠", function()
    if SavedBasePosition then
        local char = LocalPlayer.Character
        if char and char:FindFirstChild("HumanoidRootPart") then
            char.HumanoidRootPart.CFrame = SavedBasePosition
            StatusLabel.Text = "✅ Teleportado para base!"
            StatusLabel.TextColor3 = Color3.fromRGB(100, 220, 100)
        end
    else
        StatusLabel.Text = "⚠️ Salve sua base primeiro!"
        StatusLabel.TextColor3 = Color3.fromRGB(220, 150, 100)
    end
end)

-- Spot AutoLock: teleport to fixed coordinates and wait for base timer
local SPOT_CFRAME = CFrame.new(195.76, 7.60, 211.50)

local function GetBaseRemaining(base)
    if not base then return nil end
    
    -- Verificar atributo Locked (novo sistema)
    local locked = base:GetAttribute("Locked")
    if type(locked) == "boolean" then
        -- Se locked = true, base está trancada (remaining > 0)
        -- Se locked = false, base está desbloqueada (remaining = 0)
        return locked and 1 or 0
    end
    
    -- Fallback para sistema antigo com NumberValue
    local nv = base:FindFirstChild("OpenTime") or base:FindFirstChild("OpenCooldown") or base:FindFirstChild("NextOpen")
    if nv and nv:IsA("NumberValue") then
        local remaining = nv.Value
        if remaining > tick() + 100 then
            remaining = remaining - tick()
        end
        if remaining < 0 then remaining = 0 end
        return remaining
    else
        local attr = base:GetAttribute("NextOpen") or base:GetAttribute("OpenAt") or base:GetAttribute("OpenTime")
        if type(attr) == "number" then
            return math.max(0, attr - tick())
        end
    end
    
    return nil
end

-- ==================== BLOQUEIO REMOTO ====================

local function FindPlayerBase()
    -- Procura a base do jogador de várias formas
    local bases = Workspace:FindFirstChild("Bases")
    if not bases then
        print("[Bloqueio Remoto] ❌ Pasta 'Bases' não encontrada em Workspace")
        return nil
    end
    
    print("[Bloqueio Remoto] 📍 Procurando bases...")
    print("[Bloqueio Remoto] Bases encontradas:")
    for _, base in pairs(bases:GetChildren()) do
        print("[Bloqueio Remoto]   - " .. base.Name)
    end
    
    -- MÉTODO 1: Busca por nome exato
    local myBase = bases:FindFirstChild(LocalPlayer.Name)
    if myBase then
        print("[Bloqueio Remoto] ✅ Base encontrada por nome exato: " .. myBase.Name)
        return myBase
    end
    
    -- MÉTODO 2: Busca case-insensitive
    for _, base in pairs(bases:GetChildren()) do
        if base.Name:lower() == LocalPlayer.Name:lower() then
            print("[Bloqueio Remoto] ✅ Base encontrada (case-insensitive): " .. base.Name)
            return base
        end
    end
    
    -- MÉTODO 3: Busca por nome que contém
    for _, base in pairs(bases:GetChildren()) do
        if base.Name:lower():find(LocalPlayer.Name:lower(), 1, true) then
            print("[Bloqueio Remoto] ✅ Base encontrada (contém nome): " .. base.Name)
            return base
        end
    end
    
    -- MÉTODO 4: Busca por atributo Owner
    for _, base in pairs(bases:GetChildren()) do
        if base:GetAttribute("Owner") == LocalPlayer.Name then
            print("[Bloqueio Remoto] ✅ Base encontrada (atributo Owner): " .. base.Name)
            return base
        end
    end
    
    -- MÉTODO 5: Busca por atributo Username
    for _, base in pairs(bases:GetChildren()) do
        if base:GetAttribute("Username") == LocalPlayer.Name then
            print("[Bloqueio Remoto] ✅ Base encontrada (atributo Username): " .. base.Name)
            return base
        end
    end
    
    -- MÉTODO 6: Busca pela base mais perto
    if LocalPlayer.Character then
        local char = LocalPlayer.Character
        local hrp = char:FindFirstChild("HumanoidRootPart")
        if hrp then
            local closest = nil
            local closestDist = math.huge
            
            for _, base in pairs(bases:GetChildren()) do
                local basePart = base:FindFirstChildWhichIsA("BasePart")
                if basePart then
                    local dist = (basePart.Position - hrp.Position).Magnitude
                    print("[Bloqueio Remoto] Distância para '" .. base.Name .. "': " .. string.format("%.2f", dist))
                    if dist < closestDist then
                        closestDist = dist
                        closest = base
                    end
                end
            end
            
            -- Considerar base próxima (até 500 studs)
            if closest and closestDist < 500 then
                print("[Bloqueio Remoto] ✅ Base encontrada (mais próxima): " .. closest.Name .. " (" .. string.format("%.2f", closestDist) .. " studs)")
                return closest
            elseif closest then
                print("[Bloqueio Remoto] ⚠️ Base mais próxima está muito longe: " .. string.format("%.2f", closestDist) .. " studs")
            end
        end
    end
    
    -- Se chegou aqui, não encontrou
    print("[Bloqueio Remoto] ❌ Nenhuma base encontrada para o jogador: " .. LocalPlayer.Name)
    return nil
end

local function RemoteLockBase()
    local myBase = FindPlayerBase()
    
    if not myBase then
        if StatusLabel then
            StatusLabel.Text = "❌ Base não encontrada! Use Debug Base para diagnosticar."
            StatusLabel.TextColor3 = Color3.fromRGB(220, 100, 100)
        end
        print("[Bloqueio Remoto] ❌ Erro: Base não encontrada")
        print("[Bloqueio Remoto] 💡 Dica: Clique em 'Debug Base' para ver as bases disponíveis")
        return
    end
    
    print("[Bloqueio Remoto] ✅ Base encontrada: " .. myBase.Name)
    
    -- PRIORIDADE: Se temos um método descoberto, usar primeiro
    if DiscoveredLockMethod then
        print("[Bloqueio Remoto] 🎯 Usando MÉTODO DESCOBERTO: " .. DiscoveredLockMethod.method)
        
        if DiscoveredLockMethod.method == "Atributo Locked" and DiscoveredLockMethod.lockAttr then
            myBase:SetAttribute("Locked", true)
            if StatusLabel then
                StatusLabel.Text = "🔒 Base TRANCADA remotamente! (Método Descoberto)"
                StatusLabel.TextColor3 = Color3.fromRGB(100, 220, 100)
            end
            print("[Bloqueio Remoto] ✅ Método Descoberto funcionou!")
            return
        elseif DiscoveredLockMethod.method == "NumberValue" and DiscoveredLockMethod.nv then
            DiscoveredLockMethod.nv.Value = tick() + 99999
            if StatusLabel then
                StatusLabel.Text = "🔒 Base TRANCADA remotamente! (Método Descoberto)"
                StatusLabel.TextColor3 = Color3.fromRGB(100, 220, 100)
            end
            print("[Bloqueio Remoto] ✅ Método Descoberto funcionou!")
            return
        elseif DiscoveredLockMethod.method == "LockBase" and DiscoveredLockMethod.scriptables then
            local lockBase = DiscoveredLockMethod.scriptables:FindFirstChild("LockBase")
            if lockBase then
                lockBase:SetAttribute("Locked", true)
                if StatusLabel then
                    StatusLabel.Text = "🔒 Base TRANCADA remotamente! (Método Descoberto)"
                    StatusLabel.TextColor3 = Color3.fromRGB(100, 220, 100)
                end
                print("[Bloqueio Remoto] ✅ Método Descoberto funcionou!")
                return
            end
        elseif DiscoveredLockMethod.method == "RemoteEvent" and DiscoveredLockMethod.remoteEvent then
            pcall(function()
                DiscoveredLockMethod.remoteEvent:FireServer("lock")
            end)
            if StatusLabel then
                StatusLabel.Text = "🔒 Base TRANCADA remotamente! (Método Descoberto)"
                StatusLabel.TextColor3 = Color3.fromRGB(100, 220, 100)
            end
            print("[Bloqueio Remoto] ✅ Método Descoberto funcionou!")
            return
        end
    end
    
    print("[Bloqueio Remoto] Tentando trancar a base com métodos alternativos...")
    
    -- MÉTODO 1: Atributo Locked (Sistema Moderno)
    local locked = myBase:GetAttribute("Locked")
    if type(locked) == "boolean" then
        myBase:SetAttribute("Locked", true)
        if StatusLabel then
            StatusLabel.Text = "🔒 Base TRANCADA remotamente! (Método 1)"
            StatusLabel.TextColor3 = Color3.fromRGB(100, 220, 100)
        end
        print("[Bloqueio Remoto] ✅ Método 1 funcionou - Atributo Locked")
        return
    end
    
    -- MÉTODO 2: NumberValue (OpenTime, OpenCooldown, NextOpen)
    local nv = myBase:FindFirstChild("OpenTime") or myBase:FindFirstChild("OpenCooldown") or myBase:FindFirstChild("NextOpen")
    if nv and nv:IsA("NumberValue") then
        nv.Value = tick() + 99999 -- Trancar por muito tempo
        if StatusLabel then
            StatusLabel.Text = "🔒 Base TRANCADA remotamente! (Método 2)"
            StatusLabel.TextColor3 = Color3.fromRGB(100, 220, 100)
        end
        print("[Bloqueio Remoto] ✅ Método 2 funcionou - NumberValue: " .. nv.Name)
        return
    end
    
    -- MÉTODO 3: Procurar em Scriptables por LockBase
    local scriptables = myBase:FindFirstChild("Scriptables")
    if scriptables then
        local lockBase = scriptables:FindFirstChild("LockBase")
        if lockBase then
            -- Tentar trancar via atributo no LockBase
            lockBase:SetAttribute("Locked", true)
            if StatusLabel then
                StatusLabel.Text = "🔒 Base TRANCADA remotamente! (Método 3)"
                StatusLabel.TextColor3 = Color3.fromRGB(100, 220, 100)
            end
            print("[Bloqueio Remoto] ✅ Método 3 funcionou - LockBase atributo")
            return
        end
    end
    
    -- MÉTODO 4: Procurar por qualquer atributo com "Lock" no nome
    local allAttrs = myBase:GetAttributes()
    for attrName, attrValue in pairs(allAttrs) do
        if string.lower(attrName):find("lock") or string.lower(attrName):find("open") then
            if type(attrValue) == "boolean" then
                myBase:SetAttribute(attrName, true)
                if StatusLabel then
                    StatusLabel.Text = "🔒 Base TRANCADA remotamente! (Método 4)"
                    StatusLabel.TextColor3 = Color3.fromRGB(100, 220, 100)
                end
                print("[Bloqueio Remoto] ✅ Método 4 funcionou - Atributo: " .. attrName)
                return
            elseif type(attrValue) == "number" then
                myBase:SetAttribute(attrName, tick() + 99999)
                if StatusLabel then
                    StatusLabel.Text = "🔒 Base TRANCADA remotamente! (Método 4)"
                    StatusLabel.TextColor3 = Color3.fromRGB(100, 220, 100)
                end
                print("[Bloqueio Remoto] ✅ Método 4 funcionou - Atributo número: " .. attrName)
                return
            end
        end
    end
    
    -- MÉTODO 5: Procurar por NumberValues com "Lock" ou "Open" no nome
    for _, child in pairs(myBase:GetDescendants()) do
        if child:IsA("NumberValue") then
            local childName = child.Name:lower()
            if childName:find("lock") or childName:find("open") or childName:find("cooldown") or childName:find("time") then
                child.Value = tick() + 99999
                if StatusLabel then
                    StatusLabel.Text = "🔒 Base TRANCADA remotamente! (Método 5)"
                    StatusLabel.TextColor3 = Color3.fromRGB(100, 220, 100)
                end
                print("[Bloqueio Remoto] ✅ Método 5 funcionou - NumberValue descendente: " .. child.Name)
                return
            end
        end
    end
    
    -- MÉTODO 6: Tentar RemoteEvent
    local remoteEvent = myBase:FindFirstChildWhichIsA("RemoteEvent", true)
    if remoteEvent then
        pcall(function()
            remoteEvent:FireServer("lock")
        end)
        pcall(function()
            remoteEvent:FireServer({action = "lock"})
        end)
        if StatusLabel then
            StatusLabel.Text = "🔒 Bloqueio remoto enviado! (Método 6)"
            StatusLabel.TextColor3 = Color3.fromRGB(100, 220, 100)
        end
        print("[Bloqueio Remoto] ✅ Método 6 funcionou - RemoteEvent")
        return
    end
    
    -- Se nenhum método funcionou
    if StatusLabel then
        StatusLabel.Text = "⚠️ Nenhum método de bloqueio funcionou!"
        StatusLabel.TextColor3 = Color3.fromRGB(220, 150, 100)
    end
    
    print("[Bloqueio Remoto] ❌ Nenhum método funcionou")
    print("[Bloqueio Remoto] Estrutura da base:")
    print("[Bloqueio Remoto] - Atributos: " .. tostring(myBase:GetAttributes()))
    for _, child in pairs(myBase:GetChildren()) do
        print("[Bloqueio Remoto] - " .. child.Name .. " (" .. child.ClassName .. ")")
    end
end

local function StartSpotAutoLock()
    if SpotAutoLockThread then return end
    SpotAutoLockThread = {}
    SpotAutoLockThread._running = true
    local spotESP = nil
    local wasLocked = nil
    local hasTeleportedThisSession = false
    
    task.spawn(function()
        while SpotAutoLockThread and SpotAutoLockThread._running do
            local bases = Workspace:FindFirstChild("Bases")
            if bases then
                local myBase = bases:FindFirstChild(LocalPlayer.Name)
                if myBase then
                    local locked = myBase:GetAttribute("Locked")
                    
                    if locked == nil then
                        if StatusLabel then
                            StatusLabel.Text = "⏳ Aguardando atributo 'Locked'..."
                            StatusLabel.TextColor3 = Color3.fromRGB(200,200,100)
                        end
                    elseif not locked then
                        -- Base DESBLOQUEADA (locked = false)
                        -- Teleportar UMA VEZ quando desbloquear
                        if not hasTeleportedThisSession then
                            local scriptables = myBase:FindFirstChild("Scriptables")
                            if scriptables then
                                local lockBase = scriptables:FindFirstChild("LockBase")
                                if lockBase and lockBase:IsA("BasePart") then
                                    local char = LocalPlayer.Character
                                    if char and char:FindFirstChild("HumanoidRootPart") then
                                        SafeTeleport(char, CFrame.new(lockBase.Position + Vector3.new(0, 3, 0)))
                                        hasTeleportedThisSession = true
                                        if StatusLabel then
                                            StatusLabel.Text = "✅ No LockBase! Execute a ação..."
                                            StatusLabel.TextColor3 = Color3.fromRGB(100,220,100)
                                        end
                                    end
                                else
                                    if StatusLabel then
                                        StatusLabel.Text = "⚠️ LockBase não encontrado em Scriptables"
                                        StatusLabel.TextColor3 = Color3.fromRGB(220,150,100)
                                    end
                                end
                            else
                                if StatusLabel then
                                    StatusLabel.Text = "⚠️ Pasta Scriptables não encontrada"
                                    StatusLabel.TextColor3 = Color3.fromRGB(220,150,100)
                                end
                            end
                        end
                        
                        wasLocked = false
                        
                        -- Mostrar ESP com "Desbloqueado"
                        local char = LocalPlayer.Character
                        if char and char:FindFirstChild("HumanoidRootPart") then
                            if not spotESP then
                                spotESP = Instance.new("BillboardGui")
                                spotESP.Name = "SpotCountdownESP"
                                spotESP.Adornee = char:FindFirstChild("HumanoidRootPart")
                                spotESP.Size = UDim2.new(0, 150, 0, 40)
                                spotESP.StudsOffset = Vector3.new(0, 4, 0)
                                spotESP.AlwaysOnTop = true
                                spotESP.Parent = char:FindFirstChild("HumanoidRootPart")
                                
                                local frame = Instance.new("Frame")
                                frame.Size = UDim2.new(1, 0, 1, 0)
                                frame.BackgroundColor3 = Color3.fromRGB(50, 200, 50)
                                frame.BackgroundTransparency = 0.3
                                frame.BorderSizePixel = 0
                                frame.Parent = spotESP
                                
                                local corner = Instance.new("UICorner")
                                corner.CornerRadius = UDim.new(0, 8)
                                corner.Parent = frame
                                
                                local statusText = Instance.new("TextLabel")
                                statusText.Name = "StatusText"
                                statusText.Size = UDim2.new(1, -4, 1, 0)
                                statusText.Position = UDim2.new(0, 2, 0, 0)
                                statusText.BackgroundTransparency = 1
                                statusText.Text = "🔓 Desbloqueado"
                                statusText.TextColor3 = Color3.fromRGB(100, 255, 100)
                                statusText.TextSize = 14
                                statusText.Font = Enum.Font.GothamBold
                                statusText.Parent = frame
                            end
                        end
                    else
                        -- Base está BLOQUEADA (locked = true)
                        if wasLocked == false then
                            -- Era desbloqueada, agora trancou novamente - voltar
                            if spotESP then pcall(function() spotESP:Destroy() end) spotESP = nil end
                            local char = LocalPlayer.Character
                            if char and char:FindFirstChild("HumanoidRootPart") then
                                if SavedBasePosition then
                                    SafeTeleport(char, SavedBasePosition)
                                    if StatusLabel then
                                        StatusLabel.Text = "✅ Retornou para a base"
                                        StatusLabel.TextColor3 = Color3.fromRGB(100,220,100)
                                    end
                                else
                                    if StatusLabel then
                                        StatusLabel.Text = "⚠️ Base salva não encontrada"
                                        StatusLabel.TextColor3 = Color3.fromRGB(220,150,100)
                                    end
                                end
                            end
                            hasTeleportedThisSession = false
                        end
                        wasLocked = true
                        if StatusLabel then
                            StatusLabel.Text = "🔒 Base bloqueada, aguardando desbloqueio..."
                            StatusLabel.TextColor3 = Color3.fromRGB(255,150,100)
                        end
                    end
                end
            end

            task.wait(0.5)
        end
        if spotESP then pcall(function() spotESP:Destroy() end) end
        SpotAutoLockThread = nil
    end)
end

local function StopSpotAutoLock()
    if SpotAutoLockThread then
        SpotAutoLockThread._running = false
    end
    SpotAutoLockThread = nil
    StatusLabel.Text = "🔓 AutoLock Spot desativado"
    StatusLabel.TextColor3 = Color3.fromRGB(220,180,100)
end

CreateModernToggle(baseCard, "AutoLock Spot", false, function(enabled)
    if enabled then
        StartSpotAutoLock()
        StatusLabel.Text = "🔒 AutoLock Spot ativado"
        StatusLabel.TextColor3 = Color3.fromRGB(100,220,100)
    else
        StopSpotAutoLock()
    end
end)

-- Botão: Bloqueio Remoto (Super Rápido!)
CreateButton(baseCard, "🔒 Bloqueio Remoto", "⚡", function()
    RemoteLockBase()
end)

-- ==================== DEBUG DE INVENTÁRIO ====================

-- Função para debugar o inventário/items que o usuário está carregando
local function DebugInventory()
    print("\n" .. string.rep("=", 50))
    print("🎒 DEBUG DE INVENTÁRIO/ITEMS DO JOGADOR")
    print(string.rep("=", 50))
    
    local char = LocalPlayer.Character
    if not char then
        print("❌ Personagem não encontrado!")
        return
    end
    
    print("\n📍 INFORMAÇÕES DO JOGADOR:")
    print("  Nome: " .. LocalPlayer.Name)
    local pos = char.PrimaryPart and char.PrimaryPart.Position or Vector3.new(0,0,0)
    print(string.format("  Posição: X=%.2f, Y=%.2f, Z=%.2f", pos.X, pos.Y, pos.Z))
    
    print("\n🎁 BACKPACK (Items carregados):")
    local backpack = LocalPlayer:FindFirstChild("Backpack")
    if backpack then
        local items = backpack:GetChildren()
        if #items == 0 then
            print("  (Vazio)")
        else
            for i, item in pairs(items) do
                local info = string.format("  [%d] %s (%s)", i, item.Name, item.ClassName)
                

                -- Se for Model, verificar atributos
                if item:IsA("Model") then
                    local attrs = item:GetAttributes()
                    if next(attrs) then
                        print(info .. " | Atributos:")
                        for key, value in pairs(attrs) do
                            print(string.format("      - %s: %s", key, tostring(value)))
                        end
                    else
                        print(info)
                    end
                else
                    print(info)
                end
                
                -- Mostrar filhos diretos se houver
                local children = item:GetChildren()
                if #children > 0 then
                    for _, child in pairs(children) do
                        print(string.format("      └─ %s (%s)", child.Name, child.ClassName))
                    end
                end
            end
        end
    else
        print("  ❌ Backpack não encontrado!")
    end
    
    print("\n🏴 ITEMS EQUIPADOS NO PERSONAGEM:")
    local equipped = {}
    for _, item in pairs(char:GetChildren()) do
        if item:IsA("Model") and item.Parent == char then
            table.insert(equipped, item)
        end
    end
    
    if #equipped == 0 then
        print("  (Nenhum item equipado)")
    else
        for i, item in pairs(equipped) do
            print(string.format("  [%d] %s (%s)", i, item.Name, item.ClassName))
            
            -- Mostrar atributos
            local attrs = item:GetAttributes()
            if next(attrs) then
                for key, value in pairs(attrs) do
                    print(string.format("      - %s: %s", key, tostring(value)))
                end
            end
        end
    end
    
    print("\n💾 VALORES GLOBAIS DO PERSONAGEM:")
    local humanoid = char:FindFirstChild("Humanoid")
    if humanoid then
        print("  Humanoid:")
        print(string.format("    - Health: %.2f / %.2f", humanoid.Health, humanoid.MaxHealth))
        print(string.format("    - WalkSpeed: %.2f", humanoid.WalkSpeed))
        print(string.format("    - State: %s", tostring(humanoid:GetState())))
    else
        print("  (Humanoid não encontrado)")
    end
    
    print("\n🔍 ATRIBUTOS DO PERSONAGEM:")
    local charAttrs = char:GetAttributes()
    if next(charAttrs) then
        for key, value in pairs(charAttrs) do
            print(string.format("  - %s: %s", key, tostring(value)))
        end
    else
        print("  (Nenhum atributo)")
    end
    
    print("\n" .. string.rep("=", 50))
    print("✅ Debug enviado para o console (F9 ou abra DevTools)")
    print(string.rep("=", 50) .. "\n")
    
    if StatusLabel then
        StatusLabel.Text = "🎒 Debug de inventário enviado para F9!"
        StatusLabel.TextColor3 = Color3.fromRGB(100, 200, 255)
    end
end

-- Botão: Debug de Inventário
CreateButton(baseCard, "Debug Inventário (F9)", "🎒", function()
    DebugInventory()
end)

-- Botão: Debug da estrutura da base
CreateButton(baseCard, "Debug Base (F9)", "🔍", function()
    print("\n" .. string.rep("=", 60))
    print("🔍 DEBUG BASE - ANÁLISE COMPLETA DE BLOQUEIO")
    print(string.rep("=", 60))
    
    local bases = Workspace:FindFirstChild("Bases")
    if not bases then
        print("❌ Pasta 'Bases' não encontrada")
        return
    end
    
    local myBase = bases:FindFirstChild(LocalPlayer.Name)
    if not myBase then
        print("❌ Base do jogador '" .. LocalPlayer.Name .. "' não encontrada")
        print("\n📍 Bases disponíveis:")
        for _, base in pairs(bases:GetChildren()) do
            print("  - " .. base.Name)
        end
        return
    end
    
    print("\n✅ Base encontrada: " .. myBase.Name)
    print("\n" .. string.rep("-", 60))
    print("🔐 MÉTODOS DE BLOQUEIO DETECTADOS:")
    print(string.rep("-", 60))
    
    local metodosEncontrados = {}
    
    -- MÉTODO 1: Atributo Locked
    local locked = myBase:GetAttribute("Locked")
    if type(locked) == "boolean" then
        print("\n✅ MÉTODO 1: Atributo 'Locked' - DETECTADO!")
        print("   Status atual: " .. tostring(locked))
        print("   Como usar: myBase:SetAttribute('Locked', true)")
        table.insert(metodosEncontrados, "Atributo Locked")
    end
    
    -- MÉTODO 2: NumberValue
    local nv = myBase:FindFirstChild("OpenTime") or myBase:FindFirstChild("OpenCooldown") or myBase:FindFirstChild("NextOpen")
    if nv and nv:IsA("NumberValue") then
        print("\n✅ MÉTODO 2: NumberValue '" .. nv.Name .. "' - DETECTADO!")
        print("   Valor atual: " .. nv.Value)
        print("   Como usar: " .. nv.Name .. ".Value = tick() + 99999")
        table.insert(metodosEncontrados, "NumberValue: " .. nv.Name)
    end
    
    -- MÉTODO 3: LockBase em Scriptables
    local scriptables = myBase:FindFirstChild("Scriptables")
    if scriptables then
        local lockBase = scriptables:FindFirstChild("LockBase")
        if lockBase then
            print("\n✅ MÉTODO 3: LockBase em Scriptables - DETECTADO!")
            print("   Caminho: Scriptables/LockBase")
            print("   Como usar: LockBase:SetAttribute('Locked', true)")
            table.insert(metodosEncontrados, "LockBase em Scriptables")
        end
    end
    
    -- MÉTODO 4: Atributos genéricos com "Lock" ou "Open"
    local allAttrs = myBase:GetAttributes()
    local lockAttrs = {}
    for attrName, attrValue in pairs(allAttrs) do
        local lowerName = string.lower(attrName)
        if lowerName:find("lock") or lowerName:find("open") then
            table.insert(lockAttrs, {name = attrName, value = attrValue, type = type(attrValue)})
        end
    end
    
    if #lockAttrs > 0 then
        print("\n✅ MÉTODO 4: Atributos com 'Lock' ou 'Open' - DETECTADOS!")
        for i, attr in pairs(lockAttrs) do
            print(string.format("   [%d] %s = %s (%s)", i, attr.name, tostring(attr.value), attr.type))
        end
        table.insert(metodosEncontrados, "#4 - Atributos genéricos")
    end
    
    -- MÉTODO 5: NumberValues descendentes
    local descendentNVs = {}
    for _, child in pairs(myBase:GetDescendants()) do
        if child:IsA("NumberValue") then
            local childName = child.Name:lower()
            if childName:find("lock") or childName:find("open") or childName:find("cooldown") or childName:find("time") then
                table.insert(descendentNVs, {name = child.Name, path = child:GetFullName(), value = child.Value})
            end
        end
    end
    
    if #descendentNVs > 0 then
        print("\n✅ MÉTODO 5: NumberValues descendentes - DETECTADOS!")
        for i, nv_info in pairs(descendentNVs) do
            print(string.format("   [%d] %s = %.2f", i, nv_info.name, nv_info.value))
            print(string.format("       Caminho: %s", nv_info.path))
        end
        table.insert(metodosEncontrados, "#5 - NumberValues descendentes")
    end
    
    -- MÉTODO 6: RemoteEvent
    local remoteEvent = myBase:FindFirstChildWhichIsA("RemoteEvent", true)
    if remoteEvent then
        print("\n✅ MÉTODO 6: RemoteEvent - DETECTADO!")
        print("   Nome: " .. remoteEvent.Name)
        print("   Caminho: " .. remoteEvent:GetFullName())
        print("   Como usar: remoteEvent:FireServer('lock')")
        table.insert(metodosEncontrados, "RemoteEvent: " .. remoteEvent.Name)
    end
    
    -- RESUMO
    print("\n" .. string.rep("-", 60))
    print("📊 RESUMO:")
    print(string.rep("-", 60))
    
    if #metodosEncontrados > 0 then
        print("\n✅ Métodos de bloqueio encontrados: " .. #metodosEncontrados)
        for i, metodo in pairs(metodosEncontrados) do
            print("   [" .. i .. "] " .. metodo)
        end
        print("\n💡 RECOMENDAÇÃO:")
        print("   Use o método: " .. metodosEncontrados[1])
        print("   Este é o método mais provável de funcionar!")
        
        -- ARMAZENAR O MÉTODO DESCOBERTO
        DiscoveredLockMethod = {
            type = "Atributo Locked",
            base = myBase,
            lockAttr = locked,
            nv = nv,
            scriptables = scriptables,
            lockAttrs = lockAttrs,
            descendentNVs = descendentNVs,
            remoteEvent = remoteEvent,
            method = metodosEncontrados[1]
        }
        
        print("\n✨ MÉTODO ARMAZENADO PARA BLOQUEIO REMOTO!")
        print("   Clique em '🔒 Bloqueio Remoto' para trancar usando este método!")
    else
        print("\n❌ Nenhum método de bloqueio detectado!")
        print("\n📋 ESTRUTURA DA BASE:")
        for _, child in pairs(myBase:GetChildren()) do
            print("  - " .. child.Name .. " (" .. child.ClassName .. ")")
        end
        print("\n📋 ATRIBUTOS DA BASE:")
        for key, value in pairs(allAttrs) do
            print("  - " .. key .. " = " .. tostring(value) .. " (" .. type(value) .. ")")
        end
        DiscoveredLockMethod = nil
    end
    
    print("\n" .. string.rep("=", 60))
    print("✅ Debug concluído!")
    print(string.rep("=", 60) .. "\n")
    
    if StatusLabel then
        StatusLabel.Text = "🔍 Debug Base concluído! Verifique F9"
        StatusLabel.TextColor3 = Color3.fromRGB(100, 200, 255)
    end
end)

local fnafCard = CreateCard(mainContent, "🎮 FNAFs Disponíveis", "Clique para roubar")

local ScrollFrame = Instance.new("ScrollingFrame")
ScrollFrame.Size = UDim2.new(1, 0, 0, 200)
ScrollFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 26)
ScrollFrame.BorderSizePixel = 0
ScrollFrame.ScrollBarThickness = 4
ScrollFrame.ScrollBarImageColor3 = Color3.fromRGB(100, 100, 255)
ScrollFrame.LayoutOrder = 103
ScrollFrame.Parent = fnafCard

local scrollCorner = Instance.new("UICorner")
scrollCorner.CornerRadius = UDim.new(0, 8)
scrollCorner.Parent = ScrollFrame

local ListLayout = Instance.new("UIListLayout")
ListLayout.Padding = UDim.new(0, 6)
ListLayout.SortOrder = Enum.SortOrder.LayoutOrder
ListLayout.Parent = ScrollFrame

local ListPadding = Instance.new("UIPadding")
ListPadding.PaddingTop = UDim.new(0, 6)
ListPadding.PaddingBottom = UDim.new(0, 6)
ListPadding.PaddingLeft = UDim.new(0, 4)
ListPadding.PaddingRight = UDim.new(0, 4)
ListPadding.Parent = ScrollFrame

CreateButton(fnafCard, "Atualizar Lista", "🔄", function()
    UpdateList()
end)

-- ==================== ABA MOVEMENT ====================

local noclipCard = CreateCard(movementContent, "👻 Noclip", "Atravesse paredes")

CreateModernToggle(noclipCard, "Ativar Noclip", CustomSettings.NoclipEnabled, function(enabled)
    CustomSettings.NoclipEnabled = enabled
    if enabled then
        EnableNoclip()
    else
        DisableNoclip()
    end
end)

local speedCard = CreateCard(movementContent, "⚡ Speed", "Corra muito mais rápido")

CreateModernToggle(speedCard, "Ativar Speed", CustomSettings.SpeedEnabled, function(enabled)
    CustomSettings.SpeedEnabled = enabled
    if enabled then
        EnableSpeed()
    else
        DisableSpeed()
    end
end)

CreateModernSlider(speedCard, "Velocidade", 16, 200, CustomSettings.SpeedValue, function(value)
    CustomSettings.SpeedValue = value
    if CustomSettings.SpeedEnabled then
        local char = LocalPlayer.Character
        if char and char:FindFirstChild("Humanoid") then
            char.Humanoid.WalkSpeed = value
        end
    end
end)

local flyingCard = CreateCard(movementContent, "🧞 Flying Carpet", "Voe livremente pelo mapa")

CreateModernToggle(flyingCard, "Ativar Voo", CustomSettings.FlyingEnabled, function(enabled)
    CustomSettings.FlyingEnabled = enabled
    if enabled then
        EnableFlying()
        StatusLabel.Text = "✈️ Voo ativado! Use WASD + Space/Ctrl"
        StatusLabel.TextColor3 = Color3.fromRGB(100, 220, 100)
    else
        DisableFlying()
        StatusLabel.Text = "✈️ Voo desativado"
        StatusLabel.TextColor3 = Color3.fromRGB(220, 180, 100)
    end
end)

CreateModernSlider(flyingCard, "Velocidade do Voo", 20, 200, CustomSettings.FlyingSpeed, function(value)
    CustomSettings.FlyingSpeed = value
end)

-- ==================== ABA COMBAT ====================

local antiDamageCard = CreateCard(combatContent, "🛡️ Anti-Damage", "Reflita o dano e lance atacantes para fora")

CreateModernToggle(antiDamageCard, "Ativar Anti-Damage", CustomSettings.AntiDamageEnabled, function(enabled)
    CustomSettings.AntiDamageEnabled = enabled
    if enabled then
        EnableAntiDamage()
    else
        DisableAntiDamage()
    end
end)

local ragdollCard = CreateCard(combatContent, "💥 Ragdoll Aura", "Derruba jogadores próximos")

CreateModernToggle(ragdollCard, "Ativar Ragdoll Aura", CustomSettings.RagdollAuraEnabled, function(enabled)
    CustomSettings.RagdollAuraEnabled = enabled
    if enabled then
        EnableRagdollAura()
    else
        DisableRagdollAura()
    end
end)

CreateModernSlider(ragdollCard, "Distância", 5, 30, CustomSettings.RagdollDistance, function(value)
    CustomSettings.RagdollDistance = value
end)

-- Toggle Invisibilidade (local)
CreateModernToggle(ragdollCard, "Tornar Invisível (local)", CustomSettings.InvisibilityEnabled, function(enabled)
    CustomSettings.InvisibilityEnabled = enabled
    if enabled then
        EnableInvisibility()
    else
        DisableInvisibility()
    end
end)

-- ==================== ABA VISUAL ====================

local espCard = CreateCard(visualContent, "👁️ ESP FNAFs", "Veja FNAFs através das paredes")

CreateModernToggle(espCard, "Ativar ESP", CustomSettings.ESPEnabled, function(enabled)
    CustomSettings.ESPEnabled = enabled
    if enabled then
        CreateESP()
    else
        ClearESP()
    end
end)

CreateModernToggle(espCard, "Ativar Function ESP", CustomSettings.FunctionESPEnabled, function(enabled)
    CustomSettings.FunctionESPEnabled = enabled
    if enabled then
        CreateFunctionESP()
    else
        ClearFunctionESP()
    end
end)

local borderCard = CreateCard(visualContent, "🌈 Borda RGB", "Borda colorida animada")

CreateModernToggle(borderCard, "Ativar Borda RGB", CustomSettings.BorderEnabled, function(enabled)
    CustomSettings.BorderEnabled = enabled
    BorderGradient.Thickness = enabled and 2 or 0
end)

CreateModernSlider(borderCard, "Velocidade", 1, 10, CustomSettings.BorderSpeed, function(value)
    CustomSettings.BorderSpeed = value
end)

-- Botao: ESP Timer para bases
CreateButton(visualContent, "ESP Timer", "⏱️", function()
    CustomSettings.BaseTimerESPEnabled = not CustomSettings.BaseTimerESPEnabled
    if CustomSettings.BaseTimerESPEnabled then
        CreateBaseTimerESP()
        StatusLabel.Text = "⏱️ ESP Timer ativado"
        StatusLabel.TextColor3 = Color3.fromRGB(100, 220, 100)
    else
        ClearBaseTimerESP()
        StatusLabel.Text = "⏱️ ESP Timer desativado"
        StatusLabel.TextColor3 = Color3.fromRGB(220, 180, 100)
    end
end)

-- Atualizar canvas size
mainContent.CanvasSize = UDim2.new(0, 0, 0, mainContent.UIListLayout.AbsoluteContentSize.Y + 12)
movementContent.CanvasSize = UDim2.new(0, 0, 0, movementContent.UIListLayout.AbsoluteContentSize.Y + 12)
combatContent.CanvasSize = UDim2.new(0, 0, 0, combatContent.UIListLayout.AbsoluteContentSize.Y + 12)
visualContent.CanvasSize = UDim2.new(0, 0, 0, visualContent.UIListLayout.AbsoluteContentSize.Y + 12)

-- Ativar primeira aba
SwitchTab("Main")

-- ==================== MANTER CONFIGS AO RESPAWN ====================

LocalPlayer.CharacterAdded:Connect(function(char)
    char:WaitForChild("Humanoid")
    wait(0.1)
    
    if CustomSettings.SpeedEnabled then
        EnableSpeed()
    end
    
    if CustomSettings.NoclipEnabled then
        EnableNoclip()
    end
    
    if CustomSettings.RagdollAuraEnabled then
        EnableRagdollAura()
    end
    
    if CustomSettings.AntiDamageEnabled then
        EnableAntiDamage()
    end

    if CustomSettings.InvisibilityEnabled then
        EnableInvisibility()
    end
    
    if CustomSettings.FlyingEnabled then
        EnableFlying()
    end
    
    -- AutoLock features removed
end)

-- ==================== KEYBINDS ====================

-- Keybind F9 para Debug de Inventário
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    
    if input.KeyCode == Enum.KeyCode.F9 then
        DebugInventory()
    end
end)

-- ==================== INICIALIZAR ====================

UpdateList()

end) -- fechamento do pcall

if not success then
    warn("❌ ERRO ao carregar script: " .. tostring(err))
else
    print("🎮 Script Devs_Sync carregado com sucesso!")
end

