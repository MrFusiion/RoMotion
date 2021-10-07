local Roact = require(script.Parent.Parent.Roact)

local Engine = require(script.Parent.Engine)
local context = Roact.createContext()

local EngineProvider = Roact.Component:extend("EngineProvider")

EngineProvider.defaultProps = {
    engine = Engine.new()
}

function EngineProvider:render()
    return Roact.createElement(context.Provider, {
        value = self.props.engine
    }, self.props[Roact.Children])
end

function EngineProvider:didMount()
    local engine = self.props.engine
    engine:start()
end

function EngineProvider:willUnmount()
    local engine = self.props.engine
    engine:stop()
end

return {
    Consumer = context.Consumer,
    Provider = EngineProvider,
}