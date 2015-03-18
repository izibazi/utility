package jp.co.shed.color {
	
	/**
	 * RGB(赤、緑、青)の色情報を管理します。
	 * 
	 * @author Shed ishibashi
	 */
	public class ColorRGB 
	{
		
		/*各パラメーターに設定できる最大値*/
		public static const MAX_VALUE:Number = 255.0;
		
		/*各パラメーターに設定できる最小値*/
		public static const MIN_VALUE:Number = 0.0;
		
		private var m_red:Number;
		
		private var m_green:Number;
		
		private var m_blue:Number;
		
		private var m_rgb:Number;

		/**
		 * コンストラクタ。
		 * 
		 * @param	rgb　RRGGBBの16進数
		 */
		public function ColorRGB(rgb:Number = 0)
		{
			this.rgb = rgb;
		}
		
		/**
		 * rgb値を返却します。
		 */
		public function get rgb():Number { return m_rgb; }
		
		public function set rgb(value:Number):void 
		{
			m_rgb = value;
			m_red = (m_rgb >> 16) & 0xFF;
			m_green = (m_rgb >> 8) & 0xFF;
			m_blue = (m_rgb) & 0xFF;
			
			setUpRGB();
		}
		
		private function setUpRGB():void 
		{
			m_rgb = red << 16 | green << 8 | blue;			
		}
		
		private function checkValue(value:Number):Number 
		{
			value = Math.min(value , MAX_VALUE);
			value = Math.max(MIN_VALUE, value);
			return value;
		}
		
		/**
		 * RRGGBBの16進数の文字列を返却します。
		 */
		public function get rgb16():String 
		{
			return rgb.toString(16);
		}
		
		/**
		 * アルファ値を含めたARGBの値を返却します。
		 * 
		 * @param	alphaValue [min:0 max:255]
		 * @return
		 */
		public function getARGB(alphaValue:Number):Number 
		{
			var alpha:Number = checkValue(alphaValue);
			return (alpha << 24 | red << 16 | green << 8 | blue);
		}

		/**
		 * 赤 , 緑 , 青を設定します。
		 * @param	r
		 * @param	g
		 * @param	b
		 */
		public function setRGB(r:Number, g:Number, b:Number):void 
		{
			red = r;
			green = g;
			blue = b;
		}

		/**
		 * 灰色を設定します。[min:0 max:255]
		 */
		public function set gray(value:Number):void 
		{
			red = blue = green = value;
		}
		
		/**
		 * 赤の値を返却します。[min:0 max:255]
		 */
		public function get red():Number 
		{ 
			return m_red; 
		}

		public function set red(value:Number):void 
		{
			m_red = checkValue(value);
			setUpRGB();
		}

		/**
		 * 緑の値を返却します。[min:0 max:255]
		 */
		public function get green():Number 
		{ 
			return m_green; 
		}
		
		public function set green(value:Number):void 
		{
			m_green = checkValue(value);
			setUpRGB();
		}

		/**
		 * 青の値を返却します。[min:0 max:255]
		 */
		public function get blue():Number 
		{ 
			return m_blue; 
		}
		
		public function set blue(value:Number):void 
		{
			m_blue = checkValue(value);
			setUpRGB();
		}
		
		/**
		 * 赤、緑、青、RRGGBBの値を含めた完全クラス修飾名を返却します。
		 * 
		 * @return
		 */
		public function toString():String 
		{
			var s:String = "jp.co.shed.color.ColorRGB(";
			s += "red='" + red + "',";
			s += "green='" + green + "',";
			s += "blue='" + blue + "',";
			s += "rgb='" + rgb + "')";
			
			return s;
			
		}
		
		/**
		 * ColorHSBをColorRGBに変換し返却します。
		 * 
		 * @param	hsb　ColorHSBオブジェクト
		 * @return
		 */
		public static function toRGB(hsb:ColorHSB):ColorRGB {
			var _color:ColorRGB = new ColorRGB(0);
			if (hsb.saturation == 0) {
				_color.gray = Number(hsb.brightness * 255);
			}else {
				var h :Number = Math.floor(hsb.hue360 / 60);
				var f:Number = hsb.hue360 / 60 - h;
				
				var p:Number = hsb.brightness * (1 - hsb.saturation) * 255;
				var q:Number = hsb.brightness * (1 - hsb.saturation * f) * 255;
				var t:Number = hsb.brightness * (1 - (1 - f) * hsb.saturation) * 255;

				switch(h) {
					case 0:
						_color.setRGB(hsb.brightness * 255 , t , p);
					break;
					case 1:
						_color.setRGB(q , hsb.brightness * 255 , p);
					break;
					case 2:
						_color.setRGB(p , hsb.brightness * 255 , t);
					break;
					case 3:
						_color.setRGB(p , q , hsb.brightness * 255);
					break;
					case 4:
						_color.setRGB(t , p , hsb.brightness * 255);
					break;
					case 5:
						_color.setRGB(hsb.brightness * 255 , p , q);
					break;
				}
			}

			return _color;
		}
		
		/**
		 * ランダムな色の値を返却します。
		 */
		public static function get randomRGB():Number {
			return Math.random() * 255 * 255 * 255;
		}
	}
	
}