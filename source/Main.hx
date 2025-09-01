package;

import flixel.FlxGame;
import flixel.system.FlxModding;
import openfl.display.Sprite;

class Main extends Sprite
{
	public function new()
	{
		super();

		ScriptManager.loadAllScripts();
		addChild(new FlxGame(0, 0, PlayState));
	}
}
