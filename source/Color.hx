package;

import flixel.util.FlxColor;

class Color
{
	// why do I wanna make a cache system for commonly used colors?
	public static function fstr(hexStr:String):FlxColor
	{
		return FlxColor.fromString(hexStr);
	}
}
