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

class GamepadMultiInput 
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
	 * How long has the input been held down.
	 */
	public var downTicks:Int;
	
	/**
	 * How long since the input was last released.
	 */
	public var upTicks:Int;
	
	private var isOr:Bool;
	private var inputs:Array<GamepadInput>;
	
	
	/**
	 * Represents a virtual button that combines the input of 2 or more other buttons, 
	 * e.g. up-left/north-west. End users shouldn't need to create these.
	 */
	public function new(inputs:Array<GamepadInput>, isOr:Bool) 
	{
		this.inputs = inputs;
		this.isOr = isOr;
		downTicks = -1;
		upTicks = -1;
	}
	
	
	
	/**
	 * Called by owner Gamepad. End users should not call this function.
	 */
	public function update():Void
	{
		if(isOr)
		{
			isDown = false;
			
			for(gamepadInput in inputs)
			{
				if (gamepadInput.isDown)
				{
					isDown = true;
					break;
				}
			}
		}
		else
		{
			isDown = true;
			
			for(gamepadInput in inputs)
			{
				if (!gamepadInput.isDown)
				{
					isDown = false;
					break;
				}
			}
		}
		
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
	
}