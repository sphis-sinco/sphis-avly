package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;

class CharacterSelect extends FlxState
{
	public static var reos:FlxSprite;
	public static var habo:FlxSprite;

	override function create()
	{
		super.create();

		reos = new FlxSprite();
		reos.antialiasing = true;
		add(reos);

		habo = new FlxSprite();
		habo.antialiasing = true;
		add(habo);

		ScriptManager.call('onCreate');
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);
		ScriptManager.call('onUpdate', elapsed);

		reos.loadGraphic(Paths.getGamePath('img/character-select/chars/reos-idle.png'));
		reos.screenCenter();
		reos.x -= reos.width / 2;

		habo.loadGraphic(Paths.getGamePath('img/character-select/chars/habo-idle.png'));
		habo.screenCenter();
		habo.x += habo.width / 1.5;

		if (FlxG.mouse.overlaps(reos))
		{
			reos.loadGraphic(Paths.getGamePath('img/character-select/chars/reos-selected.png'));
			PlayState.player_character = Characters.NORMAL_DIFF;
		}
		if (FlxG.mouse.overlaps(habo))
		{
			habo.loadGraphic(Paths.getGamePath('img/character-select/chars/habo-selected.png'));
			PlayState.player_character = Characters.HARD_DIFF;
		}
	}
}
