package;

import flixel.FlxSprite;
import flixel.FlxState;
import sys.FileSystem;

class CharacterSelect extends FlxState
{
	public static var reos:FlxSprite;

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
		add(reos);

		ScriptManager.call('onCreate', false);
	}
}
