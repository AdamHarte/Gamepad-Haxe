package com.iainlobb.gamepad;

import com.iainlobb.gamepad.Gamepad;
import com.iainlobb.gamepad.GamepadInput;
import flash.display.DisplayObject;
import flash.display.Sprite;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.events.TouchEvent;
import flash.geom.Point;

/**
 * ...
 * @author Philippe
 */
class OnScreenJoystick extends Sprite
{
	public var gamepad:Gamepad;
	public var radius:Float;
	public var thumb:DisplayObject;
	public var direction:Float;
	public var amount:Float; 

	var dragging:Int;
	var dragPos:Point;
	
	/**
	 * An on screen joystick (for touch devices)
	 * Note: call .update() each frame to synchronize the gamepad
	 */
	public function new()
	{
		super();
	}

	/**
	 * Initialise the instance.
	 * @param gamepad The Gamepad instance to control.
	 * @param radius  of the drag area.
	 * @param thumb   The draggable graphic.
	 * @param background An optional background graphic to attach.
	 */
	public function init(gamepad:Gamepad, radius:Float, thumb:DisplayObject, ?background:DisplayObject):Void
	{
		this.gamepad = gamepad;
		gamepad.useVirtual();

		this.radius = radius;
		this.thumb = thumb;

		if (background != null) 
		{
			background.x = Std.int(-background.width / 2);
			background.y = Std.int(-background.height / 2);
			addChild(background);
		}
		
		addChild(thumb);

		if (flash.ui.Multitouch.supportsTouchEvents)
		{
			flash.ui.Multitouch.inputMode = flash.ui.MultitouchInputMode.TOUCH_POINT;
			thumb.addEventListener(TouchEvent.TOUCH_BEGIN, thumb_touchBegin);
		}
		else thumb.addEventListener(MouseEvent.MOUSE_DOWN, thumb_mouseDown);

		dragging = -1;
		dragPos = new Point(0, 0);
		direction = 0;
		amount = 0;
		update();
	}

	public function destroy():Void
	{
		thumb.removeEventListener(TouchEvent.TOUCH_BEGIN, thumb_touchBegin);
		thumb.removeEventListener(MouseEvent.MOUSE_DOWN, thumb_mouseDown);
		gamepad = null;
		thumb = null;
		while(numChildren > 0) removeChildAt(0);
	}

	/**
	 * Update the joystick visually and synchronizes the gamepad 
	 */
	public function update():Void
	{
		var prevAmount = amount;
		var prevDirection = direction;
		if (dragging >= 0)
		{
			var dx = dragPos.x;
			var dy = dragPos.y;
			var d = Math.sqrt(dx * dx + dy * dy);
			if (d < 1) d = 0;
			direction = Math.atan2(dy, dx);
			amount = Math.min(radius, d) / radius;
		}
		else if (amount != 0) 
		{
			amount *= gamepad.ease;
			if (Math.abs(amount) < 0.1) amount = 0;
		}

		setGamepad();

		thumb.x = Std.int( Math.cos(direction) * amount * radius - thumb.width / 2);
		thumb.y = Std.int( Math.sin(direction) * amount * radius - thumb.height / 2);
	}

	function setGamepad():Void
	{
		var py = Math.sin(direction) * amount;
		var px = Math.cos(direction) * amount;

		if (gamepad.isCircle)
		{
			if (Math.abs(px) < 0.5) px = 0; 
			if (Math.abs(py) < 0.5) py = 0;
		}
		setInput(gamepad.right, px, px > 0);
		setInput(gamepad.left, px, px < 0);
		setInput(gamepad.up, py, py < 0);
		setInput(gamepad.down, py, py > 0);
		gamepad.anyDirection.isDown = px != 0 || py != 0;
		gamepad.updateState();
	}

	function setInput(input:GamepadInput, amount:Float, condition:Bool)
	{
		if (condition)
		{
			input.isDown = true;
			input.pression = Math.abs(amount);
		}
		else
		{
			input.isDown = false;
			input.pression = 0;
		}
	}

	function thumb_touchBegin(e:TouchEvent) 
	{
		if (dragging >= 0) return;
		dragging = e.touchPointID;
		stage_touchMove(e);
		stage.addEventListener(TouchEvent.TOUCH_END, stage_touchEnd);
		stage.addEventListener(TouchEvent.TOUCH_MOVE, stage_touchMove);
	}

	function stage_touchMove(e:TouchEvent) 
	{
		if (e.touchPointID == dragging) 
		{
			dragPos.x = e.stageX;
			dragPos.y = e.stageY;
			dragPos = globalToLocal(dragPos);
		}	
	}

	function stage_touchEnd(e:TouchEvent) 
	{
		if (e.touchPointID == dragging) 
		{
			dragging = -1;
			stage.removeEventListener(TouchEvent.TOUCH_END, stage_touchEnd);
			stage.removeEventListener(TouchEvent.TOUCH_MOVE, stage_touchMove);
		}
	}

	function thumb_mouseDown(e)
	{
		dragging = 0;
		stage.addEventListener(MouseEvent.MOUSE_UP, stage_mouseUp);
		stage.addEventListener(MouseEvent.MOUSE_MOVE, stage_mouseMove);
	}

	function stage_mouseMove(e) 
	{
		dragPos.x = mouseX;
		dragPos.y = mouseY;
	}

	function stage_mouseUp(e)
	{
		dragging = -1;
		stage.removeEventListener(MouseEvent.MOUSE_UP, stage_mouseUp);
		stage.removeEventListener(MouseEvent.MOUSE_MOVE, stage_mouseMove);
	}
}

