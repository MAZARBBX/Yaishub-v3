-- KEY SYSTEM
local CorrectKey = "script key : hevbdjrvr fb"

local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/source.lua"))()

local KeyWindow = Library.CreateLib("Yais Hub - Key System", "DarkTheme")
local KeyTab = KeyWindow:NewTab("Verification")
local KeySection = KeyTab:NewSection("Enter your key")

local UserKey = ""

KeySection:NewTextBox("Key Input", "Enter key", function(txt)
    UserKey = txt
end)

KeySection:NewButton("Verify", "Check key", function()
    if UserKey == CorrectKey then
        KeyWindow:Destroy()
        MainScript()
    else
        print("❌ Wrong key!")
    end
end)

-- MAIN SCRIPT
function MainScript()

    -- UI
    local Window = Library.CreateLib("🛡️ Yais Hub | Green Duels Edition", "DarkTheme")

    -- [Combat Tab]
    local CombatTab = Window:NewTab("Combat")
    local CombatSection = CombatTab:NewSection("Attack Modules")

    CombatSection:NewToggle("Auto-Attack (Fast Aura)", "周囲の敵を高速で自動攻撃します", function(state)
        _G.AutoAttack = state
        spawn(function()
            while _G.AutoAttack do
                task.wait(0.05)
                for _, v in pairs(game.Players:GetPlayers()) do
                    if v ~= game.Players.LocalPlayer and v.Character and v.Character:FindFirstChild("HumanoidRootPart") then
                        local dist = (game.Players.LocalPlayer.Character.HumanoidRootPart.Position - v.Character.HumanoidRootPart.Position).Magnitude
                        if dist < 25 then
                            local remote = game:GetService("ReplicatedStorage"):FindFirstChild("AttackEvent") 
                                or game:GetService("ReplicatedStorage"):FindFirstChild("CombatRemote")
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
                local char = game.Players.LocalPlayer.Character
                if char and char:FindFirstChild("Humanoid") then
                    char.Humanoid.Health = char.Humanoid.MaxHealth
                end
            end
        end)
    end)end)-- [Movement Tab]
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


    -- [Visuals Tab]
    local VisualTab = Window:NewTab("Visuals")
    local VisualSection = VisualTab:NewSection("ESP Settings")

    VisualSection:NewButton("Enable Full ESP", "全プレイヤーをハイライト表示します", function()
        for _, v in pairs(game.Players:GetPlayers()) do
            if v ~= game.Players.LocalPlayer and v.Character then
                local hl = Instance.new("Highlight")
                hl.Parent = v.Character
                hl.FillColor = Color3.fromRGB(0, 255, 0)
                hl.OutlineColor = Color3.fromRGB(255, 255, 255)
                hl.FillTransparency = 0.5
            end
        end
    end)end)-- [System Tab]
    local SystemTab = Window:NewTab("System")
    local SystemSection = SystemTab:NewSection("Utility")

    SystemSection:NewButton("Anti-AFK", "切断を防止します", function()
        local VirtualUser = game:GetService("VirtualUser")
        game:GetService("Players").LocalPlayer.Idled:Connect(function()
            VirtualUser:CaptureCursor()
            VirtualUser:ClickButton2(Vector2.new())
        end)
    end)

    SystemSection:NewButton("Rejoin Server", "サーバーに再参加します", function()
        local ts = game:GetService("TeleportService")
        local p = game:GetService("Players").LocalPlayer
        ts:Teleport(game.PlaceId, p)
    end)

    SystemSection:NewButton("Reset Character", "キャラクターをリセットします", function()
        local char = game.Players.LocalPlayer.Character
        if char and char:FindFirstChild("Humanoid") then
            char.Humanoid.Health = 0
        end
    end)

    SystemSection:NewButton("Destroy UI", "UIを削除して終了します", function()
        if game:GetService("CoreGui"):FindFirstChild("Yais Hub") then
            game:GetService("CoreGui"):FindFirstChild("Yais Hub"):Destroy()
        end
    end)

    -- Extra Safety
    spawn(function()
        while task.wait(1) do
            pcall(function()
                local char = game.Players.LocalPlayer.Character
                if char and char:FindFirstChild("Humanoid") and _G.GodMode then
                    char.Humanoid.Health = char.Humanoid.MaxHealth
                end
            end)
        end
    end)-- End of MainScript safety loop
end
