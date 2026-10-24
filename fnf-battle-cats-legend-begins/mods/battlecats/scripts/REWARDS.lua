function onRewardCalc()
	if not getVar("isFirst") then return end

	local rewards = getVar('rewards')
	local name = loadedSongPath .. '-' .. difficultyName

	if name == "identity-crisis-chapter3" then
		addLS(4)
		table.insert(rewards, "LeaderShip + 4")
		
	elseif name == "identity-crisis-chapter1" or name == "identity-crisis-chapter2" then
		addLS(2)
		table.insert(rewards, "LeaderShip + 2")
		
	elseif name == "future-moon-chapter1" then
		addLS(3)
		table.insert(rewards, "LeaderShip + 3")
	else
		addLS(0)
	end
	
	addMaxEnergy(10)
	table.insert(rewards, "Max Energy + 10")
	
	setVar('rewards', rewards)
end
