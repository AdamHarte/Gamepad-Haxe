/*
Copyright (c) 2010 Iain Lobb - iainlobb@gmail.com

Permission is hereby granted, free of charge, to any person
obtaining a copy of this software and associated documentation
files (the "Software"), to deal in the Software without
restriction, including without limitation the rights to use,
copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the
Software is furnished to do so, subject to the following
conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
OTHER DEALINGS IN THE SOFTWARE.
*/

package com.iainlobb.gamepad;

import nme.display.Stage;
import nme.events.Event;
import nme.events.KeyboardEvent;
import nme.ui.Keyboard;

/**
 * ...
 * @author Iain Lobb - iainlobb@googlemail.com
 */

class Gamepad 
{
	/**
	 * Prevents diagonal movement being faster than horizontal or vertical movement. Use for top-down view games.
	 */
	public var isCircle:Bool;
	
	/**
	 * Simple ease-out speed (range 0 to 1). Pass value of 1 to prevent easing.
	 */
	public var ease:Float;
	
	
	/// INPUTS:
	
	/**
	 * A GamepadInput representing the up/north direction. Configure with its mapKey and unmapKey functions. Get state information from isDown, isPressed, isReleased, downTicks and upTicks.
	 */
	public var up (default, null):GamepadInput;
	
	/**
	 * A GamepadInput representing the down/south direction. Configure with its mapKey and unmapKey functions. Get state information from isDown, isPressed, isReleased, downTicks and upTicks.
	 */
	public var down (default, null):GamepadInput;
	
	/**
	 * A GamepadInput representing the left/west direction. Configure with its mapKey and unmapKey functions. Get state information from isDown, isPressed, isReleased, downTicks and upTicks.
	 */
	public var left (default, null):GamepadInput;
	
	/**
	 * A GamepadInput representing the right/east direction. Configure with its mapKey and unmapKey functions. Get state information from isDown, isPressed, isReleased, downTicks and upTicks.
	 */
	public var right (default, null):GamepadInput;
	
	/**
	 * A GamepadInput representing the primary fire button. Configure with its mapKey and unmapKey functions. Get state information from isDown, isPressed, isReleased, downTicks and upTicks.
	 */
	public var fire1 (default, null):GamepadInput;
	
	/**
	 * A GamepadInput representing the secondary fire button. Configure with its mapKey and unmapKey functions. Get state information from isDown, isPressed, isReleased, downTicks and upTicks.
	 */
	public var fire2 (default, null):GamepadInput;
	
	
	/// MULTI-INPUTS (combines 2 or more inputs into 1, e.g. _upLeft requires both up and left to be pressed):
	
	/**
	 * A GamepadMultiInput representing the up-left/north-west direction. Get state information from isDown, isPressed, isReleased, downTicks and upTicks. End-users should not need to configure this input.
	 */
	public var upLeft (default, null):GamepadMultiInput;
	
	/**
	 * A GamepadMultiInput representing the down-left/south-west direction. Get state information from isDown, isPressed, isReleased, downTicks and upTicks. End-users should not need to configure this input.
	 */
	public var downLeft (default, null):GamepadMultiInput;
	
	/**
	 * A GamepadMultiInput representing the up-right/north-east direction. Get state information from isDown, isPressed, isReleased, downTicks and upTicks. End-users should not need to configure this input.
	 */
	public var upRight (default, null):GamepadMultiInput;
	
	/**
	 * A GamepadMultiInput representing the down-right/south-east direction. Get state information from isDown, isPressed, isReleased, downTicks and upTicks. End-users should not need to configure this input.
	 */
	public var downRight (default, null):GamepadMultiInput;
	
	/**
	 * A special GamepadMultiInput representing whether any direction is pressed. Get state information from isDown, isPressed, isReleased, downTicks and upTicks. End-users should not need to configure this input.
	 */
	public var anyDirection (default, null):GamepadMultiInput;
	
	
	/// THE "STICK":
	
	/**
	 * The horizontal component of the direction pad, value between 0 and 1.
	 */
	public var x (default, null):Float;
	
	/**
	 * The vertical component of the direction pad, value between 0 and 1.
	 */
	public var y (default, null):Float;
	
	/**
	 * The angle of the direction pad in radians.
	 */
	public var angle (default, null):Float;
	
	/**
	 * The angle of the direction pad in degrees, between 0 and 360.
	 */
	public var rotation (default, null):Float;
	
	/**
	 * The length/magnitude of the direction pad, between 0 and 1.
	 */
	public var magnitude (default, null):Float;
	
