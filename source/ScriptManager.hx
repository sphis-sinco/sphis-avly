package;

import crowplexus.iris.Iris;
import crowplexus.iris.IrisConfig;
import flixel.FlxG;
import lime.app.Application;
import sys.FileSystem;
import sys.io.File;

class ScriptManager
{
	public static var SCRIPT_FOLDER:String = 'scripts';

	public static var SCRIPT_EXTS:Array<String> = ['hxc', 'hx', 'haxe', 'hscript'];

	public static var SCRIPTS:Array<Iris> = [];
	public static var SCRIPTS_ERRS:Map<String, Dynamic> = [];

	public static function call(method:String, ...args:Dynamic)
	{
		for (script in SCRIPTS)
		{
			callSingular(script, method, args);
		}
	}

	public static function callSingular(script:Iris, method:String, ...args:Dynamic)
	{
		@:privateAccess {
			if (!script.interp.variables.exists(method))
			{
				final errMsg = 'script(${script.config.name}) missing method: $method';

				if (!SCRIPTS_ERRS.exists('missing_method($method)_${script.config.name}'))
				{
					SCRIPTS_ERRS.set('missing_method($method)_${script.config.name}', errMsg);
					trace(errMsg);
				}

				return;
			}

			var ny:Dynamic = script.interp.variables.get(method);
			try
			{
				if (ny != null && Reflect.isFunction(ny))
				{
					script.call(method, args);
				}
			}
			catch (e)
			{
				final errMsg = 'error calling script(${script.config.name}) method: ' + e;

				if (!SCRIPTS_ERRS.exists('method($method)_error_${script.config.name}'))
				{
					SCRIPTS_ERRS.set('method($method)_error_${script.config.name}', errMsg);
					trace(errMsg);
				}
			}
		}
	}

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
		var newScript:Iris;

		var noExt:Int = 0;
		for (ext in SCRIPT_EXTS)
		{
			if (!StringTools.endsWith(path, '.$ext'))
				noExt++;
		}
		if (noExt >= SCRIPT_EXTS.length)
			return;

		try
		{
			newScript = new Iris(File.getContent(path), new IrisConfig(path, true, true, []));
		}
		catch (e)
		{
			newScript = null;
			trace('[SCRIPTMANAGER] Error loading script($path): ${e.message}');
			Application.current.window.alert('Error loading script($path): ${e.message}\n\n${e.details}', 'Error loading script5');
		}

		if (newScript != null)
		{
			initalizeScriptVariables(newScript);

			trace('[SCRIPTMANAGER] Loaded script($path)');

			SCRIPTS.push(newScript);
			callSingular(newScript, 'onAdded');
		}
	}

	public static function initalizeScriptVariables(script:Iris)
	{
		script.set('ScriptsManager', ScriptManager, false);

		script.set('Characters.NORMAL_DIFF', Characters.NORMAL_DIFF);
		script.set('Characters.HARD_DIFF', Characters.HARD_DIFF);

		script.set('PlayState', PlayState);
		script.set('Game', PlayState);

		script.set('Color', Color);

		script.set('Controls', Controls);

		script.set('debug', #if debug true #else false #end, true);
		script.set('colorFromString', function(string:String)
		{
			return Color.fstr(string);
		}, false);
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
