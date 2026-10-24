local tag = 'gfTied'
local hasEvent = false

function onCreatePost()
    local offX = 0
    for i = 0, getProperty('eventNotes.length') - 1 do
        if getPropertyFromGroup('eventNotes', i, 'event') == 'SpawnCharacter' then
            hasEvent = true
            offX = tonumber(getPropertyFromGroup('eventNotes', i, 'value2')) or 0
            break
        end
    end
    if not hasEvent then return end

    makeAnimatedLuaSprite(tag, 'characters/gf-tied', 0 + offX, 500)
    addAnimationByPrefix(tag, 'danceLeft', 'danceLEFT', 24, false)
    addAnimationByPrefix(tag, 'danceRight', 'danceRIGHT', 24, false)
    addLuaSprite(tag, false)
	scaleObject(tag, 0.65, 0.65)
    setProperty(tag .. '.visible', true)

    initLuaShader('RTXLighting')
    setSpriteShader(tag, 'RTXLighting')
end

function onEvent(name, v1, v2)
    if name == 'SpawnCharacter' and hasEvent then
        setProperty(tag .. '.visible', true)
    end
end



function onBeatHit()
    if not hasEvent then return end
    objectPlayAnimation(tag, curBeat % 2 == 0 and 'danceLeft' or 'danceRight', true)
end
function onCountdownTick(counter)
    objectPlayAnimation(tag, counter % 2 == 0 and 'danceLeft' or 'danceRight', true)
end