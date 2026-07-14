local Config = {
    StretchAmount = 0.53,
    Enabled = true
}
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local Camera = workspace.CurrentCamera
local Player = Players.LocalPlayer
local Connection = nil
if getgenv().StretchedResolution_Active then
    warn("already running")
    return
end
getgenv().StretchedResolution_Active = true
local function ApplyStretchEffect()
    if Config.Enabled and Camera then
        Camera.CFrame = Camera.CFrame * CFrame.new(
            0, 0, 0,
            1, 0, 0,
            0, Config.StretchAmount, 0,
            0, 0, 1
        )
    end
end
local function StartStretch()
    if Connection then
        warn("already running")
        return
    end  
    Connection = RunService.RenderStepped:Connect(ApplyStretchEffect)
end
local function StopStretch()
    if Connection then
        Connection:Disconnect()
        Connection = nil
        print("Stopped")
    end
end
local function ToggleStretch()
    Config.Enabled = not Config.Enabled
    print("" .. (Config.Enabled and "enabled" or "disabled"))
end
local function SetStretchAmount(amount)
    if type(amount) == "number" and amount >= 0 and amount <= 1 then
        Config.StretchAmount = amount
    else
        warn("invaild")
    end
end
local function OnCameraChanged()
    Camera = workspace.CurrentCamera
end
workspace:GetPropertyChangedSignal("CurrentCamera"):Connect(OnCameraChanged)
if Player.Character then
    Player.Character:WaitForChild("Humanoid").Died:Connect(function()
        task.wait(Players.RespawnTime or 5)
        Camera = workspace.CurrentCamera
    end)
end
Player.CharacterAdded:Connect(function(character)
    character:WaitForChild("Humanoid").Died:Connect(function()
        task.wait(Players.RespawnTime or 5)
        Camera = workspace.CurrentCamera
    end)
end)
getgenv().StretchedResolution = {
    Start = StartStretch,
    Stop = StopStretch,
    Toggle = ToggleStretch,
    SetAmount = SetStretchAmount,
    GetAmount = function() return Config.StretchAmount end,
    IsEnabled = function() return Config.Enabled end,
    Config = Config
}
StartStretch()
