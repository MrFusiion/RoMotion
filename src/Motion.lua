local Roact = require(script.Parent.Parent.Roact)
local Symbol = require(script.Parent.Parent.Roact.Symbol)

local Signals = Symbol.named("Signals")

local Motion = {}
local Motion_mt = { __index = Motion }


function Motion.new(value: any, twInfo: TweenInfo)
    local binding, setBinding = Roact.createBinding(value)

    local completedSignal = Instance.new("BindableEvent")

    return setmetatable({
        Binding = binding,
        SetBinding = setBinding,

        Value = value,
        Target = nil,
        TweenInfo = twInfo,
        Time = 0,
        Count = 0,
        Reversed = false,

        Completed = completedSignal.Event,

        [Signals] = {
            Completed = completedSignal
        }
    }, Motion_mt)
end


function Motion:clear()
    self.Target = nil
    self.Time = 0
    self.Count = 0
    self.Reversed = false
    self.Lerp = nil
end


function Motion:lerp(alpha: number)
    local reversed = self.Reversed
    if self.Lerp then
        local from = reversed and self.Target or self.Value
        local to = reversed and self.Value or self.Target
        return self.Lerp(from, to, alpha)
    else
        warn("Lerp is not assigned!")
    end
end


-- Tween the value
function Motion:setGoal(target: any, twInfo: TweenInfo)
    self:clear()
    self.Value = self.Binding:getValue()
    self.Target = target
    self.TweenInfo = self.TweenInfo or twInfo
end


-- Set the value instant
function Motion:jump(target: any)
    self.SetBinding(target)
end


-- Resets values and triggers the Completed Event
function Motion:completed()
    self:clear()
    self.Value = self.Target
    self[Signals].Completed:Fire()
end

return Motion