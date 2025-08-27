package;

import Controls.ControlsSave;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxMath;
import modding.PolymodHandler;

class PlayState extends State
{
	public var player:FlxSprite;
	public var player_vertical_speed_divider:Float = 10;

	public var player_last_dir:Int = 0;
	public var player_dir:Int = 0;

	public var player_moving_up(get, never):Bool;

	function get_player_moving_up():Bool
	{
		return Controls.getControlPressed('game_up');
	}

	public var player_moving_down(get, never):Bool;

	function get_player_moving_down():Bool
	{
		return Controls.getControlPressed('game_down');
	}

	public var bulletGroup:FlxTypedGroup<FlxSprite> = new FlxTypedGroup<FlxSprite>();

	override public function new()
	{
		super();
	}

	override public function create()
	{
		super.create();

		PolymodHandler.loadAllMods();

		player = new FlxSprite();
		player.makeGraphic(48, 48, Color.fstr('0xff0000'));

		player.screenCenter(Y);
		player.x = player.width * 1.5;

		add(player);

		add(bulletGroup);

		Controls.save = new ControlsSave('game/preferences/controls.json');
		Controls.save.load(Controls.save.publicPath);
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);

		if (FlxG.keys.justReleased.F5)
		{
			FlxG.resetGame();
		}

		player_last_dir = player_dir;
		player_dir = 0;

		if (player_moving_up && player.y > player.height)
		{
			player_dir = 1;
			player.y -= player.width / player_vertical_speed_divider;
		}
		if (player_moving_down && player.y < FlxG.height - (player.height * 2))
		{
			player_dir = -1;
			player.y += player.width / player_vertical_speed_divider;
		}

		if (player_moving_down || player_moving_up)
		{
			player_vertical_speed_divider = FlxMath.lerp(player_vertical_speed_divider, 5, (1 / 10));
		}
		else
		{
			player_vertical_speed_divider = FlxMath.lerp(player_vertical_speed_divider, 10, (1 / 5));
		}

		FlxG.watch.addQuick('PVSD', player_vertical_speed_divider);
	}
}
