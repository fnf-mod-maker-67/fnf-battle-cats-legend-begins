import states.PlayState;
import objects.StrumNote;
import flixel.FlxSprite;

var pSprites:Array<FlxSprite> = [];
var oSprites:Array<FlxSprite> = [];
var pShaders:Array<Dynamic> = [];
var oShaders:Array<Dynamic> = [];
var pSustainEndTime:Array<Float> = [0, 0, 0, 0];
var oSustainEndTime:Array<Float> = [0, 0, 0, 0];

function onCreatePost() {
    var isPixelStage:Bool = PlayState.isPixelStage;
    for (i in 0...4) {
        var pAnim:FlxSprite = new FlxSprite();
        setupSustainSprite(pAnim, i, isPixelStage);
        game.add(pAnim);
        pSprites.push(pAnim);
        var shaderClass = Type.resolveClass('shaders.RGBPalette');
        var pShader = (shaderClass != null) ? Type.createInstance(shaderClass, []) : null;
        if (pShader != null) {
            pAnim.shader = pShader.shader;
            pShaders.push(pShader);
        } else {
            pShaders.push(null);
        }
        var oAnim:FlxSprite = new FlxSprite();
        setupSustainSprite(oAnim, i, isPixelStage);
        game.add(oAnim);
        oSprites.push(oAnim);
        var oShader = (shaderClass != null) ? Type.createInstance(shaderClass, []) : null;
        if (oShader != null) {
            oAnim.shader = oShader.shader;
            oShaders.push(oShader);
        } else {
            oShaders.push(null);
        }
    }
}

function onCountdownStarted() {
    new FlxTimer().start(0.1, function(tmr:FlxTimer) {
        for (i in 0...4) {
            if (game.playerStrums.members[i] != null && pShaders[i] != null) {
                var strum = game.playerStrums.members[i];
                if (strum.rgbShader != null) {
                    pShaders[i].r = strum.rgbShader.r;
                    pShaders[i].g = strum.rgbShader.g;
                    pShaders[i].b = strum.rgbShader.b;
                }
            }
            if (game.opponentStrums.members[i] != null && oShaders[i] != null) {
                var strum = game.opponentStrums.members[i];
                if (strum.rgbShader != null) {
                    oShaders[i].r = strum.rgbShader.r;
                    oShaders[i].g = strum.rgbShader.g;
                    oShaders[i].b = strum.rgbShader.b;
                }
            }
        }
    });
}

function setupSustainSprite(sprite:FlxSprite, id:Int, isPixel:Bool) {
    sprite.cameras = [game.camHUD];
    sprite.visible = false;
    if (!isPixel) {
        sprite.frames = Paths.getSparrowAtlas('noteSustain/holdCoverShader');
        sprite.animation.addByPrefix('Start', 'holdCoverStart', 24, false);
        sprite.animation.addByPrefix('Loop', 'holdCover0', 24, true);
        sprite.animation.addByPrefix('End', 'holdCoverEnd', 24, false);
        sprite.offset.x = 12;
        sprite.offset.y = -55;
    } else {
        sprite.frames = Paths.getSparrowAtlas('noteSustain/holdCoverPixel');
        sprite.antialiasing = false;
        sprite.scale.set(7, 7);
        sprite.updateHitbox();
        sprite.animation.addByPrefix('Start', 'loop0', 24, false);
        sprite.animation.addByPrefix('Loop', 'loop0', 24, true);
        sprite.animation.addByPrefix('End', 'explode', 24, false);
        sprite.offset.x = -792;
        sprite.offset.y = -185;
    }

    sprite.animation.finishCallback = function(name:String) {
        if (name == 'End') {
            sprite.visible = false;
        } else if (name == 'Start') {
            sprite.animation.play('Loop', true);
        }
    };
}

function goodNoteHit(note:Dynamic) {
    if (note.isSustainNote) {
        var id = note.noteData;
        if (id >= 0 && id < pSprites.length && pSprites[id] != null) {
            pSprites[id].visible = true;
            var parentNote = note.parent != null ? note.parent : note;
            pSustainEndTime[id] = parentNote.strumTime + parentNote.sustainLength;
            if (pSprites[id].animation.curAnim == null || (pSprites[id].animation.curAnim.name != 'Start' && pSprites[id].animation.curAnim.name != 'Loop')) {
                pSprites[id].animation.play('Start', true);
            }
        }
    }
}

