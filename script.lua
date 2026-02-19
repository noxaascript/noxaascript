--[[
    NOXA ULTIMATE HUB - 99 Nights + Plants vs Brainrots
    Created for: zamxs
    Website: noxakeyhubb.infinityfreeapp.com
    Drag System: ZYLNX-style (smooth & responsive)
]]

-- Load Library
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/source.lua"))()
local Window = Library.CreateLib("NOXA ULTIMATE HUB - zamxs", "DarkTheme")

wait(1.5)

-- ================= DRAG SYSTEM (ZYLNX STYLE) =================
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local guiMain = Window.MainFrame

if guiMain then
    -- Hapus drag area lama jika ada
    for _, v in pairs(guiMain:GetChildren()) do
        if v.Name == "DragArea" then
            v:Destroy()
        end
    end

    -- Buat title bar baru (sebagai drag area)
    local titleBar = Instance.new("Frame")
    titleBar.Name = "DragArea"
    titleBar.Size = UDim2.new(1, 0, 0, 35)
    titleBar.Position = UDim2.new(0, 0, 0, 0)  -- di dalam GUI, di atas
    titleBar.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    titleBar.BorderSizePixel = 0
    titleBar.ZIndex = 9999
    titleBar.Active = true
    titleBar.Parent = guiMain

    -- Geser semua konten ke bawah (agar tidak ketimpa title bar)
    for _, v in pairs(guiMain:GetChildren()) do
        if v:IsA("Frame") and v.Name ~= "DragArea" then
            v.Position = UDim2.new(0, 0, 0, 35)
        end
    end

    -- Garis merah pembatas
    local line = Instance.new("Frame")
    line.Size = UDim2.new(1, 0, 0, 3)
    line.Position = UDim2.new(0, 0, 1, 0)
    line.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
    line.BorderSizePixel = 0
    line.ZIndex = 9999
    line.Parent = titleBar

    -- Label
    local dragLabel = Instance.new("TextLabel")
    dragLabel.Size = UDim2.new(0, 200, 1, 0)
    dragLabel.Position = UDim2.new(0, 10, 0, 0)
    dragLabel.BackgroundTransparency = 1
    dragLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
    dragLabel.Text = "NOXA HUB (Drag Here)"
    dragLabel.Font = Enum.Font.GothamBold
    dragLabel.TextSize = 14
    dragLabel.TextXAlignment = Enum.TextXAlignment.Left
    dragLabel.ZIndex = 9999
    dragLabel.Parent = titleBar

    -- Minimize Button
    local minBtn = Instance.new("TextButton")
    minBtn.Size = UDim2.new(0, 30, 0, 25)
    minBtn.Position = UDim2.new(1, -35, 0, 5)
    minBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    minBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    minBtn.Text = "-"
    minBtn.Font = Enum.Font.GothamBold
    minBtn.TextSize = 20
    minBtn.BorderSizePixel = 0
    minBtn.ZIndex = 9999
    minBtn.Parent = titleBar

    -- Variabel drag
    local dragging = false
    local dragOffset = Vector2.new(0, 0)
    local mouse = game.Players.LocalPlayer:GetMouse()

    titleBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragOffset = Vector2.new(mouse.X, mouse.Y) - Vector2.new(guiMain.AbsolutePosition.X, guiMain.AbsolutePosition.Y)
        end
    end)

    titleBar.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)

    RunService.RenderStepped:Connect(function()
        if dragging then
            local newPos = Vector2.new(mouse.X, mouse.Y) - dragOffset
            guiMain.Position = UDim2.new(0, newPos.X, 0, newPos.Y)
        end
    end)

    -- Minimize system
    local minimized = false
    local originalSize = guiMain.Size

    minBtn.MouseButton1Click:Connect(function()
        minimized = not minimized
        if minimized then
            originalSize = guiMain.Size
            guiMain.Size = UDim2.new(0, 250, 0, 35)
            for _, v in pairs(guiMain:GetChildren()) do
                if v:IsA("Frame") and v.Name ~= "DragArea" then
                    v.Visible = false
                end
            end
            minBtn.Text = "[]"
            dragLabel.Text = "NOXA [MIN]"
        else
            guiMain.Size = originalSize
            for _, v in pairs(guiMain:GetChildren()) do
                if v:IsA("Frame") and v.Name ~= "DragArea" then
                    v.Visible = true
                end
            end
            minBtn.Text = "-"
            dragLabel.Text = "NOXA HUB (Drag Here)"
        end
    end)
