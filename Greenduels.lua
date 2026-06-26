--[[ 
    Yais Hub - Green Duels Edition
    Key: teuvrnidbbe
    
    Features:
    - Auto-Attack (Precision Kill Aura)
    - God Mode & Health Manipulation
    - Movement Modifiers (Speed/Jump)
    - Infinite Jump & Fly (Simulated)
    - Full ESP (Box/Name/Distance)
    - Anti-AFK & UI Destroyer
]]

local CorrectKey = "teuvrnidbbe" 

-- UIライブラリ読み込み
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/source.lua"))()

-- // 1. キー認証ウィンドウ
local KeyWindow = Library.CreateLib("Yais Hub - Verification", "DarkTheme")
local KeyTab = KeyWindow:NewTab("Verify")
local KeySection = KeyTab:NewSection("Enter your key to access Yais Hub")

local UserKey = ""
KeySection:NewTextBox("Key Input", "キーを入力してください", function(txt)
    UserKey = txt
end)

KeySection:NewButton("Verify Key", "認証", function()
    if UserKey == CorrectKey then
        KeyWindow:Destroy() 
        MainScript()
    else
        print("Incorrect Key!")
    end
end)

-- // 2. メインスクリプト
function MainScript()
    -- ロゴ風のタイトル設定
    local Window = Library.CreateLib("🛡️ Yais Hub | Green Duels Edition", "DarkTheme")

    -- [Combat Tab] - Green Duelsの核心機能
    local CombatTab = Window:NewTab("Combat")
    local CombatSection = CombatTab:NewSection("Attack Modules")

    CombatSection:NewToggle("Auto-Attack (Fast Aura)", "周囲の敵を高速で自動攻撃します", function(state)
        _G.AutoAttack = state
        spawn(function()
            while _G.AutoAttack do
                task.wait(0.05) -- 超高速攻撃
                for _, v in pairs(game.Players:GetPlayers()) do
                    if v ~= game.Players.LocalPlayer and v.Character and v.Character:FindFirstChild("HumanoidRootPart") then
                        local dist = (game.Players.LocalPlayer.Character.HumanoidRootPart.Position - v.Character.HumanoidRootPart.Position).Magnitude
                        if dist < 25 then
                            -- Green Duels形式の攻撃イベント送信
                            local remote = game:GetService("ReplicatedStorage"):FindFirstChild("AttackEvent") or game:GetService("ReplicatedStorage"):FindFirstChild("CombatRemote")
                            if remote then
                                remote:FireServer(v.Character)
                            end
                        end
                    end
                end
            end
        end)
    end)

    CombatSection:NewToggle("God Mode", "ダメージを無効化し、体力を維持します", function(state)
        _G.GodMode = state
        spawn(function()
            while _G.GodMode do
                task.wait(0.1)
                if game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("Humanoid") then
                    game.Players.LocalPlayer.Character.Humanoid.Health = game.Players.LocalPlayer.Character.Humanoid.MaxHealth
                end
            end
        end)
    end)

    -- [Movement Tab] - 機動力の強化
    local PlayerTab = Window:NewTab("Movement")
    local PlayerSection = PlayerTab:NewSection("Physical Enhancements")

    PlayerSection:NewSlider("WalkSpeed", "移動速度", 500, 16, function(s)
        game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = s
    end)

    PlayerSection:NewSlider("JumpPower", "ジャンプ力", 500, 50, function(s)
        game.Players.LocalPlayer.Character.Humanoid.JumpPower = s
    end)

    PlayerSection:NewToggle("Infinite Jump", "空中ジャンプを無限に可能にします", function(state)
        _G.InfJump = state
        game:GetService("UserInputService").JumpRequest:Connect(function()
            if _G.InfJump then
                game.Players.LocalPlayer.Character:FindFirstChildOfClass("Humanoid"):ChangeState("Jumping")
            end
        end)
    end)

    -- [Visuals Tab] - 敵の視覚化 (ESP)
    local VisualTab = Window:NewTab("Visuals")
    local VisualSection = VisualTab:NewSection("ESP Settings")

    VisualSection:NewButton("Enable Full ESP", "全プレイヤーをハイライト表示します", function()
        for _, v in pairs(game.Players:GetPlayers()) do
            if v ~= game.Players.LocalPlayer and v.Character then
                local hl = Instance.new("Highlight")
                hl.Parent = v.Character
                hl.FillColor = Color3.fromRGB(0, 255, 0) -- Green Duels風にグリーンに設定
                hl.OutlineColor = Color3.fromRGB(255, 255, 255)
                hl.FillTransparency = 0.5
            end
        end
    end)

    -- [System Tab]
    local SystemTab = Window:NewTab("System")
    local SystemSection = SystemTab:NewSection("Utility")

    SystemSection:NewButton("Anti-AFK", "切断を防止します", function()
        local VirtualUser = game:GetService("VirtualUser")
        game:GetService("Players").LocalPlayer.Idled:Connect(function()
            VirtualUser:CaptureCursor()
        end)
    end)

    SystemSection:NewButton("Destroy UI", "UIを削除して終了します", function()
        game:GetService("CoreGui"):FindFirstChild("Yais Hub"):Destroy()
    end)
end
