package jp.co.shed.utils 
{
	/**
	 * ビット演算のラッパーユーティリティースタティッククラス。
	 * 速度が必要な時は使ってはいけない。
	 * 
	 * @author yasunari ishibashi
	 */
	public class BitUtils 
	{
		
		/**
		 * xビット目が、1の値を返却します。;
		 * 
		 * @param	x (0～31)
		 * @return
		 */
		public static function makeBit(x:int):int
		{
			return 1 << x;
		}
		
		/**
		 * マスクします。
		 * 
		 * & AND(論理積) a & b
		 * 
		 * @param	value
		 * @param	masking
		 * @return
		 */
		public static function maskBits(value:int , masking:int):int
		{
			return value & masking;
		}
		
		/**
		 * 削除します。
		 * 
		 * NAND a&~b
		 * 
		 * @param	value
		 * @param	deleteing
		 * @return
		 */
		public static function deleteBits(value:int , deleteing:int):int
		{
			return value &= ~deleteing;
		}
		
		/**
		 * 合成します。
		 * OR(論理和) a | b
		 * 
		 * @param	value
		 * @param	adding
		 * @return
		 */
		public static function addBits(value:int, adding:int):int
		{
			return value | adding;
		}
		
		/**
		 * 反転します。
		 * 
		 * XOR(排他的論理和) a ^ b
		 * 
		 * @param	value
		 * @param	reversing
		 * @return
		 */
		public static function reverseBits(value:int, reversing:int):int
		{
			return value ^ reversing;
		}
		
		/**
		 * 反転します。
		 * 
		 * NOT(論理否定) ^b
		 * @param	value
		 * @return
		 */
		public static function reverse(value:int):int
		{
			return ~value;
		}
		
		/**
		 * xビット目の値を返却します。(0 or 1)
		 * 
		 * @param	value
		 * @param	x
		 * @return
		 */
		public static function bit(value:int, x:int):int
		{
			var b = makeBit(x);
			return ((value & b) == 0) ? 0 :1;
		}
		
		/**
		 * xビット目が、1かどうかを返却します。
		 * 
		 * @param	value
		 * @param	x
		 * @return
		 */
		public static function isOn(value:int, x:int ):Boolean
		{
			return bit(value, x) == 1;
		}
		
		/**
		 * 2進数文字列を返却します。
		 * 
		 * @param	value
		 */
		public static function bits(value:int):String
		{
			var bitsValue:String = "";
			var count:int = 0;
			for (var i:int = 1; i != 0; i <<= 1 )
			{
				bitsValue = (((value & i) == 0)?"0":"1") + bitsValue;
			}

			return bitsValue;
		}
		
		/**
		 * 2進数文字列をダンプします。
		 * 
		 * @param	value
		 */
		public static function dumpBits(value:int):String
		{
			var b:String = bits(value);
			trace(b);
			return b;
		}
	}

}