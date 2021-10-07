local Symbol = require(script.Parent.Parent.Roact.Symbol)

local Intr = Symbol.named("Internal")

local WARN_COULD_NOT_FIND = "Couldn't find any motion named %s!"

local Motions = {}
local Motions_mt = {}

function Motions_mt:__index(k: string)
    if Motions[k] then
        return Motions[k]
    end

    local motion = self[Intr].Motions[k]

    if not motion then
        warn(WARN_COULD_NOT_FIND:format(k))
        return
    end

    return motion.Binding
end

function Motions.new(engine: table, motions: table)
    assert(engine~=nil, "Bad argument #1 Engine required got nil!")
    return setmetatable({
        [Intr] = {
            Motions = motions,
            Engine = engine
        }
    }, Motions_mt)
end

function Motions:setGoals(goals: table)
    for name, goal in pairs(goals) do
        local motion = self[Intr].Motions[name]
        if motion then
            if typeof(goal) == "table" then
                motion:setGoal(goal.value, goal.tweeninfo)
            else
                motion:setGoal(goal)
            end
            self[Intr].Engine:run(motion)
        else
            warn(WARN_COULD_NOT_FIND:format(name))
        end
    end
end

function Motions:jumpGoals(goals: table)
    for name, goal in pairs(goals) do
        local motion = self[Intr].Motions[name]
        if motion then
            motion:jump(goal)
            self[Intr].Engine:run(motion)
        else
            warn(WARN_COULD_NOT_FIND:format(name))
        end
    end
end

function Motions:cancel(...)
    for _, name in ipairs{...} do
        local motion = self[Intr].Motions[name]
        if motion then
            self[Intr].Engine:cancel(motion)
        else
            warn(WARN_COULD_NOT_FIND:format(name))
        end
    end
end

return Motions