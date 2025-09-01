import flixel.FlxG;

function onUpdate(elapsed:Float)
{
	if (FlxG.keys.justReleased.R)
	{
		if (PlayState.player_character == Characters.NORMAL_DIFF)
			PlayState.player_character = Characters.HARD_DIFF;
		else
			PlayState.player_character = Characters.NORMAL_DIFF;

		FlxG.resetState();
	}
}
