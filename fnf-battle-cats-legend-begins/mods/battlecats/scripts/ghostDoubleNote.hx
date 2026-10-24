// Credits: MelodyTheFelony, Unbekannt0
// Inspired by: https://gamebanana.com/mods/500551

var ghostDistance:Float = 120;
var ghostOutTime:Float = 0.15;
var ghostDelay:Float = 0.1;
var ghostReturnTime:Float = 0.50;
var ghostAlpha:Float = 0.40;

var passDirectionBF:Int = -1;
var passDirectionDad:Int = -1;
var passDirectionGF:Int = -1;

var bfTimer:FlxTimer = null;
var dadTimer:FlxTimer = null;
var gfTimer:FlxTimer = null;

var bfCanGhost:Bool = true;
var dadCanGhost:Bool = true;
var gfCanGhost:Bool = true;

// Utility
function isFlip(charName:String):Bool {
    return charName != null && charName.length >= 5 && charName.substr(charName.length - 5, 5) == "-flip";
}

// BF
function goodNoteHit(note) {
    if (note.isSustainNote || note.noAnimation) return;

    var mainNote = note.noteData;
	var isGFDuet = note.noteType == "GF Duet";

	if (passDirectionBF != -1 && bfCanGhost) {
		var ghostNote = passDirectionBF;

		if (ghostNote == mainNote) {
			ghostNote = ((ghostNote - 4 + 1) % 4) + 4;
		}

		spawnGhostBF(ghostNote, 1); // normal direction

		if (isGFDuet && game.gf != null) {
			spawnGhostGF(ghostNote, 1); // match BF direction
		}

		bfCanGhost = false;
		new FlxTimer().start(0.1, function(_) {
			bfCanGhost = true;
		});
	}

    passDirectionBF = mainNote;

    if (bfTimer != null) bfTimer.cancel();
    bfTimer = new FlxTimer().start(0.03, function(_) {
        passDirectionBF = -1;
        bfTimer = null;
    });
}

// DAD
function opponentNoteHit(note) {
    if (note.isSustainNote || note.noAnimation) return;

    var mainNote = note.noteData;
	var isGFDuet = note.noteType == "GF Duet";

	if (!note.gfNote && passDirectionDad != -1 && dadCanGhost) {
		var ghostNote = passDirectionDad;
		if (ghostNote == mainNote) ghostNote = (ghostNote + 1) % 4;

		spawnGhostDad(ghostNote, -1);

		if (isGFDuet && game.gf != null) {
			spawnGhostGF(ghostNote, -1); // match DAD direction
		}

		dadCanGhost = false;
		new FlxTimer().start(0.1, function(_) {
			dadCanGhost = true;
		});
	}

    if (!note.gfNote) {
        passDirectionDad = mainNote;
        if (dadTimer != null) dadTimer.cancel();
        dadTimer = new FlxTimer().start(0.03, function(_) {
            passDirectionDad = -1;
            dadTimer = null;
        });
    }

// GF
    if (note.gfNote && game.gf != null && passDirectionGF != -1 && gfCanGhost) {
        var ghostNote = passDirectionGF;
        if (ghostNote == mainNote) ghostNote = (ghostNote + 1) % 4;
        spawnGhostGF(ghostNote, -1);

        gfCanGhost = false;
        new FlxTimer().start(0.1, function(_) {
            gfCanGhost = true;
        });
    }

    if (note.gfNote && game.gf != null) {
        passDirectionGF = mainNote;
        if (gfTimer != null) gfTimer.cancel();
        gfTimer = new FlxTimer().start(0.03, function(_) {
            passDirectionGF = -1;
            gfTimer = null;
        });
    }
}

function getGhostColor(char:Dynamic):Int {
    var arr = char.healthColorArray;
    return (arr[0] << 16) | (arr[1] << 8) | arr[2];
}

// GHOST SPAWN FUNCTIONS
// BF
function spawnGhostBF(ghostNote:Int) {
    var ghost = new Character(game.boyfriend.x, game.boyfriend.y, game.boyfriend.curCharacter, true);
    game.addBehindBF(ghost);

    var baseX = game.boyfriend.getMidpoint().x - game.boyfriend.width / 2;
    var baseY = game.boyfriend.getMidpoint().y - game.boyfriend.height / 2;

    ghost.setPosition(baseX, baseY);
    ghost.playAnim(game.singAnimations[ghostNote], true);
    ghost.alpha = ghostAlpha;
    ghost.color = getGhostColor(game.boyfriend);

    var moveDir = isFlip(game.boyfriend.curCharacter) ? -1 : 1;

    FlxTween.tween(ghost, { x: baseX + (ghostDistance * moveDir) }, ghostOutTime, {
        ease: FlxEase.sineOut,
        onComplete: function(_) {
            new FlxTimer().start(ghostDelay, function(_) {
                FlxTween.tween(ghost, {
                    x: baseX,
                    alpha: 0
                }, ghostReturnTime, {
                    ease: FlxEase.quartIn,
                    onComplete: function(_) {
                        ghost.destroy();
                    }
                });
            });
        }
    });
}

// DAD
function spawnGhostDad(ghostNote:Int) {
    var ghost = new Character(game.dad.x, game.dad.y, game.dad.curCharacter);
    game.addBehindDad(ghost);

    var baseX = game.dad.getMidpoint().x - game.dad.width / 2;
    var baseY = game.dad.getMidpoint().y - game.dad.height / 2;

    ghost.setPosition(baseX, baseY);
    ghost.playAnim(game.singAnimations[ghostNote], true);
    ghost.alpha = ghostAlpha;
    ghost.color = getGhostColor(game.dad);

    var moveDir = isFlip(game.dad.curCharacter) ? 1 : -1;

    FlxTween.tween(ghost, { x: baseX + (ghostDistance * moveDir) }, ghostOutTime, {
        ease: FlxEase.sineOut,
        onComplete: function(_) {
            new FlxTimer().start(ghostDelay, function(_) {
                FlxTween.tween(ghost, {
                    x: baseX,
                    alpha: 0
                }, ghostReturnTime, {
                    ease: FlxEase.quartIn,
                    onComplete: function(_) {
                        ghost.destroy();
                    }
                });
            });
        }
    });
}

// GF
function spawnGhostGF(ghostNote:Int, dir:Int = -1) {
    var ghost = new Character(game.gf.x, game.gf.y, game.gf.curCharacter);
    game.addBehindGF(ghost);

    var baseX = game.gf.getMidpoint().x - game.gf.width / 2;
    var baseY = game.gf.getMidpoint().y - game.gf.height / 2;

    ghost.setPosition(baseX, baseY);
    ghost.playAnim(game.singAnimations[ghostNote], true);
    ghost.alpha = ghostAlpha;
    ghost.color = getGhostColor(game.gf);

    FlxTween.tween(ghost, { x: baseX + (ghostDistance * dir) }, ghostOutTime, {
        ease: FlxEase.sineOut,
        onComplete: function(_) {
            new FlxTimer().start(ghostDelay, function(_) {
                FlxTween.tween(ghost, {
                    x: baseX,
                    alpha: 0
                }, ghostReturnTime, {
                    ease: FlxEase.quartIn,
                    onComplete: function(_) {
                        ghost.destroy();
                    }
                });
            });
        }
    });
}