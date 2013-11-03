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

import flash.display.Sprite;
import flash.events.Event;

/**
 * ...
 * @author Iain Lobb - iainlobb@googlemail.com
 */

class GamepadView extends Sprite
{
	private var ball:Sprite;
	private var button1:Sprite;
	private var button2:Sprite;
	private var up:Sprite;
	private var down:Sprite;
	private var left:Sprite;
	private var right:Sprite;
	private var gamepad:Gamepad;
	private var colour:Int;
	
	
	/**
	 * Visual representation of a Gamepad instance.
	 */
	public function new() 
	{
		super();
	}
	
	
	
	/**
	 * Initialise the instance.
	 * @param gamepad The Gamepad instance to show.
	 * @param colour Hex value of the desired colour.
	 */
	public function init(gamepad:Gamepad, ?colour:Int = 0x669900):Void
	{
		this.gamepad = gamepad;
		this.colour = colour;
		
		drawBackground();
		createBall();
		createButtons();
		createKeypad();
		
		addEventListener(Event.ENTER_FRAME, onEnterFrame);
	}
	
	
	
	private function drawBackground():Void
	{
		if (gamepad.isCircle)
		{
			drawCircle();
		}
		else
		{
			drawSquare();
		}
	}
	
	private function drawSquare():Void
	{
		graphics.beginFill(colour, 0.2);
		graphics.drawRoundRect(-50, -50, 100, 100, 50, 50);
		graphics.endFill();
	}
	
	private function drawCircle():Void
	{
		graphics.beginFill(colour, 0.2);
		graphics.drawCircle(0, 0, 50);
		graphics.endFill();
	}
	
	private function createBall():Void
	{
		ball = new Sprite();
		ball.graphics.beginFill(colour, 1);
		ball.graphics.drawCircle(0, 0, 25);
		ball.graphics.endFill();
		addChild(ball);
	}
	
	private function createKeypad():Void
	{
		up = createKey();
		up.x = -125;
		up.y = -15;
		
		down = createKey();
		down.x = -125;
		down.y = 20;
		
		left = createKey();
		left.x = -160;
		left.y = 20;
		
		right = createKey();
		right.x = -90;
		right.y = 20;
	}
	
	private function createButtons():Void
	{
		button1 = createButton();
		button1.x = 75;
		
		button2 = createButton();
		button2.x = 75;
		button2.y = 35;
	}
	
	private function createButton():Sprite
	{
		var button:Sprite = new Sprite();
		button.graphics.beginFill(colour, 1);
		button.graphics.drawCircle(0, 0, 15);
		button.graphics.endFill();
		addChild(button);
		
		return button;
	}
	
	private function createKey():Sprite
	{
		var key:Sprite = new Sprite();
		key.graphics.beginFill(colour, 1);
		key.graphics.drawRoundRect(0, 0, 30, 30, 20, 20);
		key.graphics.endFill();
		addChild(key);
		
		return key;
	}
	
	
	
	private function onEnterFrame(event:Event):Void
	{
		ball.x = gamepad.x * 25;
		ball.y = gamepad.y * 25;
		
		button1.alpha = gamepad.fire1.isDown ? 1 : 0.2;
		button2.alpha = gamepad.fire2.isDown ? 1 : 0.2;
		
		up.alpha = gamepad.up.isDown ? 1 : 0.2;
		down.alpha = gamepad.down.isDown ? 1 : 0.2;
		left.alpha = gamepad.left.isDown ? 1 : 0.2;
		right.alpha = gamepad.right.isDown ? 1 : 0.2;
	}
	
}
