function onCreate()
    makeLuaSprite('stageBackground', 'desert', -1700, -2000)
    scaleObject('stageBackground', 2.5, 2.5)
    setScrollFactor('stageBackground', 0.5, 0.5)
    addLuaSprite('stageBackground', false)
    setVar('bgSpriteList', (getVar('bgSpriteList') or '') .. 'stageBackground,')
end