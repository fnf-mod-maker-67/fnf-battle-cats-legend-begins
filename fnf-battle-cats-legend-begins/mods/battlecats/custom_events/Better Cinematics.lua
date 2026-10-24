--Created by RamenDominoes (I earned this by 초록이)

local HudPieces = {'healthBarBG','healthBar','scoreTxt','iconP1','iconP2','timeBar','timeBarBG','timeTxt'}
local index = 1

function onCreatePost()
	makeLuaSprite('UpperBar', 'empty', -110, -350)
	makeGraphic('UpperBar', 2000, 353, '000000')
	setObjectCamera('UpperBar', 'HUD')
	addLuaSprite('UpperBar', false)

	makeLuaSprite('LowerBar', 'empty', -110, 720)
	makeGraphic('LowerBar', 2000, 353, '000000')
	setObjectCamera('LowerBar', 'HUD')
	addLuaSprite('LowerBar', false)

	UpperBar = getProperty('UpperBar.y')
	LowerBar = getProperty('LowerBar.y')
	StrumY = defaultPlayerStrumY0
end

function onEvent(name, value1, value2)
	if name == 'Better Cinematics' then
		local Speed = tonumber(value1)
		local Distance = tonumber(value2)

		if Distance > 0 then
			if downscroll then
				doTweenY('Cinematics1', 'UpperBar', UpperBar + Distance, Speed, 'QuadOut')
				doTweenY('Cinematics2', 'LowerBar', LowerBar - Distance, Speed, 'QuadOut')

				for Tweens = 0, 7 do
					noteTweenY('leftBF'..Tweens, Tweens, (StrumY - Distance) + 0, Speed, 'QuadOut')
				end
			else
				doTweenY('Cinematics1', 'UpperBar', UpperBar + Distance, Speed, 'QuadOut')
				doTweenY('Cinematics2', 'LowerBar', LowerBar - Distance, Speed, 'QuadOut')

				for Tweens = 0, 7 do
					noteTweenY('leftBF'..Tweens, Tweens, (StrumY + Distance) - 0, Speed, 'QuadOut')
				end
			end

			for Alphas = 1, 8 do
				doTweenAlpha('Alpha'..Alphas, HudPieces[index], 0, Speed - 0.1)
				index = index + 1
				if index > #HudPieces then
					index = 1
				end
			end

		else -- Distance <= 0, exit
			doTweenY('Cinematics1', 'UpperBar', UpperBar, Speed, 'QuadIn')
			doTweenY('Cinematics2', 'LowerBar', LowerBar, Speed, 'QuadIn')

			for Tweens = 0, 7 do
				noteTweenY('leftBF'..Tweens, Tweens, (StrumY - Distance) + 10, Speed, 'QuadIn')
			end

			for Alphas = 1, 8 do
				doTweenAlpha('Alpha'..Alphas, HudPieces[index], 1, Speed + 0.1)
				index = index + 1
				if index > #HudPieces then
					index = 1
				end
			end
		end
	end
end