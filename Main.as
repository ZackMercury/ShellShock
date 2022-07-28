package 
{
	import com.bit101.components.Label;
	import com.game.App;
	import flash.display.Sprite;
	import flash.utils.getTimer;
	import flash.events.Event;
	
	public class Main extends Sprite
	{
		private var _app:App;
		private var _lastTick:int = 0;
		
		public function Main()
		{
			_app = new App();
			addChild(_app);
			
			this.addEventListener(Event.ENTER_FRAME, update);
		}
		
		private function update(e:Event):void
		{
			var currTick:int = getTimer();
			var deltaS:Number = (currTick - _lastTick) / 1000;
			
			_app.update(deltaS);
			_lastTick = currTick;
		}
	}
}