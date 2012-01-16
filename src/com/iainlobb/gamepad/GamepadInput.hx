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

/**
 * ...
 * @author Iain Lobb - iainlobb@googlemail.com
 */

class GamepadInput 
{
	/**
	 * Is this input currently held down. 
	 */
	public var isDown:Bool;
	
	/**
	 * Was this input pressed this frame/step - use instead of listening to key down events.
	 */
	public var isPressed:Bool;
	
	/**
	 * Was this input released this frame/step - use instead of listening to key up events.
	 */
	public var isReleased:Bool;

	/**
	 * Is this input controlled by an onscreen/virtual device
	 */
	public var isVirtual:Bool;
	
	/**
	 * How long has the input been held down.
	 */
	public var downTicks:Int;
	
	/**
	 * How long since the input was last released.
	 */
	public var upTicks:Int;

	/**
	 * Amount of pression (joystick)
	 */
	public var pression:Float;

		
	private var mappedKeys:Array<Int>;
	
	
	/**
	 * Represents a gamepad button - can be mapped to more than 1 physical 
	 * key simultaneously, allowing multiple redundant control schemes.  
	 * @param	?keyCode	Use the constants from nme.ui.Keyboard.
	 */
	public function new(?keyCode:Int = -1) 
	{
		mappedKeys = (keyCode > -1) ? [keyCode] : [];
		downTicks = -1;
		upTicks = -1;
		pression = 1;
	}
	
	
	
	/**
	 * Map a physical key to this virtual button.
	 * @param keyCode Use the constants from nme.ui.Keyboard.
	 * @param replaceExisting pass true to replace exisiting keys, false to add mapping without replacing existing keys.
	 */
	public function mapKey(keyCode:Int, ?replaceExisting:Bool = false):Void
	{
		if (replaceExisting)
		{
			mappedKeys = [keyCode];
		}
		else if (!Lambda.has(mappedKeys, keyCode)) 
		{
			mappedKeys.push(keyCode);
		}
		isVirtual = keyCode == 0;
	}
	
	/**
	 * Unmap a physical key from this virtual button.
	 * @param keyCode Use the constants from com.cheezeworld.utils.KeyCode.
	 */
	public function unmapKey(keyCode:Int):Void
	{
		if (Lambda.has(mappedKeys, keyCode)) return;
		mappedKeys.splice(Lambda.indexOf(mappedKeys, keyCode), 1);
	}
	
	/**
	 * Called by owner Gamepad. End users should not call this function.
	 */
	public function update():Void
	{
		if (isDown)
		{
			isPressed = downTicks == -1;
			isReleased = false;
			downTicks++;
			upTicks = -1;
		}
		else
		{
			isReleased = upTicks == -1;
			isPressed = false;
			upTicks++;
			downTicks = -1;
		}
	}
	
	/**
	 * Called by owner Gamepad. End users should not call this function.
	 */
	public function keyDown(keyCode:Int):Void
	{
		if (!isVirtual && Lambda.has(mappedKeys, keyCode)) isDown = true;
	}
	
	/**
	 * Called by owner Gamepad. End users should not call this function.
	 */
	public function keyUp(keyCode:Int):Void
	{
		if (!isVirtual && Lambda.has(mappedKeys, keyCode)) isDown = false;
	}
	
}