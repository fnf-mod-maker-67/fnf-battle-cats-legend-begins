function onCreate()
    makeLuaSprite('stageBackground', 'night', -1100, -800)
    scaleObject('stageBackground', 4, 4)
    setScrollFactor('stageBackground', 0.5, 0.5)
    addLuaSprite('stageBackground', false)
    setVar('bgSpriteList', (getVar('bgSpriteList') or '') .. 'stageBackground,')
end