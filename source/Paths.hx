package;

#if sys
import sys.FileSystem;
#end

class Paths
{
	public static function getGamePath(path:String)
	{
		var retpath = '${(StringTools.startsWith(path, 'game/') ? '' : 'game/')}$path';

		for (mod in ModManager.MOD_IDS)
		{
			#if sys
			if (FileSystem.exists('${(StringTools.startsWith(path, 'game/') ? '' : 'game/')}${ModManager.MODS_FOLDER}/$mod/$path'))
			{
				retpath = '${(StringTools.startsWith(path, 'game/') ? '' : 'game/')}${ModManager.MODS_FOLDER}/$mod/$path';
			}
			#end
		}

		return retpath;
	}
}
