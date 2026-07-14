local Players = game:GetService("Players")
local VirtualUser = game:GetService("VirtualUser")
local player = Players.LocalPlayer
local afkClickInterval = 240
local lastAfkTick = 0
player.Idled:Connect(function()
    VirtualUser:Button2Down(Vector2.new(0, 0), workspace.CurrentCamera.CFrame, false)
    task.wait(0.1)
    VirtualUser:Button2Up(Vector2.new(0, 0), workspace.CurrentCamera.CFrame, false)
end)
pcall(function()
    VirtualUser:CaptureController()
end)
task.spawn(function()
    while true do
        local now = os.clock()
        if now - lastAfkTick >= afkClickInterval then
            pcall(function()
                VirtualUser:Button2Down(Vector2.new(0, 0), workspace.CurrentCamera.CFrame, false)
                task.wait(0.05)
                VirtualUser:Button2Up(Vector2.new(0, 0), workspace.CurrentCamera.CFrame, false)
            end)
            lastAfkTick = now
        end
        task.wait(1)
    end
end)
