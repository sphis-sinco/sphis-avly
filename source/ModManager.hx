package;

import haxe.Json;
import lime.utils.Assets;
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
				meta = Json.parse(Assets.getText('game/$MODS_FOLDER/$entry/$MOD_METADATA_FILE'));
			}
			catch (e)
			{
				meta = null;
				trace('$entry meta error: ${e.message}');
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
