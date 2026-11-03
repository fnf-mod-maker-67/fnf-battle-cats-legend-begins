function onCreatePost()
    makeLuaSprite('blackCover', '', -500, -500)
    makeGraphic('blackCover', 3000, 2000, '000000')
    setObjectCamera('blackCover', 'camGame')
    setScrollFactor('blackCover', 0, 0)
    setProperty('blackCover.visible', false)
    addLuaSprite('blackCover', true)
    setObjectOrder('boyfriendGroup', getObjectOrder('blackCover') + 1)
end

function onEvent(name, value1, value2)
    if name == "BlackOut" then
        setProperty('blackCover.visible', value1 == '1')
    end
end
