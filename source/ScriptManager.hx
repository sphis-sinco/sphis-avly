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

	public static function call(method:String, ...args:Dynamic)
	{
		for (script in SCRIPTS)
		{
			@:privateAccess {
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
					trace('error calling script(${script.config.name}) method: ' + e);
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
			newScript.call('onAdded');
		}
	}

	public static function initalizeScriptVariables(script:Iris)
	{
		script.set('ScriptsManager', ScriptManager, false);

		script.set('FlxG', FlxG, false);
		script.set('FlxSprite', flixel.FlxSprite, false);
		script.set('FlxBasic', flixel.FlxBasic, false);
		script.set('FlxState', flixel.FlxState, false);

		script.set('FlxGroup', flixel.group.FlxGroup, false);
		script.set('FlxTypedGroup', flixel.group.FlxGroup.FlxTypedGroup, false);

		script.set('FlxMath', flixel.math.FlxMath, false);

		script.set('PlayState', PlayState);
		script.set('Game', PlayState);

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
