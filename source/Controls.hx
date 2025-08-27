package;

import flixel.FlxG;
import flixel.input.keyboard.FlxKey;
import haxe.Json;
import haxe.exceptions.NotImplementedException;
import lime.utils.Assets;

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
	public var publicPath:Null<String>;

	public function new(pPath:Null<String> = null)
	{
		publicPath = pPath;
	}

	public function save(path:Null<String> = null) {}

	public function load(path:Null<String> = null)
	{
		trace('[CONTROLS SAVE] Loading "$path" controls preference file');

		var saveFile:ControlsPreferenceFile;

		try
		{
			saveFile = Json.parse(Assets.getText(path));
		}
		catch (e)
		{
			saveFile = null;
			trace('[CONTROLS SAVE] LOADING ERROR: "${e.message}"');
		}

		if (saveFile != null)
		{
			Controls.controls.set('game_up', saveFile.game_up);
			Controls.controls.set('game_down', saveFile.game_down);
			Controls.controls.set('game_pause', saveFile.game_pause);

			Controls.controls.set('ui_up', saveFile.ui_up);
			Controls.controls.set('ui_left', saveFile.ui_left);
			Controls.controls.set('ui_down', saveFile.ui_down);
			Controls.controls.set('ui_right', saveFile.ui_right);

			save(path);
		}
	}
}

typedef ControlsPreferenceFile =
{
	var game_up:Array<FlxKey>;
	var game_down:Array<FlxKey>;
	var game_pause:Array<FlxKey>;

	var ui_up:Array<FlxKey>;
	var ui_left:Array<FlxKey>;
	var ui_down:Array<FlxKey>;
	var ui_right:Array<FlxKey>;
}
