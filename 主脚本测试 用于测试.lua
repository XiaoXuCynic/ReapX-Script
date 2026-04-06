local WindUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/Footagesus/WindUI/main/dist/main.lua"))()

WindUI.TransparencyValue = 0.2
WindUI:SetTheme("Dark")

local function gradient(text, startColor, endColor)
    local result = ""
    for i = 1, #text do
        local t = (i - 1) / (#text - 1)
        local r = math.floor((startColor.R + (endColor.R - startColor.R) * t) * 255)
        local g = math.floor((startColor.G + (endColor.G - startColor.G) * t) * 255)
        local b = math.floor((startColor.B + (endColor.B - startColor.B) * t) * 255)
        result = result .. string.format('<font color="rgb(%d,%d,%d)">%s</font>', r, g, b, text:sub(i, i))
    end
    return result
end

WindUI:Popup({
    Title = gradient("旧冬Hub", Color3.fromHex("#6A11CB"), Color3.fromHex("#2575FC")),
    Icon = "sparkles",
    Content = "您使用的当前版本是7.0\n公告:该版本更新后小徐不再维护与更新\n由TBW.TEAM的LitYu[李涛宇]接手\n谢谢您的使用",
    Buttons = {
        {
            Title = "开始使用",
            Icon = "arrow-right",
            Variant = "Primary",
            Callback = function() end
        }
    }
})

local Window = WindUI:CreateWindow({
    Title = "旧冬Hub",
    Icon = "palette",
    Author = "by小徐 / LitYu",
    Folder = "旧冬Hub",
    Size = UDim2.fromOffset(700, 500),
    Theme = "Dark",
    Background = "https://raw.githubusercontent.com/XiaoXuCynic/Old-Winter-Script/refs/heads/main/df774d3f32578f5198ea8d7b78b31451.jpeg",
    User = {
        Enabled = true,
        Anonymous = true,
        Callback = function()
            WindUI:Notify({
                Title = "用户资料",
                Content = "用户资料已点击！",
                Duration = 3
            })
        end
    },
    SideBarWidth = 220,
    ScrollBarEnabled = true
})

Window:Tag({
    Title = "v7.0",
    Color = Color3.fromHex("#30ff6a")
})
Window:Tag({
    Title = "Kuraki / 旧冬",
    Color = Color3.fromHex("#aa00ff")
})

Window:CreateTopbarButton("theme-switcher", "moon", function()
    WindUI:SetTheme(WindUI:GetCurrentTheme() == "Dark" and "Light" or "Dark")
    WindUI:Notify({
        Title = "主题已更改",
        Content = "当前主题："..WindUI:GetCurrentTheme(),
        Duration = 2
    })
end, 990)

local Tabs = {
    Main = Window:Section({ Title = "通用", Opened = true }),
    Settings = Window:Section({ Title = "主题调整器", Opened = true }),
    FE = Window:Section({ Title = "FE脚本", Opened = true }),
    Script = Window:Section({ Title = "脚本工具", Opened = true }),
    ESP = Window:Section({ Title = "esp功能", Opened = true }),
    Server = Window:Section({ Title = "服务器", Opened = true }),
    Other = Window:Section({ Title = "其他作者的脚本", Opened = true }),
    Aimbot = Window:Section({ Title = "通用自瞄" ,Opened = true }),
    LinSky = Window:Section({ Title = "天空修改(测试)", Opened = true }),
}

local TabHandles = {
    Elements = Tabs.Main:Tab({ Title = "功能", Icon = "layout-grid" }),
    Appearance = Tabs.Settings:Tab({ Title = "外观调整", Icon = "brush" }),
    LiJian = Tabs.FE:Tab({ Title = "FE脚本", Icon = "play" }),
    XiaoXu = Tabs.Script:Tab({  Title = "制作脚本的工具", Icon = "crown" }),
    Pharaoh = Tabs.ESP:Tab({ Title = "ESP/透视", Icon = "play" }),
    LTY = Tabs.Server:Tab({ Title = "服务器脚本", Icon = "zap" }),
    ZSH = Tabs.Other:Tab({ Title = "其他作者的脚本", Icon = "info" }),
    Real = Tabs.Aimbot:Tab({ Title = "自瞄", Icon = "user" }),
    Sky = Tabs.LinSky:Tab({ Title = "天空修改", Icon = "cloud" })
}

TabHandles.Elements:Paragraph({
    Title = "旧冬HubQQ群",
    Desc = "1081649265",
    Image = "component",
    ImageSize = 20,
    Color = "White",
})

TabHandles.Elements:Divider()

-- 速度滑块
local SpeedSlider = TabHandles.Elements:Slider({
    Title = "速度",
    Desc = "调整移动速度",
    Value = { Min = 16, Max = 200, Default = 16 },
    Callback = function(value)
        local player = game.Players.LocalPlayer
        if player and player.Character then
            local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
            if humanoid then
                humanoid.WalkSpeed = value
            end
        end
    end
})

-- 跳跃滑块
local JumpSlider = TabHandles.Elements:Slider({
    Title = "跳跃高度",
    Desc = "调整跳跃高度",
    Value = { Min = 50, Max = 300, Default = 50 },
    Callback = function(value)
        local player = game.Players.LocalPlayer
        if player and player.Character then
            local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
            if humanoid then
                humanoid.JumpPower = value
            end
        end
    end
})

-- 杀戮光环
local killAuraToggle = TabHandles.Elements:Toggle({
    Title = "启用杀戮光环",
    Desc = "自动攻击附近敌人",
    Value = false,
    Callback = function(v)
        if v then
            local Players = game:GetService("Players")
            local RunService = game:GetService("RunService")
            local localPlayer = Players.LocalPlayer
            
            _G.killAuraConfig = {
                isRunning = true,
                connection = nil
            }
            
            _G.killAuraConfig.connection = RunService.Heartbeat:Connect(function()
                if not _G.killAuraConfig or not _G.killAuraConfig.isRunning then
                    return
                end
                
                local localCharacter = localPlayer.Character
                if not localCharacter then return end
                
                local humanoidRootPart = localCharacter:FindFirstChild("HumanoidRootPart")
                local humanoid = localCharacter:FindFirstChildOfClass("Humanoid")
                
                if not humanoidRootPart or not humanoid or humanoid.Health <= 0 then return end
                
                local tool = localCharacter:FindFirstChildOfClass("Tool")
                if not tool then return end
                
                for _, player in pairs(Players:GetPlayers()) do
                    if player ~= localPlayer then
                        local targetChar = player.Character
                        if targetChar then
                            local targetRoot = targetChar:FindFirstChild("HumanoidRootPart")
                            local targetHumanoid = targetChar:FindFirstChildOfClass("Humanoid")
                            
                            if targetRoot and targetHumanoid and targetHumanoid.Health > 0 then
                                local distance = (humanoidRootPart.Position - targetRoot.Position).Magnitude
                                if distance < 20 then
                                    if tool:IsA("Tool") then
                                        tool:Activate()
                                        task.wait(0.1)
                                    end
                                end
                            end
                        end
                    end
                end
            end)
            
            WindUI:Notify({
                Title = "功能设置",
                Content = "杀戮光环已启用",
                Icon = "check",
                Duration = 2
            })
        else
            if _G.killAuraConfig then
                _G.killAuraConfig.isRunning = false
                if _G.killAuraConfig.connection then
                    _G.killAuraConfig.connection:Disconnect()
                end
                _G.killAuraConfig = nil
            end
            
            WindUI:Notify({
                Title = "功能设置",
                Content = "杀戮光环已禁用",
                Icon = "x",
                Duration = 2
            })
        end
    end
})

-- 防甩飞
local FlyOffToggle = TabHandles.Elements:Toggle({
    Title = "防甩飞",
    Desc = "防止被其他玩家甩飞",
    Value = false,
    Callback = function(v)
        if v then
            local Services = setmetatable({}, {__index = function(Self, Index)
                local NewService = game:GetService(Index)
                if NewService then
                    Self[Index] = NewService
                end
                return NewService
            end})

            local LocalPlayer = Services.Players.LocalPlayer
            _G.flyOffEnabled = true
            _G.flyOffConnections = _G.flyOffConnections or {}

            local function PlayerAdded(Player)
                if Player == LocalPlayer then return end
                
                local Detected = false
                local Character
                local PrimaryPart

                local function CharacterAdded(NewCharacter)
                    Character = NewCharacter
                    repeat
                        task.wait()
                        PrimaryPart = NewCharacter:FindFirstChild("HumanoidRootPart")
                    until PrimaryPart
                    Detected = false
                end

                CharacterAdded(Player.Character or Player.CharacterAdded:Wait())
                
                local conn = Player.CharacterAdded:Connect(CharacterAdded)
                table.insert(_G.flyOffConnections, conn)
                
                local heartbeatConn = Services.RunService.Heartbeat:Connect(function()
                    if not _G.flyOffEnabled then
                        return
                    end
                    
                    if Character and Character:IsDescendantOf(workspace) and PrimaryPart and PrimaryPart:IsDescendantOf(Character) then
                        if PrimaryPart.AssemblyAngularVelocity.Magnitude > 50 or PrimaryPart.AssemblyLinearVelocity.Magnitude > 100 then
                            if Detected == false then
                                game:GetService("StarterGui"):SetCore("ChatMakeSystemMessage", {
                                    Text = "Fling Exploit Detected Player : "..tostring(Player),
                                    Color = Color3.fromRGB(255, 200, 0)
                                })
                            end
                            Detected = true
                            for i,v in ipairs(Character:GetDescendants()) do
                                if v:IsA("BasePart") then
                                    v.CanCollide = false
                                    v.AssemblyAngularVelocity = Vector3.new(0, 0, 0)
                                    v.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
                                    v.CustomPhysicalProperties = PhysicalProperties.new(0, 0, 0)
                                end
                            end
                            PrimaryPart.CanCollide = false
                            PrimaryPart.AssemblyAngularVelocity = Vector3.new(0, 0, 0)
                            PrimaryPart.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
                            PrimaryPart.CustomPhysicalProperties = PhysicalProperties.new(0, 0, 0)
                        end
                    end
                end)
                table.insert(_G.flyOffConnections, heartbeatConn)
            end

            for i,v in ipairs(Services.Players:GetPlayers()) do
                if v ~= LocalPlayer then
                    PlayerAdded(v)
                end
            end
            
            local playerAddedConn = Services.Players.PlayerAdded:Connect(PlayerAdded)
            table.insert(_G.flyOffConnections, playerAddedConn)

            WindUI:Notify({
                Title = "通知",
                Content = "防甩飞功能已启用",
                Duration = 3,
                Icon = "layout-grid",
            })
        else
            _G.flyOffEnabled = false
            if _G.flyOffConnections then
                for _, conn in ipairs(_G.flyOffConnections) do
                    if conn then
                        conn:Disconnect()
                    end
                end
                _G.flyOffConnections = {}
            end
            
            WindUI:Notify({
                Title = "通知",
                Content = "防甩飞功能已禁用",
                Duration = 3,
                Icon = "layout-grid",
            })
        end
    end
})

-- 飞行按钮
local flyButton = TabHandles.Elements:Button({
    Title = "飞行",
    Icon = "bell",
    Callback = function()
        local success, result = pcall(function()
            loadstring(game:HttpGet('https://raw.githubusercontent.com/QiuShan-UX/UnicoX/main/%E9%A3%9E%E8%A1%8C%E7%A4%BA%E4%BE%8B.lua', true))()
        end)
        
        if success then
            WindUI:Notify({
                Title = "飞行已启用",
                Content = "飞行功能已加载",
                Icon = "check",
                Duration = 3
            })
        else
            WindUI:Notify({
                Title = "飞行加载失败",
                Content = "请检查网络连接",
                Icon = "x",
                Duration = 3
            })
        end
    end
})

-- 穿墙
local noclipToggle = TabHandles.Elements:Toggle({
    Title = "启用穿墙",
    Desc = "穿墙模式",
    Value = false,
    Callback = function(v)
        if v then
            _G.Noclip = true
            if _G.NoclipConnection then
                _G.NoclipConnection:Disconnect()
                _G.NoclipConnection = nil
            end
            _G.NoclipConnection = game:GetService("RunService").Stepped:Connect(function()
                if _G.Noclip then
                    local character = game.Players.LocalPlayer.Character
                    if character then
                        for _, part in pairs(character:GetChildren()) do
                            if part:IsA("BasePart") then
                                part.CanCollide = false
                            end
                        end
                    end
                end
            end)
        else
            _G.Noclip = false
            if _G.NoclipConnection then
                _G.NoclipConnection:Disconnect()
                _G.NoclipConnection = nil
            end
        end
    end
})

-- 夜视
local nightVisionToggle = TabHandles.Elements:Toggle({
    Title = "启用夜视",
    Desc = "夜视模式",
    Value = false,
    Callback = function(v)
        local Lighting = game:GetService("Lighting")
        if v then
            _G.originalAmbient = Lighting.Ambient
            _G.originalOutdoorAmbient = Lighting.OutdoorAmbient
            Lighting.Ambient = Color3.new(1, 1, 1)
            Lighting.OutdoorAmbient = Color3.new(1, 1, 1)
        else
            if _G.originalAmbient then
                Lighting.Ambient = _G.originalAmbient
                _G.originalAmbient = nil
            else
                Lighting.Ambient = Color3.new(0, 0, 0)
            end
            
            if _G.originalOutdoorAmbient then
                Lighting.OutdoorAmbient = _G.originalOutdoorAmbient
                _G.originalOutdoorAmbient = nil
            else
                Lighting.OutdoorAmbient = Color3.new(0, 0, 0)
            end
        end
    end
})

-- 无限跳
local infiniteJumpToggle = TabHandles.Elements:Toggle({
    Title = "启用无限跳",
    Desc = "无限跳跃",
    Value = false,
    Callback = function(v)
        _G.InfiniteJumpEnabled = v
        
        if _G.InfiniteJumpConnection then
            _G.InfiniteJumpConnection:Disconnect()
            _G.InfiniteJumpConnection = nil
        end
        
        if v then
            _G.InfiniteJumpConnection = game:GetService("UserInputService").JumpRequest:Connect(function()
                if _G.InfiniteJumpEnabled then
                    local player = game.Players.LocalPlayer
                    local character = player.Character
                    if character then
                        local humanoid = character:FindFirstChildOfClass("Humanoid")
                        if humanoid then
                            humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
                        end
                    end
                end
            end)
        end
    end
})

-- 无敌
local godModeToggle = TabHandles.Elements:Toggle({
    Title = "启用无敌",
    Desc = "无敌模式（小概率bug）",
    Value = false,
    Callback = function(v)
        if v then
            local character = game.Players.LocalPlayer.Character
            if character then
                local humanoid = character:FindFirstChildOfClass("Humanoid")
                if humanoid then
                    _G.originalMaxHealth = humanoid.MaxHealth
                    _G.originalHealth = humanoid.Health
                    humanoid.MaxHealth = 9e9
                    humanoid.Health = 9e9
                end
            end
        else
            if _G.originalMaxHealth then
                local character = game.Players.LocalPlayer.Character
                if character then
                    local humanoid = character:FindFirstChildOfClass("Humanoid")
                    if humanoid then
                        humanoid.MaxHealth = _G.originalMaxHealth
                        humanoid.Health = math.min(_G.originalHealth or 100, _G.originalMaxHealth)
                    end
                end
                _G.originalMaxHealth = nil
                _G.originalHealth = nil
            end
        end
    end
})

-- 自杀按钮
local KillButton = TabHandles.Elements:Button({
    Title = "自杀",
    Icon = "bell",
    Callback = function()
        local character = game.Players.LocalPlayer.Character
        if character then
            local humanoid = character:FindFirstChildOfClass("Humanoid")
            if humanoid then
                humanoid.Health = 0
            end
        end
        WindUI:Notify({
            Title = "已自杀",
            Content = "角色已死亡",
            Icon = "bell",
            Duration = 3
        })
    end
})

-- FPS显示
local fpsToggle = TabHandles.Elements:Toggle({
    Title = "显示FPS",
    Desc = "显示实时帧率",
    Value = false,
    Callback = function(v)
        if v then
            _G.f = Instance.new("ScreenGui", game.Players.LocalPlayer.PlayerGui)
            local t = Instance.new("TextLabel", _G.f)
            _G.f.Name = "FPS"
            t.Size = UDim2.new(0, 100, 0, 50)
            t.Position = UDim2.new(0, 10, 0, 10)
            t.BackgroundTransparency = 1
            t.TextColor3 = Color3.new(1, 1, 1)
            t.TextSize = 20
            local l = 0
            _G.c = game:GetService("RunService").RenderStepped:Connect(function(d)
                l = l + d
                if l >= 0.8 then
                    t.Text = "FPS: " .. math.floor(1 / d)
                    l = 0
                end
            end)
        else
            if _G.f then _G.f:Destroy() _G.f = nil end
            if _G.c then _G.c:Disconnect() _G.c = nil end
            WindUI:Notify({
                Title = "FPS显示",
                Content = "FPS显示已禁用",
                Duration = 2
            })
        end
    end
})

-- 外观设置
TabHandles.Appearance:Paragraph({
    Title = "自定义界面",
    Desc = "个性化你的体验",
    Image = "palette",
    ImageSize = 20,
    Color = "White"
})

local themes = {}
local themeList = WindUI:GetThemes()
if themeList then
    for themeName, _ in pairs(themeList) do
        table.insert(themes, themeName)
    end
end
table.sort(themes)

if #themes == 0 then
    themes = {"Dark", "Light"}
end

local canchangetheme = true
local canchangedropdown = true

local themeDropdown = TabHandles.Appearance:Dropdown({
    Title = "选择主题",
    Values = themes,
    Value = "Dark",
    Callback = function(theme)
        canchangedropdown = false
        WindUI:SetTheme(theme)
        WindUI:Notify({
            Title = "主题已应用",
            Content = theme,
            Icon = "palette",
            Duration = 2
        })
        canchangedropdown = true
    end
})

local transparencySlider = TabHandles.Appearance:Slider({
    Title = "窗口透明度",
    Value = { Min = 0, Max = 1, Default = 0.2 },
    Step = 0.1,
    Callback = function(value)
        WindUI.TransparencyValue = tonumber(value)
        Window:ToggleTransparency(tonumber(value) > 0)
    end
})

local ThemeToggle = TabHandles.Appearance:Toggle({
    Title = "启用深色模式",
    Desc = "使用深色配色方案",
    Value = true,
    Callback = function(v)
        if canchangetheme then
            WindUI:SetTheme(v and "Dark" or "Light")
        end
        if canchangedropdown then
            themeDropdown:Select(v and "Dark" or "Light")
        end
    end
})

WindUI:OnThemeChange(function(theme)
    canchangetheme = false
    if ThemeToggle and ThemeToggle.Set then
        ThemeToggle:Set(theme == "Dark")
    end
    canchangetheme = true
end)


TabHandles.LiJian:Divider()

-- FE脚本
local zhangsihaoTButton = TabHandles.LiJian:Button({
    Title = "FE翻墙",
    Icon = "play",
    Callback = function()
        local success, result = pcall(function()
            loadstring(game:HttpGet('https://raw.githubusercontent.com/ScpGuest666/Random-Roblox-script/refs/heads/main/Roblox%20WallHop%20V4%20script', true))()
        end)
        
        if success then
            WindUI:Notify({
                Title = "已启用",
                Content = "FE翻墙脚本",
                Icon = "star",
                Duration = 3
            })
        else
            WindUI:Notify({
                Title = "加载失败",
                Content = "请检查网络连接",
                Icon = "x",
                Duration = 3
            })
        end
    end
})

local xingxingButton = TabHandles.LiJian:Button({
    Title = "FE爬行",
    Icon = "crown",
    Callback = function()
        local success, result = pcall(function()
            loadstring(game:HttpGet('https://raw.githubusercontent.com/0Ben1/fe/main/obf_vZDX8j5ggfAf58QhdJ59BVEmF6nmZgq4Mcjt2l8wn16CiStIW2P6EkNc605qv9K4.lua.txt', true))()
        end)
        
        if success then
            WindUI:Notify({
                Title = "已启用",
                Content = "FE爬行脚本",
                Icon = "star",
                Duration = 3
            })
        else
            WindUI:Notify({
                Title = "加载失败",
                Content = "请检查网络连接",
                Icon = "x",
                Duration = 3
            })
        end
    end
})

local KillerButton = TabHandles.LiJian:Button({
    Title = "FE杀手",
    Icon = "play",
    Callback = function()
        local success, result = pcall(function()
            loadstring(game:HttpGet('https://pastefy.ga/d7sogwNS/raw', true))()
        end)
        
        if success then
            WindUI:Notify({
                Title = "已启用",
                Content = "FE杀手脚本",
                Icon = "star",
                Duration = 3
            })
        else
            WindUI:Notify({
                Title = "加载失败",
                Content = "请检查网络连接",
                Icon = "x",
                Duration = 3
            })
        end
    end
})

local yinshenToggle = TabHandles.LiJian:Toggle({
    Title = "FE R15隐身",
    Desc = "R15隐身功能",
    Value = false,
    Callback = function(v)
        if v then
            local removeNametags = false

            local plr = game:GetService("Players").LocalPlayer
            local character = plr.Character
            if not character then return end
            
            local hrp = character:FindFirstChild("HumanoidRootPart")
            if not hrp then return end
            
            local old = hrp.CFrame

            if not character:FindFirstChild("LowerTorso") or character.PrimaryPart ~= hrp then
                WindUI:Notify({
                    Title = "FE隐身",
                    Content = "不支持非R15角色",
                    Duration = 3
                })
                return
            end

            if removeNametags then
                local tag = hrp:FindFirstChildOfClass("BillboardGui")
                if tag then tag:Destroy() end

                hrp.ChildAdded:Connect(function(item)
                    if item:IsA("BillboardGui") then
                        task.wait()
                        item:Destroy()
                    end
                end)
            end

            local newroot = character.LowerTorso.Root:Clone()
            hrp.Parent = workspace
            character.PrimaryPart = hrp
            character:MoveTo(Vector3.new(old.X, 9e9, old.Z))
            hrp.Parent = character
            task.wait(0.5)
            newroot.Parent = hrp
            hrp.CFrame = old
            
            WindUI:Notify({
                Title = "FE隐身",
                Content = "R15隐身已启用",
                Duration = 3
            })
        else
            WindUI:Notify({
                Title = "FE隐身",
                Content = "R15隐身已禁用",
                Duration = 3
            })
        end
    end
})

local lijianButton = TabHandles.LiJian:Button({
    Title = "FE踢",
    Icon = "play",
    Callback = function()
        local success, result = pcall(function()
            loadstring(game:HttpGet('https://raw.githubusercontent.com/ZhenX21/FE-Kick-Ban-Script/main/source', true))()
        end)
        
        if success then
            WindUI:Notify({
                Title = "已启用",
                Content = "FE踢脚本",
                Icon = "star",
                Duration = 3
            })
        else
            WindUI:Notify({
                Title = "加载失败",
                Content = "请检查网络连接",
                Icon = "x",
                Duration = 3
            })
        end
    end
})

local XiAOButton = TabHandles.LiJian:Button({
    Title = "FE闪回",
    Icon = "play",
    Callback = function()
        local success, result = pcall(function()
            loadstring(game:HttpGet('https://mscripts.vercel.app/scfiles/reverse-script.lua', true))()
        end)
        
        if success then
            WindUI:Notify({
                Title = "已启用",
                Content = "FE闪回脚本",
                Icon = "star",
                Duration = 3
            })
        else
            WindUI:Notify({
                Title = "加载失败",
                Content = "请检查网络连接",
                Icon = "x",
                Duration = 3
            })
        end
    end
})

local FEButton = TabHandles.LiJian:Button({
    Title = "FE被遗弃角色",
    Icon = "play",
    Callback = function()
        local success, result = pcall(function()
            loadstring(game:HttpGet('https://raw.githubusercontent.com/CyberNinja103/brodwa/refs/heads/main/ForsakationHub', true))()
        end)
        
        if success then
            WindUI:Notify({
                Title = "已启用",
                Content = "FE被遗弃角色脚本",
                Icon = "star",
                Duration = 3
            })
        else
            WindUI:Notify({
                Title = "加载失败",
                Content = "请检查网络连接",
                Icon = "x",
                Duration = 3
            })
        end
    end
})

-- 脚本工具
local DexVButton = TabHandles.XiaoXu:Button({
    Title = "DexV3 无汉化",
    Icon = "play",
    Callback = function()
        local success, result = pcall(function()
            loadstring(game:HttpGet('https://raw.githubusercontent.com/Babyhamsta/RBLX_Scripts/main/Universal/BypassedDarkDexV3.lua', true))()
        end)
        
        if success then
            WindUI:Notify({
                Title = "已启用",
                Content = "Dex",
                Icon = "star",
                Duration = 3
            })
        else
            WindUI:Notify({
                Title = "加载失败",
                Content = "请检查网络连接",
                Icon = "x",
                Duration = 3
            })
        end
    end
})

local dexButton = TabHandles.XiaoXu:Button({
    Title = "汉化Dex",
    Icon = "play",
    Callback = function()
        local success, result = pcall(function()
            loadstring(game:HttpGet('https://raw.githubusercontent.com/Xingyan777/roblox/refs/heads/main/bex.lua', true))()
        end)
        
        if success then
            WindUI:Notify({
                Title = "已启用",
                Content = "汉化Dex",
                Icon = "star",
                Duration = 3
            })
        else
            WindUI:Notify({
                Title = "加载失败",
                Content = "请检查网络连接",
                Icon = "x",
                Duration = 3
            })
        end
    end
})

local CnButton = TabHandles.XiaoXu:Button({
    Title = "汉化spy",
    Icon = "star",
    Callback = function()
        local success, result = pcall(function()
            loadstring(game:HttpGet('https://raw.githubusercontent.com/Finaloutcome/plz/refs/heads/main/sp3hu.lua', true))()
        end)
        
        if success then
            WindUI:Notify({
                Title = "已启用",
                Content = "汉化spy",
                Icon = "star",
                Duration = 3
            })
        else
            WindUI:Notify({
                Title = "加载失败",
                Content = "请检查网络连接",
                Icon = "x",
                Duration = 3
            })
        end
    end
})

local BSspyButton = TabHandles.XiaoXu:Button({
    Title = "抓包https spy",
    Icon = "moon",
    Callback = function()
        local success, result = pcall(function()
            loadstring(game:HttpGet('https://raw.githubusercontent.com/BS58dL/BS/refs/heads/main/请多多支持BS脚本系列.Lua', true))()
        end)
        
        if success then
            WindUI:Notify({
                Title = "已启用",
                Content = "抓包https spy",
                Icon = "star",
                Duration = 3
            })
        else
            WindUI:Notify({
                Title = "加载失败",
                Content = "请检查网络连接",
                Icon = "x",
                Duration = 3
            })
        end
    end
})

local spyButton = TabHandles.XiaoXu:Button({
    Title = "汉化spy2",
    Icon = "zap",
    Callback = function()
        local success, result = pcall(function()
            loadstring(game:HttpGet('https://raw.githubusercontent.com/xiaopi77/xiaopi77/refs/heads/main/spy%E6%B1%89%E5%8C%96%20(1).txt', true))()
        end)
        
        if success then
            WindUI:Notify({
                Title = "已启用",
                Content = "汉化spy2",
                Icon = "star",
                Duration = 3
            })
        else
            WindUI:Notify({
                Title = "加载失败",
                Content = "请检查网络连接",
                Icon = "x",
                Duration = 3
            })
        end
    end
})

TabHandles.Pharaoh:Paragraph({
    Title = "esp/透视功能",
    Desc = "不太完善请见谅",
    Image = "component",
    ImageSize = 20,
    Color = Color3.fromHex("#30ff6a"),
})

TabHandles.Pharaoh:Divider()

local GaoLiangToggle = TabHandles.Pharaoh:Toggle({
    Title = "高亮透视",
    Desc = "圆圈高亮",
    Value = false,
    Callback = function(enabled)   
        for _, player in pairs(game.Players:GetPlayers()) do
            if player ~= game.Players.LocalPlayer then
                if enabled then
                    if player.Character then
                        local highlight = Instance.new("Highlight")
                        highlight.Parent = player.Character
                        highlight.Adornee = player.Character
                        local billboardGui = Instance.new("BillboardGui")
                        billboardGui.Parent = player.Character
                        billboardGui.Adornee = player.Character
                        billboardGui.Size = UDim2.new(0, 100, 0, 100)
                        billboardGui.StudsOffset = Vector3.new(0, 3, 0)
                        billboardGui.AlwaysOnTop = true
                        local textLabel = Instance.new("TextLabel")
                        textLabel.Parent = billboardGui
                        textLabel.Size = UDim2.new(1, 0, 1, 0)
                        textLabel.BackgroundTransparency = 1
                        textLabel.Text = player.Name
                        textLabel.TextColor3 = Color3.new(1, 1, 1)
                        textLabel.TextStrokeTransparency = 0.5
                        textLabel.TextScaled = true
                        local imageLabel = Instance.new("ImageLabel")
                        imageLabel.Parent = billboardGui
                        imageLabel.Size = UDim2.new(0, 50, 0, 50)
                        imageLabel.Position = UDim2.new(0.5, 0, 0.5, 0)
                        imageLabel.AnchorPoint = Vector2.new(0.5, 0.5)
                        imageLabel.BackgroundTransparency = 1
                        imageLabel.Image = "rbxassetid://2200552246"
                    end
                else
                    if player.Character then
                        if player.Character:FindFirstChildOfClass("Highlight") then
                            player.Character:FindFirstChildOfClass("Highlight"):Destroy()
                        end
                        if player.Character:FindFirstChildOfClass("BillboardGui") then
                            player.Character:FindFirstChildOfClass("BillboardGui"):Destroy()
                        end
                    end
                end
            end
        end
    end
})

-- ===== ESP 功能 =====
TabHandles.Pharaoh:Divider()

-- ESP 总开关
local espEnabled = false
local espConnections = {}
local espObjects = {}

local function clearESP()
    for playerName, data in pairs(espObjects) do
        if data.box then pcall(function() data.box:Destroy() end) end
        if data.nameTag then pcall(function() data.nameTag:Destroy() end) end
    end
    espObjects = {}
    for _, conn in ipairs(espConnections) do
        pcall(function() conn:Disconnect() end)
    end
    espConnections = {}
end

local function createESPForCharacter(player, character)
    if not character or not espEnabled then return end
    
    if espObjects[player.Name] then
        if espObjects[player.Name].box then pcall(function() espObjects[player.Name].box:Destroy() end) end
        if espObjects[player.Name].nameTag then pcall(function() espObjects[player.Name].nameTag:Destroy() end) end
    end

    local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    if not humanoidRootPart or not humanoid or humanoid.Health <= 0 then return end

    local localPlayer = game:GetService("Players").LocalPlayer
    local isTeammate = false
    if localPlayer.Team and player.Team and localPlayer.Team == player.Team then
        isTeammate = true
    end

    local boxColor = Color3.fromRGB(255, 255, 255)
    if isTeammate then
        boxColor = Color3.fromRGB(0, 255, 0)
    elseif player ~= localPlayer then
        boxColor = Color3.fromRGB(255, 0, 0)
    end

    local box = Instance.new("BoxHandleAdornment")
    box.Adornee = humanoidRootPart
    box.AlwaysOnTop = true
    box.ZIndex = 10
    local size = character:GetExtentsSize() + Vector3.new(0.5, 0.5, 0.5) 
    box.Size = size
    box.Color3 = boxColor
    box.Transparency = 0.7
    box.Parent = humanoidRootPart

    local billboard = Instance.new("BillboardGui")
    billboard.Adornee = humanoidRootPart
    billboard.Size = UDim2.new(0, 200, 0, 50)
    billboard.StudsOffset = Vector3.new(0, size.Y/2 + 1, 0)
    billboard.AlwaysOnTop = true
    billboard.Parent = humanoidRootPart

    local nameLabel = Instance.new("TextLabel")
    nameLabel.Parent = billboard
    nameLabel.BackgroundTransparency = 1
    nameLabel.Size = UDim2.new(1, 0, 1, 0)
    nameLabel.Text = player.Name
    nameLabel.TextColor3 = boxColor
    nameLabel.TextStrokeTransparency = 0.3
    nameLabel.TextStrokeColor3 = Color3.new(0, 0, 0)
    nameLabel.Font = Enum.Font.SourceSansBold
    nameLabel.TextScaled = true

    espObjects[player.Name] = {
        box = box,
        nameTag = billboard
    }
end

local function setupESP()
    clearESP()
    if not espEnabled then return end

    local Players = game:GetService("Players")
    local localPlayer = Players.LocalPlayer

    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= localPlayer then
            if player.Character then
                createESPForCharacter(player, player.Character)
            end
        end
    end

    local playerAddedConn = Players.PlayerAdded:Connect(function(player)
        if player ~= localPlayer then
            local charConn
            charConn = player.CharacterAdded:Connect(function(character)
                if espEnabled then
                    task.wait(1)
                    createESPForCharacter(player, character)
                end
                if charConn then charConn:Disconnect() end
            end)
            table.insert(espConnections, charConn)
        end
    end)
    table.insert(espConnections, playerAddedConn)

    local characterRemovingConn = Players.CharacterRemoving:Connect(function(player)
        if espObjects[player.Name] then
            if espObjects[player.Name].box then pcall(function() espObjects[player.Name].box:Destroy() end) end
            if espObjects[player.Name].nameTag then pcall(function() espObjects[player.Name].nameTag:Destroy() end) end
            espObjects[player.Name] = nil
        end
    end)
    table.insert(espConnections, characterRemovingConn)
end

local espToggle = TabHandles.Pharaoh:Toggle({
    Title = "启用ESP",
    Desc = "显示玩家方框和名字 (白:默认 绿:队友 红:敌人)",
    Value = false,
    Callback = function(state)
        espEnabled = state
        if state then
            setupESP()
            WindUI:Notify({
                Title = "ESP已启用",
                Content = "默认白色 | 队友绿色 | 敌人红色",
                Icon = "eye",
                Duration = 2
            })
        else
            clearESP()
            WindUI:Notify({
                Title = "ESP已禁用",
                Content = "所有ESP已隐藏",
                Icon = "eye-off",
                Duration = 2
            })
        end
    end
})

TabHandles.Pharaoh:Button({
    Title = "刷新ESP",
    Icon = "refresh-cw",
    Callback = function()
        if espEnabled then
            setupESP()
            WindUI:Notify({
                Title = "ESP已刷新",
                Content = "重新生成了所有ESP",
                Duration = 1.5
            })
        else
            WindUI:Notify({
                Title = "ESP未启用",
                Content = "请先打开ESP开关",
                Icon = "alert-circle",
                Duration = 2
            })
        end
    end
})

local NightButton = TabHandles.LTY:Button({
    Title = "森林中的99夜",
    Icon = "crown",
    Callback = function()
        local success, result = pcall(function()
            loadstring(game:HttpGet('https://raw.githubusercontent.com/XiaoXuCynic/OldWinter-XiaoXu-TheBigWave-Guild/refs/heads/main/TBW%2099Night99%E5%A4%9C.lua', true))()
        end)
        
        if success then
            WindUI:Notify({
                Title = "已启用",
                Content = "森林中的99夜",
                Icon = "star",
                Duration = 3
            })
        else
            WindUI:Notify({
                Title = "加载失败",
                Content = "请检查网络连接",
                Icon = "x",
                Duration = 3
            })
        end
    end
})

local UnityButton = TabHandles.LTY:Button({
    Title = "无尽现实",
    Icon = "bell",
    Callback = function()
        local success, result = pcall(function()
            loadstring(game:HttpGet("https://raw.githubusercontent.com/XiaoXuCynic/Old-Winter-Script/refs/heads/main/TBW%20Endless%20reality%E6%97%A0%E5%B0%BD%E7%8E%B0%E5%AE%9E.lua", true))()
        end)
        
        if success then
            WindUI:Notify({
                Title = "已启用",
                Content = "无尽现实",
                Icon = "bell",
                Duration = 3
            })
        else
            WindUI:Notify({
                Title = "加载失败",
                Content = "请检查网络连接",
                Icon = "x",
                Duration = 3
            })
        end
    end
})

local DoorsButton = TabHandles.LTY:Button({
    Title = "doors",
    Icon = "bell",
    Callback = function()
        local success, result = pcall(function()
            loadstring(game:HttpGet("https://raw.githubusercontent.com/XiaoXuCynic/OldWinter-XiaoXu-TheBigWave-Guild/refs/heads/main/TBWDoors.lua", true))()
        end)
        
        if success then
            WindUI:Notify({
                Title = "已启用",
                Content = "Doors",
                Icon = "bell",
                Duration = 3
            })
        else
            WindUI:Notify({
                Title = "加载失败",
                Content = "请检查网络连接",
                Icon = "x",
                Duration = 3
            })
        end
    end
})

local EvadeButton = TabHandles.LTY:Button({
    Title = "躲避",
    Icon = "bell",
    Callback = function()
        local success, result = pcall(function()
            loadstring(game:HttpGet("https://raw.githubusercontent.com/XiaoXuCynic/Old-Winter-Script/refs/heads/main/TBW%20Evade%20%E8%BA%B2%E9%81%BF.lua", true))()
        end)
        
        if success then
            WindUI:Notify({
                Title = "已启用",
                Content = "躲避",
                Icon = "bell",
                Duration = 3
            })
        else
            WindUI:Notify({
                Title = "加载失败",
                Content = "请检查网络连接",
                Icon = "x",
                Duration = 3
            })
        end
    end
})

local hanbaoButton = TabHandles.LTY:Button({
    Title = "紧急汉堡",
    Icon = "bell",
    Callback = function()
        local success, result = pcall(function()
            loadstring(game:HttpGet("https://raw.githubusercontent.com/XiaoXuCynic/Old-Winter-Script/refs/heads/main/TBW%20Emergency%20Burger%E7%B4%A7%E6%80%A5%E6%B1%89%E5%A0%A1.lua", true))()
        end)
        
        if success then
            WindUI:Notify({
                Title = "已启用",
                Content = "紧急汉堡",
                Icon = "bell",
                Duration = 3
            })
        else
            WindUI:Notify({
                Title = "加载失败",
                Content = "请检查网络连接",
                Icon = "x",
                Duration = 3
            })
        end
    end
})

local KButton = TabHandles.LTY:Button({
    Title = "超市生活7天",
    Icon = "bell",
    Callback = function()
        local success, result = pcall(function()
            loadstring(game:HttpGet("https://raw.githubusercontent.com/XiaoXuCynic/OldWinter-XiaoXu-TheBigWave-Guild/refs/heads/main/TBW%20Live%20for%20seven%20days%E5%9C%A8%E8%B6%85%E5%B8%82%E7%94%9F%E5%AD%98%E4%B8%83%E5%A4%A9.lua", true))()
        end)
        
        if success then
            WindUI:Notify({
                Title = "已启用",
                Content = "超市生活7Day",
                Icon = "bell",
                Duration = 3
            })
        else
            WindUI:Notify({
                Title = "加载失败",
                Content = "请检查网络连接",
                Icon = "x",
                Duration = 3
            })
        end
    end
})

local UButton = TabHandles.LTY:Button({
    Title = "停电",
    Icon = "bell",
    Callback = function()
        local success, result = pcall(function()
            loadstring(game:HttpGet('https://raw.githubusercontent.com/XiaoXuCynic/OldWinter-XiaoXu-TheBigWave-Guild/refs/heads/main/TBW%20Power%20failure%E5%81%9C%E7%94%B5.lua', true))()
        end)
        
        if success then
            WindUI:Notify({
                Title = "已启用",
                Content = "停电",
                Icon = "bell",
                Duration = 3
            })
        else
            WindUI:Notify({
                Title = "加载失败",
                Content = "请检查网络连接",
                Icon = "x",
                Duration = 3
            })
        end
    end
})

local KurakiButton = TabHandles.LTY:Button({
    Title = "墨水游戏",
    Icon = "bell",
    Callback = function()
        local success, result = pcall(function()
            loadstring(game:HttpGet("https://raw.githubusercontent.com/XiaoXuCynic/OldWinter-XiaoXu-TheBigWave-Guild/refs/heads/main/TBW%20Ink%20Game%E5%A2%A8%E6%B0%B4%E6%B8%B8%E6%88%8F.lua", true))()
        end)
        
        if success then
            WindUI:Notify({
                Title = "已启用",
                Content = "墨水游戏",
                Icon = "bell",
                Duration = 3
            })
        else
            WindUI:Notify({
                Title = "加载失败",
                Content = "请检查网络连接",
                Icon = "x",
                Duration = 3
            })
        end
    end
})

local ForButton = TabHandles.LTY:Button({
    Title = "被遗弃",
    Icon = "bell",
    Callback = function()
        local success, result = pcall(function()
            loadstring(game:HttpGet('https://raw.githubusercontent.com/XiaoXuCynic/Old-Winter-Script/refs/heads/main/Forsaken.lua', true))()
        end)
        
        if success then
            WindUI:Notify({
                Title = "已启用",
                Content = "被遗弃",
                Icon = "bell",
                Duration = 3
            })
        else
            WindUI:Notify({
                Title = "加载失败",
                Content = "请检查网络连接",
                Icon = "x",
                Duration = 3
            })
        end
    end
})

local tsbButton = TabHandles.LTY:Button({
    Title = "最强战场",
    Icon = "bell",
    Callback = function()
        local success, result = pcall(function()
            loadstring(game:HttpGet('https://raw.githubusercontent.com/XiaoXuCynic/OldWinter-XiaoXu-TheBigWave-Guild/refs/heads/main/TBW%20The%20strongest%20battlefield%20%E6%9C%80%E5%BC%BA%E6%88%98%E5%9C%BA.lua', true))()
        end)
        
        if success then
            WindUI:Notify({
                Title = "已启用",
                Content = "最强战场",
                Icon = "bell",
                Duration = 3
            })
        else
            WindUI:Notify({
                Title = "加载失败",
                Content = "请检查网络连接",
                Icon = "x",
                Duration = 3
            })
        end
    end
})

local piguButton = TabHandles.LTY:Button({
    Title = "暴力区",
    Icon = "bell",
    Callback = function()
        local success, result = pcall(function()
            loadstring(game:HttpGet('https://raw.githubusercontent.com/XiaoXuCynic/OldWinter-XiaoXu-TheBigWave-Guild/refs/heads/main/TBW%20Violent%20Zone%E6%9A%B4%E5%8A%9B%E5%8C%BA.lua', true))()
        end)
        
        if success then
            WindUI:Notify({
                Title = "已启用",
                Content = "暴力区",
                Icon = "bell",
                Duration = 3
            })
        else
            WindUI:Notify({
                Title = "加载失败",
                Content = "请检查网络连接",
                Icon = "x",
                Duration = 3
            })
        end
    end
})

local EmotionButton = TabHandles.LTY:Button({
    Title = "恶魔学",
    Icon = "bell",
    Callback = function()
        local success, result = pcall(function()
            loadstring(game:HttpGet("https://raw.githubusercontent.com/XiaoXuCynic/Old-Winter-Script/refs/heads/main/%E6%81%B6%E9%AD%94%E5%AD%A6.lua", true))()
        end)
        
        if success then
            WindUI:Notify({
                Title = "已启用",
                Content = "恶魔学脚本",
                Icon = "bell",
                Duration = 3
            })
        else
            WindUI:Notify({
                Title = "加载失败",
                Content = "请检查网络连接",
                Icon = "x",
                Duration = 3
            })
        end
    end
})

local CButton = TabHandles.LTY:Button({
    Title = "战争大亨",
    Icon = "bell",
    Callback = function()
        local success, result = pcall(function()
            loadstring(game:HttpGet("https://raw.githubusercontent.com/XiaoXuCynic/Old-Winter-Script/refs/heads/main/%E6%88%98%E4%BA%89%E5%A4%A7%E4%BA%A8.lua", true))()
        end)
        
        if success then
            WindUI:Notify({
                Title = "已启用",
                Content = "战争大亨",
                Icon = "bell",
                Duration = 3
            })
        else
            WindUI:Notify({
                Title = "加载失败",
                Content = "请检查网络连接",
                Icon = "x",
                Duration = 3
            })
        end
    end
})

local QButton = TabHandles.LTY:Button({
    Title = "种植花园",
    Icon = "bell",
    Callback = function()
        local success, result = pcall(function()
            loadstring(game:HttpGet('https://raw.githubusercontent.com/XiaoXuCynic/Old-Winter-Script/refs/heads/main/%E7%A7%8D%E6%A4%8D.lua', true))()
        end)
        
        if success then
            WindUI:Notify({
                Title = "已启用",
                Content = "种植花园",
                Icon = "bell",
                Duration = 3
            })
        else
            WindUI:Notify({
                Title = "加载失败",
                Content = "请检查网络连接",
                Icon = "x",
                Duration = 3
            })
        end
    end
})

local WantedButton = TabHandles.LTY:Button({
    Title = "通缉",
    Icon = "bell",
    Callback = function()
        local success, result = pcall(function()
            loadstring(game:HttpGet('https://raw.githubusercontent.com/XiaoXuCynic/Old-Winter-Script/refs/heads/main/TBW%20Wanted%E9%80%9A%E7%BC%89.lua', true))()
        end)
        
        if success then
            WindUI:Notify({
                Title = "已启用",
                Content = "通缉",
                Icon = "bell",
                Duration = 3
            })
        else
            WindUI:Notify({
                Title = "加载失败",
                Content = "请检查网络连接",
                Icon = "x",
                Duration = 3
            })
        end
    end
})

local BreakButton = TabHandles.LTY:Button({
    Title = "力量传奇",
    Icon = "bell",
    Callback = function()
        local success, result = pcall(function()
            loadstring(game:HttpGet('https://raw.githubusercontent.com/XiaoXuCynic/OldWinter-XiaoXu-TheBigWave-Guild/refs/heads/main/TBW%20Legend%20of%20Power%E5%8A%9B%E9%87%8F%E4%BC%A0%E5%A5%87.lua', true))()
        end)
        
        if success then
            WindUI:Notify({
                Title = "已启用",
                Content = "力量传奇",
                Icon = "bell",
                Duration = 3
            })
        else
            WindUI:Notify({
                Title = "加载失败",
                Content = "请检查网络连接",
                Icon = "x",
                Duration = 3
            })
        end
    end
})

local VictoryButton = TabHandles.LTY:Button({
    Title = "模仿者",
    Icon = "bell",
    Callback = function()
        local success, result = pcall(function()
            loadstring(game:HttpGet('https://raw.githubusercontent.com/XiaoXuCynic/OldWinter-XiaoXu-TheBigWave-Guild/refs/heads/main/TBW%20Copycat%E6%A8%A1%E4%BB%BF%E8%80%85.lua', true))()
        end)
        
        if success then
            WindUI:Notify({
                Title = "已启用",
                Content = "模仿者脚本",
                Icon = "bell",
                Duration = 3
            })
        else
            WindUI:Notify({
                Title = "加载失败",
                Content = "请检查网络连接",
                Icon = "x",
                Duration = 3
            })
        end
    end
})

local ABCButton = TabHandles.LTY:Button({
    Title = "死铁轨",
    Icon = "bell",
    Callback = function()
        local success, result = pcall(function()
            loadstring(game:HttpGet('https://raw.githubusercontent.com/XiaoXuCynic/OldWinter-XiaoXu-TheBigWave-Guild/refs/heads/main/TBW%20Dead%20Rail%20%E6%AD%BB%E9%93%81%E8%BD%A8.lua', true))()
        end)
        
        if success then
            WindUI:Notify({
                Title = "已启用",
                Content = "死铁轨",
                Icon = "bell",
                Duration = 3
            })
        else
            WindUI:Notify({
                Title = "加载失败",
                Content = "请检查网络连接",
                Icon = "x",
                Duration = 3
            })
        end
    end
})

local SaiBiButton = TabHandles.LTY:Button({
    Title = "犯罪",
    Icon = "bell",
    Callback = function()
        local success, result = pcall(function()
            loadstring(game:HttpGet('https://raw.githubusercontent.com/XiaoXuCynic/OldWinter-XiaoXu-TheBigWave-Guild/refs/heads/main/TBW%20commit%20%E7%8A%AF%E7%BD%AA.lua', true))()
        end)
        
        if success then
            WindUI:Notify({
                Title = "已启用",
                Content = "犯罪",
                Icon = "sword",
                Duration = 3
            })
        else
            WindUI:Notify({
                Title = "加载失败",
                Content = "请检查网络连接",
                Icon = "x",
                Duration = 3
            })
        end
    end
})

local TnineButton = TabHandles.LTY:Button({
    Title = "凹凸世界",
    Icon = "bell",
    Callback = function()
        local success, result = pcall(function()
            loadstring(game:HttpGet('https://raw.githubusercontent.com/XiaoXuCynic/OldWinter-XiaoXu-TheBigWave-Guild/refs/heads/main/TBW%20Concave-convex%20world%E5%87%B9%E5%87%B8%E4%B8%96%E7%95%8C.lua', true))()
        end)
        
        if success then
            WindUI:Notify({
                Title = "已启用",
                Content = "凹凸世界",
                Icon = "crown",
                Duration = 3
            })
        else
            WindUI:Notify({
                Title = "加载失败",
                Content = "请检查网络连接",
                Icon = "x",
                Duration = 3
            })
        end
    end
})

local OilyButton = TabHandles.LTY:Button({
    Title = "感染微笑",
    Icon = "bell",
    Callback = function()
        local success, result = pcall(function()
            loadstring(game:HttpGet('https://raw.githubusercontent.com/XiaoXuCynic/OldWinter-XiaoXu-TheBigWave-Guild/refs/heads/main/TBW%20Infected%20smile%E6%84%9F%E6%9F%93%E5%BE%AE%E7%AC%91.lua', true))()
        end)
        
        if success then
            WindUI:Notify({
                Title = "已启用",
                Content = "感染微笑",
                Icon = "bell",
                Duration = 3
            })
        else
            WindUI:Notify({
                Title = "加载失败",
                Content = "请检查网络连接",
                Icon = "x",
                Duration = 3
            })
        end
    end
})

local KurakiFlickButton = TabHandles.ZSH:Button({
    Title = "KurakiHub闪光点",
    Icon = "bell",
    Callback = function()
        local success, result = pcall(function()
            loadstring(game:HttpGet('https://raw.githubusercontent.com/lxmyysd/KurakiHub---SUNKEN/refs/heads/main/Flick%20Kuraki%20SunkenBoat.lua', true))()
        end)
        
        if success then
            WindUI:Notify({
                Title = "已启用",
                Content = "闪光点脚本",
                Icon = "bell",
                Duration = 3
            })
        else
            WindUI:Notify({
                Title = "加载失败",
                Content = "请检查网络连接",
                Icon = "x",
                Duration = 3
            })
        end
    end
})

local ZHButton = TabHandles.ZSH:Button({
    Title = "ZH脚本",
    Icon = "bell",
    Callback = function()
        local success, result = pcall(function()
            loadstring(game:HttpGet('https://raw.githubusercontent.com/smalldesikon/ZH/refs/heads/main/ZH%20HUB', true))()
        end)
        
        if success then
            WindUI:Notify({
                Title = "已启用",
                Content = "ZH脚本",
                Icon = "bell",
                Duration = 3
            })
        else
            WindUI:Notify({
                Title = "加载失败",
                Content = "请检查网络连接",
                Icon = "x",
                Duration = 3
            })
        end
    end
})

-- ============================================
-- AimbotTab 自瞄功能
-- ============================================

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer

-- 自瞄配置变量
local aimbotConfig = {
    Enabled = false,
    TeamCheck = true,
    Range = 200,
    CircleSize = 50,
    Transparency = 0.5,
    Smoothness = 0.3,
    AimPart = "Head"
}

local aimCircle = nil
local screenGui = nil
local currentTarget = nil
local renderSteppedConn = nil
local camera = nil

-- 创建瞄准圆圈UI
local function createAimCircle()
    if aimCircle then
        pcall(function() aimCircle:Destroy() end)
        aimCircle = nil
    end
    
    local playerGui = LocalPlayer:FindFirstChild("PlayerGui")
    if not playerGui then return end
    
    screenGui = playerGui:FindFirstChild("AimbotUI")
    if not screenGui then
        screenGui = Instance.new("ScreenGui")
        screenGui.Name = "AimbotUI"
        screenGui.ResetOnSpawn = false
        screenGui.Parent = playerGui
    end
    
    aimCircle = Instance.new("ImageLabel")
    aimCircle.Name = "AimCircle"
    aimCircle.Size = UDim2.new(0, aimbotConfig.CircleSize, 0, aimbotConfig.CircleSize)
    aimCircle.Position = UDim2.new(0.5, -aimbotConfig.CircleSize/2, 0.5, -aimbotConfig.CircleSize/2)
    aimCircle.BackgroundTransparency = 1
    aimCircle.Image = "rbxassetid://160425381"
    aimCircle.ImageColor3 = Color3.fromRGB(255, 0, 0)
    aimCircle.ImageTransparency = aimbotConfig.Transparency
    aimCircle.Visible = aimbotConfig.Enabled
    aimCircle.ZIndex = 999
    aimCircle.Parent = screenGui
end

-- 更新圆圈大小
local function updateCircleSize()
    if aimCircle then
        aimCircle.Size = UDim2.new(0, aimbotConfig.CircleSize, 0, aimbotConfig.CircleSize)
        aimCircle.Position = UDim2.new(0.5, -aimbotConfig.CircleSize/2, 0.5, -aimbotConfig.CircleSize/2)
    end
end

-- 更新圆圈透明度
local function updateCircleTransparency()
    if aimCircle then
        aimCircle.ImageTransparency = aimbotConfig.Transparency
    end
end

-- 更新圆圈可见性
local function updateCircleVisibility()
    if aimCircle then
        aimCircle.Visible = aimbotConfig.Enabled
    end
end

-- 获取有效目标
local function getValidTargets()
    local targets = {}
    local localTeam = LocalPlayer.Team
    
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            if aimbotConfig.TeamCheck and localTeam and player.Team == localTeam then
                goto continue
            end
            
            local character = player.Character
            if not character then goto continue end
            
            local humanoid = character:FindFirstChildOfClass("Humanoid")
            if not humanoid or humanoid.Health <= 0 then goto continue end
            
            local aimPart = character:FindFirstChild(aimbotConfig.AimPart)
            if not aimPart then 
                aimPart = character:FindFirstChild("HumanoidRootPart")
                if not aimPart then goto continue end
            end
            
            table.insert(targets, {
                Player = player,
                Character = character,
                Humanoid = humanoid,
                AimPart = aimPart
            })
        end
        ::continue::
    end
    
    return targets
end

-- 获取屏幕上的目标位置
local function getTargetScreenPosition(aimPart)
    camera = workspace.CurrentCamera
    if not camera then return nil end
    
    local vector, onScreen = camera:WorldToScreenPoint(aimPart.Position)
    if not onScreen then return nil end
    return Vector2.new(vector.X, vector.Y)
end

-- 获取距离屏幕中心最近的目标
local function getClosestTargetToCenter()
    local targets = getValidTargets()
    if #targets == 0 then return nil end
    
    camera = workspace.CurrentCamera
    if not camera then return nil end
    
    local viewportSize = camera.ViewportSize
    local screenCenter = Vector2.new(viewportSize.X / 2, viewportSize.Y / 2)
    
    local bestTarget = nil
    local bestDistance = aimbotConfig.Range
    
    for _, target in ipairs(targets) do
        local screenPos = getTargetScreenPosition(target.AimPart)
        if screenPos then
            local distance = (screenPos - screenCenter).Magnitude
            if distance < bestDistance then
                bestDistance = distance
                bestTarget = target
            end
        end
    end
    
    return bestTarget
end

-- 平滑移动鼠标
local function smoothMoveToTarget(targetPos)
    local currentPos = UserInputService:GetMouseLocation()
    local delta = targetPos - currentPos
    local step = delta * aimbotConfig.Smoothness
    
    if math.abs(step.X) > 0.5 or math.abs(step.Y) > 0.5 then
        local newPos = currentPos + step
        pcall(function()
            UserInputService:SetMouseLocation(math.floor(newPos.X), math.floor(newPos.Y))
        end)
    end
end

-- 自瞄主循环
local function onAimbot()
    if not aimbotConfig.Enabled then return end
    
    local target = getClosestTargetToCenter()
    currentTarget = target
    
    if target and target.AimPart and target.AimPart.Parent then
        local screenPos = getTargetScreenPosition(target.AimPart)
        if screenPos then
            smoothMoveToTarget(screenPos)
        end
    end
end

-- 启动自瞄
local function startAimbot()
    stopAimbot()
    
    if aimbotConfig.Enabled then
        renderSteppedConn = RunService.RenderStepped:Connect(onAimbot)
    end
end

-- 停止自瞄
local function stopAimbot()
    if renderSteppedConn then
        renderSteppedConn:Disconnect()
        renderSteppedConn = nil
    end
    currentTarget = nil
end

-- 设置自瞄开关
local function setAimbotEnabled(enabled)
    aimbotConfig.Enabled = enabled
    
    if enabled then
        startAimbot()
        updateCircleVisibility()
    else
        stopAimbot()
        updateCircleVisibility()
    end
end

-- 设置队伍检测
local function setTeamCheck(enabled)
    aimbotConfig.TeamCheck = enabled
end

-- 设置范围
local function setRange(value)
    aimbotConfig.Range = value
end

-- 设置圆圈大小
local function setCircleSize(value)
    aimbotConfig.CircleSize = value
    updateCircleSize()
end

-- 设置透明度
local function setTransparency(value)
    aimbotConfig.Transparency = value
    updateCircleTransparency()
end

-- 清理自瞄
local function cleanupAimbot()
    stopAimbot()
    aimbotConfig.Enabled = false
    
    if aimCircle then
        pcall(function() aimCircle:Destroy() end)
        aimCircle = nil
    end
    
    if screenGui then
        pcall(function() screenGui:Destroy() end)
        screenGui = nil
    else
        local playerGui = LocalPlayer:FindFirstChild("PlayerGui")
        if playerGui then
            local gui = playerGui:FindFirstChild("AimbotUI")
            if gui then
                pcall(function() gui:Destroy() end)
            end
        end
    end
    
    currentTarget = nil
    camera = nil
end

-- 设置自瞄UI
TabHandles.Real:Divider()

TabHandles.Real:Paragraph({
    Title = "自瞄功能",
    Desc = "持续更新",
    Image = "target",
    ImageSize = 20,
    Color = "White"
})

local AimMasterToggle = TabHandles.Real:Toggle({
    Title = "自瞄总开关",
    Desc = "开启/关闭自瞄",
    Value = false,
    Callback = function(v)
        setAimbotEnabled(v)
        WindUI:Notify({
            Title = "自瞄",
            Content = v and "✅ 已启用" or "❌ 已禁用",
            Icon = v and "target" or "x",
            Duration = 2
        })
    end
})

local TeamdetectionToggle = TabHandles.Real:Toggle({
    Title = "队伍检测",
    Desc = "开启后不会瞄准队友",
    Value = true,
    Callback = function(v)
        setTeamCheck(v)
        WindUI:Notify({
            Title = "队伍检测",
            Content = v and "🔒 已开启(不瞄队友)" or "🔓 已关闭(可瞄队友)",
            Icon = "users",
            Duration = 2
        })
    end
})

local RangeSlider = TabHandles.Real:Slider({
    Title = "自瞄范围",
    Desc = "设置自瞄的有效屏幕距离",
    Value = { Min = 50, Max = 500, Default = 200 },
    Callback = function(value)
        setRange(value)
    end
})

local AimSizeSlider = TabHandles.Real:Slider({
    Title = "圆圈大小",
    Desc = "设置瞄准圈的大小",
    Value = { Min = 20, Max = 150, Default = 50 },
    Callback = function(value)
        setCircleSize(value)
    end
})

local TransparencySlider = TabHandles.Real:Slider({
    Title = "圆圈透明度",
    Desc = "设置瞄准圈的透明度",
    Value = { Min = 0, Max = 1, Default = 0.5 },
    Step = 0.1,
    Callback = function(value)
        setTransparency(value)
    end
})

-- 创建圆圈UI
createAimCircle()

-- ============================================
-- 天空修改脚本
-- ============================================

local Lighting = game:GetService("Lighting")

-- 配置变量
local skyboxEnabled = false
local skyColor = Color3.fromRGB(135, 206, 235)
local ambientColor = Color3.fromRGB(200, 200, 200)
local outdoorAmbient = Color3.fromRGB(150, 150, 150)
local fogEnabled = false
local fogColor = Color3.fromRGB(150, 150, 150)
local fogStart = 0
local fogEnd = 500
local timeOfDay = 14
local brightness = 1
local exposure = 1
local shadowSoftness = 0.5
local starsEnabled = false
local starsSize = 1
local atmosphereEnabled = false
local atmosphereDensity = 0.5
local atmosphereOffset = 0.5
local cloudsEnabled = false
local cloudColor = Color3.fromRGB(255, 255, 255)
local cloudCover = 0.5

-- 内部变量
local starsParticle = nil
local starsConnection = nil
local originalValues = {}

-- 保存原始值
local function saveOriginalValues()
    originalValues.SkyColor = Lighting.SkyColor
    originalValues.Ambient = Lighting.Ambient
    originalValues.OutdoorAmbient = Lighting.OutdoorAmbient
    originalValues.FogEnabled = Lighting.FogEnabled
    originalValues.FogColor = Lighting.FogColor
    originalValues.FogStart = Lighting.FogStart
    originalValues.FogEnd = Lighting.FogEnd
    originalValues.TimeOfDay = Lighting.TimeOfDay
    originalValues.ClockTime = Lighting.ClockTime
    originalValues.Brightness = Lighting.Brightness
    originalValues.Exposure = Lighting.ExposureCompensation
    originalValues.ShadowSoftness = Lighting.ShadowSoftness
    originalValues.Atmosphere = Lighting:FindFirstChild("Atmosphere")
    originalValues.Clouds = Lighting:FindFirstChild("Clouds")
end

-- 应用天空设置
local function applySkyboxSettings()
    if not skyboxEnabled then return end
    
    Lighting.SkyColor = skyColor
    Lighting.Ambient = ambientColor
    Lighting.OutdoorAmbient = outdoorAmbient
    Lighting.Brightness = brightness
    Lighting.ExposureCompensation = exposure
    Lighting.ShadowSoftness = shadowSoftness
    Lighting.TimeOfDay = string.format("%02d:%02d:00", math.floor(timeOfDay), (timeOfDay % 1) * 60)
    Lighting.ClockTime = timeOfDay
    
    Lighting.FogEnabled = fogEnabled
    if fogEnabled then
        Lighting.FogColor = fogColor
        Lighting.FogStart = fogStart
        Lighting.FogEnd = fogEnd
    end
    
    if atmosphereEnabled then
        local atmosphere = Lighting:FindFirstChild("Atmosphere")
        if not atmosphere then
            atmosphere = Instance.new("Atmosphere")
            atmosphere.Parent = Lighting
        end
        atmosphere.Density = atmosphereDensity
        atmosphere.Offset = atmosphereOffset
    end
    
    if cloudsEnabled then
        local clouds = Lighting:FindFirstChild("Clouds")
        if not clouds then
            clouds = Instance.new("Clouds")
            clouds.Parent = Lighting
        end
        clouds.Color = cloudColor
        clouds.Cover = cloudCover
    end
end

-- 重置所有设置
local function resetSkyboxSettings()
    Lighting.SkyColor = originalValues.SkyColor
    Lighting.Ambient = originalValues.Ambient
    Lighting.OutdoorAmbient = originalValues.OutdoorAmbient
    Lighting.FogEnabled = originalValues.FogEnabled
    Lighting.FogColor = originalValues.FogColor
    Lighting.FogStart = originalValues.FogStart
    Lighting.FogEnd = originalValues.FogEnd
    Lighting.TimeOfDay = originalValues.TimeOfDay
    Lighting.ClockTime = originalValues.ClockTime
    Lighting.Brightness = originalValues.Brightness
    Lighting.ExposureCompensation = originalValues.Exposure
    Lighting.ShadowSoftness = originalValues.ShadowSoftness
    
    local atmosphere = Lighting:FindFirstChild("Atmosphere")
    if atmosphere and atmosphere ~= originalValues.Atmosphere then
        atmosphere:Destroy()
    end
    
    local clouds = Lighting:FindFirstChild("Clouds")
    if clouds and clouds ~= originalValues.Clouds then
        clouds:Destroy()
    end
end

-- 星空效果
local function toggleStars(enabled)
    if enabled then
        if starsParticle then return end
        
        local camera = workspace.CurrentCamera
        starsParticle = Instance.new("ParticleEmitter")
        starsParticle.Name = "StarsEffect"
        starsParticle.Texture = "rbxasset://textures/particles/sparkles_main.dds"
        starsParticle.Rate = 200
        starsParticle.Lifetime = NumberRange.new(999999)
        starsParticle.SpreadAngle = Vector2.new(360, 360)
        starsParticle.VelocityInheritance = 0
        starsParticle.Speed = NumberRange.new(0)
        starsParticle.Rotation = NumberRange.new(0, 360)
        starsParticle.RotSpeed = NumberRange.new(0)
        starsParticle.Transparency = NumberSequence.new(0)
        starsParticle.Size = NumberSequence.new(starsSize)
        starsParticle.Color = ColorSequence.new(Color3.fromRGB(255, 255, 255))
        starsParticle.LightEmission = 1
        starsParticle.Enabled = true
        starsParticle.Parent = camera
        
        starsConnection = RunService.RenderStepped:Connect(function()
            if starsParticle and starsParticle.Parent then
                starsParticle.Position = Vector3.new(0, 0, -100)
            end
        end)
    else
        if starsParticle then
            starsParticle:Destroy()
            starsParticle = nil
        end
        if starsConnection then
            starsConnection:Disconnect()
            starsConnection = nil
        end
    end
end

-- 预设效果
local function presetDay()
    skyColor = Color3.fromRGB(135, 206, 235)
    ambientColor = Color3.fromRGB(200, 200, 200)
    outdoorAmbient = Color3.fromRGB(150, 150, 150)
    timeOfDay = 14
    brightness = 1
    exposure = 1
    fogEnabled = false
    atmosphereEnabled = false
    cloudsEnabled = false
    starsEnabled = false
    
    toggleStars(false)
    
    if skyboxEnabled then
        applySkyboxSettings()
    end
end

local function presetNight()
    skyColor = Color3.fromRGB(10, 10, 30)
    ambientColor = Color3.fromRGB(30, 30, 50)
    outdoorAmbient = Color3.fromRGB(20, 20, 40)
    timeOfDay = 0
    brightness = 0.3
    exposure = 0.5
    fogEnabled = true
    fogColor = Color3.fromRGB(20, 20, 40)
    fogStart = 0
    fogEnd = 300
    atmosphereEnabled = true
    atmosphereDensity = 0.3
    atmosphereOffset = 0.2
    starsEnabled = true
    starsSize = 0.5
    cloudsEnabled = false
    
    toggleStars(true)
    
    if skyboxEnabled then
        applySkyboxSettings()
    end
end

local function presetSunset()
    skyColor = Color3.fromRGB(255, 100, 50)
    ambientColor = Color3.fromRGB(255, 150, 100)
    outdoorAmbient = Color3.fromRGB(200, 100, 50)
    timeOfDay = 18
    brightness = 0.8
    exposure = 0.8
    fogEnabled = true
    fogColor = Color3.fromRGB(255, 100, 50)
    fogStart = 0
    fogEnd = 400
    atmosphereEnabled = true
    atmosphereDensity = 0.4
    atmosphereOffset = 0.3
    starsEnabled = false
    cloudsEnabled = false
    
    toggleStars(false)
    
    if skyboxEnabled then
        applySkyboxSettings()
    end
end

local function presetDark()
    skyColor = Color3.fromRGB(0, 0, 0)
    ambientColor = Color3.fromRGB(10, 10, 10)
    outdoorAmbient = Color3.fromRGB(5, 5, 5)
    timeOfDay = 0
    brightness = 0.1
    exposure = 0.2
    fogEnabled = true
    fogColor = Color3.fromRGB(0, 0, 0)
    fogStart = 0
    fogEnd = 200
    atmosphereEnabled = false
    starsEnabled = false
    cloudsEnabled = false
    
    toggleStars(false)
    
    if skyboxEnabled then
        applySkyboxSettings()
    end
end

local function presetDream()
    skyColor = Color3.fromRGB(200, 100, 255)
    ambientColor = Color3.fromRGB(150, 100, 200)
    outdoorAmbient = Color3.fromRGB(120, 80, 180)
    timeOfDay = 15
    brightness = 0.9
    exposure = 0.9
    fogEnabled = true
    fogColor = Color3.fromRGB(150, 100, 200)
    fogStart = 0
    fogEnd = 350
    atmosphereEnabled = true
    atmosphereDensity = 0.6
    atmosphereOffset = 0.4
    cloudsEnabled = true
    cloudColor = Color3.fromRGB(200, 150, 255)
    cloudCover = 0.6
    starsEnabled = false
    
    toggleStars(false)
    
    if skyboxEnabled then
        applySkyboxSettings()
    end
end

-- 天空修改总开关
local function setSkyboxEnabled(enabled)
    skyboxEnabled = enabled
    if enabled then
        applySkyboxSettings()
    else
        resetSkyboxSettings()
    end
end

-- 清理天空
local function cleanupSkybox()
    resetSkyboxSettings()
    toggleStars(false)
    skyboxEnabled = false
end

-- 设置天空UI
TabHandles.Sky:Divider()

TabHandles.Sky:Paragraph({
    Title = "☁️ 天空修改器",
    Desc = "修改游戏天空和环境效果",
    Image = "cloud-sun",
    ImageSize = 20,
    Color = Color3.fromHex("#6A11CB")
})

local skyboxToggle = TabHandles.Sky:Toggle({
    Title = "天空修改总开关",
    Desc = "开启/关闭所有天空修改",
    Value = false,
    Callback = function(v)
        setSkyboxEnabled(v)
        WindUI:Notify({
            Title = "天空修改器",
            Content = v and "✅ 已启用" or "❌ 已禁用",
            Icon = v and "cloud-sun" or "x",
            Duration = 2
        })
    end
})

TabHandles.Sky:Divider()

TabHandles.Sky:Paragraph({
    Title = "快速预设",
    Desc = "一键应用天空效果",
    Image = "palette",
    ImageSize = 18,
    Color = Color3.fromHex("#FF6B6B")
})

local daytimeButton = TabHandles.Sky:Button({
    Title = "白天",
    Icon = "sun",
    Callback = function()
        presetDay()
        skyboxToggle:Set(true)
        setSkyboxEnabled(true)
        WindUI:Notify({
            Title = "预设已应用",
            Content = "白天模式",
            Icon = "sun",
            Duration = 2
        })
    end
})

local nightButton = TabHandles.Sky:Button({
    Title = "夜晚",
    Icon = "moon",
    Callback = function()
        presetNight()
        skyboxToggle:Set(true)
        setSkyboxEnabled(true)
        WindUI:Notify({
            Title = "预设已应用",
            Content = "夜晚模式 (带星空)",
            Icon = "moon",
            Duration = 2
        })
    end
})

local duskButton = TabHandles.Sky:Button({
    Title = "黄昏",
    Icon = "sunset",
    Callback = function()
        presetSunset()
        skyboxToggle:Set(true)
        setSkyboxEnabled(true)
        WindUI:Notify({
            Title = "预设已应用",
            Content = "黄昏模式",
            Icon = "sunset",
            Duration = 2
        })
    end
})

local darkButton = TabHandles.Sky:Button({
    Title = "黑暗",
    Icon = "eye-off",
    Callback = function()
        presetDark()
        skyboxToggle:Set(true)
        setSkyboxEnabled(true)
        WindUI:Notify({
            Title = "预设已应用",
            Content = "黑暗模式",
            Icon = "eye-off",
            Duration = 2
        })
    end
})

local fantasyButton = TabHandles.Sky:Button({
    Title = "梦幻",
    Icon = "sparkles",
    Callback = function()
        presetDream()
        skyboxToggle:Set(true)
        setSkyboxEnabled(true)
        WindUI:Notify({
            Title = "预设已应用",
            Content = "梦幻模式",
            Icon = "sparkles",
            Duration = 2
        })
    end
})

TabHandles.Sky:Divider()

TabHandles.Sky:Paragraph({
    Title = "🎨 颜色设置",
    Desc = "调整天空和环境颜色",
    Image = "droplet",
    ImageSize = 18,
    Color = Color3.fromHex("#4ECDC4")
})

local skyColorPicker = TabHandles.Sky:ColorPicker({
    Title = "天空颜色",
    Desc = "设置天空盒颜色",
    Default = skyColor,
    Callback = function(color)
        skyColor = color
        if skyboxEnabled then
            Lighting.SkyColor = color
        end
    end
})

local ambientColorPicker = TabHandles.Sky:ColorPicker({
    Title = "环境光颜色",
    Desc = "设置环境光照颜色",
    Default = ambientColor,
    Callback = function(color)
        ambientColor = color
        if skyboxEnabled then
            Lighting.Ambient = color
        end
    end
})

TabHandles.Sky:Divider()

TabHandles.Sky:Paragraph({
    Title = "🌫️ 雾效设置",
    Desc = "调整游戏雾效",
    Image = "cloud-fog",
    ImageSize = 18,
    Color = Color3.fromHex("#45B7D1")
})

local fogToggle = TabHandles.Sky:Toggle({
    Title = "启用雾效",
    Desc = "开启/关闭雾效",
    Value = false,
    Callback = function(v)
        fogEnabled = v
        if skyboxEnabled then
            Lighting.FogEnabled = v
        end
    end
})

local fogColorPicker = TabHandles.Sky:ColorPicker({
    Title = "雾效颜色",
    Desc = "设置雾效颜色",
    Default = fogColor,
    Callback = function(color)
        fogColor = color
        if skyboxEnabled and fogEnabled then
            Lighting.FogColor = color
        end
    end
})

local fogStartSlider = TabHandles.Sky:Slider({
    Title = "雾效起始距离",
    Desc = "雾开始出现的距离",
    Value = { Min = 0, Max = 500, Default = 0 },
    Callback = function(value)
        fogStart = value
        if skyboxEnabled and fogEnabled then
            Lighting.FogStart = value
        end
    end
})

local fogEndSlider = TabHandles.Sky:Slider({
    Title = "雾效结束距离",
    Desc = "雾完全覆盖的距离",
    Value = { Min = 100, Max = 1000, Default = 500 },
    Callback = function(value)
        fogEnd = value
        if skyboxEnabled and fogEnabled then
            Lighting.FogEnd = value
        end
    end
})

TabHandles.Sky:Divider()

TabHandles.Sky:Paragraph({
    Title = "⏰ 时间设置",
    Desc = "调整游戏时间和亮度",
    Image = "clock",
    ImageSize = 18,
    Color = Color3.fromHex("#F7B731")
})

local timeSlider = TabHandles.Sky:Slider({
    Title = "时间",
    Desc = "设置游戏内时间 (0h-24h)",
    Value = { Min = 0, Max = 24, Default = 14 },
    Callback = function(value)
        timeOfDay = value
        if skyboxEnabled then
            local hours = math.floor(value)
            local minutes = math.floor((value % 1) * 60)
            Lighting.TimeOfDay = string.format("%02d:%02d:00", hours, minutes)
            Lighting.ClockTime = value
        end
    end
})

local brightnessSlider = TabHandles.Sky:Slider({
    Title = "亮度",
    Desc = "设置游戏亮度",
    Value = { Min = 0, Max = 2, Default = 1 },
    Step = 0.1,
    Callback = function(value)
        brightness = value
        if skyboxEnabled then
            Lighting.Brightness = value
        end
    end
})

local exposureSlider = TabHandles.Sky:Slider({
    Title = "曝光度",
    Desc = "设置相机曝光补偿",
    Value = { Min = 0, Max = 2, Default = 1 },
    Step = 0.1,
    Callback = function(value)
        exposure = value
        if skyboxEnabled then
            Lighting.ExposureCompensation = value
        end
    end
})

local shadowSoftnessSlider = TabHandles.Sky:Slider({
    Title = "阴影柔和度",
    Desc = "设置阴影柔和程度",
    Value = { Min = 0, Max = 1, Default = 0.5 },
    Step = 0.1,
    Callback = function(value)
        shadowSoftness = value
        if skyboxEnabled then
            Lighting.ShadowSoftness = value
        end
    end
})

TabHandles.Sky:Divider()

TabHandles.Sky:Paragraph({
    Title = "✨ 星空效果",
    Desc = "添加动态星空粒子",
    Image = "stars",
    ImageSize = 18,
    Color = Color3.fromHex("#A855F7")
})

local starsToggle = TabHandles.Sky:Toggle({
    Title = "启用星空",
    Desc = "在天空中显示星星粒子",
    Value = false,
    Callback = function(v)
        starsEnabled = v
        toggleStars(v)
    end
})

local starsSizeSlider = TabHandles.Sky:Slider({
    Title = "星星大小",
    Desc = "设置星星粒子大小",
    Value = { Min = 0.2, Max = 2, Default = 1 },
    Step = 0.1,
    Callback = function(value)
        starsSize = value
        if starsParticle then
            starsParticle.Size = NumberSequence.new(value)
        end
    end
})

TabHandles.Sky:Divider()

TabHandles.Sky:Paragraph({
    Title = "🌍 大气效果",
    Desc = "调整大气散射效果",
    Image = "globe",
    ImageSize = 18,
    Color = Color3.fromHex("#3B82F6")
})

local atmosphereToggle = TabHandles.Sky:Toggle({
    Title = "启用大气效果",
    Desc = "开启/关闭大气散射",
    Value = false,
    Callback = function(v)
        atmosphereEnabled = v
        if skyboxEnabled then
            if v then
                local atmosphere = Lighting:FindFirstChild("Atmosphere")
                if not atmosphere then
                    atmosphere = Instance.new("Atmosphere")
                    atmosphere.Parent = Lighting
                end
                atmosphere.Density = atmosphereDensity
                atmosphere.Offset = atmosphereOffset
            end
        end
    end
})

local atmosphereDensitySlider = TabHandles.Sky:Slider({
    Title = "大气密度",
    Desc = "设置大气散射密度",
    Value = { Min = 0, Max = 1, Default = 0.5 },
    Step = 0.1,
    Callback = function(value)
        atmosphereDensity = value
        if skyboxEnabled and atmosphereEnabled then
            local atmosphere = Lighting:FindFirstChild("Atmosphere")
            if atmosphere then
                atmosphere.Density = value
            end
        end
    end
})

local atmosphereOffsetSlider = TabHandles.Sky:Slider({
    Title = "大气偏移",
    Desc = "设置大气散射偏移",
    Value = { Min = 0, Max = 1, Default = 0.5 },
    Step = 0.1,
    Callback = function(value)
        atmosphereOffset = value
        if skyboxEnabled and atmosphereEnabled then
            local atmosphere = Lighting:FindFirstChild("Atmosphere")
            if atmosphere then
                atmosphere.Offset = value
            end
        end
    end
})

TabHandles.Sky:Divider()

TabHandles.Sky:Paragraph({
    Title = "☁️ 云层设置",
    Desc = "调整天空云层效果",
    Image = "cloud",
    ImageSize = 18,
    Color = Color3.fromHex("#94A3B8")
})

local cloudsToggle = TabHandles.Sky:Toggle({
    Title = "启用云层",
    Desc = "开启/关闭天空云层",
    Value = false,
    Callback = function(v)
        cloudsEnabled = v
        if skyboxEnabled then
            if v then
                local clouds = Lighting:FindFirstChild("Clouds")
                if not clouds then
                    clouds = Instance.new("Clouds")
                    clouds.Parent = Lighting
                end
                clouds.Color = cloudColor
                clouds.Cover = cloudCover
            end
        end
    end
})

local cloudColorPicker = TabHandles.Sky:ColorPicker({
    Title = "云层颜色",
    Desc = "设置云层颜色",
    Default = cloudColor,
    Callback = function(color)
        cloudColor = color
        if skyboxEnabled and cloudsEnabled then
            local clouds = Lighting:FindFirstChild("Clouds")
            if clouds then
                clouds.Color = color
            end
        end
    end
})

local cloudCoverSlider = TabHandles.Sky:Slider({
    Title = "云层覆盖度",
    Desc = "设置云层覆盖程度",
    Value = { Min = 0, Max = 1, Default = 0.5 },
    Step = 0.1,
    Callback = function(value)
        cloudCover = value
        if skyboxEnabled and cloudsEnabled then
            local clouds = Lighting:FindFirstChild("Clouds")
            if clouds then
                clouds.Cover = value
            end
        end
    end
})

TabHandles.Sky:Divider()

local resetButton = TabHandles.Sky:Button({
    Title = "🔄 重置所有天空设置",
    Icon = "refresh-cw",
    Variant = "Danger",
    Callback = function()
        resetSkyboxSettings()
        skyboxToggle:Set(false)
        fogToggle:Set(false)
        starsToggle:Set(false)
        atmosphereToggle:Set(false)
        cloudsToggle:Set(false)
        skyboxEnabled = false
        
        skyColor = originalValues.SkyColor
        ambientColor = originalValues.Ambient
        outdoorAmbient = originalValues.OutdoorAmbient
        fogEnabled = false
        fogColor = Color3.fromRGB(150, 150, 150)
        fogStart = 0
        fogEnd = 500
        timeOfDay = 14
        brightness = 1
        exposure = 1
        shadowSoftness = 0.5
        starsEnabled = false
        atmosphereEnabled = false
        cloudsEnabled = false
        
        toggleStars(false)
        
        WindUI:Notify({
            Title = "天空修改器",
            Content = "已重置所有天空设置",
            Icon = "refresh-cw",
            Duration = 2
        })
    end
})

-- 保存原始值
saveOriginalValues()

Window:OnClose(function()
    print("窗口已关闭")
end)

Window:OnDestroy(function()
    print("窗口已销毁")
end)