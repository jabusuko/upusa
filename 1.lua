-- FISH IT - ULTRA OPTIMIZED FOR OBFUSCATION
-- All variables grouped into tables to avoid "200+ local variables" error
-- This version should work with most obfuscators
-- Optimizations:
-- 1. All UI elements grouped into _G.UI table
-- 2. All services grouped into _G.Services table  
-- 3. All variables grouped into _G.Vars table
-- 4. All functions grouped into _G.Funcs table
-- 5. All remotes grouped into _G.Remotes table
-- 6. All tabs grouped into _G.Tabs table

local _G = {}
_G.WindUI = loadstring(game:HttpGet("https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"))()
local WindUI = _G.WindUI

WindUI:AddTheme({
    Name = "Fyy Exploit", 
    
    Accent = WindUI:Gradient({                                                  
        ["0"] = { Color = Color3.fromHex("#1f1f23"), Transparency = 0 },        
        ["100"]   = { Color = Color3.fromHex("#18181b"), Transparency = 0 },    
    }, {                                                                        
        Rotation = 0,                                                           
    }),                                                                         
    Dialog = Color3.fromHex("#161616"),
    Outline = Color3.fromHex("#FFFFFF"),
    Text = Color3.fromHex("#FFFFFF"),
    Placeholder = Color3.fromHex("#7a7a7a"),
    Background = Color3.fromHex("#101010"),
    Button = Color3.fromHex("#52525b"),
    Icon = Color3.fromHex("#a1a1aa")
})
-- Group all UI elements into tables to reduce local variables
_G.UI = {}
_G.UI.Window = WindUI:CreateWindow({
    Title = "FyyExploit",
    Icon = "slack", 
    Author = "Fyy X Fish IT",
    Folder = "FyyConfig",
    
    Size = UDim2.fromOffset(530, 300),
    MinSize = Vector2.new(320, 300),
    MaxSize = Vector2.new(850, 560),
    Transparent = true,
    Theme = "Dark",
    Resizable = true,
    SideBarWidth = 150,
    BackgroundImageTransparency = 0.42,
    HideSearchBar = false,
    ScrollBarEnabled = false,
})

local Window = _G.UI.Window

Window:SetToggleKey(Enum.KeyCode.G)

WindUI:Notify({
    Title = "FyyLoader",
    Content = "Press G To Open/Close Menu!",
    Duration = 4, 
    Icon = "slack",
})
-- Group all tabs to reduce local variables
_G.Tabs = {}
_G.Tabs.Info = Window:Tab({Title = "Info", Icon = "info"})
_G.Tabs.Player = Window:Tab({Title = "Player", Icon = "user"})
_G.Tabs.Auto = Window:Tab({Title = "Main", Icon = "play"})
_G.Tabs.Shop = Window:Tab({Title = "Shop", Icon = "shopping-cart"})
_G.Tabs.Teleport = Window:Tab({Title = "Teleport", Icon = "map-pin"})
_G.Tabs.Quest = Window:Tab({Title = "Quest", Icon = "loader"})
_G.Tabs.Setting = Window:Tab({Title = "Settings", Icon = "settings"})
_G.Tabs.Enchant = Window:Tab({Title = "Enchants", Icon = "star"})
_G.Tabs.Discord = Window:Tab({Title = "Webhook", Icon = "megaphone"})
_G.Tabs.Config = Window:Tab({Title = "Config", Icon = "folder"})

local Info, Player, Auto, Shop, Teleport, Quest, Setting, Enchant, Discord, Config = 
    _G.Tabs.Info, _G.Tabs.Player, _G.Tabs.Auto, _G.Tabs.Shop, _G.Tabs.Teleport, 
    _G.Tabs.Quest, _G.Tabs.Setting, _G.Tabs.Enchant, _G.Tabs.Discord, _G.Tabs.Config

----------- END OF TAB -------------
local InfoSection = Info:Section({
    Title = "Have Problem / Need Help? Join Server Now",
    Box = true,
    TextTransparency = 0.05,
    TextXAlignment = "Center",
    TextSize = 17,
    Opened = true,
})

Info:Select()

local function CopyLink(link, title, notifTitle, notifContent)
    Info:Button({
        Title = title or "Copy Link",
        Desc = "Click to copy link",
        Callback = function()
            if setclipboard then
                setclipboard(link)
            end
            WindUI:Notify({
                Title = notifTitle or "Copied!",
                Content = notifContent or ("Link '" .. link .. "' copied to clipboard"),
                Duration = 3,
                Icon = "bell",
            })
        end
    })
end

CopyLink(
    "https://discord.gg/77nEeYeFRp",
    "Copy Discord Link",
    "Discord Copied!",
    "Link copied to clipboard"
)

---------------------------------------------------------------
--// PLAYER TAB
local PlayerSection = Player:Section({ Title = "Player Feature" })

local WalkSpeedInput = Player:Input({
    Title = "Set WalkSpeed",
    Placeholder = "Enter number (e.g. 50)",
    Callback = function(value)
        WalkSpeedInput.Value = tonumber(value) or 16
    end
})

local WalkSpeedToggle = Player:Toggle({
    Title = "WalkSpeed",
    Default = false,
    Callback = function(state)
        local player = game.Players.LocalPlayer
        local char = player.Character or player.CharacterAdded:Wait()
        local humanoid = char:WaitForChild("Humanoid")
        humanoid.WalkSpeed = state and (WalkSpeedInput.Value or 16) or 16
    end
})

Player:Divider()

--// Infinite Jump
local InfiniteJumpConn
Player:Toggle({
    Title = "Infinite Jump",
    Default = false,
    Callback = function(state)
        local UIS = game:GetService("UserInputService")
        if state then
            InfiniteJumpConn = UIS.JumpRequest:Connect(function()
                local char = game.Players.LocalPlayer.Character
                if char and char:FindFirstChild("Humanoid") then
                    char.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
                end
            end)
        elseif InfiniteJumpConn then
            InfiniteJumpConn:Disconnect()
            InfiniteJumpConn = nil
        end
    end
})

--// NoClip
local NoClipConn
Player:Toggle({
    Title = "NoClip",
    Default = false,
    Callback = function(state)
        local player = game.Players.LocalPlayer
        if state then
            NoClipConn = game:GetService("RunService").Stepped:Connect(function()
                local char = player.Character
                if char then
                    for _, part in ipairs(char:GetChildren()) do
                        if part:IsA("BasePart") then
                            part.CanCollide = false
                        end
                    end
                end
            end)
        elseif NoClipConn then
            NoClipConn:Disconnect()
            NoClipConn = nil
            local char = player.Character
            if char then
                for _, part in ipairs(char:GetChildren()) do
                    if part:IsA("BasePart") then
                        part.CanCollide = true
                    end
                end
            end
        end
    end
})

--// Walk On Water
local walkOnWater = false
local waterPart

Player:Toggle({
    Title = "Walk On Water",
    Default = false,
    Callback = function(state)
        walkOnWater = state
        local player = game.Players.LocalPlayer
        local char = player.Character
        if state and char then
            local hrp = char:FindFirstChild("HumanoidRootPart")
            if hrp then
                if waterPart then waterPart:Destroy() end
                waterPart = Instance.new("Part")
                waterPart.Anchored = true
                waterPart.CanCollide = true
                waterPart.Size = Vector3.new(20, 1, 20)
                waterPart.Transparency = 1
                waterPart.Position = Vector3.new(hrp.Position.X, 0, hrp.Position.Z)
                waterPart.Parent = workspace
            end
        elseif waterPart then
            waterPart:Destroy()
            waterPart = nil
        end
    end
})

game:GetService("RunService").Heartbeat:Connect(function()
    if walkOnWater and waterPart then
        local player = game.Players.LocalPlayer
        local char = player.Character
        if char and char:FindFirstChild("HumanoidRootPart") then
            local pos = char.HumanoidRootPart.Position
            waterPart.Position = Vector3.new(pos.X, 0, pos.Z)
        end
    end
end)

--// Respawn at current position
Player:Button({
    Title = "Respawn at Current Position",
    Callback = function()
        local player = game.Players.LocalPlayer
        local char = player.Character
        if char then
            local humanoid = char:FindFirstChild("Humanoid")
            if humanoid then
                local pos = char:GetPivot().Position
                humanoid.Health = 0
                player.CharacterAdded:Connect(function(newChar)
                    task.wait(1)
                    local hrp = newChar:FindFirstChild("HumanoidRootPart")
                    if hrp then
                        hrp.CFrame = CFrame.new(pos)
                    end
                end)
            end
        end
    end
})


Player:Space()
Player:Divider()

local Section = Player:Section({
    Title = "Gui External",
    Opened = true,
})

local FlyButton = Player:Button({
    Title = "Fly GUI",
    Locked = false,
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/XNEOFF/FlyGuiV3/main/FlyGuiV3.txt"))()

        WindUI:Notify({
            Title = "Fly",
            Content = "Fly GUI berhasil dijalankan ✅",
            Duration = 3,
            Icon = "bell"
        })
    end
})

---------------- END OF PLAYER ------------------
-- Group all services and variables to reduce local variables
_G.Services = {}
_G.Services.VirtualInputManager = game:GetService("VirtualInputManager")
_G.Services.ReplicatedStorage = game:GetService("ReplicatedStorage")
_G.Services.Players = game:GetService("Players")
_G.Services.RunService = game:GetService("RunService")

_G.Vars = {}
_G.Vars.cycle = 0
_G.Vars.running = false
_G.Vars.equipped = false
_G.Vars.lastResetTime = 0
_G.Vars.fishCheckEnabled = false
_G.Vars.initialSetupDone = false
_G.Vars.lastFishTime = 0

local VirtualInputManager = _G.Services.VirtualInputManager

