local player = game:GetService("Players").LocalPlayer
local playerGui = player.PlayerGui

local Roact = require(game:GetService("ReplicatedStorage"):WaitForChild("Roact"))
local RoMotion = require(game:GetService("ReplicatedStorage"):WaitForChild("RoMotion"))

local function Button(props)
    local hoverColor = props.HoverColor or Color3.new(0, 0, 1)
    local motions = props[RoMotion.Motions]

    return Roact.createElement("TextButton", {
        AnchorPoint = Vector2.new(.5, .5),
        Position = UDim2.fromScale(.5, .5),
        BackgroundColor3 = motions.Color,
        BorderSizePixel = 0,
        Size = motions.Size,
        Text = "",
        ZIndex = props.ZIndex,

        [Roact.Event.MouseEnter] = function()
            motions:setGoals({
                Size = props.Size + UDim2.fromOffset(50, 50),
                Color = hoverColor,
                Corner = props.Corner * .5
            })
        end,

        [Roact.Event.MouseLeave] = function()
            motions:setGoals({
                Size = props.Size,
                Color = props.Color,
                Corner = props.Corner
            })
        end
    }, {
        Corner = Roact.createElement("UICorner", {
            CornerRadius = motions.Corner:map(function(offset)
                return UDim.new(0, offset)
            end)
        })
    })
end

Button = RoMotion.addMotion({
    Size = {
        defaultValue = UDim2.fromOffset(200, 50),
        value = RoMotion.Prop.Size,
        tweeninfo = TweenInfo.new(1, Enum.EasingStyle.Elastic)
    },
    Color = {
        defaultValue = Color3.new(1, 0, 0),
        value = RoMotion.Prop.Color,
        tweeninfo = TweenInfo.new(1, Enum.EasingStyle.Sine)
    },
    Corner = {
        defaultValue = 20,
        value = RoMotion.Prop.Corner,
        tweeninfo = TweenInfo.new(1, Enum.EasingStyle.Elastic)
    },
})(Button)

local handle = Roact.mount(Roact.createElement(RoMotion.EngineProvider, {}, {
    hud = Roact.createElement("ScreenGui", {}, {
        Background = Roact.createElement("Frame", {
            BackgroundColor3 = Color3.new(),
            BackgroundTransparency = .3,
            BorderSizePixel = 0,
            Size = UDim2.fromScale(1, 1)
        }),
        Button = Roact.createElement(Button, { ZIndex = 2 })
    })
}), playerGui, "Hud")