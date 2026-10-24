function onCreate()
    -- 배경 이미지 추가 (태그명, 이미지 파일명, X 좌표, Y 좌표)
    makeLuaSprite('stageBackground', 'newmoon', -1000, -800)
    
    -- 화면을 카메라가 줌아웃했을 때 여백이 보이지 않도록 크기를 약간 키워줍니다 (1.5배)
    scaleObject('stageBackground', 2.5, 2.5)
    
    -- 원경(멀리 있는 배경)처럼 보이도록 스크롤 속도를 캐릭터보다 약간 느리게 설정 (기본값 1.0)
    setScrollFactor('stageBackground', 0.8, 1)
    
    -- 스테이지에 배경을 배치합니다.
    addLuaSprite('stageBackground', false)
    setVar('bgSpriteList', (getVar('bgSpriteList') or '') .. 'stageBackground,')
end