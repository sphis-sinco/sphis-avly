package;

import flixel.FlxG;

class Script
{
	public static var state(get, never):String;

	static function get_state():String
	{
		return Type.getClassName(Type.getClass(FlxG.state)).split(".").pop();
	}

	public static function isDebug():Bool
		return #if debug true #else false #end;
}
