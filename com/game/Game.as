package com.game
{
	import com.greensock.TweenLite;
	import com.greensock.easing.Cubic;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.ui.Keyboard;
	
	public class Game extends Sprite
	{		
		public static const DEBUG:Boolean = true;
		
		public static const INITIAL_BLOCKS:Number = 0.25;
		public static const LINE_OFFSET:int = Block.SIZE;
		
		//States
		public static const IDLE:int = 0;
		public static const FALLING:int = 1;
		static public const SUSPENDED:int = 2;
		//--
		
		private var _options:Options = Options.getInstance();
		private var _blocks:Array;
		private var _running:Array;
		
		private var _blocksBackup:Array;
		private var _hardness:Number = 0.7;
		private var _stones:int;
		private var _averageTimeBetweenBlocks:Number;
		private var _state:int;
		
		private var _groups:Array;
		private var spr:Sprite = new Sprite();
		
		private var _clickable:Boolean = true;
		private var _waitingFor:int = 0;
		private var _score:int = 0;
		
		public function Game()
		{
			_blocks = [];
			_groups = [];
			_running = [];
			_blocksBackup = [];
			
			trace(_options.stones);
			trace(_options.hueSlider);
			_stones = int(_options.stones.text);
			_averageTimeBetweenBlocks = Number(_options.averageTimeBetweenBlocks.text);
			
			for (var i:int = 0; i < int(App.W / (Block.SIZE)); i++)
			{
				_blocks.push(new Array(int((App.H - Block.SIZE) / (Block.SIZE))));
				_blocksBackup.push(new Array(int((App.H - Block.SIZE) / (Block.SIZE))));
			}
			
			
			
			//Initializing groups with colors
			updateColors();
			
			//---
			
			for(var ox:int = 0; ox < _blocks.length; ox++)
			{
				for (var oy:int = 0; oy < _blocks[0].length; oy ++)
				{
					var block:Block = new Block(0, 0xFFFFFF);
					
					//Determining group of the block
					if (Math.random() > _hardness)
					{
						if (ox > 0 && oy > 0)
						{
							block.group = (Math.random()<0.5)?_blocks[ox-1][oy].group:_blocks[ox][oy-1].group;
						}
						else
						{
							block.group = int(Math.random() * _stones);
						}
					}
					else
					{
						block.group = int(Math.random() * _stones);
					}
					
					block.color = _groups[block.group];
					_blocks[ox][oy] = block;
					addChild(block);
					block.y = LINE_OFFSET + oy * (Block.SIZE-1);
					block.x = ox * (Block.SIZE-1);
					block.addEventListener(MouseEvent.CLICK, onBlockClick);
					
					
					if(DEBUG) _blocks[ox][oy].addEventListener(MouseEvent.MOUSE_WHEEL, onBlockWheel);
				}
			}
			
			tileBlocks();
			
			if(stage) init(null) else addEventListener(Event.ADDED_TO_STAGE, init);
		}

		
		private function init(e:Event):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
			
			_options.addEventListener(Options.HUE_CHANGE, updateColors);
			_options.addEventListener(Options.VALUE_SHIFT_CHANGE, updateColors);
			_options.addEventListener(Options.VALUE_AMPLITUDE_CHANGE, updateColors);
			_options.addEventListener(Options.VALUE_FREQUENCY_CHANGE, updateColors);
			_options.addEventListener(Options.SATURATION_SHIFT_CHANGE, updateColors);
			_options.addEventListener(Options.SATURATION_AMPLITUDE_CHANGE, updateColors);
			_options.addEventListener(Options.SATURATION_FREQUENCY_CHANGE, updateColors);
			
		}
		
		private function backupArray():void
		{
			for(var ox:int = 0; ox < _blocks.length; ox ++)
			{
				for (var oy:int = 0; oy < _blocks[0].length; oy ++)
				{
					_blocksBackup[ox][oy] = _blocks[ox][oy];
				}
			}
		}
		
		public function destroy():void
		{
			removeClickListeners();
			_options.removeEventListener(Options.HUE_CHANGE, updateColors);
			_options.removeEventListener(Options.VALUE_SHIFT_CHANGE, updateColors);
			_options.removeEventListener(Options.VALUE_AMPLITUDE_CHANGE, updateColors);
			_options.removeEventListener(Options.VALUE_FREQUENCY_CHANGE, updateColors);
			_options.removeEventListener(Options.SATURATION_SHIFT_CHANGE, updateColors);
			_options.removeEventListener(Options.SATURATION_AMPLITUDE_CHANGE, updateColors);
			_options.removeEventListener(Options.SATURATION_FREQUENCY_CHANGE, updateColors);
			stage.removeEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
		}
		
		private function onKeyDown(e:KeyboardEvent):void 
		{
			if ((e.keyCode == 90) && e.ctrlKey)
			{
				//Cancelling last move:
				for(var ox:int = 0; ox < _blocks.length; ox ++)
				{
					for (var oy:int = 0; oy < _blocks[0].length; oy ++)
					{
						var temp = _blocks[ox][oy];
						 _blocks[ox][oy] = _blocksBackup[ox][oy];
						 _blocksBackup[ox][oy] = _blocks[ox][oy];
						 if(_blocks[ox][oy]) addChild(_blocks[ox][oy]);
					}
				}
				redrawGrid();
				tileBlocks();
				addClickListeners();
			}
		}
		
		private function traceGrid():void
		{
			for(var ox:int = 0; ox < _blocks.length; ox ++)
			{
				for (var oy:int = 0; oy < _blocks[0].length; oy ++)
				{
					trace(ox, oy, _blocks[ox][oy]);
				}
			}
		}
		
		private function getCoordinates(b:Block):Object
		{
			for (var i:int = 0; i < _blocks.length; i++ )
			{
				var indexOf:int = _blocks[i].indexOf(b);
				if (indexOf > -1)
					return {x:i, y:indexOf};
			}
			return { x: Math.round((b.x)/Block.SIZE), y: Math.round((b.y)/Block.SIZE)-1 };
		}
		
		private function getRealCoordinates(ox, oy):Object
		{
			return {x:ox * (Block.SIZE-1), y: Block.SIZE + oy * (Block.SIZE-1)};
		}
		
		private function redrawGrid():void
		{
			for(var ox:int = 0; ox < _blocks.length; ox ++)
			{
				for (var oy:int = 0; oy < _blocks[0].length; oy ++)
				{
					if (!_blocks[ox][oy]) continue;
					var block:Block = _blocks[ox][oy];
					addChild(block);
					block.y = LINE_OFFSET + oy * (Block.SIZE - 1);
					block.x = ox * (Block.SIZE - 1);
				}
			}
		}
		
		private function traceCluster(x, y):Array
		{
			var cluster:Array = [];
			var awaiting:Array = [];
			
			awaiting.push(_blocks[x][y]);
			cluster.push(_blocks[x][y]);
			while (awaiting.length)
			{	
				var curr:Block = awaiting.shift();
				var x:int = getCoordinates(curr).x;
				var y:int = getCoordinates(curr).y;
				
				for (var i:int = 0; i < 4; i++)
				{
					var currX:int = Math.cos(i / 4 * 2 * Math.PI);
					var currY:int = Math.sin(i / 4 * 2 * Math.PI);
					if (((x + currX) < 0)||((x + currX) > _blocks.length - 1) ||
						((y + currY) < 0)||((y + currY) > _blocks[0].length - 1))
						continue;
					if (!_blocks[x + currX][y + currY]) continue;
					if ((_blocks[x + currX][y + currY].group == _blocks[x][y].group) &&
						(awaiting.indexOf(_blocks[x + currX][y + currY]) < 0) &&
						(cluster.indexOf(_blocks[x + currX][y + currY]) < 0))
					{
						awaiting.push(_blocks[x + currX][y + currY]);
						cluster.push(_blocks[x + currX][y + currY]);
					}
					
				}
			}
			return cluster;
		}
		
		private function onBlockClick(e:MouseEvent):void 
		{
			backupArray();
			var b:Block = e.currentTarget as Block;
			var cluster:Array = traceCluster(getCoordinates(b).x, getCoordinates(b).y);
			
			if (cluster.length > 1)
			{
				_state = FALLING;
				spr.x = spr.y = 0;
				addChild(spr);
				
				for (var i:int = 0; i < cluster.length; i ++)
				{
					spr.x += cluster[i].x + Block.SIZE / 2;
					spr.y += cluster[i].y + Block.SIZE / 2;
					cluster[i].removeEventListener(MouseEvent.CLICK, onBlockClick);
					cluster[i].mouseEnabled = false;
					removeChild(cluster[i]);
					spr.addChild(cluster[i]);
					spr.mouseChildren = false;
					spr.mouseEnabled = false;
				}
				spr.x /= cluster.length;
				spr.y /= cluster.length;
				
				var stack:Boolean = false;
				for (i = 0; i < cluster.length; i++)
				{
					cluster[i].x -= spr.x;
					cluster[i].y -= spr.y;
					
					var coords:Object = getCoordinates(cluster[i]);
					if (_blocks[coords.x][coords.y - 1] && cluster.indexOf(_blocks[coords.x][coords.y - 1])<0)
						stack = true;
					_blocks[coords.x][coords.y] = null;
				}
				TweenLite.fromTo(spr, 0.2, {alpha:1, scaleX:1, scaleY:1}, {alpha:0, scaleX: 2, scaleY:2, onComplete:onBlocksDissolve, onCompleteParams: [stack], ease:Cubic.easeIn});
				_score += Math.pow(cluster.length, 6);
			}
		}
		
		private function onBlocksDissolve(stack:Boolean):void 
		{
			removeClickListeners();
			removeChild(spr);
			while (spr.numChildren)
				spr.removeChildAt(0);
			
			if(stack)
				rebuildField();
			else
				removeGaps();
		}
		
		private function rebuildField():void 
		{
			for(var ox:int = 0; ox < _blocks.length; ox ++)
			{
				for (var oy:int = _blocks[0].length-1; oy >= 0; oy --)
				{
					if (!_blocks[ox][oy] && (oy - 1 >= 0) && _blocks[ox][oy - 1])
					{
						var ay:int = oy;
						while (--ay >= 0 && _blocks[ox][ay])
						{
							_state = FALLING;
							
							var floor:int = _blocks[0].length - 1;
							while (_blocks[ox][floor])
								floor --;
							
							TweenLite.killTweensOf(_blocks[ox][ay]);
							TweenLite.to(_blocks[ox][ay], (floor - ay) / 15, { y:getRealCoordinates(ox, floor).y, onComplete: delivered, onCompleteParams: [_blocks[ox][ay]], ease: Cubic.easeIn });
							if (!_blocks[ox][ay].animating) _waitingFor ++;
							
							_blocks[ox][ay].animating = true;
							_blocks[ox][floor] = _blocks[ox][ay];
							_blocks[ox][ay] = null;
						}
					}
				}
			}
		}
		
		private function shiftToTheLeft(ox:int):void
		{
			_state = FALLING;
			for (var ax:int = ox; ax < _blocks.length - 1; ax ++)
				for (var ay:int = 0; ay < _blocks[0].length; ay++)
				{
					_blocks[ax][ay] = _blocks[ax + 1][ay];
					if (!_blocks[ax][ay]) continue;
					_blocks[ax][ay].animating = true;
					TweenLite.killTweensOf(_blocks[ax][ay]);
					TweenLite.to(_blocks[ax][ay], (_blocks[ax][ay].x - ax * (Block.SIZE-1)) / (Block.SIZE-1) * 0.2, { x: ax * (Block.SIZE-1), onComplete: shifted, onCompleteParams: [_blocks[ax][ay]] });
					if(!_blocks[ax][ay].animating) _waitingFor ++;
				}
			
			for (var oy:int = 0; oy < _blocks[0].length; oy++)
				_blocks[_blocks.length - 1][oy] = null;
		}
		
		private function removeGaps():void
		{
			for (var ox:int = 0; ox < _blocks.length; ox ++)
			{
				if (((ox == 0) && (!isThereAnythingY(ox, 0)) && isThereAnythingAfterX(ox)) ||
					((ox-1 >= 0) && (!isThereAnythingY(ox, 0)) && isThereAnythingY(ox-1, 0) && isThereAnythingAfterX(ox)))
					shiftToTheLeft(ox--);
			}
			if (_waitingFor < 1)
				_state = IDLE;
		}
		
		private function shifted(block:Block):void 
		{
			_waitingFor --;
			block.animating = false;
			if (_waitingFor > 0) return;
			_waitingFor = 0;
			redrawGrid();
			tileBlocks();
			_state = IDLE;
		}
		
		private function delivered(bl:Block):void 
		{
			redrawGrid();
			tileBlocks();
			
			_waitingFor --;
			bl.animating = false;
			
			if (_waitingFor > 0) return;
			_waitingFor = 0;
			redrawGrid();
			tileBlocks();
			
			removeGaps();
			
			_state = IDLE;
		}
		
		private function isThereAnythingX(ox:int, oy:int):Boolean
		{
			for (var ax:int = ox; ax < _blocks.length; ax++)
				if (_blocks[ax][oy]) 
					return true;
			return false;
		}
		
		private function isThereAnythingY(ox:int, oy:int):Boolean
		{
			var anything:Boolean = false;
			for (var ay:int = oy; ay < _blocks.length; ay++)
				if (_blocks[ox][ay]) 
					anything = true;
			return anything;
		}
		
		private function isThereAnythingAfterX(ox:int):Boolean
		{
			var anything:Boolean = false;
			for (var ax:int = ox; ax < _blocks.length; ax++)
			{
				if (isThereAnythingY(ax, 0))
					anything = true;
			}
			return anything;
		}
		
		private function removeClickListeners():void 
		{
			for(var ox:int = 0; ox < _blocks.length; ox ++)
			{
				for (var oy:int = 0; oy < _blocks[0].length; oy ++)
				{
					if (!_blocks[ox][oy]) continue;
					_blocks[ox][oy].removeEventListener(MouseEvent.CLICK, onBlockClick);
					
					if (DEBUG) 
						_blocks[ox][oy].removeEventListener(MouseEvent.MOUSE_WHEEL, onBlockWheel);
				}
			}
			_clickable = false;
		}
		
		private function addClickListeners():void 
		{
			for(var ox:int = 0; ox < _blocks.length; ox ++)
			{
				for (var oy:int = 0; oy < _blocks[0].length; oy ++)
				{
					if (!_blocks[ox][oy]) continue;
					_blocks[ox][oy].addEventListener(MouseEvent.CLICK, onBlockClick);
					
					if (DEBUG)
						_blocks[ox][oy].addEventListener(MouseEvent.MOUSE_WHEEL, onBlockWheel);
				}
			}
			_clickable = true;
		}
		
		private function onBlockWheel(e:MouseEvent):void 
		{
			var b:Block = e.currentTarget as Block;
		}
		
		private function tileBlocks():void
		{
			for(var ox:int = 0; ox < _blocks.length; ox++)
			{
				for (var oy:int = 0; oy < _blocks[0].length; oy ++)
				{
					if (!_blocks[ox][oy]) continue;
					if (!_blocks[ox][oy]) continue;
					var s:String = "";
					if ( ((ox + 1) < _blocks.length) && 
						 _blocks[ox + 1][oy] && 
						 (_blocks[ox + 1][oy].group == _blocks[ox][oy].group))
						s += "1";
					else 
						s += "0";
					if ( ((oy + 1) < _blocks[0].length) && 
						 _blocks[ox][oy + 1] && 
						 (_blocks[ox][oy + 1].group == _blocks[ox][oy].group))
						s += "1";
					else 
						s += "0";
					if ( ((ox - 1) >= 0) && 
						 _blocks[ox - 1][oy] && 
						 (_blocks[ox - 1][oy].group == _blocks[ox][oy].group))
						s += "1";
					else 
						s += "0";
					if ( ((oy - 1) >= 0) && 
						 _blocks[ox][oy - 1] && 
						 (_blocks[ox][oy - 1].group == _blocks[ox][oy].group))
						s += "1";
					else 
						s += "0";
					_blocks[ox][oy].tile = parseInt(s, 2);
				}
			}
		}
		
		public function updateColors(e:Event = null):void
		{
			var clr:ColorHSV = new ColorHSV(0, 1, 1);
			_groups.splice(0);
			
			for (var i:int = 0; i < _stones; i ++)
			{
				clr.hue = (i / (_stones)) * 360 + _options.hueSlider.value;
				clr.value = _options.valueShiftSlider.value + Math.pow(Math.cos(i+_options.valueFrequencySlider.value), 2) / 3 * _options.valueAmplitudeSlider.value;
				clr.saturation = _options.saturationShiftSlider.value + Math.pow(Math.cos(i+_options.saturationFrequencySlider.value), 2) / 3 * _options.saturationAmplitudeSlider.value;
				_groups.push(clr.getHex());
			}
			
			for(var ox:int = 0; ox < _blocks.length; ox ++)
			{
				for (var oy:int = 0; oy < _blocks[0].length; oy ++)
				{
					if (!_blocks[ox][oy]) continue;
						_blocks[ox][oy].color = _groups[_blocks[ox][oy].group];
				}
			}
			
			for (i = 0; i < _running.length; i ++)
				_running[i].color = _groups[_running[i].group];
		}
		
		public function fits(b1:Block, b2:Block):Boolean
		{
			return (Math.round(b1.x / Block.SIZE) == Math.round(b2.x / Block.SIZE)) &&
					(Math.round(b1.y / Block.SIZE) >= Math.round(b2.y / Block.SIZE));
		}
		
		public function suspend():void
		{
			_state = SUSPENDED;
		}
		
		public function resume():void
		{
			_state = IDLE;
		}
		
		public function update(deltaS:Number):void
		{
			for(var ox:int = 0; ox < _blocks.length; ox ++)
			{
				for (var oy:int = 0; oy < _blocks[0].length; oy ++)
				{
					if (!_blocks[ox][oy]) continue;
					(_blocks[ox][oy] as Block).update(deltaS);
				}
			}
			
			for (var i:int = 0; i < _running.length; i ++)
			{
				_running[i].update(deltaS);
			}
			
			if (Math.random() < (deltaS / _averageTimeBetweenBlocks))
			{
				var b:Block = new Block(0x000000);
				b.group = int(Math.random() * _stones);
				b.color = _groups[b.group];
				b.dir = (Math.random() < 0.5)? -1:1;
				if (b.dir > 0)
					b.x = -Block.SIZE;
				else
					b.x = App.W;
				
				b.state = Block.RUNNING;
				addChild(b);
				_running.push(b);
				b.addEventListener(Block.OUT_OF_STAGE, destroyBlock);
				
				
				for (i = 0; i < _running.length; i ++)
					if (b.hitTestObject(_running[i]) && (b!=_running[i]) && (b.dir != _running[i].dir))
						removeRunningBlock(b); //If block spawns when something else is on the way, cancel
					else if (b.hitTestObject(_running[i]) && (b != _running[i]) && (b.dir == _running[i].dir))
						b.x = _running[i].x + b.dir * Block.SIZE;
			}
			
			switch(_state)
			{
				case IDLE:
					if (!_clickable) addClickListeners();
					break;
				case FALLING:
					if (_clickable) removeClickListeners();
					break;
				case SUSPENDED:
					if (_clickable) removeClickListeners();
					break;
			}
		}
		
		private function removeRunningBlock(b:Block):void
		{
			removeChild(b);
			_running.splice(_running.indexOf(b), 1);
		}
		
		private function destroyBlock(e:Event):void
		{
			var b:Block = e.currentTarget as Block;
			removeRunningBlock(b);
		}
		
	}
}