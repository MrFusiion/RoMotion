<h1 align="center">RoMotion 🎥🎬</h1>

<div align="center">
	An animation library for <a href="https://github.com/Roblox/roact">Roact</a>.
</div>

<div>&nbsp;</div>

## Installation

### Method 1: Model File (Roblox Studio)
* Build the model

    ```bash
    rojo build -o "RoMotion.rbxm"
    ```
* Insert the model into Studio into a place like `ReplicatedStorage`

### Method 2: Filesystem
* Copy the `src` directory into your codebase
* Rename the folder to `RoMotion`
* Use a plugin like [Rojo](https://github.com/LPGhatguy/rojo) to sync the files into a place

# Documentation

## Add an EngineProvider

### When you render an Roact application wrap the top-level component in a
`RoMotion.EngineProvider`

```lua
local app = Roact.createElement(RoMotion.EngineProvider, {
    engine = engine, --Optional. RoMotion uses the build in Engine when not defined.
}, {
    Main = Roact.createElement(MyComponent),
})
```

## Add animations
Supported Values:
* number
* boolean
* table
* Color3
* CFrame
* Rect
* UDim
* Udim2
* Vector2
* Vector3
* Vector2int16
* Vector3int16
* EnumItem

`RoMotion.addMotion(table): (MyComponent) -> WrappedMyComponent`
```lua
local MyComponent = RoMotion.addMotion({
    transparency = {
        value = .5,
        tweeninfo = TweenInfo.new(.5, Enum.EasingStyle.Sine)
    }
})(MyComponent)
```

### Use `RoMotion.Prop.{PropName}` to tell RoMotion to fetch the value from the Component's props.
### And assign `defaultValue` for when to prop Value is nil.
```lua
local MyComponent = RoMotion.addMotion({
    transparency = {
        defaultValue = .5,
        value = RoMotion.Prop.Transparency,
        tweeninfo = TweenInfo.new(.5, Enum.EasingStyle.Sine)
    }
})(MyComponent)
```

## Using animations
`RoMotion.addMotion(table): (MyComponent) -> MyWrappedComponent`
```lua
local function MyComponent(props)
    local motions = props[RoMotion.Motions]

    return Roact.createElement('TextButton', {
        AutoButtonColor = false,
        Text = 'Click'

        -- here we assign an animation binding named `Transparency` to Transparency
        Transparency = motions.transparency,

        [Roact.Event.MouseEnter] = function()
            motions:setGoals({
                transparency = 0,
            })
        end,
        [Roact.Event.MouseLeave] = function()
            motions:setGoals({
                transparency = .5,
            })
        end
    })
end

local AnimatedComponent = RoMotion.addMotion({
    transparency = {
        value = .5,
        tweeninfo = TweenInfo.new(.5, Enum.EasingStyle.Sine)
    }
})(MyComponent)
```