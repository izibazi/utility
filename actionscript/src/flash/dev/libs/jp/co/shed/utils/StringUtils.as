package jp.co.shed.utils 
{
	
	/**
	 * Stringクラスのユーティリティクラスです。
	 * 
	 * @author yasunari ishibashi
	 */
	public class StringUtils {
		
		/**
		 * 有効なemailアドレスかどうかを返却します。（要検討)
		 * 
		 * @param	str
		 * @return
		 */
		public static function isValidEmail(str:String):Boolean {
			if (str == null) return false;

			if (str.substr(str.length - 1) == ".") return false;
			
			return str.length > 4 && str.indexOf("@") >= 0 && str.indexOf(".") >= 0 && str.lastIndexOf(".") != 0;
			//return str.length > 4
		}
		
		/**
		 * valueの最初の文字を小文字にして返却します。
		 * 
		 * @return
		 */
		public static function lcFirst(value:String):String
		{
			if (value.length == 1)
				return value.toLowerCase();
				
			return value.substr(0, 1).toLowerCase() + value.substr(1);
		}
		
		/**
		 * valueの最初の文字を大文字にして返却します。
		 * 
		 * @return
		 */
		public static function ucFirst(value:String):String
		{
			if (value.length == 1)
				return value.toUpperCase();
				
			return value.substr(0, 1).toUpperCase() + value.substr(1);
		}
		
		/**
		 * valueがnullでなく、一文字以上かどうかを返却します。
		 * 
		 * @param	value
		 * @return
		 */
		public static function isValidString(value:String):Boolean
		{
			return value != null && value.length > 0;
		}
	}
}
