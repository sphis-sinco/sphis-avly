import flixel.FlxG;

function onUpdate(elapsed:Float)
{
	if (FlxG.keys.justReleased.ENTER)
	{
		FlxG.switchState(() -> new CharacterSelect());
	}
	if (FlxG.keys.justReleased.R && Script.isDebug())
	{
		if (PlayState.player_character == Characters.NORMAL_DIFF)
			PlayState.player_character = Characters.HARD_DIFF;
		else
			PlayState.player_character = Characters.NORMAL_DIFF;

		FlxG.resetState();
	}
}
