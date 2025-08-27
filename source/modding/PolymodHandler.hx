package modding;

import polymod.Polymod;
import polymod.format.ParseRules;
import sys.FileSystem;
import thx.semver.VersionRule;

class PolymodHandler
{
	static final MOD_FOLDER:String = 'mods';

	public static function getAllMods():Array<ModMetadata>
	{
		var modMeta = Polymod.scan({
			modRoot: MOD_FOLDER
		});

		trace('[POLYMOD HANDLER] Found ${modMeta.length} mods');
		return modMeta;
	}

	public static function getAllModIds():Array<String>
	{
		var modIds:Array<String> = [for (i in getAllMods()) i.id];
		return modIds;
	}

	static function createModRoot()
	{
		#if sys
		if (!FileSystem.exists(MOD_FOLDER))
			FileSystem.createDirectory(MOD_FOLDER);
		#end
	}

	public static var loadedModIds:Array<String> = [];

	static function loadModsById(i:Array<String>)
	{
		if (i.length < 1)
		{
			trace('[POLYMOD HANDLER] There are 0 mods attempting to be loaded');
			return;
		}

		Polymod.addDefaultImport(Color);
		Polymod.addDefaultImport(Controls);

		var ignoreList = Polymod.getDefaultIgnoreList();

		ignoreList.push('.git');
		ignoreList.push('.haxelib');
		ignoreList.push('.vscode');
		ignoreList.push('.gitignore');
		ignoreList.push('.gitattributes');
		ignoreList.push('README.md');

		var parseRules:ParseRules = ParseRules.getDefault();

		parseRules.addType('txt', TextFileFormat.LINES);

		parseRules.addType('hscript', TextFileFormat.PLAINTEXT);
		parseRules.addType('hxs', TextFileFormat.PLAINTEXT);
		parseRules.addType('hxc', TextFileFormat.PLAINTEXT);
		parseRules.addType('hx', TextFileFormat.PLAINTEXT);

		var loadedModList:Array<ModMetadata> = Polymod.init({
			modRoot: MOD_FOLDER,
			dirs: i,
			framework: OPENFL,

			ignoredFiles: ignoreList,
			parseRules: parseRules,

			skipDependencyErrors: true,

			useScriptedClasses: true,
			loadScriptsAsync: #if html5 true #else false #end,

			errorCallback: error ->
			{
				errorCallback(error);
			}
		});

		if (loadedModList == null)
		{
			trace('An error occurred! Failed when loading mods!');
		}
		else
		{
			if (loadedModList.length == 0)
			{
				trace('Mod loading complete. We loaded no mods / ${i.length} mods.');
			}
			else
			{
				trace('Mod loading complete. We loaded ${loadedModList.length} / ${i.length} mods.');
			}
		}

		loadedModIds = [];
		for (mod in loadedModList)
		{
			trace('  * ${mod.title} v${mod.modVersion} [${mod.id}]');
			loadedModIds.push(mod.id);
		}
	}

	public static function loadAllMods():Void
	{
		#if sys
		// Create the mod root if it doesn't exist.
		createModRoot();
		#end
		trace('[POLYMOD HANDLER] Loading all mods');
		loadModsById(getAllModIds());
	}

	static function errorCallback(error:PolymodError)
	{
		var showAlert = function(desc:String, name:String)
		{
			lime.app.Application.current.window.alert(desc, name);
		};

		switch (error.code)
		{
			case SCRIPT_PARSE_ERROR:
				showAlert('Polymod Script Parsing Error', error.message);
			case SCRIPT_RUNTIME_EXCEPTION:
				showAlert('Polymod Script Exception', error.message);
			case SCRIPT_CLASS_MODULE_NOT_FOUND:
				var className:Null<String> = error.message.split(' ').pop();
				var msg:String = 'Import error in ${error.origin}';
				msg += '\nCould not import unknown class ${className}';
				msg += '\nCheck to ensure the class exists and is spelled correctly.';

				// Notify the user via popup.
				showAlert('Polymod Script Import Error', msg);
			default:
				trace('[POLYMOD HANDLER] ${error.message}');
		}
	}
}
