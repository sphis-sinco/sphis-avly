package;

import crowplexus.iris.Iris;
import crowplexus.iris.IrisConfig;
import lime.app.Application;
import lime.utils.Assets;
#if sys
import sys.FileSystem;
import sys.io.File;
#end

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
				final errMsg = 'missing method($method) for script(${script.config.name})';

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
				final errMsg = 'error calling method($method) for script(${script.config.name}): ' + e.message;

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

		call('onAdded');
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
			newScript = new Iris(#if sys File.getContent(path) #else Assets.getText(path) #end, new IrisConfig(path, true, true, []));
		}
		catch (e)
		{
			newScript = null;
			trace('Error loading script($path): ${e.message}');
			Application.current.window.alert('Error loading script($path): ${e.message}\n\n${e.details}', 'Error loading script5');
		}

		if (newScript != null)
		{
			initalizeScriptVariables(newScript);

			trace('Loaded script($path)');

			SCRIPTS.push(newScript);
			// callSingular(newScript, 'onAdded');
		}
	}

	public static function initalizeScriptVariables(script:Iris)
	{
		script.set('Type', Type, false);

		script.set('ScriptManager', ScriptManager, false);
		script.set('Characters', {NORMAL_DIFF: Characters.NORMAL_DIFF, HARD_DIFF: Characters.HARD_DIFF});
		script.set('PlayState', PlayState, false);
		script.set('CharacterSelect', CharacterSelect, false);
		script.set('Color', Color, false);
		script.set('Controls', Controls, false);
		script.set('Script', Script, false);
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
			if (!sys.contains(Paths.getGamePath('$script_folder/$file')))
				sys.push(Paths.getGamePath('$script_folder/$file'));
		}
		return sys;
		#elseif html5
		var genScriptPath = function(filepath:String) return Paths.getGamePath('$script_folder/$filepath');
		return [
			genScriptPath('BulletMove.hx'),
			genScriptPath('BulletSpawnCondition.hx'),
			genScriptPath('SwitchCharacters.hx')
		];
		#else
		return [];
		#end
	}
}
