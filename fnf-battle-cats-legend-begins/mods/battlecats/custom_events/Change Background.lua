-- 배경별 스펙: 전부 이 스크립트 안에서 직접 만들고, 만든 태그는 bgSpriteList에 등록.
-- 스테이지 폴더 재사용(addLuaScript) 안 함 -> 곡 기본 stage랑 충돌 안 남.
local bgSpecs = {
    ['noul']    = {image = 'noul',    x = -650,  y = -450,  scale = 3,   scroll = 1.0, shader = true,
                   zoom = 0.9, bfY = 450,  dadY = 450},
    ['night']   = {image = 'night',   x = -1100, y = -800,  scale = 4,   scroll = 1.0,
                   zoom = 0.6, bfY = 300,  dadY = 400, bfX = 1200},
    ['gris']    = {image = 'gris',    x = -1650, y = -2000, scale = 5,   scroll = 1.0,
                   zoom = 0.6, bfY = -500, dadY = -1000, bfX = 900, dadX = 100},
    ['desert']  = {image = 'desert',  x = -1700, y = -2000, scale = 2.5, scroll = 1.0,
                   zoom = 0.4, bfY = 0,    dadY = 100, bfX = 800, dadX = -300},
    ['moon']    = {image = 'moon',    x = -1100, y = -2000, scale = 1.8, scroll = 1.0, darkShader = true,
                   zoom = 0.4, bfY = 0, dadY = -200, bfX = 900},
    ['newmoon'] = {image = 'newmoon', x = -1500, y = -600,  scale = 2.5, scroll = 1.0,
                   zoom = 0.4, bfY = 800,  dadY = 900, dadX = -300},
    ['white']   = {image = nil,       x = -2000, y = -2000, scale = 1,   scroll = 0, whiteFill = true,
                   zoom = 0.4, bfY = 400,  dadY = 300, dadX = -200},
}

local currentBG = nil
local dbgTimer = 0 -- 디버그용, 확인 끝나면 지울 것

function onCreate()
    setVar('bgSpriteList', '')
end

function clearBG()
    local list = getVar('bgSpriteList')
    if list and list ~= '' then
        for tag in string.gmatch(list, '([^,]+)') do
            removeLuaSprite(tag, true)
        end
    end
    setVar('bgSpriteList', '')
end

function regSprite(tag)
    setVar('bgSpriteList', (getVar('bgSpriteList') or '') .. tag .. ',')
end

function onEvent(name, value1, value2)
    if name ~= 'Change Background' then return end

    local bgName = value1
    local spec = bgSpecs[bgName]
    if not spec then return end

    clearBG()
    currentBG = bgName

    if spec.whiteFill then
        makeLuaSprite('bgSprite1', nil, spec.x, spec.y)
        makeGraphic('bgSprite1', screenWidth * 6, screenHeight * 6, 'FFFFFF')
        setScrollFactor('bgSprite1', 0, 0)
    else
        makeLuaSprite('bgSprite1', spec.image, spec.x, spec.y)
        scaleObject('bgSprite1', spec.scale, spec.scale)
        setScrollFactor('bgSprite1', spec.scroll, spec.scroll)
    end
	
    if bgName ~= "white" then
        initLuaShader('RTXLighting')
        setSpriteShader('bgSprite1', 'RTXLighting')
    end
	
    addLuaSprite('bgSprite1', false)
    regSprite('bgSprite1')

    if spec.darkShader then
        makeLuaSprite('bgSprite2', nil, -500, -500)
        makeGraphic('bgSprite2', screenWidth * 2, screenHeight * 2, '000000')
        setObjectCamera('bgSprite2', 'hud')
        setScrollFactor('bgSprite2', 0, 0)
        setProperty('bgSprite2.alpha', 0.5)
        addLuaSprite('bgSprite2', true)
        regSprite('bgSprite2')
    end

    setProperty('camGame.zoom', spec.zoom)
    setProperty('defaultCamZoom', spec.zoom)

    -- x는 선택 옵션: spec에 bfX/dadX 없으면 안 건드림(bf는 기본 800 유지)
    local bfX = spec.bfX or 800
    setProperty('boyfriend.x', bfX)
    setProperty('boyfriend.y', spec.bfY)
    setProperty('dad.y', spec.dadY)
    setVar('curBfX', tostring(bfX))
    setVar('curBfY', tostring(spec.bfY))
    setVar('curDadY', tostring(spec.dadY))

    if spec.dadX then
        setProperty('dad.x', spec.dadX)
        setVar('curDadX', tostring(spec.dadX))
    else
        setVar('curDadX', '')
    end


    if bgName == 'newmoon' then
        setProperty('gf.y', 800)
		if (dadName == "bunbun") then
			setProperty('dad.y', -100)
		else
			setProperty('dad.y', 900)
		end
    end
	if bgName == 'white' then
		setProperty('gf.y', 475)
		setProperty('gf.x', 500)
	end
	
end

function onUpdatePost()
    if currentBG == 'moon' then
        setProperty('dad.x', 500)
        setProperty('boyfriend.y', 800)
    end
    if currentBG == 'gris' and dadName == 'beach_leopard' then
		setProperty('boyfriend.angle', -30)
        setProperty('dad.y', -100)
        setProperty('boyfriend.y', -1000)
    end

    -- 디버그용: newmoon일 때 1초마다 실제 dad.y 값 화면에 출력 (확인 끝나면 삭제)
    if currentBG == 'newmoon' then
        dbgTimer = dbgTimer + 1
        if dbgTimer % 60 == 0 then
            luaTrace('[DEBUG] 현재 dad.y = ' .. tostring(getProperty('dad.y')))
        end
    end
end
