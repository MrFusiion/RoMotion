local TS = game:GetService("TweenService")
local RS = game:GetService("RunService")

local LerpFunctions = require(script.LerpFunctions)

local function getLerp(motion: table)
    local from = motion.Value
    local to = motion.Target

    assert(typeof(from)==typeof(to), ("Cannot tween from %s to %s!")
        :format(typeof(from), typeof(to)))

    local lerpF = LerpFunctions[typeof(from)]
    assert(lerpF~=nil, ("Cannot tween %s!")
        :format(typeof(from)))

    return lerpF
end

local Engine = {}
local Engine_mt = { __index = Engine }

function Engine.new()
    return setmetatable({
        Sleeping = false,
        Running = {},
        TotalRunning = 0,
    }, Engine_mt)
end

function Engine:isRunning(motion: table)
    return self.Running[motion]
end

function Engine:start()
    if not self.connetion then
        self.connetion = RS.RenderStepped:Connect(function(dt)
            self:update(dt)
        end)
        self.Sleeping = false
    end
end

function Engine:sleep()
    self:stop()
    self.Sleeping = true
end

function Engine:stop()
    if self.Sleeping then
        self.Sleeping = false
    elseif self.connetion then
        self.connetion:Disconnect()
        self.connetion = nil
    end
end

function Engine:run(motion: table)
    if self.Sleeping then
        self:start()
        --print("ENGINE WAKING")
    end

    local twInfo = motion.TweenInfo
    motion.Duration = twInfo.Reverses and twInfo.Time * .5 or twInfo.Time
    motion.Lerp = getLerp(motion)

    self.TotalRunning += 1
    self.Running[motion] = "running"
end

function Engine:cancel(motion: table)
    self.Running[motion] = nil
    self.TotalRunning -= 1
    motion:completed()
end

function Engine:calc(motion: table, dt: number)
    local twInfo: TweenInfo = motion.TweenInfo

    local reversed = motion.Reversed
    if motion.Time == 0 and not reversed then
        motion.Time = -twInfo.DelayTime + dt
    else
        motion.Time += dt
    end

    local t = motion.Time > 0 and motion.Time / motion.Duration
    if t then
        local alpha = TS:GetValue(t, twInfo.EasingStyle,
            twInfo.EasingDirection)

        local v = motion:lerp(alpha)
        local completed = false

        if t >= 1 then
            motion.Time = 0

            if twInfo.Reverses then
                motion.Reversed = not reversed
                if reversed then
                    motion.Count += 1
                end
            else
                motion.Count += 1
            end

            if twInfo.RepeatCount > -1 and motion.Count > twInfo.RepeatCount then
                completed = true
            elseif not twInfo.Reverses then
                v = motion.Value
            end
        end

        return v, completed
    end
    return motion.Value
end

function Engine:update(dt: number)
    if self.TotalRunning == 0 then
        self:sleep()
        --print("ENGINE SLEEPING")
    end

    for motion in pairs(self.Running) do
        local v, completed = self:calc(motion, dt)
        motion.SetBinding(v)

        if completed then
            self.Running[motion] = nil
            self.TotalRunning -= 1
            motion:completed()
        end
    end
end

return Engine