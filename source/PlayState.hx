package;

import flixel.FlxSprite;
import flixel.FlxState;
import flixel.group.FlxGroup.FlxTypedGroup;

class PlayState extends FlxState
{
	public var player:FlxSprite;

	public var bulletGroup:FlxTypedGroup<FlxSprite> = new FlxTypedGroup<FlxSprite>();

	override public function create()
	{
		super.create();

		player = new FlxSprite().makeGraphic(48, 48, 0xff0000);
		add(player);

		add(bulletGroup);
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);
	}
}
