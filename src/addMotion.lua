local Roact = require(script.Parent.Parent.Roact)
local EngineContext = require(script.Parent.EngineContext)
local Motion = require(script.Parent.Motion)
local MotionManager = require(script.Parent.MotionManager)

local Symbols = require(script.Parent.Symbols)
local Motions = Symbols.Motions
local Prop = Symbols.Prop

local function getValue(value: any, defaultValue: any, props: table)
    if typeof(value) == "table" and value[Prop] then
        local val = props[value[Prop]]
        if val == nil then
            props[value[Prop]] = defaultValue
            return defaultValue
        end
        return val
    else
        return value
    end
end

return function (motionData: table): (Roact.Component | (props: table, state: table) -> (Roact.Element)) -> (Roact.Component)
    return function(component)
        local componentName = ("RoMotionConnection(%s)"):format(tostring(component))

        local self = Roact.Component:extend(componentName)

        function self:init()
            self.Motions = {}
            for initName, initInfo in pairs(motionData) do
                local value = getValue(initInfo.value, initInfo.defaultValue, self.props)
                assert(value ~= nil, "'value' is required to create a RoMotion!")

                self.Motions[initName] = Motion.new(value, initInfo.tweeninfo or TweenInfo.new())
            end
        end

        function self:render()
            return Roact.createElement(EngineContext.Consumer, {
                render = function(engine)
                    assert(engine~=nil, "Component did not get a Engine! make sure to have an EngineProvider with an Engine higher up in the RoactTree!")

                    local props = {}
                    for k, v in pairs(self.props) do
                        if k ~= Roact.Children then
                            props[k] = v
                        end
                    end
                    props[Motions] = MotionManager.new(engine, self.Motions)

                    return Roact.createElement(component, props, self.props[Roact.Children])
                end
            })
        end

        return self
    end
end