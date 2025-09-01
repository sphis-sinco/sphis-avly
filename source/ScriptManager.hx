package;

import lime.app.Application;
import sys.FileSystem;
import sys.io.File;

class ScriptManager
{
	public static var SCRIPT_FOLDER:String = 'scripts';
	public static var SCRIPT_EXT:String = 'hxc';

	public static var SCRIPTS:Array<Dynamic> = [];

	public static function loadAllScripts()
	{
		for (script in SCRIPTS)
		{
			script.destroy();
			SCRIPTS.remove(script);
		}
		SCRIPTS = [];

		loadScriptsByPaths(getAllScriptPaths(SCRIPT_FOLDER));
	}

	public static function loadScriptByPath(path:String)
	{
		var newScript:Dynamic;

		if (!StringTools.endsWith(path, '.${SCRIPT_EXT}'))
			return;

		try
		{
			newScript = null; // new Dynamic(File.getContent(path), new IrisConfig(path, true, true, []));
		}
		catch (e)
		{
			newScript = null;
			trace('[SCRIPTMANAGER] Error loading script($path): ${e.message}');
			Application.current.window.alert('Error loading script($path): ${e.message}\n\n${e.details}', 'Error loading script5');
		}

		if (newScript != null)
		{
			trace('[SCRIPTMANAGER] Loaded script($path)');
			SCRIPTS.push(newScript);
			newScript.call('onAdded');
		}
	}

	public static function loadScriptsByPaths(paths:Array<String>)
	{
		for (path in paths)
			loadScriptByPath(path);
	}

	public static function getAllScriptPaths(script_folder:String):Array<String>
	{
		#if sys
		var sys = [];
		for (file in FileSystem.readDirectory('game/$script_folder/'))
		{
			sys.push('game/$script_folder/$file');
		}
		return sys;
		#else
		return [];
		#end
	}
}
