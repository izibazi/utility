package jp.co.shed.utils
{
	
	import jp.co.shed.color.*;
	
	/**
	* 色情報を管理するユーティリティスタティッククラスです。
	* 
	* @author yasunari ishibashi
	*/
	public class ColorUtils
	{

		public static function red(value:int):Number 
		{
			return (value >> 16) & 0xFF;
		}
		
		public static function green(value:int):Number 
		{
			return (value >> 8) & 0xFF;
		}
		
		public static function blue(value:int):Number
		{
			return (value) & 0xFF;
		}
		
		/**
		 * RGB値を返却します。
		 * 
		 * @param	red
		 * @param	green
		 * @param	blue
		 * @return
		 */
		public static function getRGB(red : uint , green : uint , blue :uint):uint 
		{
			blue = Math.min(blue, 255);
			red = Math.min(red, 255);
			green = Math.min(green, 255);
			return (red << 16 | green << 8 | blue);
		}
		
		/**
		 * ARGBの値を返却します。
		 * 
		 * @param	alpha
		 * @param	red
		 * @param	green
		 * @param	blue
		 * @return
		 */
		public static function getARGB(alpha:uint , red : uint , green : uint , blue :uint):uint 
		{
			blue = Math.min(blue, 255);
			red = Math.min(red, 255);
			green = Math.min(green, 255);
			alpha = Math.min(alpha, 255);
			return (alpha << 24 | red << 16 | green << 8 | blue);
			
		}

		/**
		 * ColorHSBインスタンスを返却します。
		 * 
		 * @param	red
		 * @param	green
		 * @param	blue
		 * @return
		 */
		public static function RGBtoHSB(red:uint , green:uint, blue:uint):ColorHSB 
		{
			var rgb:ColorRGB = new ColorRGB();
			rgb.setRGB(red, green, blue);
			var hsb:ColorHSB = ColorHSB.toHSB(rgb);	

			return hsb;
		}
		
		/**
		 * ColorRGBインスタンスを返却します。
		 * 
		 * @param	hue
		 * @param	saturation
		 * @param	brightness
		 * @return
		 */
		public static function HSBtoRGB(hue:uint , saturation:uint , brightness:uint):ColorRGB 
		{
			var hsb:ColorHSB = new ColorHSB(hue, saturation, brightness);
			var rgb:ColorRGB = ColorRGB.toRGB(hsb);
			return rgb;
		}
		
		public static function getLuminance(red : uint , green : uint , blue : uint):Number
		{
			return 0.298912 * red + 0.586611 * green + 0.114478 * blue;
		}

		/*
		*	ColorMatrixFilterで使用するgrayscaleの配列を返却
		*
		*	
		*	 redResult = a[0] * srcR + a[1] * srcG + a[2] * srcB + a[3] * srcA + a[4]
		*	 greenResult = a[5] * srcR + a[6] * srcG + a[7] * srcB + a[8] * srcA + a[9]
		*	 blueResult = a[10] * srcR + a[11] * srcG + a[12] * srcB + a[13] * srcA + a[14]
		*	 alphaResult = a[15] * srcR + a[16] * srcG + a[17] * srcB + a[18] * srcA + a[19]
		*/
		public static function getGlayScaleMatrix(percent:Number = 1):Array
		{
			return [
		 				0.3*percent, 0.59*percent, 0.11*percent, 0, 0 ,
						0.3*percent, 0.59*percent, 0.11*percent, 0, 0 ,
						0.3*percent, 0.59*percent, 0.11*percent, 0, 0 , 
						0 , 0 , 0 , 1 , 0 
			]
		}
		
		
		public static function toString():String
		{
			return "jp.co.shed.utils.ColorUtils";
		}
	}
}