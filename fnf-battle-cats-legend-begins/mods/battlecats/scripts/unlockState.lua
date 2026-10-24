local debugger = false
local id = loadedSongPath .. difficultyPath

function onEndSong()
	if (id == "identity-crisis-chapter2") then
		unlockState("mission")
	end
	
	if (id == "identity-crisis-chapter1") then
		unlockState("freeplay")
	end
	
	if (id == "identity-crisis-chapter3") then
		unlockState("charselect")
	end
end

function onCreate()
	if (debugger ~= true) then
		return Function_Stop
	end
	if (id == "newtorial-tutorial") then
		unlockState("freeplay")
	end
end