function noteMissPress(direction:Int) {
    if (direction >= 0 && direction < pSprites.length && pSprites[direction] != null) {
        if (pSprites[direction].visible && (pSprites[direction].animation.curAnim.name == 'Loop' || pSprites[direction].animation.curAnim.name == 'Start')) {
            pSprites[direction].animation.play('End', true);
            pSustainEndTime[direction] = 0;
        }
    }
}

function opponentNoteHit(note:Dynamic) {
    if (note.isSustainNote) {
        var id = note.noteData;
        if (id >= 0 && id < oSprites.length && oSprites[id] != null) {
            oSprites[id].visible = true;
            var parentNote = note.parent != null ? note.parent : note;
            oSustainEndTime[id] = parentNote.strumTime + parentNote.sustainLength;
            if (oSprites[id].animation.curAnim == null || (oSprites[id].animation.curAnim.name != 'Start' && oSprites[id].animation.curAnim.name != 'Loop')) {
                oSprites[id].animation.play('Start', true);
            }
        }
    }
}

function onUpdate(elapsed:Float) {
    var isPixelStage:Bool = PlayState.isPixelStage;
    var songPos = Conductor.songPosition; 
    for (i in 0...4) {
        if (game.playerStrums.members[i] != null && i < pSprites.length && pSprites[i] != null) {
            var strum = game.playerStrums.members[i];
            var sprite = pSprites[i];
            sprite.alpha = strum.alpha;
            sprite.x = strum.x + (strum.width / 2) - (sprite.width / 2);
            sprite.y = strum.y + (strum.height / 2) - (sprite.height / 2);
            if (sprite.animation.curAnim != null && sprite.animation.curAnim.name == 'Loop') {
                if (songPos >= pSustainEndTime[i] || (strum.animation.curAnim != null && strum.animation.curAnim.name == 'static')) {
                    sprite.animation.play('End', true);
                    pSustainEndTime[i] = 0;
                }
            }

            if (!isPixelStage) {
                if (sprite.animation.curAnim != null) {
                    switch(sprite.animation.curAnim.name) {
                        case 'Loop': sprite.offset.set(11, -53);
                        case 'Start': sprite.offset.set(11, -52);
                        case 'End': sprite.offset.set(8, -54);
                    }
                }
            } else {
                if (sprite.animation.curAnim != null) {
                    switch(sprite.animation.curAnim.name) {
                        case 'Loop': sprite.offset.set(-792, -180);
                        case 'End': sprite.offset.set(-792, -185);
                    }
                }
            }
        }

        if (game.opponentStrums.members[i] != null && i < oSprites.length && oSprites[i] != null) {
            var strum = game.opponentStrums.members[i];
            var sprite = oSprites[i];
            sprite.alpha = strum.alpha;
            sprite.x = strum.x + (strum.width / 2) - (sprite.width / 2);
            sprite.y = strum.y + (strum.height / 2) - (sprite.height / 2);
            if (sprite.animation.curAnim != null && sprite.animation.curAnim.name == 'Loop') {
                if ((oSustainEndTime[i] - songPos) <= 5 || (strum.animation.curAnim != null && strum.animation.curAnim.name == 'static')) {
                    sprite.visible = false;
                    sprite.animation.stop();
                    if (sprite.animation.getByName('End') != null) {
                        sprite.animation.play('End', true);
                        sprite.animation.finish();
                    }
                    oSustainEndTime[i] = 0;
                }
            }
            if (!isPixelStage) {
                if (sprite.animation.curAnim != null) {
                    switch(sprite.animation.curAnim.name) {
                        case 'Loop': sprite.offset.set(11, -53);
                        case 'Start': sprite.offset.set(11, -52);
                    }
                }
            } else {
                if (sprite.animation.curAnim != null) {
                    switch(sprite.animation.curAnim.name) {
                        case 'Loop': sprite.offset.set(-792, -180);
                    }
                }
            }
        }
    }
}