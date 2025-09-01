package;

import flixel.FlxSprite;
import flixel.FlxState;
#if sys
import sys.FileSystem;
#end

class CharacterSelect extends FlxState
{
	public static var reos:FlxSprite;
	public static var habo:FlxSprite;

	override function create()
	{
		super.create();

		reos = new FlxSprite();
		reos.loadGraphic(Paths.getGamePath('img/character-select/chars/reos-idle.png'));
		reos.screenCenter();
		reos.x -= reos.width / 2;
		add(reos);

		habo = new FlxSprite();
		habo.loadGraphic(Paths.getGamePath('img/character-select/chars/habo-idle.png'));
		habo.screenCenter();
		habo.x += habo.width / 2;
		add(habo);

		ScriptManager.call('onCreate', false);
	}
}
