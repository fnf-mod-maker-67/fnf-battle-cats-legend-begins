import flixel.text.FlxText.FlxTextBorderStyle;
import flixel.text.FlxText.FlxTextFormat; // 추가: 색상 포맷 클래스
import flixel.math.FlxMath;
import backend.Language;
import backend.Highscore;

var rewardTxt:String = '';
var victoryDone:Bool = false;

var highestCombo:Int = 0;
var misses:Int = songMisses;
var rating:Float = ratingPercent * 100;

function onRecalculateRating() { // 추가: 매 판정마다 최대 콤보 갱신
	if (PlayState.instance.combo > highestCombo) highestCombo = PlayState.instance.combo;
}

function onCreate() {
	setVar('rewards', []);
	var hasHighscore:Bool = Highscore.getScore(PlayState.SONG.song, PlayState.storyDifficulty) > 0;
	setVar('isFirst', !hasHighscore);
}

function onEndSong() {
	if (victoryDone) return Function_Continue;

	callOnScripts('onRewardCalc'); // 보상 스크립트들 먼저 실행
	CustomSubstate.openCustomSubstate('victory', true);
	return Function_Stop;
}

function showErrorAndFreeze(msg:String) {
	FlxG.sound.music.pause();

	var errTxt:FlxText = new FlxText(0, 0, FlxG.width, "ERROR:\n" + msg);
	errTxt.setFormat(Paths.font("vcr.ttf"), 20, FlxColor.RED, 'center');
	errTxt.screenCenter();
	errTxt.cameras = [camOther]; // 항상 보이는 카메라에
	PlayState.instance.add(errTxt);

	// 강제로 아무것도 안 넘어가게 무한 대기
	PlayState.instance.persistentUpdate = false;
}

function onCustomSubstateCreate(name:String) {
	misses = songMisses;
	rating = FlxMath.roundDecimal(ratingPercent * 100, 2);
	
	camGame.stopFX();
	camHUD.stopFX();
	camOther.stopFX();
	
	if (name != 'victory') return;
	camHUD.visible = false;

	rewardTxt = '';

	var mySprite:FlxSprite = new FlxSprite(0, 0);
	mySprite.loadGraphic(Paths.image('endsong/win'));
	mySprite.screenCenter();
	mySprite.y -= 150;
	customSubstate.add(mySprite);
	mySprite.antialiasing = true;
	
	var xpTextBar:FlxSprite = new FlxSprite(0, 0).loadGraphic(Paths.image('endsong/xpTextBar')).screenCenter();
	customSubstate.add(xpTextBar);
	
	var missStr:String = Language.getPhrase('endingwin_miss', 'Miss: ');
	var ratingStr:String = Language.getPhrase('endingwin_rating', 'Rating: ');
	var comboStr:String = Language.getPhrase('endingwin_combo', 'Max Combo: ');
	var xpText:String = missStr + misses + "    /    " + ratingStr + rating + "%    /    " + comboStr + highestCombo;
	
	var xpTextTxt:FlxText = new FlxText(0,0, FlxG.width, xpText).screenCenter();
	xpTextTxt.setFormat(Paths.font("vcr.ttf"), 25, FlxColor.WHITE, 'center');
	xpTextTxt.setBorderStyle(FlxTextBorderStyle.OUTLINE, FlxColor.BLACK, 2);
	xpTextTxt.bold = true;
	xpTextTxt.antialiasing = true;
	xpTextTxt.y -= 10;

	var firstSlash:Int = xpText.indexOf('/');
	var secondSlash:Int = xpText.indexOf('/', firstSlash + 1);

	if (firstSlash != -1 && secondSlash != -1) {
		xpTextTxt.addFormat(new FlxTextFormat(FlxColor.RED), 0, firstSlash);
		xpTextTxt.addFormat(new FlxTextFormat(FlxColor.CYAN), firstSlash, secondSlash);
		xpTextTxt.addFormat(new FlxTextFormat(FlxColor.YELLOW), secondSlash, xpText.length);
	}

	customSubstate.add(xpTextTxt);

	var rewards:Array<String> = getVar('rewards');

	if (rewards != null && rewards.length > 0) {
		var step:Int = 0;
		for (reward in rewards) {
			rewardTxt += reward;
			step += 1;
			if (step == 2) {
				step = 0;
				rewardTxt += '\n';
			}
		}

		var rewardBox:FlxSprite = new FlxSprite(0, 0);
		rewardBox.loadGraphic(Paths.image('endsong/rewards'));
		rewardBox.x = (FlxG.width - rewardBox.width) / 2;
		rewardBox.antialiasing = true;
		var h:Float = rewardBox.height;
		rewardBox.y = FlxG.height * 0.75 - h / 2;
		customSubstate.add(rewardBox);

		var myText:FlxText = new FlxText(0, 0, FlxG.width, rewardTxt, 20);
		myText.setFormat(Paths.font("title.otf"), 20, FlxColor.WHITE, 'center');
		myText.setBorderStyle(FlxTextBorderStyle.OUTLINE, FlxColor.BLACK, 5);
		myText.borderSize = 5;
		myText.y = rewardBox.y + (h - myText.height) / 2;
		myText.antialiasing = true;
		customSubstate.add(myText);
	}
}

function onCustomSubstateUpdate(name:String, elapsed:Float) {
	if (name != 'victory') return;
	if (controls.ACCEPT) {
		victoryDone = true;
		CustomSubstate.closeCustomSubstate();
		game.endSong();
	}
}
