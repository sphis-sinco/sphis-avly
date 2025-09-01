import flixel.FlxG;

function onUpdate(elapsed:Float)
{
	if (FlxG.keys.justReleased.ENTER)
	{
		final state = Type.getClassName(Type.getClass(FlxG.state)).split(".").pop();

		if (state == 'PlayState')
			FlxG.switchState(() -> new CharacterSelect());
		else if (state == 'CharacterSelect')
			FlxG.switchState(() -> new PlayState());
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
