import flixel.FlxG;

function onUpdate(elapsed:Float)
{
	if (FlxG.keys.justReleased.ENTER)
	{
		if (Script.state == 'PlayState')
			FlxG.switchState(() -> new CharacterSelect());
		else if (Script.state == 'CharacterSelect')
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
