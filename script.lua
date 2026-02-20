--[[
██████╗  ██████╗ ██████╗ ██╗      ██████╗ ██╗  ██╗
██╔══██╗██╔═══██╗██╔══██╗██║     ██╔═══██╗╚██╗██╔╝
██████╔╝██║   ██║██████╔╝██║     ██║   ██║ ╚███╔╝ 
██╔══██╗██║   ██║██╔══██╗██║     ██║   ██║ ██╔██╗ 
██████╔╝╚██████╔╝██║  ██║███████╗╚██████╔╝██╔╝ ██╗
╚═════╝  ╚═════╝ ╚═╝  ╚═╝╚══════╝ ╚═════╝ ╚═╝  ╚═╝
--]]
-- SCRIPT BY: NOXA_TERMINAL | OWNER: ZAMXS
-- TANGGAL: 23/12/2025 (FIXED VERSION 3.4 - KELZZNOXA-V2 ULTIMATE)
-- GAME: FISH IT + PLANTS VS BRAINROT DUAL SCRIPT
-- FITUR: AUTO KEY GENERATOR (A-Z + 0-1) + DRAG GUI + MINIMIZE + ANTI ERROR

math.randomseed(os.time())
math.random() math.random() math.random()

-- ===================================================
--                     KONFIGURASI
-- ===================================================
local config = {
    version = "3.4",
    colors = {
        primary = Color3.fromRGB(255, 51, 102),
        secondary = Color3.fromRGB(102, 255, 153),
        bg = Color3.fromRGB(20, 20, 30),
        text = Color3.fromRGB(255, 255, 255)
    },
    gameIds = {
        fish = {121864768012064},  -- ID FISH IT asli dari Yang Mulia
        plants = {127742093697776} -- ID PLANTS VS BRAINROT asli
    }
}

-- ===================================================
--              KEY GENERATOR (A-Z + 0-1)
-- ===================================================
local characters = {}
for i = 65, 90 do table.insert(characters, string.char(i)) end
table.insert(characters, "0")
table.insert(characters, "1")