end

-- ================= KEY SYSTEM (FIXED) =================
local KeySystem = Window:NewTab("ACTIVATION")
local KeySection = KeySystem:NewSection("KEY VALIDATION")

KeySection:NewLabel("HOW TO GET KEY:")
KeySection:NewLabel("1. Click 'GET 99N' or 'GET BR' below")
KeySection:NewLabel("2. Or visit: noxakeyhubb.infinityfreeapp.com")
KeySection:NewLabel("")
KeySection:NewLabel("ENTER YOUR KEY:")

local KeyInput = KeySection:NewTextBox("Enter Key", "NOXA-99N-XXXX-12345-XXXXX", function(v) end)
local KeyStatus = KeySection:NewLabel("Status: NOT ACTIVE")
local KeyValid = false

-- GET KEY BUTTONS
KeySection:NewButton("GET KEY - 99 NIGHTS", function()
    local success, key = pcall(function()
        return game:HttpGet("http://noxakeyhubb.infinityfreeapp.com/getkey.php?game=1")
    end)
    if success and key and string.find(key, "NOXA") then
        KeyInput.Text = key
        Library:Notify("Key obtained (expires in 5 min)")
    else
        Library:Notify("Failed to get key - Server error")
    end
end)

KeySection:NewButton("GET KEY - BRAINROTS", function()
    local success, key = pcall(function()
        return game:HttpGet("http://noxakeyhubb.infinityfreeapp.com/getkey.php?game=2")
    end)
    if success and key and string.find(key, "NOXA") then
        KeyInput.Text = key
        Library:Notify("Key obtained (expires in 5 min)")
    else
        Library:Notify("Failed to get key - Server error")
    end
end)

-- Deteksi game dari key
local function detectGameFromKey(key)
    if string.find(key, "99N") then
        return 1, "99 Nights"
    elseif string.find(key, "BR") then
        return 2, "Brainrots"
    else
        return nil, "Unknown"
    end
end

-- VERIFY KEY
KeySection:NewButton("VERIFY KEY", function()
    local key = KeyInput.Text
    if key == "" then
        KeyStatus:Set("Status: KEY EMPTY")
        return
    end

    KeyStatus:Set("Status: VERIFYING...")

    local gameParam, gameName = detectGameFromKey(key)

    if not gameParam then
        KeyStatus:Set("Status: INVALID FORMAT")
        Library:Notify("Key must contain 99N or BR")
        return
    end

    local success, response = pcall(function()
        return game:HttpGet("http://noxakeyhubb.infinityfreeapp.com/verify.php?key=" .. key .. "&game=" .. gameParam)
    end)

    if success and response == "VALID" then
        KeyValid = true
        KeyStatus:Set("Status: KEY VALID (" .. gameName .. ")")
        Library:Notify("KEY VALID - Features unlocked for " .. gameName)
    elseif success and response == "INVALID" then
        KeyStatus:Set("Status: KEY INVALID")
        Library:Notify("KEY INVALID or EXPIRED")
    else
        KeyStatus:Set("Status: VERIFY FAILED")
        Library:Notify("Connection failed - Check server")
    end
end)

local function checkKey()
    if not KeyValid then
        Library:Notify("Activate key first")
        return false
    end
    return true
end

