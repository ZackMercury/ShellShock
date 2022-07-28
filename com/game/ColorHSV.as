package com.game 
{
	/**
	 * ...
	 * @author ZackMercury
	 */
	public class ColorHSV 
	{
		private var _hue:Number;
		private var _saturation:Number;
		private var _value:Number;
 
		public function ColorHSV(hue:Number, saturation:Number, value:Number) 
		{
			this.hue = hue;
			this.saturation = saturation;
			this.value = value;
		}
 
		public function getRGB():Object
		{
			var hi:int = int(_hue / 60) % 6; //делим тон на 6 промежутков, для каждого отдельно будем считать компоненты RGB
			var vMin:int = (100 - _saturation * 100) * _value; 
 
			var a:Number = (_value * 100 - vMin) * (_hue % 60) / 60;
			var vInc:Number = vMin + a;
			var vDec:Number = _value * 100 - a;
 
			var rgb:Object = {r:0, g:0, b:0};
			switch(hi)
			{
				case 0:
					rgb.r = _value;
					rgb.g = vInc / 100;
					rgb.b = vMin / 100; 
					break;
				case 1:
					rgb.r = vDec / 100;
					rgb.g = _value;
					rgb.b = vMin / 100; 
					break;
				case 2:
					rgb.r = vMin / 100;
					rgb.g = _value;
					rgb.b = vInc / 100; 
					break;
				case 3:
					rgb.r = vMin / 100;
					rgb.g = vDec / 100;
					rgb.b = _value; 
					break;
				case 4:
					rgb.r = vInc / 100;
					rgb.g = vMin / 100;
					rgb.b = _value; 
					break;
				case 5:
					rgb.r = _value;
					rgb.g = vMin / 100;
					rgb.b = vDec / 100; 
					break;
			}
 
			return rgb;
		}
 
		public function setRGB(rgb:Object):void
		{
			if (rgb.r > 1) rgb.r = 1;
			else if (rgb.r < 0) rgb.r = 0;
			if (rgb.g > 1) rgb.g = 1;
			else if (rgb.g < 0) rgb.g = 0;
			if (rgb.b > 1) rgb.b = 1;
			else if (rgb.b < 0) rgb.b = 0; //корректировка значений
 
			var min:Number = Math.min(rgb.r, rgb.g, rgb.b); //Находим минимум
			var max:Number = Math.max(rgb.r, rgb.g, rgb.b); //Находим максимум
 
			if (max == min) _hue = 0; //если цвет серый, ничего не надо считать
			else if ((max == rgb.r) && (rgb.g >= rgb.b)) 
				_hue = (60 * (rgb.g - rgb.b)) / (max - min); //если красного больше, всего, и зелёного больше или столько же, сколько и синего
			else if ((max == rgb.r) && (rgb.g < rgb.b)) 
				_hue = (60 * (rgb.g - rgb.b)) / (max - min) + 360; //если красного больше всего и зелёного меньше, чем синего
			else if (max == rgb.g) 
				_hue = (60 * (rgb.b - rgb.r)) / (min - max) + 120; //если зелёного больше всего
			else 
				_hue = (60 * (rgb.r - rgb.g)) / (max - min) + 240; //если синего больше всего
			if(max == 0) _saturation = 0;
			else _saturation = 1 - min / max;
			_value = max;
		}
 
		public function setHex(hex:uint):void
		{
			var rgb:Object = { r: (hex >> 16) & 0xFF, g: (hex >> 8) & 0xFF, b: hex & 0xFF };
			rgb.r /= 0xFF;
			rgb.g /= 0xFF;
			rgb.b /= 0xFF; //Нам нужны значения от нуля до единицы
 
			setRGB(rgb);
		}
 
		public function getHex():uint
		{
			var rgb:Object = getRGB();
			return (Math.round(rgb.r * 0xFF) << 16) | (Math.round(rgb.g * 0xFF) << 8) | (Math.round(rgb.b * 0xFF));
		}
 
		//GET/SET
		public function get hue():Number 
		{
			return _hue;
		}
 
		public function set hue(val:Number):void 
		{
			if (val < 0) //Немного математики для зацикливания от 0 до 360 для всех значений.
				val += Math.ceil(-val / 360) * 360;
			if (val >= 360)
				val -= int(val / 360) * 360;
			_hue = val;
		}
 
		public function get saturation():Number 
		{
			return _saturation;
		}
 
		public function set saturation(val:Number):void 
		{
			if (val < 0)
				val = 0;
			if (val > 1)
				val = 1; //корректировка значений
			_saturation = val;
		}
 
		public function get value():Number 
		{
			return _value;
		}
 
		public function set value(val:Number):void 
		{
			if (val < 0)
				val = 0;
			if (val > 1)
				val = 1; //корректировка значений
			_value = val;
		}
 
	}
 
}