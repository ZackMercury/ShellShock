package com.game 
{
	import com.bit101.components.Slider;
	import com.greensock.TweenLite;
	import com.greensock.easing.Cubic;
	import flash.display.Graphics;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	/**
	 * ...
	 * @author ZackMercury
	 */
	public class Window extends Sprite 
	{
		public static const BACKGROUND_COLOR:uint = 0xFFFFFF;
		public static const BORDER_COLOR:uint = 0x000000;
		
		public static const CROSS_BASE:Number = 50;
		
		protected var _background:Shape = new Shape();
		protected var _cross:Sprite = new Sprite();
		protected var _windowWidth:int = 320;
		protected var _windowHeight:int = 240;
		
		public function Window() 
		{
			super();
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		protected function init(e:Event = null):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
		
			//Drawing background
			addChild(_background);
			var g:Graphics = _background.graphics;
			g.beginFill(0, 0.5);
			g.drawRect( -App.W/2, -App.H/2, App.W*2, App.H*2);
			g.endFill();
			
			g.beginFill(BACKGROUND_COLOR);
			g.lineStyle(1, BORDER_COLOR);
			g.drawRect(0, 0, _windowWidth, _windowHeight);
			
			addChild(_cross);
			g = _cross.graphics;
			g.beginFill(0xFF5555);
			var catheti:Number = CROSS_BASE * Math.sqrt(2) / 2;
			g.moveTo(catheti, 0);
			g.lineTo(catheti, catheti);
			g.lineTo(0, 0);
			g.endFill();
			
			_cross.x = _windowWidth - _cross.width + 1;
			
			_cross.addEventListener(MouseEvent.CLICK, close);
		}
		
		public function appear():void
		{
			alpha = 0;
			scaleX = scaleY = 1.5;
			x -= ((_windowWidth * 1.5 - _windowWidth) / 2);
			y -= ((_windowHeight * 1.5 - _windowHeight) / 2);
			TweenLite.to(this, 0.3, { alpha: 1, scaleX:1, scaleY:1, x: x + ((_windowWidth * 1.5 - _windowWidth) / 2), y: y + ((_windowHeight * 1.5 - _windowHeight) / 2)});
		}
		
		public function close(e:MouseEvent):void 
		{
			TweenLite.to(this, 0.4, { alpha: 0, scaleX:1.5, scaleY:1.5, x: x-((_windowWidth*1.5-_windowWidth)/2), y:y-((_windowHeight*1.5-_windowHeight)/2),onComplete: fadingOver, ease: Cubic.easeIn});
		}
		
		private function fadingOver():void 
		{
			if (parent.contains(this))
				parent.removeChild(this);
			alpha = 1;
			scaleX = scaleY = 1;
			x += ((_windowWidth * 1.5 - _windowWidth) / 2);
			y += ((_windowHeight * 1.5 - _windowHeight) / 2);
			
			dispatchEvent(new Event(Event.CLOSE));
		}
		
		public function get windowHeight():int 
		{
			return _windowHeight;
		}
		
		public function get windowWidth():int 
		{
			return _windowWidth;
		}
		
	}

}