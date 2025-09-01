package;

import sys.FileSystem;

class ModManager
{
	public static var MOD_IDS:Array<String> = [];

	public static var MODS_FOLDER:String = 'game/mods/';

	public static function loadMods()
	{
		#if sys
		for (entry in FileSystem.readDirectory(MODS_FOLDER))
		{
			if (FileSystem.isDirectory(entry))
			{
				for (file in FileSystem.readDirectory('$MODS_FOLDER/$entry')) {}
			}
		}
		#end
	}
}
