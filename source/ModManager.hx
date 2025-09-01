package;

import sys.FileSystem;

class ModManager
{
	public static var MOD_IDS:Array<String> = [];
	public static var MOD_METADATA_FILE:String = 'meta.json';

	public static var MODS_FOLDER:String = 'game/mods';

	public static function loadMods()
	{
		MOD_IDS = [];

		#if sys
		for (entry in FileSystem.readDirectory('$MODS_FOLDER/'))
		{
			if (FileSystem.isDirectory(entry))
			{
				if (FileSystem.readDirectory('$MODS_FOLDER/$entry').contains(MOD_METADATA_FILE))
				{
					MOD_IDS.push(entry);
				}
			}
		}
		#end

		trace('${MOD_IDS.length} valid mods loaded');
	}
}
