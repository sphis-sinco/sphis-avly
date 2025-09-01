import flixel.FlxG;

function onCreate()
{
	PlayState.bulletSpawnCondition = function()
	{
		if (PlayState.player_character == Characters.NORMAL_DIFF)
			return FlxG.random.bool(FlxG.random.float(0, 5));
		else
			return FlxG.random.bool(FlxG.random.float(0, 15));
	}
}