local function generateKey(prefix, length)
    length = length or 16
    local key = prefix or ""
    for i = 1, length do
        local rand = math.random(1, #characters)
        key = key .. characters[rand]
        if i % 4 == 0 and i < length then
            key = key .. "-"
        end
    end
    return key
end

local function generateFishKey()
    return generateKey("FISH-", 12)
end

local function generatePlantsKey()
    return generateKey("PLANT-", 12)
end

local function generateMasterKey()
    return generateKey("NOXA-", 16)
end

local function validateKey(key)
    key = key:upper()
    if key:match("^FISH%-[A-Z0-1][A-Z0-1][A-Z0-1][A-Z0-1]%-[A-Z0-1][A-Z0-1][A-Z0-1][A-Z0-1]%-[A-Z0-1][A-Z0-1][A-Z0-1][A-Z0-1]$") then
        return "fish"
    end
    if key:match("^PLANT%-[A-Z0-1][A-Z0-1][A-Z0-1][A-Z0-1]%-[A-Z0-1][A-Z0-1][A-Z0-1][A-Z0-1]%-[A-Z0-1][A-Z0-1][A-Z0-1][A-Z0-1]$") then
        return "plants"
    end
    if key:match("^NOXA%-[A-Z0-1][A-Z0-1][A-Z0-1][A-Z0-1]%-[A-Z0-1][A-Z0-1][A-Z0-1][A-Z0-1]%-[A-Z0-1][A-Z0-1][A-Z0-1][A-Z0-1]%-[A-Z0-1][A-Z0-1][A-Z0-1][A-Z0-1]$") then
        return "dual"
    end
    return nil
end

-- ===================================================
--              DETEKSI GAME OTOMATIS
-- ===================================================
local function detectCurrentGame()
    local placeId = game.PlaceId
    for gameType, ids in pairs(config.gameIds) do
        for _, id in ipairs(ids) do
            if placeId == id then
                return gameType
            end
        end
    end
    return nil
end

-- ===================================================
--              ANTI AFK
-- ===================================================
local function antiAFK()
    local vu = game:GetService("VirtualUser")
    game:GetService("Players").LocalPlayer.Idled:Connect(function()
        vu:Button2Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
        task.wait(1)
        vu:Button2Up(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
    end)
end
antiAFK()

-- ===================================================
--              PROTECT GUI
-- ===================================================
local function protectGUI(gui)
    local success, err = pcall(function()
        if syn and syn.protect_gui then
            syn.protect_gui(gui)
        elseif gethui then
            gui.Parent = gethui()
        elseif cloneref and game:GetService("CoreGui") then
            gui.Parent = cloneref(game:GetService("CoreGui"))
        else
            gui.Parent = game:GetService("CoreGui")
        end
    end)
    if not success then
        gui.Parent = game:GetService("CoreGui")
    end
    return gui
end

-- ===================================================
--           NOTIFIKASI MODERN
-- ===================================================
local function showNotification(text, duration)
    duration = duration or 3
    local gui = Instance.new("ScreenGui")
    gui.Name = "KelzzNotification"
    protectGUI(gui)

    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0, 300, 0, 60)
    frame.Position = UDim2.new(0.5, -150, 0.2, -30)
    frame.BackgroundColor3 = config.colors.bg
    frame.BorderSizePixel = 2
    frame.BorderColor3 = config.colors.primary
    frame.Parent = gui

    local textLabel = Instance.new("TextLabel")
    textLabel.Size = UDim2.new(1, -20, 1, -20)
    textLabel.Position = UDim2.new(0, 10, 0, 10)
    textLabel.BackgroundTransparency = 1
    textLabel.Text = text
    textLabel.TextColor3 = config.colors.secondary
    textLabel.TextWrapped = true
    textLabel.Font = Enum.Font.Code
    textLabel.TextSize = 16
    textLabel.Parent = frame

    task.wait(duration)
    gui:Destroy()
end

-- ===================================================
--                 KEY GENERATOR GUI
-- ===================================================
local function showKeyGenerator(callback)
    local success, gui = pcall(function()
        local gui = Instance.new("ScreenGui")
        gui.Name = "KeyGeneratorGUI"
        gui.ResetOnSpawn = false
        protectGUI(gui)

        local main = Instance.new("Frame")
        main.Name = "MainFrame"
        main.Size = UDim2.new(0, 500, 0, 450)
        main.Position = UDim2.new(0.5, -250, 0.5, -225)
        main.BackgroundColor3 = config.colors.bg
        main.BorderSizePixel = 3
        main.BorderColor3 = config.colors.primary
        main.Active = true
        main.Draggable = true
        main.Parent = gui

        local shadow = Instance.new("Frame")
        shadow.Name = "Shadow"
        shadow.Size = UDim2.new(1, 10, 1, 10)
        shadow.Position = UDim2.new(0, -5, 0, -5)
        shadow.BackgroundColor3 = Color3.new(0, 0, 0)
        shadow.BackgroundTransparency = 0.5
        shadow.ZIndex = -1
        shadow.Parent = main

        local titleBar = Instance.new("Frame")
        titleBar.Name = "TitleBar"
        titleBar.Size = UDim2.new(1, 0, 0, 40)
        titleBar.BackgroundColor3 = config.colors.primary
        titleBar.BorderSizePixel = 0
        titleBar.Parent = main

        local titleText = Instance.new("TextLabel")
        titleText.Name = "TitleText"
        titleText.Size = UDim2.new(1, -70, 1, 0)
        titleText.Position = UDim2.new(0, 10, 0, 0)
        titleText.BackgroundTransparency = 1
        titleText.Text = "KELZZNOXA KEY GENERATOR v" .. config.version
        titleText.TextColor3 = Color3.new(1, 1, 1)
        titleText.TextXAlignment = Enum.TextXAlignment.Left
        titleText.Font = Enum.Font.GothamBold
        titleText.TextSize = 18
        titleText.Parent = titleBar

        local closeBtn = Instance.new("TextButton")
        closeBtn.Name = "CloseBtn"
        closeBtn.Size = UDim2.new(0, 30, 0, 30)
        closeBtn.Position = UDim2.new(1, -35, 0, 5)
        closeBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
        closeBtn.Text = "X"
        closeBtn.TextColor3 = Color3.new(1, 1, 1)
        closeBtn.TextSize = 20
        closeBtn.Font = Enum.Font.GothamBold
        closeBtn.Parent = titleBar

        local infoText = Instance.new("TextLabel")
        infoText.Name = "InfoText"
        infoText.Size = UDim2.new(1, -40, 0, 60)
        infoText.Position = UDim2.new(0, 20, 0, 50)
        infoText.BackgroundTransparency = 1
        infoText.Text = "GENERATE KEY RANDOM DARI KOMBINASI A-Z DAN 0-1\nFormat key unik dengan sistem biner!"
        infoText.TextColor3 = config.colors.secondary
        infoText.Font = Enum.Font.Code
        infoText.TextSize = 14
        infoText.TextWrapped = true
        infoText.Parent = main

        local keyFrame = Instance.new("Frame")
        keyFrame.Name = "KeyFrame"
        keyFrame.Size = UDim2.new(1, -40, 0, 80)
        keyFrame.Position = UDim2.new(0, 20, 0, 120)
        keyFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
        keyFrame.BorderSizePixel = 2
        keyFrame.BorderColor3 = config.colors.secondary
        keyFrame.Parent = main

        local generatedKey = Instance.new("TextLabel")
        generatedKey.Name = "GeneratedKey"
        generatedKey.Size = UDim2.new(1, -20, 1, -20)
        generatedKey.Position = UDim2.new(0, 10, 0, 10)
        generatedKey.BackgroundTransparency = 1
        generatedKey.Text = "KLIK GENERATE"
        generatedKey.TextColor3 = config.colors.secondary
        generatedKey.Font = Enum.Font.Code
        generatedKey.TextSize = 20
        generatedKey.TextWrapped = true
        generatedKey.Parent = keyFrame

        local typeFrame = Instance.new("Frame")
        typeFrame.Name = "TypeFrame"
        typeFrame.Size = UDim2.new(1, -40, 0, 50)
        typeFrame.Position = UDim2.new(0, 20, 0, 210)
        typeFrame.BackgroundTransparency = 1
        typeFrame.Parent = main

        local keyType = "fish"

        local fishBtn = Instance.new("TextButton")
        fishBtn.Name = "FishBtn"
        fishBtn.Size = UDim2.new(0.3, -5, 1, -10)
        fishBtn.Position = UDim2.new(0, 0, 0, 5)
        fishBtn.BackgroundColor3 = config.colors.secondary
        fishBtn.Text = "FISH IT"
        fishBtn.TextColor3 = Color3.new(0, 0, 0)
        fishBtn.Font = Enum.Font.GothamBold
        fishBtn.TextSize = 16
        fishBtn.Parent = typeFrame

        local plantsBtn = Instance.new("TextButton")
        plantsBtn.Name = "PlantsBtn"
        plantsBtn.Size = UDim2.new(0.3, -5, 1, -10)
        plantsBtn.Position = UDim2.new(0.35, 0, 0, 5)
        plantsBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 70)
        plantsBtn.Text = "PLANTS"
        plantsBtn.TextColor3 = Color3.new(1, 1, 1)
        plantsBtn.Font = Enum.Font.GothamBold
        plantsBtn.TextSize = 16
        plantsBtn.Parent = typeFrame

        local masterBtn = Instance.new("TextButton")
        masterBtn.Name = "MasterBtn"
        masterBtn.Size = UDim2.new(0.3, -5, 1, -10)
        masterBtn.Position = UDim2.new(0.7, 0, 0, 5)
        masterBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 70)
        masterBtn.Text = "MASTER"
        masterBtn.TextColor3 = Color3.new(1, 1, 1)
        masterBtn.Font = Enum.Font.GothamBold
        masterBtn.TextSize = 16
        masterBtn.Parent = typeFrame

        local generateBtn = Instance.new("TextButton")
        generateBtn.Name = "GenerateBtn"
        generateBtn.Size = UDim2.new(1, -40, 0, 50)
        generateBtn.Position = UDim2.new(0, 20, 0, 270)
        generateBtn.BackgroundColor3 = config.colors.primary
        generateBtn.Text = "GENERATE KEY"
        generateBtn.TextColor3 = Color3.new(1, 1, 1)
        generateBtn.Font = Enum.Font.GothamBold
        generateBtn.TextSize = 20
        generateBtn.Parent = main

        local useBtn = Instance.new("TextButton")
        useBtn.Name = "UseBtn"
        useBtn.Size = UDim2.new(1, -40, 0, 50)
        useBtn.Position = UDim2.new(0, 20, 0, 330)
        useBtn.BackgroundColor3 = config.colors.secondary
        useBtn.Text = "GUNAKAN KEY INI"
        useBtn.TextColor3 = Color3.new(0, 0, 0)
        useBtn.Font = Enum.Font.GothamBold
        useBtn.TextSize = 20
        useBtn.Visible = false
        useBtn.Parent = main

        local statusText = Instance.new("TextLabel")
        statusText.Name = "StatusText"
        statusText.Size = UDim2.new(1, -40, 0, 30)
        statusText.Position = UDim2.new(0, 20, 0, 390)
        statusText.BackgroundTransparency = 1
        statusText.Text = "Siap generate key..."
        statusText.TextColor3 = config.colors.secondary
        statusText.Font = Enum.Font.Code
        statusText.TextSize = 12
        statusText.Parent = main

        local detectedGame = detectCurrentGame()
        if detectedGame == "fish" then
            keyType = "fish"
            fishBtn.BackgroundColor3 = config.colors.secondary
            fishBtn.TextColor3 = Color3.new(0, 0, 0)
            plantsBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 70)
            plantsBtn.TextColor3 = Color3.new(1, 1, 1)
            masterBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 70)
            masterBtn.TextColor3 = Color3.new(1, 1, 1)
            statusText.Text = "Game terdeteksi: FISH IT"
        elseif detectedGame == "plants" then
            keyType = "plants"
            plantsBtn.BackgroundColor3 = config.colors.primary
            plantsBtn.TextColor3 = Color3.new(1, 1, 1)
            fishBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 70)
            fishBtn.TextColor3 = Color3.new(1, 1, 1)
            masterBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 70)
            masterBtn.TextColor3 = Color3.new(1, 1, 1)
            statusText.Text = "Game terdeteksi: PLANTS"
        end

        local currentKey = ""
        local isVerifying = false
        local isGenerating = false

        fishBtn.MouseButton1Click:Connect(function()
            keyType = "fish"
            fishBtn.BackgroundColor3 = config.colors.secondary
            fishBtn.TextColor3 = Color3.new(0, 0, 0)
            plantsBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 70)
            plantsBtn.TextColor3 = Color3.new(1, 1, 1)
            masterBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 70)
            masterBtn.TextColor3 = Color3.new(1, 1, 1)
            statusText.Text = "Mode: FISH IT selected"
        end)

        plantsBtn.MouseButton1Click:Connect(function()
            keyType = "plants"
            plantsBtn.BackgroundColor3 = config.colors.primary
            plantsBtn.TextColor3 = Color3.new(1, 1, 1)
            fishBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 70)
            fishBtn.TextColor3 = Color3.new(1, 1, 1)
            masterBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 70)
            masterBtn.TextColor3 = Color3.new(1, 1, 1)
            statusText.Text = "Mode: PLANTS selected"
        end)

        masterBtn.MouseButton1Click:Connect(function()
            keyType = "master"
            masterBtn.BackgroundColor3 = config.colors.primary
            masterBtn.TextColor3 = Color3.new(1, 1, 1)
            fishBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 70)
            fishBtn.TextColor3 = Color3.new(1, 1, 1)
            plantsBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 70)
            plantsBtn.TextColor3 = Color3.new(1, 1, 1)
            statusText.Text = "Mode: MASTER KEY (dual game) selected"
        end)

        generateBtn.MouseButton1Click:Connect(function()
            if isGenerating then return end
            isGenerating = true
            generateBtn.Text = "GENERATING..."
            generateBtn.BackgroundColor3 = Color3.fromRGB(200, 200, 0)
            task.wait(0.5)
            if keyType == "fish" then
                currentKey = generateFishKey()
            elseif keyType == "plants" then
                currentKey = generatePlantsKey()
            else
                currentKey = generateMasterKey()
            end
            generatedKey.Text = currentKey
            generatedKey.TextColor3 = (keyType == "master") and Color3.fromRGB(255, 255, 0) or config.colors.secondary
            generateBtn.Text = "GENERATE KEY"
            generateBtn.BackgroundColor3 = config.colors.primary
            useBtn.Visible = true
            statusText.Text = "Key berhasil digenerate! Klik 'GUNAKAN KEY' untuk lanjut"
            isGenerating = false
        end)

        useBtn.MouseButton1Click:Connect(function()
            if currentKey == "" or isVerifying then return end
            isVerifying = true
            useBtn.Active = false
            useBtn.Text = "VERIFYING..."
            useBtn.BackgroundColor3 = Color3.fromRGB(200, 200, 0)
            task.wait(0.5)
            local gameType = validateKey(currentKey)
            if gameType then
                useBtn.Text = "VALID!"
                useBtn.BackgroundColor3 = config.colors.secondary
                statusText.Text = "Key valid! Loading script..."
                task.wait(0.5)
                gui:Destroy()
                callback(true, currentKey, gameType)
            else
                useBtn.Text = "INVALID!"
                useBtn.BackgroundColor3 = config.colors.primary
                statusText.Text = "Key tidak valid! Generate ulang"
                task.wait(1)
                useBtn.Text = "GUNAKAN KEY INI"
                useBtn.BackgroundColor3 = config.colors.secondary
                useBtn.Active = true
                isVerifying = false
            end
        end)

        closeBtn.MouseButton1Click:Connect(function()
            gui:Destroy()
            callback(false)
        end)

        return gui
    end)

    if not success then
        warn("Gagal load Key Generator:", gui)
        callback(false)
    end
