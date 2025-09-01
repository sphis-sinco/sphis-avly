package;

#if sys
import sys.FileSystem;
#end

class Paths
{
	public static function getGamePath(path:String)
	{
		var retpath = 'game/$path';

		for (mod in ModManager.MOD_IDS)
		{
			#if sys
			if (FileSystem.exists('game/${ModManager.MODS_FOLDER}/$mod/$path'))
				retpath = 'game/${ModManager.MODS_FOLDER}/$mod/$path';
			#end
		}

		return retpath;
	}
}