	private var stage:Stage;
	private var inputs:Array<GamepadInput>;
	private var multiInputs:Array<GamepadMultiInput>;
	private var targetX:Float;
	private var targetY:Float;
	
	
	/**
	 * Gamepad simplifies keyboard input by simulating an analog joystick.
	 * @param stage A reference to the stage is needed to listen for system events
	 * @param isCircle Prevents diagonal movement being faster than horizontal or vertical movement. Use for top-down view games.
	 * @param ease Simple ease-out speed (range 0 to 1). Pass value of 1 to prevent easing.
	 * @param autoStep Pass in false if you intend to call step() manually.
	 */
	public function new(stage:Stage, isCircle:Bool, ?ease:Float = 0.2, ?autoStep:Bool = true) 
	{
		this.isCircle = isCircle;
		this.ease = ease;
		this.stage = stage;
		
		x = 0;
		y = 0;
		angle = 0;
		rotation = 0;
		magnitude = 0;
		targetX = 0;
		targetY = 0;
		
		up = new GamepadInput();
		down = new GamepadInput();
		left = new GamepadInput();
		right = new GamepadInput();
		fire1 = new GamepadInput();
		fire2 = new GamepadInput();
		
		inputs = [up, down, left, right, fire1, fire2];
		
		upLeft = new GamepadMultiInput([up, left], false);
		upRight = new GamepadMultiInput([up, right], false);
		downLeft = new GamepadMultiInput([down, left], false);
		downRight = new GamepadMultiInput([down, right], false);
		anyDirection = new GamepadMultiInput([up, down, left, right], true);
		
		multiInputs = [upLeft, upRight, downLeft, downRight, anyDirection];
		
		useArrows();
		useControlSpace();
		
		stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);// , false, 0, true);
		stage.addEventListener(KeyboardEvent.KEY_UP, onKeyUp);// , false, 0, true);
		
