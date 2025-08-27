package;

import flixel.FlxState;
import flixel.FlxSubState;
import modding.events.ScriptEvents;
import modding.modules.ModuleHandler;

class State extends FlxState
{
	override function new()
	{
		super();

		subStateOpened.add(onOpenSubStateComplete);
		subStateClosed.add(onCloseSubStateComplete);
	}

	public function dispatchEvent(event:ScriptEvent)
	{
		ModuleHandler.callEvent(event);
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		dispatchEvent(new UpdateScriptEvent(elapsed));
	}

	override function onFocus():Void
	{
		super.onFocus();

		dispatchEvent(new FocusScriptEvent(FOCUS_GAINED));
	}

	override function onFocusLost():Void
	{
		super.onFocusLost();

		dispatchEvent(new FocusScriptEvent(FOCUS_LOST));
	}

	public override function openSubState(targetSubState:FlxSubState):Void
	{
		var event = new SubStateScriptEvent(SUBSTATE_OPEN_BEGIN, targetSubState, true);

		dispatchEvent(event);

		if (event.eventCanceled)
			return;

		super.openSubState(targetSubState);
	}

	function onOpenSubStateComplete(targetState:FlxSubState):Void
	{
		dispatchEvent(new SubStateScriptEvent(SUBSTATE_OPEN_END, targetState, true));
	}

	public override function closeSubState():Void
	{
		var event = new SubStateScriptEvent(SUBSTATE_CLOSE_BEGIN, this.subState, true);

		dispatchEvent(event);

		if (event.eventCanceled)
			return;

		super.closeSubState();
	}

	function onCloseSubStateComplete(targetState:FlxSubState):Void
	{
		dispatchEvent(new SubStateScriptEvent(SUBSTATE_CLOSE_END, targetState, true));
	}
}
