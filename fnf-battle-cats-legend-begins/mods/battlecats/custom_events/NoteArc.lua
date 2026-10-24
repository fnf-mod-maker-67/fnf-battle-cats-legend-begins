-- 클로드가 만듬

luaDebugMode = true
local arcActive = false
local ARC_HEIGHT_DOWN = 300   -- 다운스크롤: 더 높이 튀었다가 내려옴
local SPAWN_OFFSET_Y_UP = 1200 -- 업스크롤: 위쪽에서 얼마나 아래쪽으로 더 떨어진 지점에서 솟아오를지
local ARC_DURATION = 1000      -- [속도 조절] 이 값을 늘릴수록 더 멀리서 천천히 들어옵니다. (1200~1500 추천)
local debugCount = 0

function onEvent(name, value1, value2)
    if name == 'NoteArc' then
        arcActive = (value1 == '1' or value1 == 'true' or value1 == 'on')
    end
end

function onUpdatePost(elapsed)
    if not arcActive then return end

    local isDownscroll = getVar('downScroll')
    local noteCount = getProperty('notes.length')
    if noteCount == nil then return end

    for i = 0, noteCount - 1 do
        if getPropertyFromGroup('notes', i, 'exists') then
            local strumTime = getPropertyFromGroup('notes', i, 'strumTime')
            local timeLeft = strumTime - getSongPosition()

            -- 대각선 연출 시작 범위보다 멀리 있는 노트는 미리 숨김 (기존 방식으로 내려오는 것 방지)
            if timeLeft > ARC_DURATION then
                setPropertyFromGroup('notes', i, 'visible', false)
            elseif timeLeft >= 0 and timeLeft <= ARC_DURATION then
                -- 연출 구간에 진입하면 보이기
                setPropertyFromGroup('notes', i, 'visible', true)

                local noteData = getPropertyFromGroup('notes', i, 'noteData')
                local mustPress = getPropertyFromGroup('notes', i, 'mustPress')
                local strumIndex = noteData + (mustPress and 4 or 0)

                local targetX = getPropertyFromGroup('strumLineNotes', strumIndex, 'x')
                local targetY = getPropertyFromGroup('strumLineNotes', strumIndex, 'y')

                local t = 1 - (timeLeft / ARC_DURATION)
                local x, y

                if isDownscroll then
                    -- 다운스크롤: 포물선 이동
                    x = targetX
                    y = targetY - ARC_HEIGHT_DOWN * (4 * t * (1 - t))
                else
                    -- 업스크롤: t를 직접 곱하여 등속 직선 이동
                    local spawnOffsetX = (noteData < 2) and -200 or 200
                    
                    local spawnX = targetX + spawnOffsetX
                    local spawnY = targetY + SPAWN_OFFSET_Y_UP
                    x = spawnX + (targetX - spawnX) * t
                    y = spawnY + (targetY - spawnY) * t
                end

                setPropertyFromGroup('notes', i, 'x', x)
                setPropertyFromGroup('notes', i, 'y', y)
            end
        end
    end
end