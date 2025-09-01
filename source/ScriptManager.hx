package;

import lime.app.Application;
import rulescript.RuleScript;
import rulescript.RuleScriptInterp;
import rulescript.parsers.HxParser;
import sys.FileSystem;
import sys.io.File;

class ScriptManager
{
	public static var SCRIPT_FOLDER:String = 'scripts';

	public static var CUSTOM_SCRIPT_EXT:String = 'hxc';
	public static var DEFAULT_SCRIPT_EXT:String = 'hx';

	public static var SCRIPTS:Array<RuleScript> = [];

	public static function loadAllScripts()
	{
		for (script in SCRIPTS)
		{
			SCRIPTS.remove(script);
		}
		SCRIPTS = [];

		loadScriptsByPaths(getAllScriptPaths(SCRIPT_FOLDER));
	}

	public static function loadScriptByPath(path:String)
	{
		var newScript:RuleScript;

		try
		{
			newScript = getScript(path.split('.')[0]);
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
		}
	}

	public static function getScript(key:String):RuleScript
	{
		var scriptExists = FileSystem.exists('$key.$CUSTOM_SCRIPT_EXT');
		var path:String = scriptExists ? '$key.$CUSTOM_SCRIPT_EXT' : '$key.$DEFAULT_SCRIPT_EXT';
		var script:RuleScript;
		script = new RuleScript(new RuleScriptInterp(), new HxParser());
		script.getParser(HxParser).setParams(null, null, true, null);
		if (scriptExists)
			script.getParser(HxParser).mode = MODULE;
		script.execute(File.getContent(path));
		return script;
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
