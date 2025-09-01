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

		FlxG.watch.addQuick('PVSD', player_vertical_speed_divider);
	}
}
