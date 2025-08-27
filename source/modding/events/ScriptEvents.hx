package modding.events;

import flixel.*;

// thank you funkin
class ScriptEvent
{
	/**
	 * If true, the behavior associated with this event can be prevented.
	 * For example, cancelling COUNTDOWN_START should prevent the countdown from starting,
	 * until another script restarts it, or cancelling NOTE_HIT should cause the note to be missed.
	 */
	public var cancelable(default, null):Bool;

	/**
	 * The type associated with the event.
	 */
	public var type(default, null):ScriptEventType;

	/**
	 * Whether the event should continue to be triggered on additional targets.
	 */
	public var shouldPropagate(default, null):Bool;

	/**
	 * Whether the event has been canceled by one of the scripts that received it.
	 */
	public var eventCanceled(default, null):Bool;

	public function new(type:ScriptEventType, cancelable:Bool = false):Void
	{
		this.type = type;
		this.cancelable = cancelable;
		this.eventCanceled = false;
		this.shouldPropagate = true;
	}

	/**
	 * Call this function on a cancelable event to cancel the associated behavior.
	 * For example, cancelling COUNTDOWN_START will prevent the countdown from starting.
	 */
	public function cancelEvent():Void
	{
		if (cancelable)
		{
			eventCanceled = true;
		}
	}

	/**
	 * Cancel this event.
	 * This is an alias for cancelEvent() but I make this typo all the time.
	 */
	public function cancel():Void
	{
		cancelEvent();
	}

	/**
	 * Call this function to stop any other Scripteds from receiving the event.
	 */
	public function stopPropagation():Void
	{
		shouldPropagate = false;
	}

	public function toString():String
	{
		return 'ScriptEvent(type=$type, cancelable=$cancelable)';
	}
}

class UpdateScriptEvent extends ScriptEvent
{
	/**
	 * The note associated with this event.
	 * You cannot replace it, but you can edit it.
	 */
	public var elapsed(default, null):Float;

	public function new(elapsed:Float):Void
	{
		super(UPDATE, false);
		this.elapsed = elapsed;
	}

	public override function toString():String
	{
		return 'UpdateScriptEvent(elapsed=$elapsed)';
	}
}

/**
 * An event that is fired when moving out of or into an FlxState.
 */
class StateChangeScriptEvent extends ScriptEvent
{
	/**
	 * The state the game is moving into.
	 */
	public var targetState(default, null):FlxState;

	public function new(type:ScriptEventType, targetState:FlxState, cancelable:Bool = false):Void
	{
		super(type, cancelable);
		this.targetState = targetState;
	}

	public override function toString():String
	{
		return 'StateChangeScriptEvent(type=' + type + ', targetState=' + targetState + ')';
	}
}

/**
 * An event that is fired when the game loses or gains focus.
 */
class FocusScriptEvent extends ScriptEvent
{
	public function new(type:ScriptEventType):Void
	{
		super(type, false);
	}

	public override function toString():String
	{
		return 'FocusScriptEvent(type=' + type + ')';
	}
}

class SubStateScriptEvent extends ScriptEvent
{
	/**
	 * The state the game is moving into.
	 */
	public var targetState(default, null):FlxSubState;

	public function new(type:ScriptEventType, targetState:FlxSubState, cancelable:Bool = false):Void
	{
		super(type, cancelable);
		this.targetState = targetState;
	}

	public override function toString():String
	{
		return 'SubStateScriptEvent(type=' + type + ', targetState=' + targetState + ')';
	}
}
