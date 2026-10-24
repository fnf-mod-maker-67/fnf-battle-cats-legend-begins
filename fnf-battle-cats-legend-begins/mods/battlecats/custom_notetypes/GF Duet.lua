healthToGive = 0.02

function opponentNoteHit(id, noteData, noteType, isSustainNote)
	if noteType == 'GF Duet' then

		local anim = ''
		if noteData == 0 then anim = 'singLEFT' end
		if noteData == 1 then anim = 'singDOWN' end
		if noteData == 2 then anim = 'singUP' end
		if noteData == 3 then anim = 'singRIGHT' end

		characterPlayAnim('gf', anim, true)

		setProperty('gf.holdTimer', 'game.gf.singDuration')

	end
end

function goodNoteHit(id, noteData, noteType, isSustainNote)
local currentHealth = getProperty('health')
	
	if noteType == 'GF Duet' then

		local anim = ''
		if noteData == 0 then anim = 'singLEFT' end
		if noteData == 1 then anim = 'singDOWN' end
		if noteData == 2 then anim = 'singUP' end
		if noteData == 3 then anim = 'singRIGHT' end

		characterPlayAnim('gf', anim, true)

		setProperty('gf.holdTimer', 'game.gf.singDuration')

		local resultHealth = currentHealth + healthToGive
		
		setProperty('health', resultHealth)
	end
end