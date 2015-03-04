package jp.co.shed.color {
	
	/**
	 * HSB(色合、彩度、輝度)の色情報を管理します。
	 * 
	 * @author Shed ishibashi
	 */
	public class ColorHSB 
	{
		
		/*各パラメーターに設定できる最大値*/
		public static const MAX_VALUE:Number = 1.0;
		
		/*各パラメーターに設定できる最小値*/
		public static const MIN_VALUE:Number = 0.0;
		
		private var m_hue:Number;
		
		private var m_saturation:Number;
		
		private var m_brightness:Number;
		
		/**
		 * コンスとタクタ。
		 * 
		 * @param	hue			色合[0-1]
		 * @param	saturation	彩度[0-1]
		 * @param	brightness	輝度[0-1]
		 */
		public function ColorHSB(hue:Number = 1 , saturation:Number = 1  , brightness:Number = 1) 
		{
				this.hue = hue;
				this.saturation = saturation;
				this.brightness = brightness;
		}

		private function checkValue(value:Number):Number
		{
			value = Math.min(value , MAX_VALUE);
			value = Math.max(MIN_VALUE, value);
			return value;
		}	
		
		/**
		 * 色合いを返却します。[min:0 max:360]
		 */
		public function get hue360():Number 
		{
			return hue * 360;
		}
		
		/**
		 * 角度を用いて色彩を設定します。
		 * @param	degree
		 */
		public function setHue360(degree:Number):void 
		{
			var value:Number = degree % 360;
			if (value < 0) 
			{
				value = 360 + value;
			}
			
			hue = value / 360;
		}	
		
		/**
		 *　色合いを返却します。[min:0 max:1]
		 */
		public function get hue():Number { return m_hue; }
		
		public function set hue(value:Number):void 
		{
			m_hue = checkValue(value);
			if (m_hue == 1) 
			{
				m_hue = 0;
			}
		}
		
		/**
		 * 彩度を返却します。[min:0 max:1]
		 */
		public function get saturation():Number 
		{ 
			return m_saturation; 
		}
		
		public function set saturation(value:Number):void 
		{
			m_saturation = checkValue(value);
		}
		
		/**
		 * 輝度を返却します。[min:0 max:1]
		 */
		public function get brightness():Number 
		{ 
			return m_brightness; 
		}
		
		public function set brightness(value:Number):void 
		{
			m_brightness = checkValue(value);
		}

		/**
		 * ColorRGBの値をColorHSBに変換し返却します。
		 * 
		 * @param	rgb ColorRGBオブジェクト
		 * @return
		 */
		public static function toHSB(rgb:ColorRGB):ColorHSB 
		{
			var max:Number = Math.max(rgb.red , rgb.green , rgb.blue);
			var min:Number = Math.min(rgb.red , rgb.green , rgb.blue);
			var h:Number=0;
			var s:Number = max != 0?(max - min) / max:0;
			var b:Number=max;
			
			if ((max - min) != 0)
			{
				if (max == rgb.red) 
				{
					h = 60 * (rgb.green - rgb.blue) / (max - min) + 0;
				}else if (max == rgb.green) 
				{
					h = 60 * (rgb.blue - rgb.red) / (max - min) + 120;
				}else 
				{
					h = 60 * (rgb.red - rgb.green) / (max - min) + 240;
				}
				if (h < 0) 
				{
					h = 360 + h;
				}
			}
			return new ColorHSB(h/360, s, b / 255);
		}
		
		/**
		 * 色合、彩度、輝度の値を含めた完全クラス修飾名を返却します。
		 * 
		 * @return
		 */
		public function toString():String 
		{
			var s:String = "jp.co.shed.color.ColorHSB (";
			s += "hue='" + hue + "',";
			s += "saturation='" + saturation + "',";
			s += "brightness='" + brightness + "')";
			
			return s;
		}
		
	}
	
}