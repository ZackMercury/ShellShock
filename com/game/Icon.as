package com.game 
{
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	
	/**
	 * ...
	 * @author ZackMercury
	 */
	public class Icon extends Sprite 
	{
		public static const SIZE:int = 25;
		
		var _iconWidth:int = SIZE;
		var _iconHeight:int = SIZE;
		var _spr:Sprite;
		
		public function Icon(sprite:Sprite) 
		{
			super();
			
			this.useHandCursor = true;
			
			_spr = sprite;
			addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event = null):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			
			graphics.beginFill(0, 0);
			graphics.drawRect(0, 0, SIZE, SIZE);
			addChild(_spr);
		}
		
		public function get iconWidth():int 
		{
			return _iconWidth;
		}
		
		public function get iconHeight():int 
		{
			return _iconHeight;
		}
		
	}

}