--[[
    NOXA ULTIMATE HUB - 99 Nights + Plants vs Brainrots
    Created for: zamxs
    Website: noxakeyhubb.infinityfreeapp.com
    Fitur: Auto Detect Key (No Dropdown)
]]

-- Load Library
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/source.lua"))()
local Window = Library.CreateLib("NOXA ULTIMATE HUB - zamxs", "DarkTheme")

wait(1.5)

-- ================= DRAG SYSTEM (FINAL FIX) =================
local UIS = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local guiMain = Window.MainFrame

if guiMain then
    -- Hapus drag area lama
    for _, v in pairs(guiMain:GetChildren()) do
        if v.Name == "DragArea" then
            v:Destroy()
        end
    end
    
    -- Drag area baru (PASTI KELIATAN)
    local dragArea = Instance.new("Frame")
    dragArea.Name = "DragArea"
    dragArea.Size = UDim2.new(1, 0, 0, 35)
    dragArea.Position = UDim2.new(0, 0, 0, -35)
    dragArea.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    dragArea.BorderSizePixel = 0
    dragArea.ZIndex = 9999
    dragArea.Active = true
    dragArea.Parent = guiMain
    
    -- Garis merah pembatas
    local line = Instance.new("Frame")
    line.Size = UDim2.new(1, 0, 0, 3)
    line.Position = UDim2.new(0, 0, 1, 0)
    line.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
    line.BorderSizePixel = 0
    line.ZIndex = 9999
    line.Parent = dragArea
    
    -- Label
    local dragLabel = Instance.new("TextLabel")
    dragLabel.Size = UDim2.new(0, 150, 1, 0)
    dragLabel.Position = UDim2.new(0, 10, 0, 0)
    dragLabel.BackgroundTransparency = 1
    dragLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
    dragLabel.Text = "NOXA HUB"
    dragLabel.Font = Enum.Font.GothamBold
    dragLabel.TextSize = 16
    dragLabel.TextXAlignment = Enum.TextXAlignment.Left
    dragLabel.ZIndex = 9999
    dragLabel.Parent = dragArea
    
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
    minBtn.Parent = dragArea
    
    -- DRAG SYSTEM
    local dragging = false
    local dragStart, startPos
    
    dragArea.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = guiMain.Position
        end
    end)
    
    dragArea.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)
    
    UIS.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = input.Position - dragStart
            guiMain.Position = UDim2.new(
                startPos.X.Scale,
                startPos.X.Offset + delta.X,
                startPos.Y.Scale,
                startPos.Y.Offset + delta.Y
            )
        end
    end)
    
    -- MINIMIZE SYSTEM
    local minimized = false
    local originalSize = guiMain.Size
    
    minBtn.MouseButton1Click:Connect(function()
        minimized = not minimized
        if minimized then
            if originalSize == guiMain.Size then
                originalSize = guiMain.Size
            end
            guiMain:TweenSize(UDim2.new(0, 220, 0, 35), "Out", "Quad", 0.3, true)
            for _, v in pairs(guiMain:GetChildren()) do
                if v:IsA("Frame") and v.Name ~= "DragArea" then
                    v.Visible = false
                end
            end
            minBtn.Text = "□"
            dragLabel.Text = "NOXA [MIN]"
        else
            guiMain:TweenSize(originalSize, "Out", "Quad", 0.3, true)
            for _, v in pairs(guiMain:GetChildren()) do
                if v:IsA("Frame") and v.Name ~= "DragArea" then
                    v.Visible = true
                end
            end
            minBtn.Text = "-"
            dragLabel.Text = "NOXA HUB"
        end
    end)
end

-- ================= KEY SYSTEM - AUTO DETECT GAME =================
local KeySystem = Window:NewTab("ACTIVATION")
local KeySection = KeySystem:NewSection("KEY VALIDATION")

KeySection:NewLabel("━━━━━━━━━━━━━━━━━━━━━━")
KeySection:NewLabel("HOW TO GET KEY:")
KeySection:NewLabel("1. Click 'GET KEY' for 5-min key")
KeySection:NewLabel("2. Or visit: noxakeyhubb.infinityfreeapp.com")
KeySection:NewLabel("━━━━━━━━━━━━━━━━━━━━━━")
KeySection:NewLabel("")
KeySection:NewLabel("ENTER YOUR KEY:")

local KeyInput = KeySection:NewTextBox("Enter Key", "NOXA-99N-XXXX-12345-XXXXX", function(v) end)
local KeyStatus = KeySection:NewLabel("Status: NOT ACTIVE")
local KeyValid = false
local DetectedGame = ""

-- Fungsi auto detect game dari format key
local function detectGameFromKey(key)
    if string.find(key, "99N") then
        return 1, "99 Nights"
    elseif string.find(key, "BR") then
        return 2, "Brainrots"
    else
        return nil, "Unknown"
    end
end

-- Tombol GET KEY (otomatis pilih game sesuai dropdown sebelumnya, tapi kita kasih pilihan manual di sini)
KeySection:NewButton("⚡ GET KEY (5 MIN)", function()
    -- Tampilkan pilihan game sederhana pake Notify (karena dropdown dihapus)
    Library:Notify("Choose game: Click again for 99 Nights, or use website")
    -- Solusi sederhana: minta user pilih lewat website atau kita buat dua tombol terpisah
end)

-- Tombol GET KEY untuk 99 Nights
KeySection:NewButton("🌲 GET KEY - 99 NIGHTS", function()
    local success, key = pcall(function()
        return game:HttpGet("http://noxakeyhubb.infinityfreeapp.com/getkey.php?game=1")
    end)
    if success and key and string.sub(key,1,4) == "NOXA" then
        KeyInput.Text = key
        Library:Notify("Key obtained (expires in 5 min)")
    else
        Library:Notify("Failed to get key")
    end
end)

-- Tombol GET KEY untuk Brainrots
KeySection:NewButton("🧠 GET KEY - BRAINROTS", function()
    local success, key = pcall(function()
        return game:HttpGet("http://noxakeyhubb.infinityfreeapp.com/getkey.php?game=2")
    end)
    if success and key and string.sub(key,1,4) == "NOXA" then
        KeyInput.Text = key
        Library:Notify("Key obtained (expires in 5 min)")
    else
        Library:Notify("Failed to get key")
    end
end)

-- Tombol VERIFY (otomatis deteksi game)
KeySection:NewButton("✓ VERIFY KEY", function()
    local key = KeyInput.Text
    if key == "" then
        KeyStatus:Set("Status: KEY EMPTY")
        return
    end
    
    KeyStatus:Set("Status: VERIFYING...")
    
    -- Auto detect game dari key
    local gameParam, gameName = detectGameFromKey(key)
    
    if not gameParam then
        KeyStatus:Set("Status: INVALID FORMAT")
        Library:Notify("Key format invalid - Must contain 99N or BR")
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
        Library:Notify("Connection failed")
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
inf:NewLabel("Drag & Minimize FIXED")
inf:NewLabel("5-min Key System")
inf:NewLabel("Auto Detect Game from Key")
inf:NewButton("COPY WEBSITE", function() 
    setclipboard("noxakeyhubb.infinityfreeapp.com") 
    Library:Notify("Website link copied") 
end)

Library:Notify("NOXA HUB LOADED - Drag the RED line above")