		if (autoStep)
		{
			stage.addEventListener(Event.ENTER_FRAME, onEnterFrame);// , false, 0, true);
		}
	}
	
	
	
	/**
	 * Destructor.
	 */
	public function destroy():Void {
		stage.removeEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
		stage.removeEventListener(KeyboardEvent.KEY_UP, onKeyUp);
		stage.removeEventListener(Event.ENTER_FRAME, onEnterFrame);
	}
	
	/// DIRECTION PRESETS:
	
	/**
	 * Quickly map all direction keys
	 * @param up Keycode - use the constants from com.cheezeworld.utils.KeyCode.
	 * @param down Keycode - use the constants from com.cheezeworld.utils.KeyCode.
	 * @param left Keycode - use the constants from com.cheezeworld.utils.KeyCode.
	 * @param right Keycode - use the constants from com.cheezeworld.utils.KeyCode.
	 * @param replaceExisting pass true to replace exisiting keys, false to add mapping without replacing existing keys.
	 */
	public function mapDirection(up:Int, down:Int, left:Int, right:Int, ?replaceExisting:Bool = false):Void
	{
		this.up.mapKey(up, replaceExisting);
		this.down.mapKey(down, replaceExisting);
		this.left.mapKey(left, replaceExisting);
		this.right.mapKey(right, replaceExisting);
	}
	
	/**
	 * Preset to use the direction arrow keys for movement
	 * @param replaceExisting pass true to replace exisiting keys, false to add mapping without replacing existing keys. 
	 */
	public function useArrows(?replaceExisting:Bool = false):Void
	{
		mapDirection(Keyboard.UP, Keyboard.DOWN, Keyboard.LEFT, Keyboard.RIGHT, replaceExisting);
	}
	
	/**
	 * Preset to use the W, A, S and D keys for movement. This layout doesn't work for players with French AZERTY keyboards - call useZQSD() instead.
	 * @param replaceExisting pass true to replace exisiting keys, false to add mapping without replacing existing keys. 
	 */
	public function useWASD(?replaceExisting:Bool = false):Void
	{
		mapDirection(Keyboard.W, Keyboard.S, Keyboard.A, Keyboard.D, replaceExisting);
	}
	
	/**
	 * Preset to use the I, J, K and L keys for movement.
	 * @param replaceExisting pass true to replace exisiting keys, false to add mapping without replacing existing keys. 
	 */
	public function useIJKL(?replaceExisting:Bool = false):Void
	{
		mapDirection(Keyboard.I, Keyboard.K, Keyboard.J, Keyboard.L, replaceExisting);
	}
	
	/**
	 * Preset to use the Z, Q, S and D keys for movement. Use this mapping instead of useWASD() when targeting French AZERTY keyboards.
	 * @param replaceExisting pass true to replace exisiting keys, false to add mapping without replacing existing keys. 
	 */
	public function useZQSD(?replaceExisting:Bool = false):Void
	{
		mapDirection(Keyboard.Z, Keyboard.S, Keyboard.Q, Keyboard.D, replaceExisting);
	}
	
	/// FIRE BUTTON PRESETS:
	
	/**
	 * Map the fire buttons.
	 * @param fire1 The primary fire button.
	 * @param fire2 The secondary fire button.
	 * @param replaceExisting pass true to replace exisiting keys, false to add mapping without replacing existing keys. 
	 */
	public function mapFireButtons(fire1:Int, fire2:Int, ?replaceExisting:Bool = false):Void
	{
		this.fire1.mapKey(fire1, replaceExisting);
		this.fire2.mapKey(fire2, replaceExisting);
	}
	
	/**
	 * Preset to use the < and > keys for fire buttons.
	 * @param replaceExisting pass true to replace exisiting keys, false to add mapping without replacing existing keys. 
	 */
	/*public function useChevrons(?replaceExisting:Bool = false):Void
	{
		//TODO: Currently doesn't seem to work when publishing to some platforms.
		mapFireButtons(Keyboard.COMMA, Keyboard.PERIOD, replaceExisting);
	}*/
	
	/**
	 * Preset to use the G and H keys for fire buttons.
	 * @param replaceExisting pass true to replace exisiting keys, false to add mapping without replacing existing keys. 
	 */
	public function useGH(?replaceExisting:Bool = false):Void
	{
		mapFireButtons(Keyboard.G, Keyboard.H, replaceExisting);
	}
	
	/**
	 * Preset to use the Z and X keys for fire buttons.
	 * @param replaceExisting pass true to replace exisiting keys, false to add mapping without replacing existing keys. 
	 */
	public function useZX(?replaceExisting:Bool = false):Void
	{
		mapFireButtons(Keyboard.Z, Keyboard.X, replaceExisting);
	}
	
	/**
	 * Preset to use the Y and X keys for fire buttons.
	 * @param replaceExisting pass true to replace exisiting keys, false to add mapping without replacing existing keys. 
	 */
	public function useYX(?replaceExisting:Bool = false):Void
	{
		mapFireButtons(Keyboard.Y, Keyboard.X, replaceExisting);
	}
	
	/**
	 * Preset to use the CTRL and SPACEBAR keys for fire buttons.
	 * @param replaceExisting pass true to replace exisiting keys, false to add mapping without replacing existing keys. 
	 */
	public function useControlSpace(?replaceExisting:Bool = false):Void
	{
		mapFireButtons(Keyboard.CONTROL, Keyboard.SPACE, replaceExisting);
	}
	
	/// UPDATE:
	
	/**
	 * Step/Update the gamepad. Called automatically if you didn't pass in autoStep as false. This should be called in sync with you game/physics step.
	 */
	public function step():Void
	{
		x += (targetX - x) * ease;
		y += (targetY - y) * ease;
		
		magnitude = Math.sqrt((x * x) + (y * y));
		
		angle = Math.atan2(x, y);
		
		rotation = angle * 57.29577951308232;
		
		for (gamepadInput in inputs) gamepadInput.update();
	}
	
	
	
	private function updateState():Void
	{
		for(gamepadMultiInput in multiInputs) gamepadMultiInput.update();
		
		if (up.isDown)
		{
			targetY = -1;
		}
		else if (down.isDown)
		{
			targetY = 1;
		}
		else
		{
			targetY = 0;
		}
		
		if (left.isDown)
		{
			targetX = -1;
		}
		else if (right.isDown)
		{
			targetX = 1;
		}
		else
		{
			targetX = 0;
		}
		
		var targetAngle:Float = Math.atan2(targetX, targetY);
		
		if (isCircle && anyDirection.isDown)
		{
			targetX = Math.sin(targetAngle);
			targetY = Math.cos(targetAngle);
		}
	}
	
	
	
	private function onEnterFrame(event:Event):Void
	{
		step();
	}
	
	private function onKeyDown(event:KeyboardEvent):Void
	{
		for(gamepadInput in inputs) gamepadInput.keyDown(event.keyCode);
		
		updateState();
	}
	
	private function onKeyUp(event:KeyboardEvent):Void
	{
		for(gamepadInput in inputs) gamepadInput.keyUp(event.keyCode);
		
		updateState();
	}
	
}