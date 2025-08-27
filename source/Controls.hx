package;

import flixel.FlxG;
import flixel.input.keyboard.FlxKey;
import haxe.exceptions.NotImplementedException;

class Controls
{
	public static var controls:Map<String, Array<FlxKey>> = [
		// game_
		'game_up' => [UP, W],
		'game_down' => [DOWN, S],
		'game_pause' => [ENTER, ESCAPE],
		// ui_
		'ui_up' => [UP, W],
		'ui_left' => [LEFT, A],
		'ui_down' => [DOWN, S],
		'ui_right' => [RIGHT, D]
	];

	public static var save:ControlsSave;

	public static function getControlPressed(controlKey:String):Bool
	{
		return FlxG.keys.anyPressed(controls.get(controlKey));
	}

	public static function getControlJustReleased(controlKey:String):Bool
	{
		return FlxG.keys.anyJustReleased(controls.get(controlKey));
	}

	public static function getControlJustPressed(controlKey:String):Bool
	{
		return FlxG.keys.anyJustPressed(controls.get(controlKey));
	}
}

class ControlsSave
{
	public function save(path:String)
	{
		trace(new NotImplementedException('ControlsSave "save(${path})" unimplemented'));
	}

	public function load(path:String)
	{
		trace(new NotImplementedException('ControlsSave "load(${path})" unimplemented'));

		save(path);
	}
}
