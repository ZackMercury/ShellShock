package com.game 
{
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	
	/**
	 * ...
	 * @author ZackMercury
	 */
	public class Key extends Shape
	{
		private var keysDown:Object = { };
		
		public function Key() 
		{
			super();
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event = null):void
		{
			stage.addEventListener(KeyboardEvent.KEY_DOWN, kDown);
			stage.addEventListener(KeyboardEvent.KEY_UP, kUp);
		}
		
		private function kDown(e:KeyboardEvent):void
		{
			keysDown[e.keyCode] = true;
		}
		
		private function kUp(e:KeyboardEvent):void
		{
			keysDown[e.keyCode] = null;
		}
		
		public function isDown(key:int):Boolean
		{
			return keysDown[key];
		}
	}

}