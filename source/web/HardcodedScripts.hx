package web;

import flixel.FlxG;
import flixel.FlxSprite;

class HardcodedScripts
{
	public static var BulletMove = function()
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
	public static var BulletSpawnCondition = function()
	{
		PlayState.bulletSpawnCondition = function()
		{
			if (PlayState.player_character == Characters.NORMAL_DIFF)
				return FlxG.random.bool(FlxG.random.float(0, 5));
			else
				return FlxG.random.bool(FlxG.random.float(0, 15));
		}
	};

	public static var PlayerSpeed = function()
	{
		// smaller = faster

		PlayState.player_max_speed = 5;
		PlayState.player_min_speed = 10;

		if (PlayState.player_character == Characters.HARD_DIFF)
		{
			PlayState.player_max_speed = 3;
			PlayState.player_min_speed = 7;
		}
	}

	public static var SwitchCharacters = function()
	{
		if (FlxG.keys.justReleased.ENTER)
		{
			if (Script.state == 'PlayState')
				FlxG.switchState(() -> new CharacterSelect());
			else if (Script.state == 'CharacterSelect')
				FlxG.switchState(() -> new PlayState());
		}
		if (FlxG.mouse.justReleased)
		{
			if (Script.state == 'CharacterSelect')
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

	public static function onCreate()
	{
		#if html5
		BulletMove();
		BulletSpawnCondition();
		PlayerSpeed();
		#end
	}

	public static function onUpdate(elapsed:Float)
	{
		#if html5
		SwitchCharacters();
		#end
	}
}