-- ================= 99 NIGHTS =================
local NightsTab = Window:NewTab("99 NIGHTS")
local f1 = NightsTab:NewSection("AUTO FARM")
f1:NewToggle("Auto Wood", "", function(s) if checkKey() then _G.AW=s; while _G.AW do wait(0.5) end end end)
f1:NewToggle("Auto Stone", "", function(s) if checkKey() then _G.AS=s; while _G.AS do wait(0.5) end end end)

local c1 = NightsTab:NewSection("COMBAT")
c1:NewToggle("Kill Aura", "", function(s) if checkKey() then _G.KA=s; while _G.KA do wait(0.1) end end end)
c1:NewToggle("God Mode", "", function(s) if checkKey() then _G.GM=s end end)

local e1 = NightsTab:NewSection("ESP")
e1:NewToggle("ESP Monster", "", function(s) if checkKey() then _G.EM=s end end)
e1:NewToggle("ESP Player", "", function(s) if checkKey() then _G.EP=s end end)

local m1 = NightsTab:NewSection("MOVEMENT")
m1:NewToggle("Fly", "", function(s) if checkKey() then _G.Fly=s end end)
m1:NewSlider("Speed", "", 200, 16, function(v) if checkKey() then pcall(function() game.Players.LocalPlayer.Character.Humanoid.WalkSpeed=v end) end end)
m1:NewSlider("Jump", "", 200, 50, function(v) if checkKey() then pcall(function() game.Players.LocalPlayer.Character.Humanoid.JumpPower=v end) end end)
m1:NewButton("Teleport to Camp", "", function() if checkKey() then 
    local camp = workspace:FindFirstChild("Camp") or workspace:FindFirstChild("Spawn")
    if camp then game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = camp.CFrame end
end end)

-- ================= BRAINROTS =================
local PlantsTab = Window:NewTab("BRAINROTS")
local p1 = PlantsTab:NewSection("AUTO FARM")
p1:NewToggle("Auto Money", "", function(s) if checkKey() then _G.AM=s; while _G.AM do wait(0.1) end end end)
p1:NewToggle("Auto Sell", "", function(s) if checkKey() then _G.ASell=s; while _G.ASell do wait(2) end end end)

local p2 = PlantsTab:NewSection("SPAWNER")
p2:NewToggle("Brainrot Spawner", "", function(s) if checkKey() then _G.BS=s; while _G.BS do wait(1) end end end)
p2:NewSlider("Attack Speed", "", 200, 10, function(v) if checkKey() then _G.Attack=v end end)

local p3 = PlantsTab:NewSection("UPGRADE")
p3:NewToggle("Auto Upgrade", "", function(s) if checkKey() then _G.AU=s; while _G.AU do wait(5) end end end)

-- ================= COMBO =================
local ComboTab = Window:NewTab("COMBO")
local cs = ComboTab:NewSection("COMBINED")
cs:NewToggle("Auto Farm Both", "", function(s) if checkKey() then _G.CF=s; while _G.CF do wait(0.5) end end end)
cs:NewButton("Switch Game", "", function() if checkKey() then 
    local tp = game:GetService("TeleportService")
    local id = game.PlaceId
    if id == 9828735123 then 
        tp:Teleport(1838492312, game.Players.LocalPlayer)
    else 
        tp:Teleport(9828735123, game.Players.LocalPlayer) 
    end
end end)

-- ================= INFO =================
local InfoTab = Window:NewTab("INFO")
local inf = InfoTab:NewSection("NOXA HUB INFO")
inf:NewLabel("━━━━━━━━━━━━━━━━━━")
inf:NewLabel("NAME: NOXA HUB")
inf:NewLabel("OWNER: zamxs")
inf:NewLabel("PHONE: +6282117450684")
inf:NewLabel("DATE: 23/12/2025")
inf:NewLabel("━━━━━━━━━━━━━━━━━━")
inf:NewButton("COPY WEBSITE", function() 
    setclipboard("noxakeyhubb.infinityfreeapp.com") 
    Library:Notify("Website link copied") 
end)

Library:Notify("NOXA HUB LOADED - Drag the gray bar at top")
