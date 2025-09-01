package;

import Controls.ControlsSave;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxMath;
import sys.FileSystem;

class PlayState extends FlxState
{
	public static var player:FlxSprite;
	public static var player_character:String;
	public static var player_vertical_speed_divider:Float = 10;

	public static var player_moving_up(get, never):Bool;

	static function get_player_moving_up():Bool
	{
		return Controls.getControlPressed('game_up');
	}

	public static var player_moving_down(get, never):Bool;

	static function get_player_moving_down():Bool
	{
		return Controls.getControlPressed('game_down');
	}

	public static var bulletGroup:FlxTypedGroup<FlxSprite>;
	public static var bulletSpawnCondition:Dynamic;
	public static var bulletMove:Dynamic;

	override public function new()
	{
		super();
	}

	override public function create()
	{
		super.create();

		if (player_character == null)
			player_character = Characters.NORMAL_DIFF;

		player = new FlxSprite();
		player.loadGraphic('game/img/characters/$player_character.png', true, 48, 48);
		for (mod in ModManager.MOD_IDS)
		{
			#if sys
			if (FileSystem.exists('game/${ModManager.MODS_FOLDER}/$mod/img/characters/$player_character.png'))
				player.loadGraphic('game/${ModManager.MODS_FOLDER}/$mod/img/characters/$player_character.png', true, 48, 48);
			#end
		}
		player.animation.add('fly', [0, 1], 8);
		player.animation.play('fly');

		player.screenCenter(Y);
		player.x = player.width * 1.5;

		player.scale.set(2, 2);

		add(player);

		bulletGroup = new FlxTypedGroup<FlxSprite>();
		add(bulletGroup);

		Controls.save = new ControlsSave('game/preferences/controls.json');
		Controls.save.load(Controls.save.publicPath);

		bulletSpawnCondition = function()
		{
			return FlxG.random.bool(FlxG.random.float(0, 15));
		};

		bulletMove = function(bullet:FlxSprite)
		{
			bullet.x -= (bullet.width / 2);

			if (bullet.x < -(bullet.width * 2))
			{
				bullet.destroy();
				bulletGroup.members.remove(bullet);
			}
		};

		ScriptManager.call('onCreate', true);
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);

		ScriptManager.call('onUpdate', elapsed);

		if (player_moving_up && player.y > player.height)
			player.y -= player.width / player_vertical_speed_divider;
		if (player_moving_down && player.y < FlxG.height - (player.height * 2))
			player.y += player.width / player_vertical_speed_divider;

		if (player_moving_down || player_moving_up)
		{
			player_vertical_speed_divider = FlxMath.lerp(player_vertical_speed_divider, 5, (1 / 10));
		}
		else
		{
			player_vertical_speed_divider = FlxMath.lerp(player_vertical_speed_divider, 10, (1 / 5));
		}

		if (bulletSpawnCondition())
		{
			spawnBullet();
		}

		for (bullet in bulletGroup.members)
		{
			bulletMove(bullet);
		}

		FlxG.watch.addQuick('PVSD', player_vertical_speed_divider);
	}

	public static function spawnBullet()
	{
		var newBullet = new FlxSprite();
		newBullet.loadGraphic('game/img/bullet.png');

		for (mod in ModManager.MOD_IDS)
		{
			#if sys
			if (FileSystem.exists('game/${ModManager.MODS_FOLDER}/$mod/img/bullet.png'))
				newBullet.loadGraphic('game/${ModManager.MODS_FOLDER}/$mod/img/bullet.png');
			#end
		}

		newBullet.y = player.y;
		newBullet.y += Math.abs(FlxG.random.float(newBullet.width * -10, newBullet.width * 10));
		newBullet.x = FlxG.width + newBullet.width;

		if (newBullet.y < 0 || newBullet.y > FlxG.height)
		{
			spawnBullet(); // take 2
			return;
		}

		ScriptManager.call('onSpawnBullet', newBullet); // u can do sum shit with it here

		bulletGroup.add(newBullet);
	}
}
