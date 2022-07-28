package com.game
{
	import com.bit101.components.InputText;
	import com.bit101.components.Label;
	import com.bit101.components.Slider;
	import com.greensock.TweenLite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.net.SharedObject;
	
	/**
	 * ...
	 * @author ZackMercury
	 */
	public class Options extends Window
	{
		public static const PADDING:int = 15;
		
		public static var _instance:Options;
		
		public var hueSlider:Slider;
		public var valueShiftSlider:Slider;
		public var valueAmplitudeSlider:Slider;
		public var valueFrequencySlider:Slider;
		public var saturationShiftSlider:Slider;
		public var saturationAmplitudeSlider:Slider;
		public var saturationFrequencySlider:Slider;
		public var stones:InputText;
		public var averageTimeBetweenBlocks:InputText;
		
		public static const HUE_CHANGE:String = "hueChange";
		static public const VALUE_SHIFT_CHANGE:String = "valueShiftChange";
		static public const VALUE_FREQUENCY_CHANGE:String = "valueFrequencyChange";
		static public const VALUE_AMPLITUDE_CHANGE:String = "valueAmplitudeChange";
		static public const SATURATION_SHIFT_CHANGE:String = "saturationShiftChange";
		static public const SATURATION_AMPLITUDE_CHANGE:String = "saturationAmplitudeChange";
		static public const SATURATION_FREQUENCY_CHANGE:String = "saturationFrequencyChange";
		static public const STONES_CHANGE:String = "stonesChange";
		public static const INITIALIZED:String = "initialized";
		static public const AVERAGE_TIME_BETWEEN_BLOCKS_CHANGE:String = "blocksPerSecondChange";
		
		private var currY:int = PADDING*3;
		
		
		public function Options()
		{
			super();
			super._windowWidth = 500;
			super._windowHeight = 500;
			_instance = this;
		}
		
		override protected function init(e:Event = null):void
		{
			super.init(e);
			
			var so:SharedObject = SharedObject.getLocal("shellshockgame");
			if (!so.data.notTheFirstLaunch)
			{
				so.data.notTheFirstLaunch = true;
				so.data.hueShift = 200/9;
				so.data.valueShift = 0.68;
				so.data.valueAmplitude = 0.7;
				so.data.valueFrequency = 2;
				so.data.saturationShift = 1;
				so.data.saturationAmplitude = 0;
				so.data.saturationFrequency = 0;
				so.data.stones = 9;
				so.data.averageTimeBetweenBlocks = 5;
				
				so.flush();
			}
			
			var label:Label = new Label(this, PADDING, currY - 15 - PADDING, "Block coloring settings");
			
			hueSlider = new Slider(Slider.HORIZONTAL, this, PADDING, currY, hueChange);
			hueSlider.minimum = 0;
			hueSlider.maximum = 360/so.data.stones;
			label = new Label(this, hueSlider.x, hueSlider.y - 15, "Hue");
			currY += PADDING + hueSlider.height;
			currY += PADDING;
			hueSlider.value = so.data.hueShift;
			
			valueShiftSlider = new Slider(Slider.HORIZONTAL, this, PADDING, currY, valueShiftChange);
			valueShiftSlider.minimum = 0;
			valueShiftSlider.maximum = 1;
			label = new Label(this, valueShiftSlider.x, valueShiftSlider.y - 15, "Value Shift");
			currY += PADDING + valueShiftSlider.height;
			valueShiftSlider.addEventListener(MouseEvent.MOUSE_DOWN, onHueDown);
			valueShiftSlider.value = so.data.valueShift;
			
			valueAmplitudeSlider = new Slider(Slider.HORIZONTAL, this, PADDING, currY, valueAmplitudeChange);
			valueAmplitudeSlider.minimum = 0;
			valueAmplitudeSlider.maximum = 1;
			label = new Label(this, valueAmplitudeSlider.x, valueAmplitudeSlider.y - 15, "Value Amplitude");
			currY += PADDING + valueAmplitudeSlider.height;
			valueAmplitudeSlider.addEventListener(MouseEvent.MOUSE_DOWN, onHueDown);
			valueAmplitudeSlider.value = so.data.valueAmplitude;
			
			
			valueFrequencySlider = new Slider(Slider.HORIZONTAL, this, PADDING, currY, valueFrequencyChange);
			valueFrequencySlider.minimum = 0;
			valueFrequencySlider.maximum = 6;
			label = new Label(this, valueFrequencySlider.x, valueFrequencySlider.y - 15, "Value Phase Shift");
			currY += PADDING + valueFrequencySlider.height;
			valueFrequencySlider.addEventListener(MouseEvent.MOUSE_DOWN, onHueDown);
			valueFrequencySlider.value = so.data.valueFrequency;
			
			currY += PADDING;
			
			saturationShiftSlider = new Slider(Slider.HORIZONTAL, this, PADDING, currY, saturationShiftChange);
			saturationShiftSlider.minimum = 0;
			saturationShiftSlider.maximum = 1;
			label = new Label(this, saturationShiftSlider.x, saturationShiftSlider.y - 15, "Saturation Shift");
			currY += PADDING + saturationShiftSlider.height;
			saturationShiftSlider.addEventListener(MouseEvent.MOUSE_DOWN, onHueDown);
			saturationShiftSlider.value = so.data.saturationShift;
			
			
			saturationAmplitudeSlider = new Slider(Slider.HORIZONTAL, this, PADDING, currY, saturationAmplitudeChange);
			saturationAmplitudeSlider.minimum = 0;
			saturationAmplitudeSlider.maximum = 1;
			label = new Label(this, saturationAmplitudeSlider.x, saturationAmplitudeSlider.y - 15, "Saturation Amplitude");
			currY += PADDING + saturationAmplitudeSlider.height;
			saturationAmplitudeSlider.addEventListener(MouseEvent.MOUSE_DOWN, onHueDown);
			saturationAmplitudeSlider.value = so.data.saturationAmplitude;
			
			saturationFrequencySlider = new Slider(Slider.HORIZONTAL, this, PADDING, currY, saturationFrequencyChange);
			saturationFrequencySlider.minimum = 0;
			saturationFrequencySlider.maximum = 6;
			label = new Label(this, saturationFrequencySlider.x, saturationFrequencySlider.y - 15, "Saturation Phase Shift");
			currY += PADDING + saturationFrequencySlider.height;
			saturationFrequencySlider.addEventListener(MouseEvent.MOUSE_DOWN, onHueDown);
			saturationFrequencySlider.value = so.data.saturationFrequency;
			
			hueSlider.addEventListener(MouseEvent.MOUSE_DOWN, onHueDown);
			
			currY += PADDING;
			//---
			stones = new InputText(this, PADDING, currY, "", stonesChange);
			stones.text = so.data.stones;
			currY += PADDING + stones.height;
			
			averageTimeBetweenBlocks = new InputText(this, PADDING, currY, "", averageTimeBetweenBlocksChange);
			averageTimeBetweenBlocks.text = String(so.data.averageTimeBetweenBlocks);
			
			stage.addEventListener(MouseEvent.MOUSE_UP, onStageUp);
			dispatchEvent(new Event(INITIALIZED));
		}
		
		private function averageTimeBetweenBlocksChange(e:Event):void 
		{
			dispatchEvent(new Event(AVERAGE_TIME_BETWEEN_BLOCKS_CHANGE));
		}
		
		override public function close(e:MouseEvent):void
		{
			super.close(e);
			var so:SharedObject = SharedObject.getLocal("shellshockgame");
			so.data.stones = int(stones.text);
			so.data.hueShift = hueSlider.value;
			so.data.valueShift = valueShiftSlider.value;
			so.data.valueAmplitude = valueAmplitudeSlider.value;
			so.data.valueFrequency = valueFrequencySlider.value;
			so.data.saturationShift = saturationShiftSlider.value;
			so.data.saturationAmplitude = saturationAmplitudeSlider.value;
			so.data.saturationFrequency = saturationFrequencySlider.value;
			so.data.averageTimeBetweenBlocks = Number(averageTimeBetweenBlocks.text);
			
			so.flush();
		}
		
		public static function getInstance():Options
		{
			if (_instance)
				return _instance;
			else 
				return (new Options());
			
		}
		
		private function saturationFrequencyChange(e:Event):void 
		{
			dispatchEvent(new Event(SATURATION_FREQUENCY_CHANGE));
		}
		
		private function stonesChange(e:Event):void
		{
			hueSlider.maximum = 360 / int(stones.text);
			
			dispatchEvent(new Event(STONES_CHANGE));
		}
		
		private function saturationAmplitudeChange(e:Event):void 
		{
			dispatchEvent(new Event(SATURATION_AMPLITUDE_CHANGE));
		}
		
		private function saturationShiftChange(e:Event):void
		{
			dispatchEvent(new Event(SATURATION_SHIFT_CHANGE));
		}
		
		private function valueFrequencyChange(e:Event):void
		{
			dispatchEvent(new Event(VALUE_FREQUENCY_CHANGE));
		}
		
		private function valueAmplitudeChange(e:Event):void
		{
			dispatchEvent(new Event(VALUE_AMPLITUDE_CHANGE));
		}
		
		private function valueShiftChange(e:Event):void
		{
			dispatchEvent(new Event(VALUE_SHIFT_CHANGE));
		}
		
		private function onHueDown(e:MouseEvent):void
		{
			TweenLite.to(_background, 0.5, {alpha: 0.05});
		}
		
		private function onStageUp(e:MouseEvent):void
		{
			TweenLite.to(_background, 0.3, {alpha: 1});
		}
		
		private function hueChange(e:Event):void
		{
			dispatchEvent(new Event(HUE_CHANGE));
		}
	
	}

}