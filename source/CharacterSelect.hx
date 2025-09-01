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
		reos.loadGraphic('game/img/character-select/chars/reos-idle.png');
		for (mod in ModManager.MOD_IDS)
		{
			#if sys
			if (FileSystem.exists('game/${ModManager.MODS_FOLDER}/$mod/img/character-select/reos-idle.png'))
				reos.loadGraphic('game/${ModManager.MODS_FOLDER}/$mod/img/character-select/reos-idle.png', true, 48, 48);
			#end
		}
		reos.screenCenter();
		reos.x -= reos.width / 2;
		add(reos);

		habo = new FlxSprite();
		habo.loadGraphic('game/img/character-select/chars/habo-idle.png');
		for (mod in ModManager.MOD_IDS)
		{
			#if sys
			if (FileSystem.exists('game/${ModManager.MODS_FOLDER}/$mod/img/character-select/habo-idle.png'))
				habo.loadGraphic('game/${ModManager.MODS_FOLDER}/$mod/img/character-select/habo-idle.png', true, 48, 48);
			#end
		}
		habo.screenCenter();
		habo.x += habo.width / 2;
		add(habo);

		ScriptManager.call('onCreate', false);
	}
}
