function onEvent(name, value1, value2)
    if name == "HudHide" then
        local show = not (value1 == '1' or value1 == 'true')
        setProperty('camHUD.visible', show)
    end
end
