package jp.co.shed.utils
{
	/**
	*	Mathクラスのユーティリティクラスです。
	*
	*	@author yasunari ishibashi
	*/
	public class MathUtils
	{
		
		public static const toDegree:Number = 180 / Math.PI;
		
		public static const toRadian:Number = Math.PI / 180;
		
		/**
		 * 角度からラジアンに変更して返却します
		 * 
		 * @param degree 角度
		 * 
		 * @return ラジアン値
		*/
		public static function radian(degree:Number):Number
		{
			return degree * toRadian;
		}

		/**
		 * ラジアンを角度に変更して返却します
		 * 
		 * @param radian ラジアン
		 * 
		 * @return 角度 
		 */
		public static function degree(radian:Number):Number
		{
			return radian*toDegree;
		}
		
		/**
		 * 最小値と最大値内でランダムな値を返却します。
		 * negativeをtrueにすると,結果の値は、正負ランダムに返却します。
		 * 
		 * @param	min
		 * @param	max
		 * @param	negative
		 * @return
		 */
		public static function random(min:Number = 0 , max:Number = 1 , negative:Boolean = false ):Number
		{
			if (max == min) return max;

			if (max < min) 
			{
				var _temp: Number = max;
				max = min;
				min = _temp;
			}

			var distance:Number = max - min;
			var value:Number = Math.random() * distance + min;

			if (negative) 
				value *= ((Math.random() < .5)?1: -1);
			
			return value;
		}
		
		/**
		 * Math.randomの値が、
		 * pctの値より小さい場合は、1を、それ以外の場合は、-1を返却します。
		 */
		public static function random1(pct:Number = .5):int 
		{
			return Math.random() < pct?1: -1;
		}
		
		/**
		 * 指定した小数点桁数に変換し返却します。
		 * 
		 * @param	value
		 * @param	digit
		 * @return
		 */
		public static function round(value:Number , digit:Number):Number 
		{
			return Math.round(value * digit) / digit;
		}
		
		/**
		 * ある範囲からほかの範囲内に値をマップします。
		 * 
		 * @param	value
		 * @param	low1
		 * @param	hight1
		 * @param	low2
		 * @param	high2
		 * @return
		 */
		public static function map(value:Number , low1:Number , high1:Number , low2:Number , high2:Number):Number 
		{
			var distance1:Number = high1 - low1;
			var def:Number = value - low1;
			var pct:Number = def / distance1;
			
			var distance2:Number = high2 - low2;
			return low2 + distance2 * pct;
		}
		
		/**
		 * 指定した値内に抑制し返却します。
		 * 
		 * @param	value
		 * @param	min
		 * @param	max
		 * @return
		 */
		public static function constrain(value:Number , min:Number = 0, max : Number = 1):Number 
		{
			if (value < min) 
			{
				return min;
			}
			else if (value > max) 
			{
				return max;
			}
			
			return value;
		}
		
		/**
		 * 正規化された範囲の値をマップし返却します。
		 * 
		 * @param	value
		 * @param	min
		 * @param	max
		 * @return
		 */
		public static function norm(value:Number , min:Number = 0, max:Number = 1):Number 
		{
			return value;
		}
		
		public static function randomSplit(value:Number , split:uint , rounded:Boolean = true):Number
		{
			var a:Number = value / split;
			
			var rand:Number = Math.random() * split;
			return a * (rounded?Math.round(rand):rand);
		}
	}
}
