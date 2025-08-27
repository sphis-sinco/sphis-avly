package modding.events;

import modding.events.ScriptEvents;

/**
 * Utility functions to assist with handling scripted classes.
 */
@:nullSafety
class ScriptEventDispatcher
{
	/**
	 * Invoke the given event hook on the given scripted class.
	 * @param target The target class to call script hooks on.
	 * @param event The event, which determines the script hook to call and provides parameters for it.
	 */
	public static function callEvent(target:Null<IScriptedClass>, event:ScriptEvent):Void
	{
		if (target == null || event == null)
			return;

		target.onScriptEvent(event);

		// If one target says to stop propagation, stop.
		if (!event.shouldPropagate)
		{
			return;
		}

		// IScriptedClass
		switch (event.type)
		{
			case CREATE:
				target.onCreate(event);
				return;
			case DESTROY:
				target.onDestroy(event);
				return;
			case UPDATE:
				target.onUpdate(cast event);
				return;
			default: // Continue;
		}

		// If you get a crash on this line, that means ERIC FUCKED UP!
		// throw 'No function called for event type: ${event.type}';
	}

	public static function callEventOnAllTargets(targets:Iterator<IScriptedClass>, event:ScriptEvent):Void
	{
		if (targets == null || event == null)
			return;

		if (Std.isOfType(targets, Array))
		{
			var t = cast(targets, Array<Dynamic>);
			if (t.length == 0)
				return;
		}

		for (target in targets)
		{
			var t:IScriptedClass = cast target;
			if (t == null)
				continue;

			callEvent(t, event);

			// If one target says to stop propagation, stop.
			if (!event.shouldPropagate)
			{
				return;
			}
		}
	}
}
