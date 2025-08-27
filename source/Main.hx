package;

import flixel.FlxGame;
import openfl.display.Sprite;

class Main extends Sprite
{
	public function new()
	{
		super();

		Controls.save.load('game/preferences/controls.json');

		addChild(new FlxGame(0, 0, PlayState));
	}
}
