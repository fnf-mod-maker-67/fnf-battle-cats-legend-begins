function onCreate()
	-- 배경 이미지 생성 (태그명, 이미지 파일명, x좌표, y좌표)
	makeLuaSprite('noul_bg', 'noul', -650, -450);
	setScrollFactor('noul_bg', 0.7, 0.7);
	scaleObject('noul_bg', 3, 3); -- 화면 크기에 맞춰 조절 가능
	initLuaShader('RTXLighting')
	setSpriteShader('noul_bg', 'RTXLighting')
	
	addLuaSprite('noul_bg', false); -- 캐릭터 뒤에 배치
	setVar('bgSpriteList', (getVar('bgSpriteList') or '') .. 'noul_bg,')
end
