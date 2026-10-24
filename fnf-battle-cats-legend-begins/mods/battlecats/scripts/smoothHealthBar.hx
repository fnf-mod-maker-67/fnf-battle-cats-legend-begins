// Credits: MelodyTheFelony

var healthLerp:Float = 1.0;
function onCreatePost()
    game.healthBar.valueFunction = function() return healthLerp;

function onUpdate(elapsed:Float)
    healthLerp = FlxMath.lerp(healthLerp, game.health, 0.15);