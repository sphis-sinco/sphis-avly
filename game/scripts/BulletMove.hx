import flixel.FlxG;
import flixel.FlxSprite;

function onCreate()
{
	PlayState.bulletMove = function(bullet:FlxSprite)
	{
		if (PlayState.player_character == Characters.NORMAL_DIFF)
			bullet.x -= (bullet.width / 2);
		else
			bullet.x -= (bullet.width / 1.5);

		if (bullet.overlaps(PlayState.player))
			FlxG.switchState(() -> new CharacterSelect());

		if (bullet.x < -(bullet.width * 2))
		{
			bullet.destroy();
			PlayState.bulletGroup.members.remove(bullet);
		}
	}
}
