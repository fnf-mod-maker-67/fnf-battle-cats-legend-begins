-------- ManiaCat (최적화 버전 v2) --------
-- 원본 문제: onUpdate()에서 매 프레임 makeLuaSprite() 호출 → 1초에 60번 이미지 로드 → FPS 폭락
-- v1 문제: 토글 끌 때 visible=false로 숨기기만 함 → 스프라이트 객체가 살아있어 비용 남음
-- v2 수정: 토글 끌 때 스프라이트를 완전 삭제(destroy), 켤 때 재생성 → 끄면 "삭제"랑 동일하게 60fps

-------- 조작키 (키보드) --------
local leftkey  = 'left'
local downkey  = 'down'
local upkey    = 'up'
local rightkey = 'right'

-------- 마니아캣 켜기/끄기 토글 키 --------
-- 게임 플레이 중 이 키를 누르면 마니아캣이 켜졌다 꺼졌다 함
-- 끄면 스프라이트를 완전히 삭제해서 성능 100% 복구
local toggleKey = 'FIVE'

-------- 스킨 선택 --------
local skincat = 'BF'  -- Default / BF / GF / Custom

-------- 위치 / 크기 --------
local ycat = 300
local xcat = 0
local scalecat = 0.1

-- ----- 이하 코드 (건드릴 필요 없음) ----- --

local dirSprites = {
    'base', 'up', 'down', 'left', 'right',
    'upright', 'leftdown', 'base_left', 'base_right'
}

local catVisible = false
local spritesCreated = false

-- 스프라이트 생성 (1회)
function createCatSprites()
    if spritesCreated then return end
    local p = 'ManiaCat/' .. string.lower(skincat) .. '/'
    for _, s in ipairs(dirSprites) do
        makeLuaSprite(s, p .. s, xcat, ycat)
        setObjectCamera(s, 'other')
        scaleObject(s, scalecat, scalecat)
        addLuaSprite(s, true)
        setProperty(s .. '.visible', false)
    end
    setProperty('base.visible', true)
    spritesCreated = true
end

-- 스프라이트 완전 삭제 (성능 100% 복구)
function destroyCatSprites()
    if not spritesCreated then return end
    for _, s in ipairs(dirSprites) do
        removeLuaSprite(s, true)  -- true = 객체까지 destroy
    end
    spritesCreated = false
end

function onCreatePost()
    if catVisible then
        createCatSprites()
    end
end

function onUpdate()
    -- 토글 키 처리 (누른 순간 1회만)
    if keyboardJustPressed(toggleKey) then
        catVisible = not catVisible
        if catVisible then
            createCatSprites()
        else
            destroyCatSprites()
        end
    end

    -- 꺼져 있으면(스프라이트 없으면) 아무것도 안 함 → 성능 100% 복구
    if not spritesCreated then return end

    local u = keyPressed(upkey)
    local d = keyPressed(downkey)
    local l = keyPressed(leftkey)
    local r = keyPressed(rightkey)

    -- base(몸통)는 항상 보이기
    setProperty('base.visible', true)

    -- 방향 결정 (우선순위: 대각선 > 단일 방향 > idle)
    local show
    if     u and r then show = 'upright'
    elseif l and d then show = 'leftdown'
    elseif u       then show = 'up'
    elseif d       then show = 'down'
    elseif l       then show = 'left'
    elseif r       then show = 'right'
    else                show = 'base_right'
    end

    -- base 외 스프라이트는 show 에 해당하는 것만 노출
    for _, s in ipairs(dirSprites) do
        if s ~= 'base' then
            setProperty(s .. '.visible', s == show)
        end
    end
end

-- 곡 끝나면 혹시 남은 스프라이트 정리
function onDestroy()
    destroyCatSprites()
end

function onCustomSubstateCreate(name)
    if name == 'victory' then
        destroyCatSprites()
    end
end
