package modding.events;

enum abstract ScriptEventType(String) from String to String
{
	var CREATE = 'CREATE';
	var DESTROY = 'DESTROY';
	var ADDED = 'ADDED';
	var UPDATE = 'UPDATE';

	var STATE_CHANGE_BEGIN = 'STATE_CHANGE_BEGIN';
	var STATE_CHANGE_END = 'STATE_CHANGE_END';

	var SUBSTATE_OPEN_BEGIN = 'SUBSTATE_OPEN_BEGIN';
	var SUBSTATE_OPEN_END = 'SUBSTATE_OPEN_END';
	var SUBSTATE_CLOSE_BEGIN = 'SUBSTATE_CLOSE_BEGIN';
	var SUBSTATE_CLOSE_END = 'SUBSTATE_CLOSE_END';

	var FOCUS_GAINED = 'FOCUS_GAINED';

	/**
	 * Allow for comparing `ScriptEventType` to `String`.
	 */
	@:op(A == B) private static inline function equals(a:ScriptEventType, b:String):Bool
	{
		return (a : String) == b;
	}

	/**
	 * Allow for comparing `ScriptEventType` to `String`.
	 */
	@:op(A != B) private static inline function notEquals(a:ScriptEventType, b:String):Bool
	{
		return (a : String) != b;
	}
}
