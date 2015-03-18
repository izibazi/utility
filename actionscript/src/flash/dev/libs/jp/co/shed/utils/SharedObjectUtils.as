package jp.co.shed.utils {
	
	import flash.net.SharedObject;
	
	/**
	 * SharedObjectを管理するユーティリティクラス。
	 * 
	 * @author yasunari ishibashi
	 */
	public class SharedObjectUtils
	{
		
		/**
		 * 指定したSharedObjectを返却します。
		 * 
		 * @param	key
		 * @param	localPath
		 * @return
		 */
		public static function getLocal(key:String , localPath:String = null):SharedObject
		{
			return SharedObject.getLocal(key, localPath);
		}
		
		/**
		 * 指定したSharedObjectのdataオブジェクトを返却します。
		 * @param	key
		 * @param	localPath
		 * @return
		 */
		public static function getData(key:String , localPath:String = null):Object
		{
			var so:SharedObject = SharedObject.getLocal(key, localPath);	
			return so.data;
		}
		
		/**
		 * 指定したSharedObjectのdataオブジェクトのプロパティ値を返却します。
		 * 
		 * @param	key
		 * @param	param
		 * @param	localPath
		 * @return
		 */
		public static function getDataAt(key:String , param:String , localPath:String = null):*
		{
			var data:Object = getData(key , localPath);
			if (data == null) return null;
			return data[param];
		}
		
		/**
		 * 指定したSharedOjectのdataオブジェクトにデータをセットします。
		 * 
		 * @param	name
		 * @param	data
		 * @param	localPath
		 * @param	minDiskSpace	確保するディスクスペース　バイト
		 */
		public static function setData(key:String , data:Object , localPath:String = null, minDiskSpace:uint = 0):void
		{
			var so:SharedObject = SharedObject.getLocal(key, localPath);
			
			for (var i:* in data)
			{
				so.data[i] = data[i];
			}
			
			so.flush(minDiskSpace);
		}
		
		/**
		 * 指定したSharedObjectのdataオブジェクトに、指定したparamのvalue値をセットします。
		 * 
		 * @param	name
		 * @param	param
		 * @param	value
		 * @param	localPath
		 * @param	minDiskSpace
		 */
		public static function setDataAt(key:String , param:String , value:* , localPath:String = null, minDiskSpace:uint = 0):void
		{
			var so:SharedObject = SharedObject.getLocal(key, localPath);
			so.data[param] = value;
			so.flush(minDiskSpace);
		}
		
		/**
		 * 指定したSharedObjectをクリアーします。
		 * 
		 * @param	name
		 * @param	localPath
		 */
		public static function clear(key:String , localPath:String = null):void
		{
			var so:SharedObject=SharedObject.getLocal(key,localPath);
			so.clear();
		}
	}
}