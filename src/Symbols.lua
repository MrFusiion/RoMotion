local Symbol = require(script.Parent.Parent.Roact.Symbol)

local Prop = Symbol.named("Property")
local Prop_mt = getmetatable(Prop)

function Prop_mt:__index(k: string)
    return { [Prop] = k }
end

return {
    Motions = Symbol.named("Motions"),
    Prop = Prop
}