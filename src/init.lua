local Symbols = require(script.Symbols)

return {
    EngineProvider =  require(script.EngineContext).Provider,
    addMotion = require(script.addMotion),
    Motions = Symbols.Motions,
    Prop = Symbols.Prop
}