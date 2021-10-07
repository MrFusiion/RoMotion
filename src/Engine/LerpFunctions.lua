local function nLerp(from, to, t)
    return from + (to - from) * t
end

local function bLerp(from, to, t)
    from = from and 1 or 0
    to = to and 1 or 0
    return math.floor(nLerp(from, to, t) + .5) == 1 and true or false
end

local function mLerp(from, to, t)
    return from:Lerp(to, t)
end

local function vLerp(from, to, t)
    return from:Lerp(to, t)
end

local function cLerp(from, to, t)
    return from:lerp(to, t)
end

local function uLerp(from, to, t)
    return UDim.new(
        nLerp(from.Scale, to.Scale, t),
        nLerp(from.Offset, to.Offset, t)
    )
end

local f = {}

f["number"] = nLerp

f["boolean"] = bLerp

f["Rect"] = function(from, to, t)
    return Rect.new(
        vLerp(from.Min, to.Min, t),
        vLerp(from.Max, to.Max, t)
    )
end

f["Color3"] = cLerp

f["CFrame"] = mLerp

f["UDim"] = uLerp

f["UDim2"] = function(from, to, t)
    return UDim2.new(
        uLerp(from.X, to.X, t),
        uLerp(from.Y, to.Y, t)
    )
end

f["Vector2"] = vLerp
f["Vector2int16"] = function(from, to, t)
    local v = vLerp(Vector2.new(from.X, from.Y),
        Vector2.new(to.X, to.Y), t)
    return Vector2int16.new(v.X, v.Y)
end

f["Vector3"] = vLerp
f["Vector3int16"] = function(from, to, t)
    local v = vLerp(Vector3.new(from.X, from.Y, from.Z),
        Vector3.new(to.X, to.Y, to.Z), t)
    return Vector3int16.new(v.X, v.Y, v.Z)
end

f["EnumItem"] = function(from, to, t)
    return bLerp(true, false, t) and from or to
end

f["table"] = function(from, to, t)
    local newT = {}
    for k, fv in pairs(from) do
        local tv = to[k]
        newT[k] = tv ~= nil and f[typeof(tv)](fv, tv, t) or fv
    end
    return newT
end

return f