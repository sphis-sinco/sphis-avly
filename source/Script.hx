package;

class Script
{
	public static function isDebug():Bool
		return #if debug true #else false #end;
}
