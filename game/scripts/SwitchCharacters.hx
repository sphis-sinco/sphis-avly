import events.UpdateEvent;
import flixel.FlxG;

function onUpdate(event:UpdateEvent)
{
	if (FlxG.keys.justReleased.R && Script.isDebug())
	{
		if (PlayState.player_character == Characters.NORMAL_DIFF)
			PlayState.player_character = Characters.HARD_DIFF;
		else
			PlayState.player_character = Characters.NORMAL_DIFF;

		FlxG.resetState();
	}
}
