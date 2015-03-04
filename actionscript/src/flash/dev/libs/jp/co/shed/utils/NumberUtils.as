package jp.co.shed.utils
{
	/**
	 * Numberを操作するスタティックユーティリティクラスです。
	 * 
	 * @author yasunari ishibashi
	 */
	public class NumberUtils
	{
		
		public static var HH_MM_SS_TYPE:uint = 0;
		
		public static var MM_SS_TYPE:uint=1;

		/**
		 * 秒数を時間フォーマットに変換して返却します。
		 * 
		 * <p>現段階では、typeパラメータは、MM_SS_TYPEのみ使用可能です。</p>
		 *	
	  	 * @param sec 秒数
		 * @param type フォーマットタイプ
		 * @param separate セパレート表示文字列
		 */
		public static function formatTime(sec:Number = 0 , type:uint = 1 , separate:String = ":"):String 
		{
			var time:String = "00" + separate + "00";
			
			switch(type)
			{
				case MM_SS_TYPE:
					var mm:String=String(Math.floor(sec/60));
					var ss:String=String(Math.round(sec%60));
					
					mm = mm.length == 1?("0" + mm):mm;
					ss = ss.length == 1?("0" + ss):ss;
					
					return mm+separate+ss;
				break;
				case HH_MM_SS_TYPE:
				
				break;
				default:
					
				break;
			}
			
			return time;
		}
		
		/**
		 * 指定した桁数にフォーマットし返却します。
		 * 
		 * @param	value
		 * @param	displayDigit
		 * @return
		 */
		public static function digit(value:Number , displayDigit:Number):String
		{
			var _value:String = String(value);

			for (var i:uint = 0; i < displayDigit ; i++ ) 
			{
				if (_value.length < displayDigit)
				{
					_value = "0" + _value;
				}
				else 
				{
					break;
				}
			}
			
			return _value;
		}
		
		/**
		 * カンマを3桁ごとに追加した文字列を返却します。
		 * 
		 * @param	value
		 * @return
		 */
		public static function addComma(value:int):String
		{
			var str:String=value+"";
			var newValue:String="";
			var len:uint=str.length;
			for (var i:int = len - 1, count:int = 1; i >= 0; i--, count++) 
			{
				newValue = str.substr(i, 1) + newValue;
				if (count % 3 == 0 && i != 0)
					newValue = "," + newValue;
			}
			
			return newValue;
		}
	}
}