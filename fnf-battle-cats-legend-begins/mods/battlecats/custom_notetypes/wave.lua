function onSpawnNote(id, noteData, noteType, isSustainNote)
    if noteType == 'wave' then
        setPropertyFromGroup('notes', id, 'texture', 'noteSkins/NOTE_assets-wave')
        -- RGB 쉐이더를 비활성화합니다.
        setPropertyFromGroup('notes', id, 'rgbShader.enabled', false)
        
        -- [수정] 플레이어 노트(mustPress)일 때만 무시 설정 적용
        -- 상대방 라인의 노트라면 ignoreNote를 false로 두어 CPU가 치도록 만듭니다.
        if getPropertyFromGroup('notes', id, 'mustPress') then
            setPropertyFromGroup('notes', id, 'ignoreNote', true)
        else
            setPropertyFromGroup('notes', id, 'ignoreNote', false)
        end
        
        if isSustainNote then
            setPropertyFromGroup('notes', id, 'isSustainNote', false)
        end
    end
end

function onUpdatePost(elapsed)
    local noteCount = getProperty('notes.length')
    for i = 0, noteCount - 1 do
        if getPropertyFromGroup('notes', i, 'noteType') == 'wave' then
            setPropertyFromGroup('notes', i, 'rgbShader.enabled', false)
        end
    end
end

-- 노트를 쳤을 때만 페널티 적용
function goodNoteHit(id, noteData, noteType, isSustainNote)
    if noteType == 'wave' then
        -- 1. 체력 감소 및 화면 흔들림
        cameraShake('game', 0.02, 0.5)
        cameraShake('hud', 0.01, 0.3)
        cameraFlash('hud', '87CEEB', 0.7, true)
		
		
        -- 2. 미스 횟수 증가 및 콤보/정확도 보정
        setProperty('misses', getProperty('misses') + 1)
        setProperty('combo', getProperty('combo') - 1)
        setProperty('sicks', getProperty('sicks') - 1)
        setProperty('totalNotesHit', getProperty('totalNotesHit') - 1)
    end
end