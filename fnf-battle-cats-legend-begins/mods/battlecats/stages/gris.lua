function onCreate()
    makeLuaSprite('stageBackground', 'gris', -1550, -1300)
    scaleObject('stageBackground', 5, 5)
    setScrollFactor('stageBackground', 1.0, 1.0)
    addLuaSprite('stageBackground', false)
    setVar('bgSpriteList', (getVar('bgSpriteList') or '') .. 'stageBackground,')
end