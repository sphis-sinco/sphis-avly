package;

import sys.FileSystem;

class ModManager
{
	public static var MOD_IDS:Array<String> = [];
	public static var MOD_METADATA_FILE:String = 'meta.json';

	public static var MODS_FOLDER:String = 'mods';

	public static function loadMods()
	{
		MOD_IDS = [];

		#if sys
		if (!FileSystem.exists('game/$MODS_FOLDER/'))
			FileSystem.createDirectory('game/$MODS_FOLDER');

		for (entry in FileSystem.readDirectory('game/$MODS_FOLDER/'))
		{
			if (FileSystem.exists('game/$MODS_FOLDER/$entry/$MOD_METADATA_FILE'))
				MOD_IDS.push(entry);
		}
		#end

		trace('${MOD_IDS.length} valid mods loaded');
	}
}
