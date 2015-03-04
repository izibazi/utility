package jp.co.shed.utils 
{
	
	import flash.system.IME;
	import flash.system.IMEConversionMode;
	import flash.system.Capabilities;
	
	/**
	 * Systemに関するユーティリティクラス
	 * 
	 * @author yasunari ishibashi
	 */
	public class SystemUtils 
	{
		/**
		 * IMEを調べ、有効、無効に変更します。
		 */
		public static function set imeEnabled(enable:Boolean):void {
			if (Capabilities.hasIME)
			{
				IME.enabled = enable;
			}
		}

	}
	
}