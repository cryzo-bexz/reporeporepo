-- By gpt.

Players = game:GetService('Players')
LocalPlayer = Players.LocalPlayer
Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
Backpack = LocalPlayer:WaitForChild('Backpack')

-- // Helper Functions

function ChangePos(p1, p2)
    p1.CFrame = p1.CFrame - p1.CFrame.Position + Vector3.new(p2.X, p2.Y, p2.Z)
end

function GetClosestPlayer()
    local _huge = math.huge
    local v4 = next
    local v5, v6 = game.Workspace.Live:GetChildren()
    local v7 = nil

    while true do
        local v8
        v6, v8 = v4(v5, v6)
        if v6 == nil then break end
        if v8.Name ~= LocalPlayer.Name and (v8:FindFirstChild('HumanoidRootPart') ~= nil and (v8:FindFirstChild('Humanoid') ~= nil and v8:FindFirstChild('Humanoid').Health > 0)) then
            local _magnitude = (v8.HumanoidRootPart.Position - LocalPlayer.Character.HumanoidRootPart.Position).magnitude
            if _magnitude < _huge then
                v7 = v8
                _huge = _magnitude
            end
        end
    end

    return v7
end

function PlayAnimation(p33, p34, p35, p36)
    local u37 = p36 or false
    local _Animation = Instance.new('Animation')
    _Animation.AnimationId = p33
    local u39 = Character.Humanoid.Animator:LoadAnimation(_Animation)
    u39:Play()
    u39.TimePosition = p35 or 0
    u39:AdjustSpeed(p34 or 1)
    if u37 then
        task.spawn(function()
            task.wait(u37)
            u39:Stop()
        end)
    end
    return u39
end

function StopAnimation(p40)
    local v41, v42, v43 = ipairs(Character.Humanoid:FindFirstChildOfClass('Animator'):GetPlayingAnimationTracks())
    while true do
        local v44
        v43, v44 = v41(v42, v43)
        if v43 == nil then break end
        if v44.Animation.AnimationId == p40 then
            v44:Stop()
        end
    end
end

function PlaySound(p49, p50)
    local _Sound = Instance.new('Sound')
    _Sound.Parent = workspace
    _Sound.SoundId = p49
    _Sound.PlaybackSpeed = p50 or 1
    _Sound:Play()
    _Sound.Ended:Connect(function()
        _Sound:Destroy()
    end)
end

-- // ORIGINAL Skill (UNCHANGED)

function Skill(p53, p54, p55)
    local _Tool = Instance.new('Tool')
    _Tool.Name = p53
    _Tool.RequiresHandle = false
    _Tool.Parent = Backpack

    _Tool:SetAttribute('Cooldown', p55)

    local u57 = nil
    local u58 = nil
    local u59 = p55 or 0
    local u60 = LocalPlayer.PlayerGui.Hotbar.Backpack.LocalScript.Cooldown:Clone()

    if Backpack:GetAttribute('CustomSkills') == nil then
        Backpack:SetAttribute('CustomSkills', -1)
    end

    Backpack:SetAttribute('CustomSkills', Backpack:GetAttribute('CustomSkills') + 1)

    for v61 = 1, 13 do
        local _Text = LocalPlayer.PlayerGui.Hotbar.Backpack.Hotbar[tostring(v61)].Base.ToolName.Text
        if _Text == _Tool.Name then
            u57 = LocalPlayer.PlayerGui.Hotbar.Backpack.Hotbar[tostring(v61)].Base
            _Tool.Name = _Tool.Name .. 'ID:' .. tostring(Backpack:GetAttribute('CustomSkills'))
            LocalPlayer.PlayerGui.Hotbar.Backpack.Hotbar[tostring(v61)].Base.ToolName.Text = _Text
        end
    end

    u60.Parent = u57.Parent
    u60.Size = UDim2.new(1, 0, 0, 0)

    local u64 = u57.Activated:Connect(function()
        if not IPlacedThisForSpacing then
            u57.Overlay.Visible = false
            if u59 == 1234 or u60.Size ~= UDim2.new(1, 0, 0, 0) then
                u58 = not u58
                if u58 then
                    u60.Size = UDim2.new(1, 0, -1, 0)
                else
                    u60.Size = UDim2.new(1, 0, 0, 0)
                end
            else
                u60.Size = UDim2.new(1, 0, -1, 0)
                game:GetService('TweenService'):Create(u60, TweenInfo.new(u59, Enum.EasingStyle.Linear, Enum.EasingDirection.Out), {
                    Size = UDim2.new(1, 0, 0, 0),
                }):Play()
            end
            p54()
        end
    end)

    Character.Humanoid.Died:Once(function()
        u64:Disconnect()
    end)

    return _Tool
end

-- // BackTP

BackTP = false
Character.Humanoid.Animator.AnimationPlayed:Connect(function(p77)
    if p77.Animation.AnimationId == 'rbxassetid://13532604085' then
        BackTP = true
        task.wait(0.3)
        BackTP = false
    end
end)

-- // Phantom Blink (UNCHANGED)

function MakePhantomBlinkSkill()
    Skill('Phantom Blink', function()
        PlaySound('rbxassetid://5066021887')
        PlayAnimation('rbxassetid://15957361339', 0.5, 0, 0.5)

        if Character.Humanoid.MoveDirection.Magnitude ~= 0 then
            local v102 = Character.HumanoidRootPart.CFrame + Character.Humanoid.MoveDirection * 50
            game:GetService('TweenService'):Create(Character.HumanoidRootPart, TweenInfo.new(0.3), {CFrame = v102}):Play()
            task.wait(0.3)
            Character.HumanoidRootPart.Velocity = Vector3.new(0, 0, 0)
        else
            Character.HumanoidRootPart.Velocity = Vector3.new(0, 0, 0)
        end
    end, 0.1)
end

-- // Cycle Teleport (ADDED SAME STYLE)

function MakeCycleTeleportSkill()
    local Positions = {
        Vector3.new(809.12, 405.99, 22660.85),
        Vector3.new(-79.32, 29.25, 20349.29),
        Vector3.new(1098.25, 27.85, 22942.23),
        Vector3.new(317.73, 629.94, -490.78),
        Vector3.new(439.01, 570.87, -375.42),
        Vector3.new(117.72, 441.78, 0.70)
    }

    local Index = 0

    Skill('Place Teleport', function()
        Index = Index + 1
        if Index > #Positions then
            Index = 1
        end

        PlaySound('rbxassetid://5066021887')
        PlayAnimation('rbxassetid://15957361339', 0.5, 0, 0.3)

        Character.HumanoidRootPart.CFrame = CFrame.new(Positions[Index])
        Character.HumanoidRootPart.Velocity = Vector3.new(0,0,0)
    end, 0.1)
end

-- // Initialize

MakePhantomBlinkSkill()
MakeCycleTeleportSkill()
