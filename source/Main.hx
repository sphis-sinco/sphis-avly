package;

import flixel.FlxGame;
import modding.PolymodHandler;
import openfl.display.Sprite;

class Main extends Sprite
{
	public function new()
	{
		super();

		PolymodHandler.loadAllMods();

		addChild(new FlxGame(0, 0, PlayState));
	}
}
