function onEvent(name, value1, value2)
    if name == 'Show image' then
		if value2 == 'show' then
			if value1 == 'pork' then
				makeLuaSprite('pork', 'pork', 0, 500)
				scaleObject('pork', 1.5, 1.5) -- 1.5배 크게
				setObjectCamera('pork', 'game') -- 'game' 또는 'hud'
				addLuaSprite('pork', true)
			end
			if value1 == 'coat' then
				makeLuaSprite('coat', 'coat', 100, 400)
				scaleObject('coat', 1.5, 1.5) -- 1.5배 크게
				setObjectCamera('coat', 'game') -- 'game' 또는 'hud'
				addLuaSprite('coat', true)
			end
			if value1 == 'ele' then
				makeLuaSprite('ele', 'ele', 1600, 500)
				scaleObject('ele', 1.5, 1.5) -- 1.5배 크게
				setObjectCamera('ele', 'game') -- 'game' 또는 'hud'
				addLuaSprite('ele', true)
			end
			if value1 == 'deadbore' then
				makeLuaSprite('deadbore', 'deadbore', -300, 1000)
				scaleObject('deadbore', 1.5, 1.5) -- 1.5배 크게
				setObjectCamera('deadbore', 'game') -- 'game' 또는 'hud'
				addLuaSprite('deadbore', false)
				initLuaShader('RTXLighting')
				setSpriteShader('deadbore', 'RTXLighting')
			end
			if value1 == 'deadAilenHead' then
				makeLuaSprite('deadAilenHead', 'deadAilenHead', 1400, 1000)
				scaleObject('deadAilenHead', 1.5, 1.5) -- 1.5배 크게
				setObjectCamera('deadAilenHead', 'game') -- 'game' 또는 'hud'
				addLuaSprite('deadAilenHead', false)
				initLuaShader('RTXLighting')
				setSpriteShader('deadAilenHead', 'RTXLighting')
			end
		elseif value2 == 'hide' then
            removeLuaSprite(value1, true)
		end
	end
end 
		