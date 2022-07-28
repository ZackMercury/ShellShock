package com.game
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.text.TextField;
	
	public class Block extends Sprite
	{		
		public static const SIZE:int = 48;
		public static const BORDER_THICKNESS:Number = 1.2;
		
		//Events
		public static const OUT_OF_STAGE:String = "outOfStage";
		
		//States
		public static const RUNNING:int = 0;
		public static const FALLING:int = 1;
		public static const FALLEN:int = 2;
		
		private var _group:int = -1;
		private var _color:uint;
		private var _state:int = FALLEN;

		
		//Tiles
		public static const LEFT_END:int = parseInt("1000", 2);
		public static const RIGHT_END:int = parseInt("0010", 2);
		public static const HORIZONTAL_TUBE:int = parseInt("1010", 2);
		public static const UPPER_END:int = parseInt("0100", 2);
		public static const LOWER_END:int = parseInt("0001", 2);
		public static const VERTICAL_TUBE:int = parseInt("0101", 2);
		public static const LEFT_DOWN_CORNER:int = parseInt("0110", 2);
		public static const LEFT_UP_CORNER:int = parseInt("0011", 2);
		public static const RIGHT_DOWN_CORNER:int = parseInt("1100", 2);
		public static const RIGHT_UP_CORNER:int = parseInt("1001", 2);
		public static const SINGLE:int = parseInt("0000", 2);
		public static const LEFT_TOP_RIGHT:int = parseInt("1011", 2);
		public static const LEFT_BOTTOM_RIGHT:int = parseInt("1110", 2);
		public static const BOTTOM_LEFT_TOP:int = parseInt("0111", 2);
		public static const BOTTOM_RIGHT_TOP:int = parseInt("1101", 2);
		public static const CROWDED:int = parseInt("1111", 2);
		
		private var _tile:int = SINGLE;
		
		private var _velocity:Point = new Point(0, 0);
		private var _dir:int = 1;
		private var _speed:int = 30;
		public var animating:Boolean = false;
		
		public function Block(color:uint, group:int = -1)
		{
			this._group = group;
			this._color = color;
			draw();
		}
		
		public function update(deltaS:Number):void
		{
			switch(_state)
			{
				case FALLEN:
					this._velocity.x = 0;
					this._velocity.y = 0;
					
					break;
				case RUNNING:
					this._velocity.x = _dir * _speed;
					
					if ( ((_dir > 0) &&
						 (x >= App.W)) ||
						 ((dir < 0) && (x + SIZE < 0)))
						 dispatchEvent(new Event(OUT_OF_STAGE));
					break;
				case FALLING:
					_tile = SINGLE;
					draw();
					this._velocity.y = 600*deltaS;
					break;
			}
			
			this.x += this._velocity.x * deltaS;
			this.y += this._velocity.y * deltaS;
		}
		
		private function draw():void
		{
			graphics.clear();
			graphics.beginFill(_color);
			graphics.drawRect(0, 0, SIZE, SIZE);
			graphics.endFill();
			
			switch(_tile)
			{
				case SINGLE:
					graphics.lineStyle(BORDER_THICKNESS, 0, 1);
					graphics.drawRect(0, 0, SIZE, SIZE);
					break;
				case LEFT_END:
					graphics.lineStyle(BORDER_THICKNESS, 0, 1);
					graphics.moveTo(SIZE, 0);
					graphics.lineTo(0, 0);
					graphics.lineTo(0, SIZE);
					graphics.lineTo(SIZE, SIZE);
					break;
				case RIGHT_END:
					graphics.lineStyle(BORDER_THICKNESS, 0, 1);
					graphics.moveTo(0, 0);
					graphics.lineTo(SIZE, 0);
					graphics.lineTo(SIZE, SIZE);
					graphics.lineTo(0, SIZE);
					break;
				case UPPER_END:
					graphics.lineStyle(BORDER_THICKNESS, 0, 1);
					graphics.moveTo(0, SIZE);
					graphics.lineTo(0, 0);
					graphics.lineTo(SIZE, 0);
					graphics.lineTo(SIZE, SIZE);
					break;
				case LOWER_END:
					graphics.lineStyle(BORDER_THICKNESS, 0, 1);
					graphics.moveTo(SIZE, 0);
					graphics.lineTo(SIZE, SIZE);
					graphics.lineTo(0, SIZE);
					graphics.lineTo(0, 0);
					break;
				case CROWDED:
					graphics.drawRect(0, 0, SIZE, SIZE);
					break;
				case VERTICAL_TUBE:
					graphics.lineStyle(BORDER_THICKNESS, 0, 1);
					graphics.moveTo(0, 0);
					graphics.lineTo(0, SIZE);
					graphics.moveTo(SIZE, 0);
					graphics.lineTo(SIZE, SIZE);
					break;
				case HORIZONTAL_TUBE:
					graphics.lineStyle(BORDER_THICKNESS, 0, 1);
					graphics.moveTo(0, 0);
					graphics.lineTo(SIZE, 0);
					graphics.moveTo(0, SIZE);
					graphics.lineTo(SIZE, SIZE);
					break;
				case RIGHT_DOWN_CORNER:
					graphics.lineStyle(BORDER_THICKNESS, 0, 1);
					graphics.moveTo(SIZE, 0);
					graphics.lineTo(0, 0);
					graphics.lineTo(0, SIZE);
					break;
				case RIGHT_UP_CORNER:
					graphics.lineStyle(BORDER_THICKNESS, 0, 1);
					graphics.moveTo(0, 0);
					graphics.lineTo(0, SIZE);
					graphics.lineTo(SIZE, SIZE);
					break;
				case LEFT_DOWN_CORNER:
					graphics.lineStyle(BORDER_THICKNESS, 0, 1);
					graphics.moveTo(0, 0);
					graphics.lineTo(SIZE, 0);
					graphics.lineTo(SIZE, SIZE);
					break;
				case LEFT_UP_CORNER:
					graphics.lineStyle(BORDER_THICKNESS, 0, 1);
					graphics.moveTo(SIZE, 0);
					graphics.lineTo(SIZE, SIZE);
					graphics.lineTo(0, SIZE);
					break;
				case BOTTOM_RIGHT_TOP:
					graphics.lineStyle(BORDER_THICKNESS, 0, 1);
					graphics.moveTo(0, 0);
					graphics.lineTo(0, SIZE);
					break;
				case BOTTOM_LEFT_TOP:
					graphics.lineStyle(BORDER_THICKNESS, 0, 1);
					graphics.moveTo(SIZE, 0);
					graphics.lineTo(SIZE, SIZE);
					break;
				case LEFT_BOTTOM_RIGHT:
					graphics.lineStyle(BORDER_THICKNESS, 0, 1);
					graphics.moveTo(0, 0);
					graphics.lineTo(SIZE, 0);
					break;
				case LEFT_TOP_RIGHT:
					graphics.lineStyle(BORDER_THICKNESS, 0, 1);
					graphics.moveTo(0, SIZE);
					graphics.lineTo(SIZE, SIZE);
					break;
			}
		}
		
		public function get group():int
		{
			return this._group;
		}
		
		public function set group(g:int):void
		{
			this._group = g;
		}
		
		public function set color(c:uint):void
		{
			this._color = c;
			draw();
		}
		
		public function get color():uint
		{
			return this._color;
		}
		
		public function get tile():int 
		{
			return _tile;
		}
		
		public function set tile(value:int):void 
		{
			_tile = value;
			draw();
		}
		
		public function get dir():int 
		{
			return _dir;
		}
		
		public function set dir(value:int):void 
		{
			_dir = value;
		}
		
		public function get state():int 
		{
			return _state;
		}
		
		public function set state(value:int):void 
		{
			_state = value;
		}
	}
}