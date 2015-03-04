package jp.co.shed.utils 
{
	import flash.utils.getDefinitionByName;
	
	/**
	 * 
	 * @author yasunari ishibashi
	 */
	public class ClassUtils 
	{
		/**
		 * 指定したクラス名のクラスからオブジェクトを生成して返却します。
		 * 
		 * @param	className
		 * @return
		 */
		public static function getObject(className:String):* 
		{	try {
				var classRef:Class = (getDefinitionByName(className) as Class);
			}
			catch (e:Error)
			{
				trace("!ClassUtils : " + e );
				return null;
			}

			return new classRef();
		}
		
	}
	
}