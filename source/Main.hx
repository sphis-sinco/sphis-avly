package;

import flixel.FlxGame;
import openfl.display.Sprite;

class Main extends Sprite
{
	public function new()
	{
		super();

		ModManager.loadMods();
		ScriptManager.loadAllScripts();
		addChild(new FlxGame(0, 0, PlayState));
	}
}
