function onCreate()
	initLuaShader('RTXLighting')
    -- 1. 맨 뒤 배경 (ForestWall)
    makeLuaSprite('wall', 'BGforest/ForestWall', -600, -300)
    setScrollFactor('wall', 0.2, 0.2)
    addLuaSprite('wall', false)
	setSpriteShader('wall', 'RTXLighting')
    -- 2. 바닥 (ForestFloor)
    makeLuaSprite('floor', 'BGforest/ForestFloor',-1000, 500)
	setProperty('floor.angle', -3.5)
    setScrollFactor('floor', 1.0, 1.0)
    addLuaSprite('floor', false)
	setSpriteShader('floor', 'RTXLighting')
    -- 3. 수풀 1 (ForestBush)
    makeLuaSprite('bush1', 'BGforest/ForestBush', -600, -100)
	setProperty('bush1.scale.x', 2)
    setProperty('bush1.scale.y', 2)
    updateHitbox('bush1')
    setScrollFactor('bush1', 0.9, 0.9)
    addLuaSprite('bush1', false)
	setSpriteShader('bush1', 'RTXLighting')
    -- 4. 수풀 2 (ForestBush2)
    makeLuaSprite('bush2', 'BGforest/ForestBush2', 1500, -100)
	setProperty('bush2.scale.x', 2)
	setProperty('bush2.scale.y', 2)
	updateHitbox('bush2')
    setScrollFactor('bush2', 0.9, 0.9)
    addLuaSprite('bush2', false)
	setSpriteShader('bush2', 'RTXLighting')
	
	-- 레이어
    makeLuaSprite('l', 'BGforest/LAYER', -600, -300)
	setProperty('l.scale.x', 2)
	setProperty('l.scale.y', 2)
	updateHitbox('l')
    setScrollFactor('l', 0, 0)
    addLuaSprite('l', true)
	
	makeLuaSprite('l2', 'BGforest/lay-er', -600, -300)
	setProperty('l2.scale.x', 2)
	setProperty('l2.scale.y', 2)
	updateHitbox('l2')
    setScrollFactor('l2', 0, 0)
    addLuaSprite('l2', true)
end

function onUpdate(elapsed)	
    local songPos = getSongPosition()
    -- Bush3는 원래 계획대로 흔들기
    setProperty('bush3.angle', math.sin(songPos / 1000) * 10)
    
    -- 나머지 수풀들도 아주 미세하게(2~3도)만 따로 흔들어보세요
    setProperty('bush1.angle', math.sin(songPos / 1200) * 5)
    setProperty('bush2.angle', math.sin(songPos / 800) * -4)
end

function onUpdatePost()
    local top = math.max(
        getObjectOrder('boyfriendGroup'),
        getObjectOrder('dadGroup'),
        getObjectOrder('gfGroup'),
        getObjectOrder('gfTied')
    )
    setObjectOrder('l', top + 1)
    setObjectOrder('l2', top + 2)
end