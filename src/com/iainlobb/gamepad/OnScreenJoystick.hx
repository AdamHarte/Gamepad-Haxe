package com.iainlobb.gamepad;

import com.iainlobb.gamepad.Gamepad;
import com.iainlobb.gamepad.GamepadInput;
import nme.display.DisplayObject;
import nme.display.Sprite;
import nme.events.Event;
import nme.events.MouseEvent;

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

	var dragging:Bool;
	
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
		thumb.addEventListener(MouseEvent.MOUSE_DOWN, thumb_mouseDown);

		dragging = false;
		direction = 0;
		amount = 0;
		update();
	}

	public function destroy():Void
	{
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
		if (dragging)
		{
			var dx = mouseX;
			var dy = mouseY;
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


	function thumb_mouseDown(e)
	{
		stage.addEventListener(MouseEvent.MOUSE_UP, stage_mouseUp);
		dragging = true;
	}

	function stage_mouseUp(e)
	{
		stage.removeEventListener(MouseEvent.MOUSE_UP, stage_mouseUp);	
		dragging = false;
	}
}

