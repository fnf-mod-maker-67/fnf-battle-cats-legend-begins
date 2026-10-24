setVar("pass10s", false)
trigger10 = false

function onUpdate()
	if not trigger10 and getSongPosition() >= 10000 then
		trigger10 = true
		setVar("pass10s", true)
		spendEnergy(getVar("energyCost"))
	end
end
