package;

import haxe.Json;
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
			var meta:ModMeta;
			try
			{
				meta = Json.parse('game/$MODS_FOLDER/$entry/$MOD_METADATA_FILE');
			}
			catch (e)
			{
				meta = null;
			}

			if (meta != null)
				MOD_IDS.push(entry);
		}
		#end

		trace('${MOD_IDS.length} valid mods loaded');
		if (MOD_IDS.length > 0)
		{
			for (id in MOD_IDS)
				trace(' * $id');
		}
	}
}
