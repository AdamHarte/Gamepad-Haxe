/*
Copyright (c) 2010 Iain Lobb

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

package com.iainlobb.gamepadtesters;

import com.iainlobb.gamepad.Gamepad;
import nme.display.MovieClip;
import nme.display.Stage;

/**
 * ...
 * @author Iain Lobb - iainlobb@googlemail.com
 */

class PlatformGameCharacter extends MovieClip
{
	public var gamePad:Gamepad;
	public var speedX:Float;
	public var speedY:Float;
	public var gravity:Float;
	public var grounded:Bool;
	public var maxSpeed:Float;
	public var airAcceleration:Float;
	
	private var ticksInAir:Int;
	private var downwardGravity:Float;
	

	public function new(colour:Int, stage:Stage) 
	{
		super();
		
		speedX = 0;
		speedY = 0;
		gravity = 0.6;
		maxSpeed = 10;
		airAcceleration = 0.5;
		downwardGravity = 1;
		
		graphics.beginFill(colour, 1);
		graphics.drawRect(-25, -25, 50, 50);
		graphics.endFill();
		
		gamePad = new Gamepad(stage, false, 1);
	}
	
	
	
	public function update():Void
	{
		if (grounded)
		{
			speedX += gamePad.x;
		}
		else
		{
			speedX += gamePad.x * airAcceleration;
		}
		
		speedX *= 0.9;
		
		if (speedX > maxSpeed) speedX = maxSpeed;
		if (speedX < -maxSpeed) speedX = -maxSpeed;
		
		x += speedX;
		y += speedY;
		
		if (y > 250)
		{
			y = 250;
			grounded = true;
			speedY = 0;
		}
		
		if (grounded)
		{
			ticksInAir = 0;
		}
		else
		{
			ticksInAir++;
		}
		
		// Alternate version for non-repeating jumps:
		//if ((grounded && gamePad.up.isPressed) || (!grounded && ticksInAir < 8 && gamePad.up.isDown))
		
		if ((grounded || ticksInAir < 8) && gamePad.up.isDown)
		{
			speedY -= 2;
			grounded = false;
		}
		
		speedY += (speedY > 0) ? downwardGravity : gravity;
	}
	
}