import flixel.FlxG;

function onCreate()
{
	PlayState.bulletSpawnCondition = function()
	{
		return FlxG.random.bool(FlxG.random.float(0, 5));
	}
}
