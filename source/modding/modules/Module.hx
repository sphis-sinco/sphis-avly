package modding.modules;

import modding.events.ScriptEvents;

class Module implements IScriptedClass
{
	/**
	 * Whether the module is currently active.
	 */
	public var active(default, set):Bool = true;

	function set_active(value:Bool):Bool
	{
		return this.active = value;
	}

	public var moduleId(default, null):String = 'UNKNOWN';

	/**
	 * Determines the order in which modules receive events.
	 * You can modify this to change the order in which a given module receives events.
	 *
	 * Priority 1 is processed before Priority 1000, etc.
	 */
	public var priority(default, set):Int = 1000;

	function set_priority(value:Int):Int
	{
		this.priority = value;
		@:privateAccess
		ModuleHandler.reorderModuleCache();
		return value;
	}

	/**
	 * Called when the module is initialized.
	 * It may not be safe to reference other modules here since they may not be loaded yet.
	 *
	 * NOTE: To make the module start inactive, call `this.active = false` in the constructor.
	 */
	public function new(moduleId:String, priority:Int = 1000):Void
	{
		this.moduleId = moduleId;
		this.priority = priority;
	}

	public function toString()
	{
		return 'Module(' + this.moduleId + ')';
	}

	public function onScriptEvent(event:ScriptEvent) {}

	public function onCreate(event:ScriptEvent) {}

	public function onDestroy(event:ScriptEvent) {}

	public function onUpdate(event:UpdateScriptEvent) {}
}
