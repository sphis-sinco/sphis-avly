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
	public static var player_character:String;
	public static var player_vertical_speed_divider:Float = 10;

	public static var player_min_speed:Float = 10;
	public static var player_max_speed:Float = 5;

	public static var player_moving_up:Bool;
	public static var player_moving_down:Bool;

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
		player.loadGraphic(Paths.getGamePath('img/characters/$player_character.png'), true, 48, 48);
		player.animation.add('fly', [0, 1], 8);
		player.animation.play('fly');

		player.screenCenter(Y);
		player.x = player.width * 1.5;

		player.scale.set(2, 2);

		add(player);

		bulletGroup = new FlxTypedGroup<FlxSprite>();
		add(bulletGroup);

		Controls.save = new ControlsSave(Paths.getGamePath('preferences/controls.json'));
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

		player_moving_up = Controls.getControlPressed('game_up');
		player_moving_down = Controls.getControlPressed('game_down');

		ScriptManager.call('onUpdate', elapsed);

		if (player_moving_up && player.y > player.height)
			player.y -= player.width / player_vertical_speed_divider;
		if (player_moving_down && player.y < FlxG.height - (player.height * 2))
			player.y += player.width / player_vertical_speed_divider;

		if (player_moving_down || player_moving_up)
		{
			player_vertical_speed_divider = FlxMath.lerp(player_vertical_speed_divider, player_max_speed, (1 / player_min_speed));
		}
		else
		{
			player_vertical_speed_divider = FlxMath.lerp(player_vertical_speed_divider, player_min_speed, (1 / player_max_speed));
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
		newBullet.loadGraphic(Paths.getGamePath('img/bullet.png'));

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
