local isAlphaTween = false

function onUpdate(elapsed)
	if isAlphaTween == true then
		local curHealth = getHealth() / 2
		for i = 4, 7 do
            setPropertyFromGroup('strumLineNotes', i, 'alpha', curHealth)
        end
	end
end

function onEvent(name, value1, value2)
	if name == "AlphaIsHealth" then
		if value1 == 'start' then
			isAlphaTween = true
		elseif value1 == 'end' then
			isAlphaTween = false
			for i = 4, 7 do
				setPropertyFromGroup('strumLineNotes', i, 'alpha', 1)
			end
		end
	end
end
		