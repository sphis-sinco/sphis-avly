package;

import Controls.ControlsSave;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxMath;

class PlayState extends FlxState
{
	public static var player:FlxSprite;
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

	public static var bulletGroup:FlxTypedGroup<FlxSprite> = new FlxTypedGroup<FlxSprite>();
	public static var bulletSpawnCondition:Dynamic;
	public static var bulletMove:Dynamic;

	override public function new()
	{
		super();
	}

	override public function create()
	{
		super.create();

		player = new FlxSprite();
		player.makeGraphic(48, 48, Color.fstr('0xff0000'));

		player.screenCenter(Y);
		player.x = player.width * 1.5;

		add(player);

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

		ScriptManager.call('onCreate');
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
		newBullet.makeGraphic(16, 8, Color.fstr('0xffff00'));

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
