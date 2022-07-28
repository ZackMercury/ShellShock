package com.game 
{
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	/**
	 * ...
	 * @author ZackMercury
	 */
	public class GamePanel extends Sprite 
	{
		public static const BACKGROUND_COLOR:uint = 0xFF9933;
		public static const PADDING:int = 5;
		public static const RESTART:String = "restart";
		public static const OPTIONS:String = "options";
		
		private static const NEW_GAME:int = 0;
		private static const PREFERENCES:int = 1;
		
		private var _icons:Array = [new Icon(new NewGameSprite()), new Icon(new GearSprite())];
		
		public function GamePanel() 
		{
			super();
			addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			
			//Draw background
			graphics.beginFill(BACKGROUND_COLOR);
			graphics.drawRect(0, 0, App.W, Icon.SIZE + PADDING * 2);
			
			for (var i:int = 0; i < _icons.length; i++)
			{
				addChild(_icons[i]);
				_icons[i].x = PADDING + ((i > 0)?(_icons[i - 1].x + _icons[i - 1].iconWidth):0);
				_icons[i].y = PADDING;
				_icons[i].addEventListener(MouseEvent.CLICK, onIconClick);
			}
		}
		
		private function onIconClick(e:Event):void 
		{
			switch(_icons.indexOf(e.currentTarget as Icon))
			{
				case NEW_GAME:
					dispatchEvent(new Event(RESTART));
					break;
				case PREFERENCES:
					dispatchEvent(new Event(OPTIONS));
					break;
			}
		}
		
	}

}