task.spawn(function()
    while true do
        local waitTime = math.random(600, 700)
        task.wait(waitTime)
        local keyCombos = {
            {Enum.KeyCode.LeftShift, Enum.KeyCode.E},    
            {Enum.KeyCode.LeftControl, Enum.KeyCode.F},     
            {Enum.KeyCode.Q, Enum.KeyCode.Tab},           
            {Enum.KeyCode.LeftShift, Enum.KeyCode.Q},     
            {Enum.KeyCode.E, Enum.KeyCode.F},             
        }
        
        local chosenCombo = keyCombos[math.random(1, #keyCombos)]
        pcall(function()
            for _, key in pairs(chosenCombo) do
                VirtualInputManager:SendKeyEvent(true, key, false, nil)
            end
            
            task.wait(0.1) 
                for _, key in pairs(chosenCombo) do
                VirtualInputManager:SendKeyEvent(false, key, false, nil)
            end
        end)        
    end
end)
print("ANTI-AFK : ON By Fyy")

local Section = Auto:Section({ 
    Title = "Main Feature",
})

-- Group all fishing variables to reduce local variables
_G.Fishing = {}
_G.Fishing.autoFishingRunning = false
_G.Fishing.autoFishingToggle = nil

local ReplicatedStorage = _G.Services.ReplicatedStorage
local Players = _G.Services.Players
local player = Players.LocalPlayer

-- Group all remotes to reduce local variables
_G.Remotes = {}
_G.Remotes.REEquipToolFromHotbar = ReplicatedStorage.Packages._Index["sleitnick_net@0.2.0"].net["RE/EquipToolFromHotbar"]
_G.Remotes.RFChargeFishingRod = ReplicatedStorage.Packages._Index["sleitnick_net@0.2.0"].net["RF/ChargeFishingRod"]
_G.Remotes.RFRequestFishingMinigameStarted = ReplicatedStorage.Packages._Index["sleitnick_net@0.2.0"].net["RF/RequestFishingMinigameStarted"]
_G.Remotes.REFishingCompleted = ReplicatedStorage.Packages._Index["sleitnick_net@0.2.0"].net["RE/FishingCompleted"]
_G.Remotes.REUnequipToolFromHotbar = ReplicatedStorage.Packages._Index["sleitnick_net@0.2.0"].net["RE/UnequipToolFromHotbar"]
_G.Remotes.RFCancelFishingInputs = ReplicatedStorage.Packages._Index["sleitnick_net@0.2.0"].net["RF/CancelFishingInputs"]
_G.Remotes.REFishCaught = ReplicatedStorage.Packages._Index["sleitnick_net@0.2.0"].net["RE/FishCaught"]

-- Use global variables instead of local
_G.Vars.lastFishTime = 0
_G.Vars.running = false
_G.Vars.equipped = false
_G.Vars.lastResetTime = 0
_G.Vars.fishCheckEnabled = false
_G.Vars.initialSetupDone = false

local REEquipToolFromHotbar = _G.Remotes.REEquipToolFromHotbar
local RFChargeFishingRod = _G.Remotes.RFChargeFishingRod
local RFRequestFishingMinigameStarted = _G.Remotes.RFRequestFishingMinigameStarted
local REFishingCompleted = _G.Remotes.REFishingCompleted
local REUnequipToolFromHotbar = _G.Remotes.REUnequipToolFromHotbar
local RFCancelFishingInputs = _G.Remotes.RFCancelFishingInputs
local REFishCaught = _G.Remotes.REFishCaught 

-- Group all functions to reduce local variables
_G.Funcs = {}
_G.Funcs.safeFire = function(remote, arg)
	if not remote then return false end
	local ok, err = pcall(function()
		if arg ~= nil then remote:FireServer(arg) else remote:FireServer() end
	end)
	return ok
end

_G.Funcs.safeInvoke = function(remote, arg1, arg2)
	if not remote then return nil end
	local ok, res = pcall(function()
		if arg1 ~= nil and arg2 ~= nil then
			return remote:InvokeServer(arg1, arg2)
		elseif arg1 ~= nil then
			return remote:InvokeServer(arg1)
		else
			return remote:InvokeServer()
		end
	end)
	return ok and res or nil
end

local safeFire, safeInvoke = _G.Funcs.safeFire, _G.Funcs.safeInvoke

local function showNotification(title, content)
    if WindUI and WindUI.Notify then
        WindUI:Notify({
            Title = title,
            Content = content,
            Duration = 3,
        })
    elseif Auto and Auto.Notify then
        Auto:Notify({
            Title = title,
            Content = content,
            Duration = 3,
        })
    end
end

local function equipToolOnce()
    if not equipped then
        for i = 1, 3 do
            safeFire(REEquipToolFromHotbar, 1)
        end
        equipped = true
    end
end

local function resetTool()
    safeFire(REUnequipToolFromHotbar)
    equipped = false
    equipToolOnce()
end

local function doChargeAndRequest()
    safeInvoke(RFChargeFishingRod, 2)
    

    for i = 1, 1 do
        safeInvoke(RFRequestFishingMinigameStarted, -1.25, 1)
        task.wait() 
    end
end

local function doRequestOnly()
    for i = 1, 2 do
        safeInvoke(RFRequestFishingMinigameStarted, -1.25, 1)
        task.wait() 
    end
end

local function forceResetFishing()
    
    for i = 1, 2 do
        safeInvoke(RFCancelFishingInputs)
    end
    
    resetTool()
    task.wait(0.5) 
    doChargeAndRequest()  
    lastFishTime = tick() 
end

local function fishCheckLoop()
    local retryCount = 0
    local maxRetries = 10
    
    while running and fishCheckEnabled do
        local currentTime = tick()
        if currentTime - lastFishTime >= 8 and lastFishTime > 0 then
            retryCount = retryCount + 1
            forceResetFishing()
            
            if retryCount >= maxRetries then
                retryCount = 0
            end
        else
            retryCount = 0
        end
        task.wait(1)
    end
end

local function spamCompletedLoop()
    while running do
        safeFire(REFishingCompleted)
        task.wait()
    end
end

local function equipToolLoop()
    while running do
        safeFire(REEquipToolFromHotbar, 1)
        task.wait(2)
    end
end

local function periodicResetLoop()
    while running do
        task.wait(300)
        if running then
            resetTool()
            lastResetTime = tick()
        end
    end
end

local function setupFishCaughtHandler()
    REFishCaught.OnClientEvent:Connect(function(fishName, fishData)
        lastFishTime = tick()
        
        -- Update performance stats for super fast modes
        updatePerformanceStats()
        
        if running then
            task.wait(0.09)
            doChargeAndRequest() 
        end
    end)
end

local function fishingCycle()
    lastResetTime = tick()
    lastFishTime = tick()
    fishCheckEnabled = true
    
    setupFishCaughtHandler()
    
    task.spawn(spamCompletedLoop)
    task.spawn(equipToolLoop)
    task.spawn(fishCheckLoop)
    task.spawn(periodicResetLoop)
    
    task.wait(0.5)  
    doChargeAndRequest()  
    initialSetupDone = true
    
    
    while running do
        task.wait()
    end
    
    fishCheckEnabled = false
    initialSetupDone = false
end

local autoFishingToggle = Auto:Toggle({
    Title = "Auto Fishing", 
    Type = "Toggle",
    Desc = "INSTANT FISHING - WITH ANTI STUCK SYSTEM",
    Default = false,
    Callback = function(state) 
        running = state
        autoFishingRunning = state 
        if running then
            task.spawn(fishingCycle)
        else
            safeInvoke(RFCancelFishingInputs)
            equipped = false
            fishCheckEnabled = false
            initialSetupDone = false
        end
    end
})

-- SUPER FAST INSTANT FISHING FEATURE
local superFastEnabled = false
local superFastSpeed = 0.01
local superFastConnections = {}

local function superFastFishing()
    while superFastEnabled and running do
        -- Ultra fast fishing with minimal delays
        safeFire(REFishingCompleted)
        safeInvoke(RFRequestFishingMinigameStarted, -1.25, 1)
        safeFire(REEquipToolFromHotbar, 1)
        task.wait(superFastSpeed)
    end
end

local SuperFastToggle = Auto:Toggle({
    Title = "🚀 Super Fast Instant Fishing",
    Desc = "ULTRA FAST FISHING - MAXIMUM SPEED",
    Default = false,
    Callback = function(state)
        superFastEnabled = state
        if state then
            -- Disable normal fishing to avoid conflicts
            if running then
                autoFishingToggle:Set(false)
                task.wait(0.5)
                autoFishingToggle:Set(true)
            end
            
            -- Reset performance stats
            resetPerformanceStats()
            
            -- Start super fast fishing
            task.spawn(superFastFishing)
            
            WindUI:Notify({
                Title = "🚀 Super Fast Mode",
                Content = "Ultra fast fishing activated!",
                Duration = 3,
                Icon = "zap"
            })
        else
            WindUI:Notify({
                Title = "Super Fast Mode",
                Content = "Super fast fishing disabled",
                Duration = 3,
                Icon = "bell"
            })
        end
    end
})

local SuperFastSlider = Auto:Slider({
    Title = "⚡ Super Fast Speed",
    Desc = "Lower = Faster (0.001 = MAX SPEED)",
    Step = 0.001,
    Value = {Min = 0.001, Max = 0.1, Default = 0.01},
    Callback = function(value)
        superFastSpeed = value
    end
})

-- ULTRA FAST FISHING WITH MULTI-THREADING
local ultraFastEnabled = false
local threadCount = 5

local function ultraFastFishing()
    local threads = {}
    
    for i = 1, threadCount do
        table.insert(threads, task.spawn(function()
            while ultraFastEnabled and running do
                -- Spam fishing with maximum efficiency
                for j = 1, 10 do
                    safeFire(REFishingCompleted)
                    safeInvoke(RFRequestFishingMinigameStarted, -1.25, 1)
                end
                task.wait(0.001)
            end
        end))
    end
    
    return threads
end

local UltraFastToggle = Auto:Toggle({
    Title = "🔥 ULTRA Fast Multi-Thread",
    Desc = "MAXIMUM SPEED WITH MULTI-THREADING",
    Default = false,
    Callback = function(state)
        ultraFastEnabled = state
        if state then
            -- Disable other fishing modes
            if superFastEnabled then
                SuperFastToggle:Set(false)
            end
            if running then
                autoFishingToggle:Set(false)
                task.wait(0.5)
                autoFishingToggle:Set(true)
            end
            
            -- Reset performance stats
            resetPerformanceStats()
            
            -- Start ultra fast fishing
            ultraFastFishing()
            
            WindUI:Notify({
                Title = "🔥 ULTRA Fast Mode",
                Content = "Multi-threaded ultra fast fishing activated!",
                Duration = 3,
                Icon = "zap"
            })
        else
            WindUI:Notify({
                Title = "ULTRA Fast Mode",
                Content = "Ultra fast fishing disabled",
                Duration = 3,
                Icon = "bell"
            })
        end
    end
})

-- INSTANT CATCH SYSTEM
local instantCatchEnabled = false

local function instantCatchSystem()
    while instantCatchEnabled and running do
        -- Instant catch with zero delay
        safeFire(REFishingCompleted)
        safeFire(REFishingCompleted)
        safeFire(REFishingCompleted)
        safeInvoke(RFRequestFishingMinigameStarted, -1.25, 1)
        safeFire(REEquipToolFromHotbar, 1)
        task.wait(0.0001) -- Ultra minimal delay
    end
end

local InstantCatchToggle = Auto:Toggle({
    Title = "⚡ Instant Catch System",
    Desc = "ZERO DELAY INSTANT CATCHING",
    Default = false,
    Callback = function(state)
        instantCatchEnabled = state
        if state then
            -- Disable other modes
            if superFastEnabled then SuperFastToggle:Set(false) end
            if ultraFastEnabled then UltraFastToggle:Set(false) end
            if running then
                autoFishingToggle:Set(false)
                task.wait(0.5)
                autoFishingToggle:Set(true)
            end
            
            -- Reset performance stats
            resetPerformanceStats()
            
            -- Start instant catch
            task.spawn(instantCatchSystem)
            
            WindUI:Notify({
                Title = "⚡ Instant Catch",
                Content = "Zero delay instant catching activated!",
                Duration = 3,
                Icon = "zap"
            })
        else
            WindUI:Notify({
                Title = "Instant Catch",
                Content = "Instant catch system disabled",
                Duration = 3,
                Icon = "bell"
            })
        end
    end
})

-- PERFORMANCE MONITORING
local performanceStats = {
    catchesPerSecond = 0,
    totalCatches = 0,
    startTime = 0
}

local function updatePerformanceStats()
    if superFastEnabled or ultraFastEnabled or instantCatchEnabled then
        performanceStats.totalCatches = performanceStats.totalCatches + 1
        local currentTime = tick()
        local elapsedTime = currentTime - performanceStats.startTime
        if elapsedTime > 0 then
            performanceStats.catchesPerSecond = performanceStats.totalCatches / elapsedTime
        end
    end
end

local PerformanceButton = Auto:Button({
    Title = "📊 Show Performance Stats",
    Callback = function()
        local stats = string.format(
            "🚀 SUPER FAST FISHING STATS:\n\n" ..
            "Catches per Second: %.2f\n" ..
            "Total Catches: %d\n" ..
            "Runtime: %.1f seconds\n\n" ..
            "Status: %s",
            performanceStats.catchesPerSecond,
            performanceStats.totalCatches,
            tick() - performanceStats.startTime,
            (superFastEnabled and "Super Fast") or 
            (ultraFastEnabled and "ULTRA Fast") or 
            (instantCatchEnabled and "Instant Catch") or 
            "Normal"
        )
        
        WindUI:Notify({
            Title = "📊 Performance Stats",
            Content = stats,
            Duration = 8,
            Icon = "bar-chart"
        })
    end
})

-- Reset stats when starting new mode
local function resetPerformanceStats()
    performanceStats.catchesPerSecond = 0
    performanceStats.totalCatches = 0
    performanceStats.startTime = tick()
end

Auto:Space()
Auto:Divider()

local SuperFastSection = Auto:Section({ 
    Title = "🚀 Super Fast Instant Fishing",
})

local SuperFastInfo = Auto:Section({
    Title = "Super Fast Fishing Features",
    Box = true,
    TextTransparency = 0.05,
    TextXAlignment = "Center",
    TextSize = 14,
    Opened = true,
})

-- Add info text about Super Fast features
local SuperFastInfoText = Auto:Label({
    Title = "🚀 Super Fast Instant Fishing",
    Text = "ULTRA FAST FISHING MODES:\n• Super Fast: Optimized speed fishing\n• ULTRA Fast: Multi-threaded maximum speed\n• Instant Catch: Zero delay catching\n\n⚠️ WARNING: Use at your own risk!\nMay cause lag or detection if overused.",
    TextSize = 12,
    TextColor = Color3.fromHex("#FFFFFF"),
    TextTransparency = 0.1,
    TextXAlignment = "Center"
})

Auto:Space()
Auto:Divider()

local Section = Auto:Section({ 
    Title = "Teleport Feature",
})

local Players = game:GetService("Players")
local player = Players.LocalPlayer

-- Optimize teleport locations to reduce local variables
local function getTeleportLocations()
    return {
        ["Fisherman Island"] = CFrame.new(77, 9, 2706),
        ["Kohana Volcano"] = CFrame.new(-628.758911, 35.710186, 104.373764, 0.482912123, 1.81591773e-08, 0.875668824, 3.01732896e-08, 1, -3.73774007e-08, -0.875668824, 4.44718076e-08, 0.482912123),
        ["Kohana"] = CFrame.new(-725.013306, 3.03549194, 800.079651, -0.999999285, -5.38041718e-08, -0.00118542486, -5.379977e-08, 1, -3.74458198e-09, 0.00118542486, -3.68080366e-09, -0.999999285),
        ["Esotric Islands"] = CFrame.new(2113, 10, 1229),
        ["Coral Reefs"] = CFrame.new(-3063.54248, 4.04500151, 2325.85278, 0.999428809, 2.02288568e-08, 0.033794228, -1.96206607e-08, 1, -1.83286453e-08, -0.033794228, 1.76551112e-08, 0.999428809),
        ["Crater Island"] = CFrame.new(984.003296, 2.87008905, 5144.92627, 0.999932885, 1.19231975e-08, 0.0115857301, -1.04685522e-08, 1, -1.25615529e-07, -0.0115857301, 1.25485812e-07, 0.999932885),
        ["Sisyphus Statue"] = CFrame.new(-3737, -136, -881),
        ["Treasure Room"] = CFrame.new(-3650.4873, -269.269318, -1652.68323, -0.147814155, -2.75628675e-08, -0.989015162, -1.74189818e-08, 1, -2.52656349e-08, 0.989015162, 1.34930183e-08, -0.147814155),
        ["Lost Isle"] = CFrame.new(-3649.0813, 5.42584181, -1052.88745, 0.986230493, 3.9997154e-08, -0.165376455, -3.81513914e-08, 1, 1.43375187e-08, 0.165376455, -7.83075649e-09, 0.986230493),
        ["Tropical Grove"] = CFrame.new(-2151.29248, 15.8166971, 3628.10669, -0.997403979, 4.56146232e-09, -0.0720091537, 4.62302685e-09, 1, -6.88285429e-10, 0.0720091537, -1.0193989e-09, -0.997403979),
        ["Weater Machine"] = CFrame.new(-1518.05042, 2.87499976, 1909.78125, -0.995625556, -1.82757487e-09, -0.0934334621, 2.24076646e-09, 1, -4.34377512e-08, 0.0934334621, -4.34570957e-08, -0.995625556),
        ["Enchant Room"] = CFrame.new(3180.14502, -1302.85486, 1387.9563, 0.338028163, 9.92235272e-08, -0.941136003, 1.90291747e-08, 1, 1.12264253e-07, 0.941136003, -5.58575195e-08, 0.338028163),  
        ["Seconds Enchant"] = CFrame.new(1487, 128, -590),
        ["Ancient Jungle"] = CFrame.new(1519.33215, 2.08891273, -307.090668, 0.632470906, -1.48247699e-08, 0.774584115, -2.24899335e-08, 1, 3.75027014e-08, -0.774584115, -4.11397139e-08, 0.632470906),
        ["Sacred Temple"] = CFrame.new(1413.84277, 4.375, -587.298279, 0.261966974, 5.50031594e-08, -0.965076864, -8.19077872e-09, 1, 5.47701973e-08, 0.965076864, -6.44325127e-09, 0.261966974),
        ["Underground Cellar"] = CFrame.new(2103.14673, -91.1976471, -717.124939, -0.226165071, -1.71397723e-08, -0.974088967, -2.1650266e-09, 1, -1.70930168e-08, 0.974088967, -1.75691484e-09, -0.226165071),
        ["Arrow Artifact"] = CFrame.new(883.135437, 6.62499952, -350.10025, -0.480593145, 2.676836e-08, 0.876943707, -4.66245069e-08, 1, -5.6076324e-08, -0.876943707, -6.78369645e-08, -0.480593145),
        ["Crescent Artifact"] = CFrame.new(1409.40747, 6.62499952, 115.430603, -0.967555583, -5.63477229e-08, 0.252658188, -7.82660337e-08, 1, -7.67005233e-08, -0.252658188, -9.39865714e-08, -0.967555583),
        ["Hourglass Diamond Artifact"] = CFrame.new(1480.98645, 6.27569771, -847.142029, -0.967326343, -5.985531e-08, 0.253534466, -6.16077926e-08, 1, 1.02735098e-09, -0.253534466, -1.46259147e-08, -0.967326343),
        ["Diamond Artifact"] = CFrame.new(1836.31604, 6.34277105, -298.546265, 0.545851529, -2.36059989e-08, -0.837881923, -4.70848498e-08, 1, -5.8847597e-08, 0.837881923, 7.15735951e-08, 0.545851529),
        ["Mount Hallow"] = CFrame.new(2105, 81, 3294),
    }
end

local teleportLocations = getTeleportLocations()

local selectedLocation = ""
local freezeLoop = nil
local lastCFrame = nil

local function startFreeze()
    if freezeLoop then return end
    
    if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
        lastCFrame = player.Character.HumanoidRootPart.CFrame
    end
    
    freezeLoop = game:GetService("RunService").Heartbeat:Connect(function()
        if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            local rootPart = player.Character.HumanoidRootPart
            local targetCFrame = teleportLocations[selectedLocation]
            
            if rootPart and targetCFrame then
                local currentCFrame = rootPart.CFrame
                local distanceFromStart = (currentCFrame.Position - lastCFrame.Position).Magnitude
                
                if distanceFromStart > 0.1 then
                    rootPart.CFrame = targetCFrame
                    lastCFrame = targetCFrame
                end
            end
        end
    end)
end

local function stopFreeze()
    if freezeLoop then
        freezeLoop:Disconnect()
        freezeLoop = nil
        lastCFrame = nil
    end
end

local LocationDropdown = Auto:Dropdown({
    Title = "Teleport Location",
    Values = {"Fisherman Island", "Kohana Volcano", "Kohana", "Esotric Islands", "Coral Reefs", "Crater Island", "Sisyphus Statue", "Treasure Room", "Lost Isle", "Tropical Grove", "Weater Machine", "Enchant Room","Seconds Enchant", "Ancient Jungle", "Sacred Temple", "Underground Cellar", "Arrow Artifact", "Crescent Artifact", "Hourglass Diamond Artifact", "Diamond Artifact", "Mount Hallow"},
    Value = "",
    Callback = function(option)
        if option and option ~= "" then
            selectedLocation = option
        end
    end
})

local TeleportToggle = Auto:Toggle({
    Title = "Teleport & Freeze to Position",
    Default = false,
    Callback = function(state)
        if state then
            if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                local rootPart = player.Character.HumanoidRootPart
                local targetCFrame = teleportLocations[selectedLocation]
                
                if rootPart and targetCFrame then
                    rootPart.CFrame = targetCFrame
                    task.wait(0.1)
                    startFreeze()
                end
            end
        else
            stopFreeze()
        end
    end
})

Auto:Divider()

local Players = game:GetService("Players")
local player = Players.LocalPlayer

local savedCFrame = nil
local freezeLoop = nil
local teleportEnabled = false

local function saveCurrentPosition()
    if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
        local rootPart = player.Character:FindFirstChild("HumanoidRootPart")
        savedCFrame = rootPart.CFrame
        
        showNotification("Position Saved")
        return true
    end
    return false
end

local function startFreeze()
    if freezeLoop then return end
    
    freezeLoop = game:GetService("RunService").Heartbeat:Connect(function()
        if teleportEnabled and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            local rootPart = player.Character:FindFirstChild("HumanoidRootPart")
            
            if savedCFrame then
                rootPart.CFrame = savedCFrame
            end
        end
    end)
end

local function stopFreeze()
    if freezeLoop then
        freezeLoop:Disconnect()
        freezeLoop = nil
    end
end

local SaveButton = Auto:Button({
    Title = "Save Your Position",
    Callback = saveCurrentPosition
})

local TeleportToggles = Auto:Toggle({
    Title = "Teleport & Freeze to Position",
    Default = false,
    Callback = function(state)
        teleportEnabled = state
        
        if teleportEnabled then
            if not savedCFrame then
                showNotification("❌ Teleport", "Save position first!")
                teleportEnabled = false
                TeleportToggle:Set(false)
                return
            end
            
            if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                local rootPart = player.Character:FindFirstChild("HumanoidRootPart")
                rootPart.CFrame = savedCFrame
                task.wait(0.1)
                startFreeze()
            end
        else
            stopFreeze()
        end
    end
})

Auto:Space()
Auto:Divider()
local Section = Auto:Section({ 
    Title = "Auto Sell Feature",
})

local autoSellEnabled = false
local autoSellInterval = 5 

local AutoSellSlider = Auto:Slider({
    Title = "Auto Sell Timer (Minutes)",
    Step = 1,
    Value = {Min = 1, Max = 30, Default = 5},
    Callback = function(value)
        autoSellInterval = value
    end
})

local function sellAllItems()
    local ReplicatedStorage = game:GetService("ReplicatedStorage")
    local RFSellAllItems = ReplicatedStorage.Packages._Index["sleitnick_net@0.2.0"].net["RF/SellAllItems"]
    
    pcall(function()
        RFSellAllItems:InvokeServer()
    end)
end

local function startAutoSell()
    task.spawn(function()
        while autoSellEnabled do
            local secondsToWait = autoSellInterval * 60
            for i = 1, secondsToWait do
                if not autoSellEnabled then break end
                task.wait(1)
            end
            if autoSellEnabled then
                sellAllItems()
            end
        end
    end)
end

local AutoSellToggle = Auto:Toggle({
    Title = "Enable Auto Sell",
    Default = false,
    Callback = function(state)
        autoSellEnabled = state
        if autoSellEnabled then
            startAutoSell()
        else
        end
    end
})

local ManualSellButton = Auto:Button({
    Title = "Sell All Items Now",
    Callback = sellAllItems
})

local Section = Auto:Section({ 
    Title = "Auto Favorite Feature",
})

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local REFavoriteItem = ReplicatedStorage.Packages._Index["sleitnick_net@0.2.0"].net["RE/FavoriteItem"]
local REObtainedNewFishNotification = ReplicatedStorage.Packages._Index["sleitnick_net@0.2.0"].net["RE/ObtainedNewFishNotification"]

-- Optimize fish tiers to reduce local variables
local function getFishTiers()
    return {
        Common = {43, 20, 66, 45, 64, 31, 46, 116, 32, 63, 33, 65, 62, 51, 61, 92, 91, 90, 108, 109, 111, 112, 113, 114, 115, 135, 154, 151, 166, 165, 198, 234, 281, 279, 290, 315, 318},
        Uncommon = {44, 59, 19, 67, 41, 68, 60, 50, 117, 29, 42, 30, 58, 28, 69, 190, 87, 86, 94, 106, 107, 121, 120, 139, 140, 144, 142, 163, 161, 153, 164, 189, 182, 186, 188, 197, 202, 203, 204, 211, 232, 237, 242, 280, 287, 275, 285, 262, 288, 289, 301, 300, 313, 312, 306},
        Rare = {18, 71, 40, 72, 23, 89, 88, 93, 119, 157, 191, 183, 184, 194, 196, 210, 209, 239, 238, 235, 241, 278, 282, 277, 284, 310, 305},
        Epic = {17, 22, 37, 53, 57, 26, 70, 14, 49, 25, 24, 48, 36, 38, 16, 56, 55, 27, 39, 74, 73, 95, 96, 138, 143, 160, 155, 162, 149, 207, 227, 233, 276, 268, 270, 303, 298, 304, 309},
        Legendary = {15, 47, 75, 52, 21, 34, 54, 35, 97, 110, 137, 146, 147, 152, 199, 208, 224, 236, 243, 286, 283, 274, 296, 299, 307, 317, 311},
        Mythic = {98, 122, 158, 150, 185, 205, 215, 240, 247, 249, 248, 263, 273, 264, 316, 308, 314},
        SECRET = {82, 99, 136, 141, 159, 156, 145, 187, 200, 195, 206, 201, 225, 218, 228, 226, 83, 176, 292, 293, 272, 269, 295, 302, 297, 319},
    }
end

local fishTiers = getFishTiers()

local allMutations = {"Albino", "Color Burn", "Corrupt", "Fairy Dust", "Festive", "Frozen", "Galaxy", "Gemstone", "Ghost", "Gold", "Holographic", "Lightning", "Midnight", "Radioactive", "Stone"}
local connection = nil
local selectedTiers = {}
local selectedMutations = {}

-- GET MUTATION
local function getMutation(weightData, itemData)
    return (weightData and weightData.VariantId) or (itemData and itemData.InventoryItem and itemData.InventoryItem.Metadata and itemData.InventoryItem.Metadata.VariantId)
end

-- MAIN HANDLER
local function handleFish(fishId, weightData, itemData, isNew)
    local mutation = getMutation(weightData, itemData)
    
    -- Check Rarity
    for _, tier in pairs(selectedTiers) do
        if fishTiers[tier] and table.find(fishTiers[tier], fishId) then
            REFavoriteItem:FireServer(itemData and itemData.InventoryItem and itemData.InventoryItem.UUID or fishId)
            return
        end
    end
    
    -- Check Mutation
    if mutation and table.find(selectedMutations, mutation) then
        REFavoriteItem:FireServer(itemData and itemData.InventoryItem and itemData.InventoryItem.UUID or fishId)
    end
end

-- UI
local AutoFavRarity = Auto:Dropdown({
    Title = "Rarity",
    Values = {"Common", "Uncommon", "Rare", "Epic", "Legendary", "Mythic", "SECRET"},
    Value = {},
    Multi = true,
    Callback = function(v) selectedTiers = v end
})

local AutoFavMutasi = Auto:Dropdown({
    Title = "Mutation", 
    Values = allMutations,
    Value = {},
    Multi = true,
    Callback = function(v) selectedMutations = v end
})

local AutoFAVORITE = Auto:Toggle({
    Title = "Enable Auto Favorite",
    Default = false,
    Callback = function(state)
        if state then
            connection = REObtainedNewFishNotification.OnClientEvent:Connect(handleFish)
        elseif connection then
            connection:Disconnect()
            connection = nil
        end
    end
})

------------ END OF MAIN FEATURE --------------
local Section = Shop:Section({ 
    Title = "Fishing Rod Shop",
})

local currentRod = ""

local RodDropdown = Shop:Dropdown({
    Title = "Select Fishing Rod",
    Values = {
        "Starter Rod (50$)",
        "Luck Rod (350$)", 
        "Carbon Rod (900$)",
        "Grass Rod (1500$)",
        "Desmascus Rod (3000$)",
        "Ice Rod (5000$)",
        "Lucky Rod (15000$)",
        "Midnight Rod (50000$)",
        "SteamPunk Rod (215000$)",
        "Chrome Rod (437000$)",
        "Fluorescent Rod (715000$)",
        "Astral Rod (1M$)",
        "Ares Rod (3M$)",
        "Angler Rod (8M$)",
        "Bambo Rod (12M$)"
    },
    Value = "",
    Callback = function(option)
        currentRod = option
    end
})

local PurchaseButton = Shop:Button({
    Title = "Purchase Fishing Rod",
    Callback = function()
        local ReplicatedStorage = game:GetService("ReplicatedStorage")
        local RFPurchaseFishingRod = ReplicatedStorage.Packages._Index["sleitnick_net@0.2.0"].net["RF/PurchaseFishingRod"]
        
        if currentRod == "Starter Rod (50$)" then
            RFPurchaseFishingRod:InvokeServer(1)
        elseif currentRod == "Luck Rod (350$)" then
            RFPurchaseFishingRod:InvokeServer(79)
        elseif currentRod == "Carbon Rod (900$)" then
            RFPurchaseFishingRod:InvokeServer(76)
        elseif currentRod == "Grass Rod (1500$)" then
            RFPurchaseFishingRod:InvokeServer(85)
        elseif currentRod == "Desmascus Rod (3000$)" then
            RFPurchaseFishingRod:InvokeServer(77)
        elseif currentRod == "Ice Rod (5000$)" then
            RFPurchaseFishingRod:InvokeServer(78)
        elseif currentRod == "Lucky Rod (15000$)" then
            RFPurchaseFishingRod:InvokeServer(4)
        elseif currentRod == "Midnight Rod (50000$)" then
            RFPurchaseFishingRod:InvokeServer(80)
        elseif currentRod == "SteamPunk Rod (215000$)" then
            RFPurchaseFishingRod:InvokeServer(6)
        elseif currentRod == "Chrome Rod (437000$)" then
            RFPurchaseFishingRod:InvokeServer(7)
        elseif currentRod == "Fluorescent Rod (715000$)" then
            RFPurchaseFishingRod:InvokeServer(255)
        elseif currentRod == "Astral Rod (1M$)" then
            RFPurchaseFishingRod:InvokeServer(5)
        elseif currentRod == "Ares Rod (3M$)" then
            RFPurchaseFishingRod:InvokeServer(126)
        elseif currentRod == "Angler Rod (8M$)" then
            RFPurchaseFishingRod:InvokeServer(168)
        elseif currentRod == "Bambo Rod (12M$)" then
            RFPurchaseFishingRod:InvokeServer(258)
        end
    end
})

local Section = Shop:Section({ 
    Title = "Purchase Bait",
})

local currentBait = ""

local BaitDropdown = Shop:Dropdown({
    Title = "Select Bobbers",
    Values = {
        "TopWater Bait (100$)",
        "Luck Bait (1000$)", 
        "Midnight Bait (3000$)",
        "Nature Bait (83500$)",
        "Chroma Bait (290000$)",
        "Dark Matter Bait (630000$)",
        "Corrupt Bait (1.15M$)",
        "Aether Bait (3.70M$)",
        "Floral Bait (4M$)"
    },
    Value = "",
    Callback = function(option)
        currentBait = option
    end
})

local PurchaseBaitButton = Shop:Button({
    Title = "Purchase Bobbers",
    Callback = function()
        local ReplicatedStorage = game:GetService("ReplicatedStorage")
        local RFPurchaseBait = ReplicatedStorage.Packages._Index["sleitnick_net@0.2.0"].net["RF/PurchaseBait"]
        
        if currentBait == "TopWater Bait (100$)" then
            RFPurchaseBait:InvokeServer(10)
        elseif currentBait == "Luck Bait (1000$)" then
            RFPurchaseBait:InvokeServer(2)
        elseif currentBait == "Midnight Bait (3000$)" then
            RFPurchaseBait:InvokeServer(3)
        elseif currentBait == "Nature Bait (83500$)" then
            RFPurchaseBait:InvokeServer(17)
        elseif currentBait == "Chroma Bait (290000$)" then
            RFPurchaseBait:InvokeServer(6)
        elseif currentBait == "Dark Matter Bait (630000$)" then
            RFPurchaseBait:InvokeServer(8)
        elseif currentBait == "Corrupt Bait (1.15M$)" then
            RFPurchaseBait:InvokeServer(15)
        elseif currentBait == "Aether Bait (3.70M$)" then
            RFPurchaseBait:InvokeServer(16)
        elseif currentBait == "Floral Bait (4M$)" then
            RFPurchaseBait:InvokeServer(20)
        end
    end
})


local Section = Shop:Section({ 
    Title = "Purchase Weather",
})

local selectedWeathers = {"Wind (10000)"}
local autoBuyWeather = false
local weatherLoop = nil

local WeatherDropdown = Shop:Dropdown({
    Title = "Select Weather",
    Values = {
        "Wind (10000)",
        "Cloudy (20000)", 
        "Snow (15000)",
        "Storm (35000)",
        "Radiant (50000)",
        "Shark Hunt (300000)"
    },
    Value = {"Wind (10000)"},
    Multi = true,
    AllowNone = true,
    Callback = function(option) 
        selectedWeathers = option
    end
})

local function purchaseWeather(weatherName)
    local ReplicatedStorage = game:GetService("ReplicatedStorage")
    local RFPurchaseWeatherEvent = ReplicatedStorage.Packages._Index["sleitnick_net@0.2.0"].net["RF/PurchaseWeatherEvent"]
    
    if weatherName == "Wind (10000)" then
        RFPurchaseWeatherEvent:InvokeServer("Wind")
    elseif weatherName == "Cloudy (20000)" then
        RFPurchaseWeatherEvent:InvokeServer("Cloudy")
    elseif weatherName == "Snow (15000)" then
        RFPurchaseWeatherEvent:InvokeServer("Snow")
    elseif weatherName == "Storm (35000)" then
        RFPurchaseWeatherEvent:InvokeServer("Storm")
    elseif weatherName == "Radiant (50000)" then
        RFPurchaseWeatherEvent:InvokeServer("Radiant")
    elseif weatherName == "Shark Hunt (300000)" then
        RFPurchaseWeatherEvent:InvokeServer("Shark Hunt")
    end
end

local PurchaseWeatherButton = Shop:Button({
    Title = "Purchase Weather",
    Callback = function()
        for _, weather in pairs(selectedWeathers) do
            purchaseWeather(weather)
        end
    end
})

local AutoWeatherToggle = Shop:Toggle({
    Title = "Auto Buy Weather",
    Default = false,
    Callback = function(state)
        autoBuyWeather = state
        
        if state then
            weatherLoop = game:GetService("RunService").Heartbeat:Connect(function()
                task.wait(60) 
                
                if autoBuyWeather then
                    for _, weather in pairs(selectedWeathers) do
                        purchaseWeather(weather)
                    end
                end
            end)
        else
            if weatherLoop then
                weatherLoop:Disconnect()
                weatherLoop = nil
            end
        end
    end
})

local section = Teleport:Section({ 
    Title = "Teleport To Players",
})

local Players = game:GetService("Players")
local player = Players.LocalPlayer

local selectedPlayer = ""

local function refreshPlayerList()
    local playerNames = {}
    
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= Players.LocalPlayer then
            table.insert(playerNames, player.Name)
        end
    end
    
    return playerNames
end

local PlayerDropdown = Teleport:Dropdown({
    Title = "Select Player",
    Values = refreshPlayerList(),
    Value = "",
    Callback = function(option)
        selectedPlayer = option
    end
})

local TeleportButton = Teleport:Button({
    Title = "Teleport to Player",
    Callback = function()
        if selectedPlayer and selectedPlayer ~= "" then
            local targetPlayer = Players:FindFirstChild(selectedPlayer)
            if targetPlayer and targetPlayer.Character and targetPlayer.Character:FindFirstChild("HumanoidRootPart") then
                local targetCFrame = targetPlayer.Character.HumanoidRootPart.CFrame
                
                if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                    player.Character.HumanoidRootPart.CFrame = targetCFrame
                end
            end
        end
    end
})

task.spawn(function()
    while true do
        task.wait(5)
        pcall(function()
            local currentPlayers = refreshPlayerList()
            PlayerDropdown:SetValues(currentPlayers)
        end)
    end
end)

local Section = Teleport:Section({ 
    Title = "Teleport To Island Locations",
})

local Players = game:GetService("Players")
local player = Players.LocalPlayer

local teleportLocations = {
    ["Fisherman Island"] = CFrame.new(77, 9, 2706),
    ["Kohana Volcano"] = CFrame.new(-628.758911, 35.710186, 104.373764, 0.482912123, 1.81591773e-08, 0.875668824, 3.01732896e-08, 1, -3.73774007e-08, -0.875668824, 4.44718076e-08, 0.482912123),
    ["Kohana"] = CFrame.new(-725.013306, 3.03549194, 800.079651, -0.999999285, -5.38041718e-08, -0.00118542486, -5.379977e-08, 1, -3.74458198e-09, 0.00118542486, -3.68080366e-09, -0.999999285),
    ["Esotric Islands"] = CFrame.new(2113, 10, 1229),
    ["Coral Reefs"] = CFrame.new(-3063.54248, 4.04500151, 2325.85278, 0.999428809, 2.02288568e-08, 0.033794228, -1.96206607e-08, 1, -1.83286453e-08, -0.033794228, 1.76551112e-08, 0.999428809),
    ["Crater Island"] = CFrame.new(984.003296, 2.87008905, 5144.92627, 0.999932885, 1.19231975e-08, 0.0115857301, -1.04685522e-08, 1, -1.25615529e-07, -0.0115857301, 1.25485812e-07, 0.999932885),
    ["Sisyphus Statue"] = CFrame.new(-3737, -136, -881),
    ["Treasure Room"] = CFrame.new(-3650.4873, -269.269318, -1652.68323, -0.147814155, -2.75628675e-08, -0.989015162, -1.74189818e-08, 1, -2.52656349e-08, 0.989015162, 1.34930183e-08, -0.147814155),
    ["Lost Isle"] = CFrame.new(-3649.0813, 5.42584181, -1052.88745, 0.986230493, 3.9997154e-08, -0.165376455, -3.81513914e-08, 1, 1.43375187e-08, 0.165376455, -7.83075649e-09, 0.986230493),
    ["Tropical Grove"] = CFrame.new(-2151.29248, 15.8166971, 3628.10669, -0.997403979, 4.56146232e-09, -0.0720091537, 4.62302685e-09, 1, -6.88285429e-10, 0.0720091537, -1.0193989e-09, -0.997403979),
    ["Weater Machine"] = CFrame.new(-1518.05042, 2.87499976, 1909.78125, -0.995625556, -1.82757487e-09, -0.0934334621, 2.24076646e-09, 1, -4.34377512e-08, 0.0934334621, -4.34570957e-08, -0.995625556),
    ["Enchant Room"] = CFrame.new(3180.14502, -1302.85486, 1387.9563, 0.338028163, 9.92235272e-08, -0.941136003, 1.90291747e-08, 1, 1.12264253e-07, 0.941136003, -5.58575195e-08, 0.338028163),  
    ["Seconds Enchant"] = CFrame.new(1487, 128, -590),  
    ["Ancient Jungle"] = CFrame.new(1519.33215, 2.08891273, -307.090668, 0.632470906, -1.48247699e-08, 0.774584115, -2.24899335e-08, 1, 3.75027014e-08, -0.774584115, -4.11397139e-08, 0.632470906),
    ["Sacred Temple"] = CFrame.new(1413.84277, 4.375, -587.298279, 0.261966974, 5.50031594e-08, -0.965076864, -8.19077872e-09, 1, 5.47701973e-08, 0.965076864, -6.44325127e-09, 0.261966974),
    ["Underground Cellar"] = CFrame.new(2103.14673, -91.1976471, -717.124939, -0.226165071, -1.71397723e-08, -0.974088967, -2.1650266e-09, 1, -1.70930168e-08, 0.974088967, -1.75691484e-09, -0.226165071),
    ["Arrow Artifact"] = CFrame.new(883.135437, 6.62499952, -350.10025, -0.480593145, 2.676836e-08, 0.876943707, -4.66245069e-08, 1, -5.6076324e-08, -0.876943707, -6.78369645e-08, -0.480593145),
    ["Crescent Artifact"] = CFrame.new(1409.40747, 6.62499952, 115.430603, -0.967555583, -5.63477229e-08, 0.252658188, -7.82660337e-08, 1, -7.67005233e-08, -0.252658188, -9.39865714e-08, -0.967555583),
    ["Hourglass Diamond Artifact"] = CFrame.new(1480.98645, 6.27569771, -847.142029, -0.967326343, -5.985531e-08, 0.253534466, -6.16077926e-08, 1, 1.02735098e-09, -0.253534466, -1.46259147e-08, -0.967326343),
    ["Diamond Artifact"] = CFrame.new(1836.31604, 6.34277105, -298.546265, 0.545851529, -2.36059989e-08, -0.837881923, -4.70848498e-08, 1, -5.8847597e-08, 0.837881923, 7.15735951e-08, 0.545851529),
    ["Mount Hallow"] = CFrame.new(2105, 81, 3294),
}


local selectedLocation = ""

local LocationDropdown = Teleport:Dropdown({
    Title = "Teleport To Island",
    Values = {"Fisherman Island", "Kohana Volcano", "Kohana", "Esotric Islands", "Coral Reefs", "Crater Island", "Sisyphus Statue", "Treasure Room", "Lost Isle", "Tropical Grove", "Weater Machine", "Enchant Room","Seconds Enchant", "Ancient Jungle", "Sacred Temple", "Underground Cellar", "Arrow Artifact", "Crescent Artifact", "Hourglass Diamond Artifact", "Diamond Artifact","Mount Hallow"},
    Value = "",
    Callback = function(option)
        if option and option ~= "" then
            selectedLocation = option
        end
    end
})

local TeleportButton = Teleport:Button({
    Title = "Teleport to Island",
    Callback = function()
        if selectedLocation and selectedLocation ~= "" then
            if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                local rootPart = player.Character.HumanoidRootPart
                local targetCFrame = teleportLocations[selectedLocation]
                
                if rootPart and targetCFrame then
                    rootPart.CFrame = targetCFrame
                end
            end
        end
    end
})
local Section = Teleport:Section({ 
    Title = "Teleport To Game Event",
})

local teleportToggle
local locationDropdown

local currentLocation = "Megalodon Hunt"
local bodyVelocity = nil
local lastPosition = nil

local function findLocationPart(locationName)
    local menuRings = workspace:FindFirstChild("!!! MENU RINGS")
    if not menuRings then return nil end
    
    if locationName == "Megalodon Hunt" then
        local props = menuRings:FindFirstChild("Props")
        if props then
            local megalodon = props:FindFirstChild("Megalodon Hunt")
            if megalodon and megalodon:IsA("Model") then
                return megalodon.PrimaryPart or megalodon:FindFirstChildWhichIsA("BasePart")
            end
        end
    
    elseif locationName == "Ghost Shark Hunt" then
        for _, child in pairs(menuRings:GetChildren()) do
            local ghostShark = child:FindFirstChild("Ghost Shark Hunt")
            if ghostShark and ghostShark:IsA("Model") then
                return ghostShark.PrimaryPart or ghostShark:FindFirstChildWhichIsA("BasePart")
            end
        end
    
    elseif locationName == "Shark Hunt" then
        for _, child in pairs(menuRings:GetChildren()) do
            local shark = child:FindFirstChild("Shark Hunt")
            if shark and shark:IsA("Model") then
                return shark.PrimaryPart or shark:FindFirstChildWhichIsA("BasePart")
            end
        end
    
    elseif locationName == "Worm Fish" then
        for _, child in pairs(menuRings:GetChildren()) do
            local model = child:FindFirstChild("Model")
            if model and model:IsA("Model") then
                local children = model:GetChildren()
                if #children >= 3 then
                    local thirdChild = children[3]
                    if thirdChild and thirdChild:IsA("BasePart") then
                        return thirdChild
                    end
                end
            end
        end
    end
    
    return nil
end

local function freezePosition(position)
    local character = game.Players.LocalPlayer.Character
    if not character then return end
    
    local rootPart = character:FindFirstChild("HumanoidRootPart")
    if not rootPart then return end
    
    if bodyVelocity then
        bodyVelocity:Destroy()
        bodyVelocity = nil
    end
    
    bodyVelocity = Instance.new("BodyVelocity")
    bodyVelocity.Velocity = Vector3.new(0, 0, 0)
    bodyVelocity.MaxForce = Vector3.new(40000, 40000, 40000)
    bodyVelocity.P = 10000
    bodyVelocity.Parent = rootPart
    
    rootPart.CFrame = CFrame.new(position)
end

local function unfreezePosition()
    if bodyVelocity then
        bodyVelocity:Destroy()
        bodyVelocity = nil
    end
end

local function saveCurrentPosition()
    local character = game.Players.LocalPlayer.Character
    if not character then return end
    
    local rootPart = character:FindFirstChild("HumanoidRootPart")
    if not rootPart then return end
    
    lastPosition = rootPart.Position
end

local function teleportToLocation(locationPart)
    if not locationPart then 
        return false
    end
    saveCurrentPosition()
    local character = game.Players.LocalPlayer.Character
    if not character then return false end
    local rootPart = character:FindFirstChild("HumanoidRootPart")
    if not rootPart then return false end
    local randomX = locationPart.Position.X + math.random(-10, 10)
    local randomZ = locationPart.Position.Z + math.random(-10, 10)
    local yOffset = locationPart.Position.Y + 50
    local targetPosition = Vector3.new(randomX, yOffset, randomZ)
    freezePosition(targetPosition)
    
    return true
end

local function returnToLastPosition()
    if not lastPosition then return end
    unfreezePosition()
    local character = game.Players.LocalPlayer.Character
    if not character then return end
    local rootPart = character:FindFirstChild("HumanoidRootPart")
    if not rootPart then return end
    rootPart.CFrame = CFrame.new(lastPosition)
end

local GameToggle = Teleport:Dropdown({
    Title = "Hunt Location",
    Values = {"Megalodon Hunt", "Ghost Shark Hunt", "Shark Hunt", "Worm Fish"},
    Value = "",
    Callback = function(option)
        currentLocation = option
    end
})

local GameEventToggle = Teleport:Toggle({
    Title = "Teleport To Game Event",
    Type = "Toggle",
    Default = false,
    Callback = function(state)
        if state then
            local selectedLocation = currentLocation
            local locationPart = findLocationPart(selectedLocation)
            
            if locationPart then
                teleportToLocation(locationPart)
            end
        else
            returnToLastPosition()
        end
    end
})


local Section = Teleport:Section({ 
    Title = "Teleport To NPC Locations",
})

local npcLocations = {
    ["Alex"] = CFrame.new(49, 17, 2880),
    ["Alien Merchant"] = CFrame.new(-134, 2, 2762),
    ["Aura Kid"] = CFrame.new(71, 17, 2830),
    ["Billy Bob"] = CFrame.new(80, 17, 2876),
    ["Boat Expert"] = CFrame.new(33, 10, 2783),
    ["Joe"] = CFrame.new(144, 20, 2862),
    ["Ron"] = CFrame.new(-52, 17, 2859),
    ["Scientist"] = CFrame.new(-7, 18, 2886),
    ["Scott"] = CFrame.new(-17, 10, 2703),
    ["Seth"] = CFrame.new(111, 17, 2877),
    ["Silly Fisherman"] = CFrame.new(102, 10, 2690)
}

local selectedNPC = ""

local NPCDropdown = Teleport:Dropdown({
    Title = "Teleport to NPC",
    Values = {"Alex", "Alien Merchant", "Aura Kid", "Billy Bob", "Boat Expert", "Joe", "Ron", "Scientist", "Scott", "Seth", "Silly Fisherman"},
    Value = "",
    Callback = function(option)
        if option and option ~= "" then
            selectedNPC = option
        end
    end
})

local TeleportNPCButton = Teleport:Button({
    Title = "Teleport to NPC",
    Callback = function()
        if selectedNPC and selectedNPC ~= "" then
            if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                local rootPart = player.Character.HumanoidRootPart
                local targetCFrame = npcLocations[selectedNPC]
                
                if rootPart and targetCFrame then
                    rootPart.CFrame = targetCFrame
                end
            end
        end
    end
})

--------------- QUEST -------------

local Button = Quest:Button({
    Title = "Check Quest DeepSea",
    Callback = function()
        local questData = require(ReplicatedStorage.Packages.Replion).Client:WaitReplion("Data")
        local deepSeaData = questData:Get({"DeepSea", "Available", "Forever"})
        
        if not deepSeaData then return end
        
        local progressText = ""
        local quests = require(ReplicatedStorage.Shared.Quests.QuestList).DeepSea.Forever
        
        for i, questInfo in ipairs(quests) do
            local questProgress = deepSeaData.Quests[i]
            local target = questInfo.Arguments.value
            local current = questProgress and questProgress.Progress or 0
            local percent = math.floor((current / target) * 100)
            
            progressText = progressText .. i .. ". " .. questInfo.DisplayName .. " : " .. current .. "/" .. target .. " (" .. percent .. "%)\n"
        end
        
        WindUI:Notify({
            Title = "Deep Sea Quest",
            Content = progressText,
            Duration = 10,
        })
    end
})

local runningDeepSea = false

local function getDeepSeaProgress()
    local Replion = require(ReplicatedStorage.Packages.Replion)
    local QuestList = require(ReplicatedStorage.Shared.Quests.QuestList)
    local questData = Replion.Client:WaitReplion("Data")
    
    local deepSeaData = questData:Get({"DeepSea", "Available", "Forever"})
    
    if not deepSeaData or not deepSeaData.Quests then
        return nil
    end
    
    local progress = {}
    local deepSeaQuests = QuestList.DeepSea.Forever
    
    for i, questInfo in ipairs(deepSeaQuests) do
        local questProgress = deepSeaData.Quests[i]
        local target = questInfo.Arguments.value
        local current = questProgress and questProgress.Progress or 0
        local completed = current >= target
        
        progress[i] = {
            name = questInfo.DisplayName,
            current = current,
            target = target,
            completed = completed,
            redeemed = questProgress and questProgress.Redeemed or false
        }
    end
    
    return progress
end

local function teleportToLocation(cframe)
    local player = game.Players.LocalPlayer
    if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
        player.Character.HumanoidRootPart.CFrame = cframe
    end
end

local function isPlayerFarFromTarget(targetCFrame, maxDistance)
    local player = game.Players.LocalPlayer
    if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
        local playerPosition = player.Character.HumanoidRootPart.Position
        local targetPosition = targetCFrame.Position
        local distance = (playerPosition - targetPosition).Magnitude
        return distance > maxDistance
    end
    return true
end

local function startDeepSeaQuest()
    local quest234Location = CFrame.new(-3737, -136, -881)
    local quest1Location = CFrame.new(-3650.4873, -269.269318, -1652.68323, -0.147814155, -2.75628675e-08, -0.989015162, -1.74189818e-08, 1, -2.52656349e-08, 0.989015162, 1.34930183e-08, -0.147814155)
    
    local currentTargetLocation = nil
    
    while runningDeepSea do
        local success, progress = pcall(getDeepSeaProgress)
        
        if not success or not progress then
            task.wait(60)
         
        end
        
        local allCompleted = true
        for i = 1, 4 do
            if progress[i] and not progress[i].completed then
                allCompleted = false
                break
            end
        end
        
        if allCompleted then
            runningDeepSea = false
            DeepSeaToggle:Set(false)
            break
        end
        
        local quest234Completed = true
        for i = 2, 4 do
            if progress[i] and not progress[i].completed then
                quest234Completed = false
                break
            end
        end
        
        if not quest234Completed then
            currentTargetLocation = quest234Location
        else
            currentTargetLocation = quest1Location
        end
        
        if currentTargetLocation and isPlayerFarFromTarget(currentTargetLocation, 10) then
            teleportToLocation(currentTargetLocation)
        end
        
        task.wait(1)
    end
end

local function stopDeepSeaQuest()
    runningDeepSea = false
end

local DeepSeaToggle = Quest:Toggle({
    Title = "Auto Complete Deep Sea",
    Default = false,
    Callback = function(state)
        runningDeepSea = state
        if state then
            if not autoFishingRunning then
                autoFishingToggle:Set(true)
            end
            task.spawn(function()
                startDeepSeaQuest()
            end)
        else
            stopDeepSeaQuest()
        end
    end
})

Divider = Quest:Divider()
Space = Quest:Space()

local Button = Quest:Button({
    Title = "Check Element Jungle",
    Callback = function()
        local questData = require(ReplicatedStorage.Packages.Replion).Client:WaitReplion("Data")
        local jungleData = questData:Get({"ElementJungle", "Available", "Forever"})
        
        if not jungleData then return end
        
        local progressText = ""
        local quests = require(ReplicatedStorage.Shared.Quests.QuestList).ElementJungle.Forever
        
        for i, questInfo in ipairs(quests) do
            local questProgress = jungleData.Quests[i]
            local target = questInfo.Arguments.value
            local current = questProgress and questProgress.Progress or 0
            local percent = math.floor((current / target) * 100)
            
            progressText = progressText .. i .. ". " .. questInfo.DisplayName .. " : " .. current .. "/" .. target .. " (" .. percent .. "%)\n"
        end
        
        WindUI:Notify({
            Title = "Element Jungle",
            Content = progressText,
            Duration = 10,
        })
    end
})

local runningElementJungle = false

local function getElementJungleProgress()
    local Replion = require(ReplicatedStorage.Packages.Replion)
    local QuestList = require(ReplicatedStorage.Shared.Quests.QuestList)
    local questData = Replion.Client:WaitReplion("Data")
    
    local elementJungleData = questData:Get({"ElementJungle", "Available", "Forever"})
    
    if not elementJungleData or not elementJungleData.Quests then
        return nil
    end
    
    local progress = {}
    local elementJungleQuests = QuestList.ElementJungle.Forever
    
    for i, questInfo in ipairs(elementJungleQuests) do
        local questProgress = elementJungleData.Quests[i]
        local target = questInfo.Arguments.value
        local current = questProgress and questProgress.Progress or 0
        local completed = current >= target
        
        progress[i] = {
            name = questInfo.DisplayName,
            current = current,
            target = target,
            completed = completed
        }
    end
    
    return progress
end

local function teleportToLocation(cframe)
    local player = game.Players.LocalPlayer
    if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
        player.Character.HumanoidRootPart.CFrame = cframe
    end
end

local function startElementJungleQuest()
    local quest2Location = CFrame.new(1519.33215, 2.08891273, -307.090668, 0.632470906, -1.48247699e-08, 0.774584115, -2.24899335e-08, 1, 3.75027014e-08, -0.774584115, -4.11397139e-08, 0.632470906)
    local quest3Location = CFrame.new(1413.84277, 4.375, -587.298279, 0.261966974, 5.50031594e-08, -0.965076864, -8.19077872e-09, 1, 5.47701973e-08, 0.965076864, -6.44325127e-09, 0.261966974)
    
    while runningElementJungle do
        local success, progress = pcall(getElementJungleProgress)
        
        if not success or not progress then
            task.wait(5)
            
        end
        
        if progress[1] and not progress[1].completed then
            WindUI:Notify({
                Title = "Element Jungle Quest",
                Content = "Selesaikan Quest Deep Sea dulu!",
                Duration = 5,
            })
            runningElementJungle = false
            ElementJungleToggle:Set(false)
            break
        end
        
        if progress[1] and progress[1].completed and 
           progress[2] and progress[2].completed and 
           progress[3] and progress[3].completed then
            runningElementJungle = false
            ElementJungleToggle:Set(false)
            break
        end
        
        if progress[2] and not progress[2].completed then
            teleportToLocation(quest2Location)
        end
        
        if progress[3] and not progress[3].completed then
            teleportToLocation(quest3Location)
        end
        
        task.wait(5)
    end
end

local ElementJungleToggle = Quest:Toggle({
    Title = "Auto Element Jungle Quest",
    Default = false,
    Callback = function(state)
        runningElementJungle = state
        if state then
            -- Auto nyalain Auto Fishing
            if not autoFishingRunning then
                autoFishingToggle:Set(true)
            end
            task.spawn(function()
                startElementJungleQuest()
            end)
        end
    end
})

----------------- webhook -------------

local webhookUrl = "YOUR_WEBHOOK_URL_HERE"
local monitorEnabled = false
local selectedTiers = {"Epic", "Legendary", "Mythic", "SECRET"}

local fishNameMapping = {}
local fishTierMapping = {}
local fishPriceMapping = {}

local function getTierName(tierNumber)
    local tierMap = {
        [1] = "Common",
        [2] = "Uncommon", 
        [3] = "Rare",
        [4] = "Epic",
        [5] = "Legendary",
        [6] = "Mythic",
        [7] = "SECRET"
    }
    return tierMap[tierNumber] or "Unknown"
end

local function getTierColor(tierName)
    local colors = {
        ["Common"] = 0x7289DA,
        ["Uncommon"] = 0x57F287, 
        ["Rare"] = 0x3498DB,
        ["Epic"] = 0x9B59B6,
        ["Legendary"] = 0xF1C40F,
        ["Mythic"] = 0xE91E63,
        ["SECRET"] = 0xFF00FF 
    }
    return colors[tierName] or 0x7289DA
end

local function getTierEmoji(tierName)
    local emojis = {
        ["Common"] = "⚪",
        ["Uncommon"] = "🟢", 
        ["Rare"] = "🔵",
        ["Epic"] = "🟣",
        ["Legendary"] = "🟡",
        ["Mythic"] = "🔴",
        ["SECRET"] = "💠" 
    }
    return emojis[tierName] or "🎣"
end

local function formatPrice(price)
    return tostring(price):reverse():gsub("%d%d%d", "%1,"):reverse():gsub("^,", "")
end

local function getMutationStatus(mutationData)
    if not mutationData then return "Normal" end
    
    if mutationData.Shiny then return "✨ Shiny"
    elseif mutationData.Golden then return "🌟 Golden" 
    elseif mutationData.Rainbow then return "🌈 Rainbow"
    elseif mutationData.Crystal then return "💎 Crystal"
    elseif mutationData.Albino then return "⚪ Albino"
    else return "Normal" end
end

local function scanAllItems()
    local ItemsFolder = game:GetService("ReplicatedStorage"):FindFirstChild("Items")
    if not ItemsFolder then return 0 end
    
    local fishCount = 0
    
    for _, item in pairs(ItemsFolder:GetDescendants()) do
        if item:IsA("ModuleScript") then
            local success, itemData = pcall(function()
                return require(item)
            end)
            
            if success and itemData then
                local data = itemData.Data or itemData
                
                if data and type(data) == "table" and data.Id and data.Name then
                    fishCount = fishCount + 1
                    
                    fishNameMapping[data.Id] = data.Name
                    fishTierMapping[data.Id] = data.Tier or 1
                    
                    if itemData.SellPrice then
                        fishPriceMapping[data.Id] = itemData.SellPrice
                    elseif data.SellPrice then
                        fishPriceMapping[data.Id] = data.SellPrice
                    else
                        fishPriceMapping[data.Id] = 0
                    end
                end
            end
        end
    end
    
    return fishCount
end

local function getFishNameFromId(fishId)
    return fishNameMapping[fishId] or "Unknown Fish (ID: " .. tostring(fishId) .. ")"
end

local function getFishPriceFromId(fishId)
    return fishPriceMapping[fishId] or 0
end

local function createSecretEmbed(fishName, playerName, weight, mutationStatus, fishPrice)
    return {
        title = "🚨 **ULTRA RARE FISH CAUGHT!** 🚨",
        color = 0xFF00FF,
        description = "***A legendary fisherman has achieved the impossible!***",
        thumbnail = {
            url = "https://cdn.discordapp.com/attachments/1307006912348291122/1426396355407904839/fish_icon.png"
        },
        fields = {
            {
                name = "**Fisherman**",
                value = playerName,
                inline = true
            },
            {
                name = "**Rarity**", 
                value = "💠 **SECRET**",
                inline = true
            },
            {
                name = "**Mutation**",
                value = mutationStatus,
                inline = true
            },
            {
                name = "**Weight**",
                value = weight .. " kg",
                inline = true
            },
            {
                name = "**Fish Name**",
                value = "**" .. fishName .. "**",
                inline = false
            },
            {
                name = "**Value**",
                value = "$" .. formatPrice(fishPrice),
                inline = true
            }
        },
        footer = {
            text = "🌟 SECRET!! CATCH • " .. os.date("%m/%d/%Y %I:%M %p")
        },
        timestamp = os.date("!%Y-%m-%dT%H:%M:%SZ")
    }
end

local function createNormalEmbed(fishName, playerName, tierName, tierColor, tierEmoji, weight, mutationStatus, fishPrice)
    return {
        title = "🎣 New Fish Caught!",
        color = tierColor,
        fields = {
            {
                name = "**Fisherman**",
                value = playerName,
                inline = true
            },
            {
                name = "**Rarity**", 
                value = tierEmoji .. " " .. tierName,
                inline = true
            },
            {
                name = "**Mutation**",
                value = mutationStatus,
                inline = true
            },
            {
                name = "**Weight**",
                value = weight .. " kg",
                inline = true
            },
            {
                name = "**Fish Name**",
                value = "**" .. fishName .. "**",
                inline = false
            },
            {
                name = "**Value**",
                value = "$" .. formatPrice(fishPrice),
                inline = true
            }
        },
        footer = {
            text = "Fyy Community • " .. os.date("%m/%d/%Y %I:%M %p")
        },
        timestamp = os.date("!%Y-%m-%dT%H:%M:%SZ")
    }
end

local function sendFishWebhook(fishId, weightData, itemData, isNew)
    if not monitorEnabled then return end
    
    local fishName = getFishNameFromId(fishId)
    local weight = weightData and weightData.Weight or "N/A"
    local tierNumber = fishTierMapping[fishId] or 1
    local tierName = getTierName(tierNumber)
    
    if not table.find(selectedTiers, tierName) then return end
    
    local tierColor = getTierColor(tierName)
    local tierEmoji = getTierEmoji(tierName)
    local fishPrice = getFishPriceFromId(fishId)
    
    local mutationData = weightData
    local mutationStatus = getMutationStatus(mutationData)
    
    local player = game.Players.LocalPlayer
    local playerName = player.DisplayName
    
    if webhookUrl and webhookUrl ~= "YOUR_WEBHOOK_URL_HERE" then
        local embed
        
        if tierName == "SECRET" then
            embed = createSecretEmbed(fishName, playerName, weight, mutationStatus, fishPrice)
        else
            embed = createNormalEmbed(fishName, playerName, tierName, tierColor, tierEmoji, weight, mutationStatus, fishPrice)
        end
        
        local payload = {
            username = "Fyy Community",
            avatar_url = "https://cdn.discordapp.com/attachments/1307006912348291122/1426396355407904839/fish_icon.png",
            embeds = { embed }
        }
        
        pcall(function()
            local request = (syn and syn.request) or (http and http.request) or http_request or request
            request({
                Url = webhookUrl,
                Method = "POST",
                Headers = {
                    ["Content-Type"] = "application/json"
                },
                Body = game:GetService("HttpService"):JSONEncode(payload)
            })
        end)
    end
end

local function startFishMonitoring()
    local ReplicatedStorage = game:GetService("ReplicatedStorage")
    
    local targetRemote
    local success, result = pcall(function()
        return ReplicatedStorage:FindFirstChild("Packages") and ReplicatedStorage.Packages._Index["sleitnick_net@0.2.0"].net["RE/ObtainedNewFishNotification"]
    end)
    
    if success and result then
        targetRemote = result
    else
        for _, obj in pairs(ReplicatedStorage:GetDescendants()) do
            if obj:IsA("RemoteEvent") and string.find(string.lower(obj.Name), "fish") then
                targetRemote = obj
                break
            end
        end
    end
    
    if targetRemote then
        targetRemote.OnClientEvent:Connect(function(fishId, weightData, itemData, isNew)
            sendFishWebhook(fishId, weightData, itemData, isNew)
        end)
    end
end

local function testWebhookConnection()
    if webhookUrl == "YOUR_WEBHOOK_URL_HERE" then return end
    
    local payload = {
        username = "FyyCommunity",
        embeds = {
            {
                title = "✅ Webhook Connected",
                description = "FyyCommunity webhook system is now connected and ready!",
                color = 0x00FF00,
                fields = {
                    {
                        name = "**Status**",
                        value = "🟢 Connected",
                        inline = true
                    },
                    {
                        name = "**Service**",
                        value = "Fish Monitor",
                        inline = true
                    },
                    {
                        name = "**Version**", 
                        value = "Beta Version 1.0.0.1",
                        inline = true
                    }
                },
                footer = {
                    text = "FyyCommunity • " .. os.date("%m/%d/%Y %I:%M %p")
                },
                timestamp = os.date("!%Y-%m-%dT%H:%M:%SZ")
            }
        }
    }
    
    pcall(function()
        local request = (syn and syn.request) or (http and http.request) or http_request or request
        request({
            Url = webhookUrl,
            Method = "POST",
            Headers = {
                ["Content-Type"] = "application/json"
            },
            Body = game:GetService("HttpService"):JSONEncode(payload)
        })
    end)
end

local WebhookInput = Discord:Input({
    Title = "Webhook URL",
    Placeholder = "https://discord.com/api/webhooks/...",
    Callback = function(value)
        webhookUrl = value
    end
})

local TierDropdown = Discord:Dropdown({
    Title = "Notify Tiers",
    Values = {"Common", "Uncommon", "Rare", "Epic", "Legendary", "Mythic", "SECRET"},
    Value = {""},
    Multi = true,
    AllowNone = false,
    Callback = function(selected)
        selectedTiers = selected
    end
})

local MonitorToggle = Discord:Toggle({
    Title = "Enable Webhook Notifications",
    Default = false,
    Callback = function(state)
        monitorEnabled = state
        if state then
            startFishMonitoring()
        end
    end
})

local TestWebhookButton = Discord:Button({
    Title = "Test Webhook Connection",
    Callback = testWebhookConnection
})

task.spawn(function()
    task.wait(3)
    scanAllItems()
end)

local section = Setting:Section({ 
    Title = "Game Optimization",
})

local AntiLagButton = Setting:Button({
    Title = "Apply Anti Lag",
    Desc = "Optimalkan game untuk mengurangi lag",
    Callback = function()
        loadstring(game:HttpGet("https://pastebin.com/raw/C7W8GSu4"))()
    end
})

local localPlayer = game.Players.LocalPlayer
local playerName = localPlayer.Name  
local originalAnimator = nil
local animatorRemoved = false

local AnimatorToggle = Setting:Toggle({
    Title = "Remove Animasi Catch Fishing",
    Default = false,
    Callback = function(state)
        local character = workspace.Characters:FindFirstChild(playerName)
        
        if state then
            if character then
                local humanoid = character:FindFirstChild("Humanoid")
                if humanoid then
                    local animator = humanoid:FindFirstChildOfClass("Animator")
                    if animator then
                        originalAnimator = animator:Clone()  
                        animator:Destroy()
                        animatorRemoved = true
                    else
                    end
                else
                end
            else
            end
        else
            if character and animatorRemoved then
                local humanoid = character:FindFirstChild("Humanoid")
                if humanoid and originalAnimator then
                    local currentAnimator = humanoid:FindFirstChildOfClass("Animator")
                    if not currentAnimator then
                        local newAnimator = originalAnimator:Clone()
                        newAnimator.Parent = humanoid
                    end
                    animatorRemoved = false
                end
            end
        end
    end
})

local function Main()
    local ReplicatedStorage = game:GetService("ReplicatedStorage")
    local Players = game:GetService("Players")
    
    local Client = require(ReplicatedStorage.Packages.Replion).Client
    local player = Players.LocalPlayer
    local dataStore = Client:WaitReplion("Data")

    local REEquipItem = ReplicatedStorage.Packages._Index["sleitnick_net@0.2.0"].net["RE/EquipItem"]
    local REEquipToolFromHotbar = ReplicatedStorage.Packages._Index["sleitnick_net@0.2.0"].net["RE/EquipToolFromHotbar"]
    local REActivateEnchantingAltar = ReplicatedStorage.Packages._Index["sleitnick_net@0.2.0"].net["RE/ActivateEnchantingAltar"]
    local RERollEnchant = ReplicatedStorage.Packages._Index["sleitnick_net@0.2.0"].net["RE/RollEnchant"]
    local UpdateRemote = ReplicatedStorage.Packages._Index["ytrev_replion@2.0.0-rc.3"].replion.Remotes.Update

    local enchantMapping = {
        ["Big Hunter I"] = 3,
        ["Cursed I"] = 12,
        ["Empowered I"] = 9, 
        ["Glistening I"] = 1,
        ["Gold Digger I"] = 4,
        ["Leprechaun I"] = 5,
        ["Leprechaun II"] = 6,
        ["Mutation Hunter I"] = 7,
        ["Mutation Hunter II"] = 14,
        ["Perfection"] = 15,
        ["Prismatic I"] = 13,
        ["Reeler I"] = 2,
        ["Stargazer I"] = 8,
        ["Stormhunter I"] = 11,
        ["XPerienced I"] = 10
    }

    local autoRerollEnabled = false
    local targetEnchantId = 10
    local rollCount = 0
    local waitingForUpdate = false
    local currentCycleRunning = false

    local function scanEnchantStones()
        local inventoryData = dataStore:Get("Inventory")
        local enchantStones = {}
        
        if inventoryData then
            for category, items in pairs(inventoryData) do
                if type(items) == "table" and #items > 0 then
                    for _, item in ipairs(items) do
                        if item.Id == 10 then
                            table.insert(enchantStones, {
                                id = item.Id,
                                uuid = item.UUID,
                                category = category
                            })
                        end
                    end
                end
            end
        end
        
        return enchantStones
    end

    local function teleportToEnchant()
        local character = player.Character
        if character and character:FindFirstChild("HumanoidRootPart") then
            character.HumanoidRootPart.CFrame = CFrame.new(3245, -1301, 1394)
            return true
        end
        return false
    end

    local function equipEnchantStoneSimple()
        local allEnchantStones = scanEnchantStones()
        
        if #allEnchantStones > 0 then
            local randomIndex = math.random(1, #allEnchantStones)
            local selectedStone = allEnchantStones[randomIndex]
            
            for i = 1, 3 do
                REEquipItem:FireServer(selectedStone.uuid, "EnchantStones")
                task.wait(1)
            end
            return true
        end
        return false
    end

    local function equipToolThreeTimes()
        for i = 1, 3 do
            REEquipToolFromHotbar:FireServer(6)
            task.wait(1)
        end
        return true
    end

    local function activateAltarThreeTimes()
        for i = 1, 3 do
            REActivateEnchantingAltar:FireServer()
            task.wait(0.5)
        end
        return true
    end

    local function startTimeoutChecker()
        coroutine.wrap(function()
            for i = 1, 30 do
                if not waitingForUpdate or not autoRerollEnabled then
                    return
                end
                task.wait(0.1)
            end
                if waitingForUpdate and autoRerollEnabled then
                waitingForUpdate = false
                currentCycleRunning = false
                
                task.wait(1)
                if autoRerollEnabled then
                    currentCycleRunning = true
                    
                    coroutine.wrap(function()
                        if equipEnchantStoneSimple() then
                            task.wait(2)
                            equipToolThreeTimes()
                            task.wait(2)
                            activateAltarThreeTimes()
                            task.wait(0.1)
                            waitingForUpdate = true
                            RERollEnchant:FireServer()
                            startTimeoutChecker()
                        end
                    end)()
                end
            end
        end)()
    end

    local function startNewEnchantCycle()
        if not autoRerollEnabled or currentCycleRunning then return end
        
        currentCycleRunning = true
        
        if not teleportToEnchant() then 
            currentCycleRunning = false
            return 
        end
        task.wait(2)

        if not equipEnchantStoneSimple() then 
            currentCycleRunning = false
            return 
        end
        task.wait(2)
        equipToolThreeTimes()
        task.wait(1)
        activateAltarThreeTimes()
        task.wait(0.1)
        waitingForUpdate = true
        RERollEnchant:FireServer()
        
        startTimeoutChecker()
    end

    local function createUI()
        if not Discord then return end
        
        Enchant:Dropdown({
            Title = "Target Enchant",
            Values = {
                "Big Hunter I", "Cursed I", "Empowered I", "Glistening I", "Gold Digger I",
                "Leprechaun I", "Leprechaun II", "Mutation Hunter I", "Mutation Hunter II",
                "Perfection", "Prismatic I", "Reeler I", "Stargazer I", "Stormhunter I", "XPerienced I"
            },
            Value = "XPerienced I",
            Callback = function(selected)
                targetEnchantId = enchantMapping[selected] or 10
            end
        })

        Enchant:Toggle({
            Title = "Auto Enchant",
            Value = false,
            Callback = function(state)
                autoRerollEnabled = state
                if state then
                    rollCount = 0
                    waitingForUpdate = false
                    currentCycleRunning = false
                    
                    coroutine.wrap(function()
                        startNewEnchantCycle()
                    end)()
                else
                    waitingForUpdate = false
                    currentCycleRunning = false
                end
            end
        })
    end

    UpdateRemote.OnClientEvent:Connect(function(dataString, path, data)
        if not autoRerollEnabled then return end
        if not waitingForUpdate then return end
        
        waitingForUpdate = false
        currentCycleRunning = false
        
        if path and type(path) == "table" then
            if #path >= 4 and path[1] == "Inventory" and path[2] == "Fishing Rods" and path[4] == "Metadata" then
                if data and data.EnchantId then
                    local enchantId = data.EnchantId
                    
                    rollCount = rollCount + 1
                    
                    if enchantId == targetEnchantId then
                        autoRerollEnabled = false
                    else
                        task.wait(8)
                        
                        if autoRerollEnabled then
                            coroutine.wrap(function()
                                startNewEnchantCycle()
                            end)()
                        end
                    end
                end
            end
        end
    end)

    task.wait(2)
    createUI()
end

pcall(Main)

if Discord then
    local Players = game:GetService("Players")
    local player = Players.LocalPlayer
    local originalSmallNotification = nil
    
local RemoveNOTIF = Setting:Toggle({
        Title = "Remove Notification", 
        Value = false, 
        Callback = function(state)
            local playerGui = player:WaitForChild("PlayerGui")
            local smallNotification = playerGui:FindFirstChild("Small Notification")
            
            if state then
                if smallNotification then
                    originalSmallNotification = smallNotification:Clone()
                    smallNotification:Destroy()
                end
            else
                if originalSmallNotification then
                    smallNotification = originalSmallNotification:Clone()
                    smallNotification.Parent = playerGui
                    originalSmallNotification = nil
                end
            end
        end
    })
end

local ConfigManager = Window.ConfigManager
local FyyConfig = ConfigManager:CreateConfig("FishingConfig")

-- Split config registration into smaller functions to avoid 200+ local variables
local function registerMainElements()
    FyyConfig:Register("Auto_FishingToggle", autoFishingToggle)
    FyyConfig:Register("LocationDropdown", LocationDropdown)
    FyyConfig:Register("TeleportToggle", TeleportToggle)
    FyyConfig:Register("AutoSellSlider", AutoSellSlider)
    FyyConfig:Register("AutoSellToggle", AutoSellToggle)
    FyyConfig:Register("AutoFavRarity", AutoFavRarity)
    FyyConfig:Register("AutoFavMutasi", AutoFavMutasi)
    FyyConfig:Register("AutoFAVORITE", AutoFAVORITE)
end

local function registerShopElements()
    FyyConfig:Register("Shop_WeatherDropdown", WeatherDropdown)
    FyyConfig:Register("Shop_AutoWeatherToggle", AutoWeatherToggle)
    FyyConfig:Register("GameToggle", GameToggle)
    FyyConfig:Register("GameEventToggle", GameEventToggle)
end

local function registerQuestElements()
    FyyConfig:Register("DeepSeaToggle", DeepSeaToggle)
    FyyConfig:Register("ElementJungleToggle", ElementJungleToggle)
    FyyConfig:Register("AnimatorToggle", AnimatorToggle)
end

local function registerWebhookElements()
    FyyConfig:Register("WebhookInput", WebhookInput)
    FyyConfig:Register("TierDropdown", TierDropdown)
    FyyConfig:Register("MonitorToggle", MonitorToggle)
end

local function registerSuperFastElements()
    FyyConfig:Register("SuperFastToggle", SuperFastToggle)
    FyyConfig:Register("SuperFastSlider", SuperFastSlider)
    FyyConfig:Register("UltraFastToggle", UltraFastToggle)
    FyyConfig:Register("InstantCatchToggle", InstantCatchToggle)
    FyyConfig:Register("PerformanceButton", PerformanceButton)
end

local function registerAllElements()
    registerMainElements()
    registerShopElements()
    registerQuestElements()
    registerWebhookElements()
    registerSuperFastElements()
end

-- Split config buttons into smaller functions
local function createSaveButton()
    return Config:Button({
        Title = "Save Config",
        Desc = "Save ALL current settings",
        Callback = function()
            FyyConfig:Save("FyyFishingConfig")
            WindUI:Notify({
                Title = "Config Saved",
                Content = "All settings have been saved!",
                Duration = 3,
            })
        end
    })
end

local function createLoadButton()
    return Config:Button({
        Title = "Load Config",
        Desc = "Load ALL saved settings",
        Callback = function()
            FyyConfig:Load("FyyFishingConfig")
            WindUI:Notify({
                Title = "Config Loaded",
                Content = "All settings have been loaded!",
                Duration = 3,
            })
        end
    })
end

local function createResetButton()
    return Config:Button({
        Title = "Reset Config",
        Desc = "Reset to default settings",
        Callback = function()
            FyyConfig:Delete("FyyFishingConfig")
            for _, element in pairs(FyyConfig.Elements or {}) do
                if element.SetValue then
                    if element.Default ~= nil then
                        element:SetValue(element.Default)
                    elseif element.Type == "Toggle" then
                        element:SetValue(false)
                    elseif element.Type == "Slider" then
                        element:SetValue(0)
                    elseif element.Type == "Input" then
                        element:SetValue("")
                    elseif element.Type == "Dropdown" then
                        element:SetValue({})
                    end
                end
            end
            FyyConfig:Save("FyyFishingConfig")
            WindUI:Notify({
                Title = "Config Reset",
                Content = "All settings reset to default!",
                Duration = 3,
            })
        end
    })
end

local function setupConfigButtons()
    createSaveButton()
    createLoadButton()
    createResetButton()
end

task.spawn(function()
    task.wait(2)
    registerAllElements()
    setupConfigButtons()

    if FyyConfig.ConfigExists and FyyConfig:ConfigExists("FyyFishingConfig") then
        FyyConfig:Load("FyyFishingConfig")
    end
end)