package;

import flixel.util.FlxColor;

class Color
{
	public static function fstr(hexStr:String):FlxColor
	{
		return FlxColor.fromString(hexStr);
	}
}
