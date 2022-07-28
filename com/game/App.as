package com.game
{
	import flash.display.Sprite;
	import flash.events.Event;
	
	public class App extends Sprite
	{
		public static const W:int = 820;
		public static const H:int = 800;
		
		private var _game:Game;
		private var _menu:GamePanel;
		private var _options:Options;
		
		public function App()
		{
			_options = Options.getInstance();
			_options.addEventListener(Options.INITIALIZED, onOptionsActivate);
			addChild(_options); //required for initializing sliders
			
			_options.alpha = 0;
			
		}
		
		private function onOptionsActivate(e:Event):void
		{
			_options.removeEventListener(Options.INITIALIZED, onOptionsActivate);
			removeChild(_options);
			_game = new Game();
			addChild(_game);
			_menu = new GamePanel(); //doesn't require updating
			addChild(_menu);
			_menu.addEventListener(GamePanel.OPTIONS, openOptions);
			_menu.addEventListener(GamePanel.RESTART, restartGame);
			
			_game.y = _menu.y + Icon.SIZE + GamePanel.PADDING * 2;
		}
		
		private function restartGame(e:Event):void 
		{
			_game.destroy();
			removeChild(_game);
			_game = new Game();
			addChild(_game);
			_game.y = _menu.y + Icon.SIZE + GamePanel.PADDING * 2;
		}
		
		private function openOptions(e:Event):void
		{
			addChild(_options);
			_options.x = (App.W - _options.windowWidth) / 2;
			_options.y = (App.H - _options.windowHeight) / 2;
			_options.appear();
			
			_game.suspend();
			_options.addEventListener(Event.CLOSE, resumeGame);
		}
		
		private function resumeGame(e:Event):void
		{
			_game.resume();
		}
		
		public function update(deltaS:Number):void
		{
			if (_game) _game.update(deltaS);
		}
	}
}