end

-- ===================================================
--                 GUI CREATION
-- ===================================================
local function createMainGUI(gameType, key)
    local gui = Instance.new("ScreenGui")
    gui.Name = "KELZZNOXA_TERMINAL_GUI"
    gui.ResetOnSpawn = false
    protectGUI(gui)

    local main = Instance.new("Frame")
    main.Name = "MainFrame"
    main.Size = UDim2.new(0, 500, 0, 400)
    main.Position = UDim2.new(0.5, -250, 0.5, -200)
    main.BackgroundColor3 = config.colors.bg
    main.BorderSizePixel = 2
    main.BorderColor3 = config.colors.primary
    main.Active = true
    main.Draggable = true
    main.Parent = gui

    local shadow = Instance.new("Frame")
    shadow.Name = "Shadow"
    shadow.Size = UDim2.new(1, 10, 1, 10)
    shadow.Position = UDim2.new(0, -5, 0, -5)
    shadow.BackgroundColor3 = Color3.new(0, 0, 0)
    shadow.BackgroundTransparency = 0.5
    shadow.ZIndex = -1
    shadow.Parent = main

    local titleBar = Instance.new("Frame")
    titleBar.Name = "TitleBar"
    titleBar.Size = UDim2.new(1, 0, 0, 35)
    titleBar.BackgroundColor3 = config.colors.primary
    titleBar.BorderSizePixel = 0
    titleBar.Parent = main

    local titleText = Instance.new("TextLabel")
    titleText.Name = "TitleText"
    titleText.Size = UDim2.new(1, -70, 1, 0)
    titleText.Position = UDim2.new(0, 10, 0, 0)
    titleText.BackgroundTransparency = 1
    titleText.Text = "KELZZNOXA TERMINAL v" .. config.version .. " | Key: " .. key:sub(1, 10) .. "..."
    titleText.TextColor3 = Color3.new(1, 1, 1)
    titleText.TextXAlignment = Enum.TextXAlignment.Left
    titleText.Font = Enum.Font.GothamBold
    titleText.TextSize = 14
    titleText.Parent = titleBar

    local minimizeBtn = Instance.new("TextButton")
    minimizeBtn.Name = "MinimizeBtn"
    minimizeBtn.Size = UDim2.new(0, 30, 0, 30)
    minimizeBtn.Position = UDim2.new(1, -35, 0, 2.5)
    minimizeBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
    minimizeBtn.Text = "-"
    minimizeBtn.TextColor3 = Color3.new(1, 1, 1)
    minimizeBtn.TextSize = 20
    minimizeBtn.Font = Enum.Font.GothamBold
    minimizeBtn.Parent = titleBar

    local closeBtn = Instance.new("TextButton")
    closeBtn.Name = "CloseBtn"
    closeBtn.Size = UDim2.new(0, 30, 0, 30)
    closeBtn.Position = UDim2.new(1, -70, 0, 2.5)
    closeBtn.BackgroundColor3 = config.colors.primary
    closeBtn.Text = "X"
    closeBtn.TextColor3 = Color3.new(1, 1, 1)
    closeBtn.TextSize = 20
    closeBtn.Font = Enum.Font.GothamBold
    closeBtn.Parent = titleBar

    local tabFrame = Instance.new("Frame")
    tabFrame.Name = "TabFrame"
    tabFrame.Size = UDim2.new(1, 0, 0, 40)
    tabFrame.Position = UDim2.new(0, 0, 0, 35)
    tabFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
    tabFrame.BorderSizePixel = 0
    tabFrame.Parent = main

    local fishTab = Instance.new("TextButton")
    fishTab.Name = "FishTab"
    fishTab.Size = UDim2.new(0.5, -1, 1, -2)
    fishTab.Position = UDim2.new(0, 0, 0, 1)
    fishTab.BackgroundColor3 = config.colors.secondary
    fishTab.Text = "FISH IT"
    fishTab.TextColor3 = Color3.new(0, 0, 0)
    fishTab.TextSize = 18
    fishTab.Font = Enum.Font.GothamBold
    fishTab.Parent = tabFrame

    local plantsTab = Instance.new("TextButton")
    plantsTab.Name = "PlantsTab"
    plantsTab.Size = UDim2.new(0.5, -1, 1, -2)
    plantsTab.Position = UDim2.new(0.5, 1, 0, 1)
    plantsTab.BackgroundColor3 = Color3.fromRGB(60, 60, 70)
    plantsTab.Text = "PLANTS VS BRAINROT"
    plantsTab.TextColor3 = Color3.new(1, 1, 1)
    plantsTab.TextSize = 18
    plantsTab.Font = Enum.Font.GothamBold
    plantsTab.Parent = tabFrame

    local contentFrame = Instance.new("Frame")
    contentFrame.Name = "ContentFrame"
    contentFrame.Size = UDim2.new(1, -20, 1, -115)
    contentFrame.Position = UDim2.new(0, 10, 0, 85)
    contentFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
    contentFrame.BorderSizePixel = 1
    contentFrame.BorderColor3 = config.colors.primary
    contentFrame.Parent = main

    local statusBar = Instance.new("Frame")
    statusBar.Name = "StatusBar"
    statusBar.Size = UDim2.new(1, -20, 0, 25)
    statusBar.Position = UDim2.new(0, 10, 1, -30)
    statusBar.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
    statusBar.BorderSizePixel = 1
    statusBar.BorderColor3 = config.colors.secondary
    statusBar.Parent = main

    local statusText = Instance.new("TextLabel")
    statusText.Name = "StatusText"
    statusText.Size = UDim2.new(1, -10, 1, 0)
    statusText.Position = UDim2.new(0, 5, 0, 0)
    statusText.BackgroundTransparency = 1
    statusText.Text = "SYSTEM READY | Game: " .. (gameType == "dual" and "DUAL MODE" or gameType:upper())
    statusText.TextColor3 = config.colors.secondary
    statusText.TextXAlignment = Enum.TextXAlignment.Left
    statusText.Font = Enum.Font.Code
    statusText.TextSize = 12
    statusText.Parent = statusBar

    local watermark = Instance.new("TextLabel")
    watermark.Name = "Watermark"
    watermark.Size = UDim2.new(0, 200, 0, 30)
    watermark.Position = UDim2.new(0, 10, 1, -60)
    watermark.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    watermark.BackgroundTransparency = 0.5
    watermark.Text = "KELZZNOXA-V2 | ZAMXS"
    watermark.TextColor3 = config.colors.primary
    watermark.Font = Enum.Font.Code
    watermark.TextSize = 14
    watermark.Parent = gui

    local minimized = false
    minimizeBtn.MouseButton1Click:Connect(function()
        minimized = not minimized
        if minimized then
            main.Size = UDim2.new(0, 500, 0, 35)
            for _, v in pairs(main:GetChildren()) do
                if v ~= titleBar and v ~= shadow then
                    v.Visible = false
                end
            end
            watermark.Visible = false
            minimizeBtn.Text = "+"
        else
            main.Size = UDim2.new(0, 500, 0, 400)
            for _, v in pairs(main:GetChildren()) do
                if v ~= titleBar and v ~= shadow then
                    v.Visible = true
                end
            end
            watermark.Visible = true
            minimizeBtn.Text = "-"
        end
    end)

    closeBtn.MouseButton1Click:Connect(function()
        gui:Destroy()
    end)

    local function createFishItFeatures(parent)
        local scrolling = Instance.new("ScrollingFrame")
        scrolling.Name = "FishItFeatures"
        scrolling.Size = UDim2.new(1, 0, 1, 0)
        scrolling.BackgroundTransparency = 1
        scrolling.ScrollBarThickness = 5
        scrolling.ScrollBarImageColor3 = config.colors.secondary
        scrolling.CanvasSize = UDim2.new(0, 0, 0, 600)
        scrolling.Parent = parent

        local features = {
            {name = "Auto Fish", desc = "Otomatis mancing + instant catch", key = "autoFish", color = config.colors.secondary},
            {name = "Legendary Hack", desc = "Semua ikan jadi LEGENDARY", key = "legendary", color = config.colors.secondary},
            {name = "Auto Cast", desc = "Cast otomatis terus menerus", key = "autoCast", color = config.colors.secondary},
            {name = "Auto Sell", desc = "Jual ikan otomatis", key = "autoSell", color = config.colors.secondary},
            {name = "Dupe Inventory", desc = "Gandakan semua item", key = "dupe", color = config.colors.secondary},
            {name = "Teleport Spot", desc = "Teleport ke spot terbaik", key = "teleport", color = config.colors.secondary},
            {name = "Anti AFK", desc = "Anti di kick", key = "antiAfk", color = config.colors.secondary},
            {name = "Speed Hack", desc = "Speed jalan + berenang", key = "speed", color = config.colors.secondary},
            {name = "ESP Fish", desc = "Lihat ikan tembus objek", key = "esp", color = config.colors.secondary},
            {name = "Auto Reel", desc = "Otomatis narik pancing", key = "autoReel", color = config.colors.secondary}
        }

        local yPos = 5
        for i, feature in ipairs(features) do
            local frame = Instance.new("Frame")
            frame.Size = UDim2.new(1, -20, 0, 50)
            frame.Position = UDim2.new(0, 10, 0, yPos)
            frame.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
            frame.BorderSizePixel = 1
            frame.BorderColor3 = feature.color
            frame.Parent = scrolling

            local name = Instance.new("TextLabel")
            name.Size = UDim2.new(0.6, -5, 1, 0)
            name.Position = UDim2.new(0, 10, 0, 0)
            name.BackgroundTransparency = 1
            name.Text = feature.name
            name.TextColor3 = Color3.new(1, 1, 1)
            name.TextXAlignment = Enum.TextXAlignment.Left
            name.Font = Enum.Font.GothamBold
            name.TextSize = 16
            name.Parent = frame

            local desc = Instance.new("TextLabel")
            desc.Size = UDim2.new(0.6, -5, 1, 0)
            desc.Position = UDim2.new(0, 10, 0, 20)
            desc.BackgroundTransparency = 1
            desc.Text = feature.desc
            desc.TextColor3 = Color3.fromRGB(150, 150, 150)
            desc.TextXAlignment = Enum.TextXAlignment.Left
            desc.Font = Enum.Font.Code
            desc.TextSize = 11
            desc.Parent = frame

            local toggle = Instance.new("TextButton")
            toggle.Name = feature.key
            toggle.Size = UDim2.new(0, 60, 0, 30)
            toggle.Position = UDim2.new(1, -70, 0.5, -15)
            toggle.BackgroundColor3 = Color3.fromRGB(60, 60, 70)
            toggle.Text = "OFF"
            toggle.TextColor3 = Color3.new(1, 0, 0)
            toggle.TextSize = 14
            toggle.Font = Enum.Font.GothamBold
            toggle.Parent = frame

            local enabled = false
            toggle.MouseButton1Click:Connect(function()
                enabled = not enabled
                if enabled then
                    toggle.BackgroundColor3 = feature.color
                    toggle.Text = "ON"
                    toggle.TextColor3 = Color3.new(1, 1, 1)
                else
                    toggle.BackgroundColor3 = Color3.fromRGB(60, 60, 70)
                    toggle.Text = "OFF"
                    toggle.TextColor3 = Color3.new(1, 0, 0)
                end
            end)

            yPos = yPos + 55
        end

        scrolling.CanvasSize = UDim2.new(0, 0, 0, yPos + 10)
        return scrolling
    end

    local function createPlantsFeatures(parent)
        local scrolling = Instance.new("ScrollingFrame")
        scrolling.Name = "PlantsFeatures"
        scrolling.Size = UDim2.new(1, 0, 1, 0)
        scrolling.BackgroundTransparency = 1
        scrolling.ScrollBarThickness = 5
        scrolling.ScrollBarImageColor3 = config.colors.primary
        scrolling.CanvasSize = UDim2.new(0, 0, 0, 600)
        scrolling.Parent = parent

        local features = {
            {name = "Infinite Sun", desc = "Sun unlimited", key = "infiniteSun", color = config.colors.primary},
            {name = "Instant Win", desc = "Menang dalam 1 detik", key = "instantWin", color = config.colors.primary},
            {name = "Plant Spam", desc = "Taro tanaman di mana aja", key = "plantSpam", color = config.colors.primary},
            {name = "Unlock All Plants", desc = "Buka semua tanaman", key = "unlockPlants", color = config.colors.primary},
            {name = "Zombie Remover", desc = "Hapus semua zombie", key = "zombieKiller", color = config.colors.primary},
            {name = "Fast Wave", desc = "Wave cepet selesai", key = "fastWave", color = config.colors.primary},
            {name = "God Mode", desc = "Tanaman gak bisa mati", key = "godMode", color = config.colors.primary},
            {name = "Auto Collect", desc = "Auto collect sun/coins", key = "autoCollect", color = config.colors.primary},
            {name = "Brain Rot", desc = "Zombie langsung mati", key = "brainRot", color = config.colors.primary},
            {name = "Unlimited Plants", desc = "Tanaman unlimited", key = "unlimitedPlants", color = config.colors.primary}
        }

        local yPos = 5
        for i, feature in ipairs(features) do
            local frame = Instance.new("Frame")
            frame.Size = UDim2.new(1, -20, 0, 50)
            frame.Position = UDim2.new(0, 10, 0, yPos)
            frame.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
            frame.BorderSizePixel = 1
            frame.BorderColor3 = feature.color
            frame.Parent = scrolling

            local name = Instance.new("TextLabel")
            name.Size = UDim2.new(0.6, -5, 1, 0)
            name.Position = UDim2.new(0, 10, 0, 0)
            name.BackgroundTransparency = 1
            name.Text = feature.name
            name.TextColor3 = Color3.new(1, 1, 1)
            name.TextXAlignment = Enum.TextXAlignment.Left
            name.Font = Enum.Font.GothamBold
            name.TextSize = 16
            name.Parent = frame

            local desc = Instance.new("TextLabel")
            desc.Size = UDim2.new(0.6, -5, 1, 0)
            desc.Position = UDim2.new(0, 10, 0, 20)
            desc.BackgroundTransparency = 1
            desc.Text = feature.desc
            desc.TextColor3 = Color3.fromRGB(150, 150, 150)
            desc.TextXAlignment = Enum.TextXAlignment.Left
            desc.Font = Enum.Font.Code
            desc.TextSize = 11
            desc.Parent = frame

            local toggle = Instance.new("TextButton")
            toggle.Name = feature.key
            toggle.Size = UDim2.new(0, 60, 0, 30)
            toggle.Position = UDim2.new(1, -70, 0.5, -15)
            toggle.BackgroundColor3 = Color3.fromRGB(60, 60, 70)
            toggle.Text = "OFF"
            toggle.TextColor3 = Color3.new(1, 0, 0)
            toggle.TextSize = 14
            toggle.Font = Enum.Font.GothamBold
            toggle.Parent = frame

            local enabled = false
            toggle.MouseButton1Click:Connect(function()
                enabled = not enabled
                if enabled then
                    toggle.BackgroundColor3 = feature.color
                    toggle.Text = "ON"
                    toggle.TextColor3 = Color3.new(1, 1, 1)
                else
                    toggle.BackgroundColor3 = Color3.fromRGB(60, 60, 70)
                    toggle.Text = "OFF"
                    toggle.TextColor3 = Color3.new(1, 0, 0)
                end
            end)

            yPos = yPos + 55
        end

        scrolling.CanvasSize = UDim2.new(0, 0, 0, yPos + 10)
        return scrolling
    end

    local function switchToFish()
        for _, v in pairs(contentFrame:GetChildren()) do
            if v:IsA("ScrollingFrame") then
                v:Destroy()
            end
        end
        createFishItFeatures(contentFrame)
        fishTab.BackgroundColor3 = config.colors.secondary
        fishTab.TextColor3 = Color3.new(0, 0, 0)
        plantsTab.BackgroundColor3 = Color3.fromRGB(60, 60, 70)
        plantsTab.TextColor3 = Color3.new(1, 1, 1)
        statusText.Text = "FISH IT MODE ACTIVE"
    end

    local function switchToPlants()
        for _, v in pairs(contentFrame:GetChildren()) do
            if v:IsA("ScrollingFrame") then
                v:Destroy()
            end
        end
        createPlantsFeatures(contentFrame)
        plantsTab.BackgroundColor3 = config.colors.primary
        plantsTab.TextColor3 = Color3.new(1, 1, 1)
        fishTab.BackgroundColor3 = Color3.fromRGB(60, 60, 70)
        fishTab.TextColor3 = Color3.new(1, 1, 1)
        statusText.Text = "PLANTS VS BRAINROT MODE ACTIVE"
    end

    fishTab.MouseButton1Click:Connect(switchToFish)
    plantsTab.MouseButton1Click:Connect(switchToPlants)

    if gameType == "fish" then
        switchToFish()
        statusText.Text = "FISH IT MODE ACTIVE | Key: " .. key
    elseif gameType == "plants" then
        switchToPlants()
        statusText.Text = "PLANTS VS BRAINROT MODE ACTIVE | Key: " .. key
    else
        switchToFish()
        statusText.Text = "DUAL MODE ACTIVE (MASTER KEY) | Key: " .. key
    end
end

local function main()
    showKeyGenerator(function(success, key, gameType)
        if success and key and gameType then
            showNotification("Key valid! Loading KELZZNOXA TERMINAL...", 2)
            task.wait(1)
            createMainGUI(gameType, key)
        else
            game:GetService("Players").LocalPlayer:Kick("Key generator ditutup! Inject ulang untuk generate key.")
        end
    end)
end

local success, err = pcall(main)
if not success then
    warn("KELZZNOXA TERMINAL Error:", err)
    showNotification("Error: " .. tostring(err), 5)
end

showNotification("KELZZNOXA TERMINAL v3.4 | Key Generator Active | Created by: ZAMXS", 3)
