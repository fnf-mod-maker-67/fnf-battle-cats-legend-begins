function onEvent(name, value1, value2)
	if name == "fade" then
		local a, b = value2:match("%s*(%S+)%s*,%s*(%S+)%s*")
		
		if b == "out" then
			b = false
		elseif b == "in" then
			b = true
		end
		
		local fadeInfo = {a, b}
		runHaxeCode("FlxG.camera.fade(FlxColor.fromString('" .. value1 .. "'), " .. fadeInfo[1] .. ", " .. tostring(fadeInfo[2]) .. ", null, true);")
	end
end