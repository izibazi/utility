package jp.co.shed.net
{
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	
	/**
	 * ログ取得用のスタティッククラス。
	 */
	public class LogManager
	{	
		private static var m_log_ary:Array;
		
		/*ログを取得するかどうかの真偽値*/
		public static var GET_LOG_FLAG:Boolean = true;
		
		/*キャッシュを防止するかどうかの真偽値*/
		public static var noCache:Boolean = true;
		
		/**
		 * ログを取得します。
		 * 
		 * @param	url
		 */
		public static function log(url:String):void 
		{
			if (!GET_LOG_FLAG)
				return ;

			if (m_log_ary == null)
			{
				m_log_ary=[];
			}
			var loader:URLLoader = new URLLoader();
			var excuteURL:String = url + (noCache?("?noCache=" + Math.round(Math.random() * 10000000000)):"");

			var request:URLRequest = new URLRequest(excuteURL);			
			
			m_log_ary.push( { loader : loader , url:url } );			
			trace(toString() + "  " + url);
			addListener(loader);
			loader.load(request);
		}
		
		private static function addListener(loader:URLLoader):void
		{
			loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR , onSecurityError);
			loader.addEventListener(IOErrorEvent.IO_ERROR , onIOError);
			loader.addEventListener(Event.COMPLETE , onComplete);			
		}
		
		private static function removeListener(loader:URLLoader):void
		{
			loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR , onSecurityError);
			loader.addEventListener(IOErrorEvent.IO_ERROR , onIOError);
			loader.addEventListener(Event.COMPLETE , onComplete);			
		}
		
		private static function onComplete(evt:Event):void
		{
			trace(toString() + "ロードに成功しました。" + url(evt.target));
		}
		
		private static function onSecurityError(evt:SecurityErrorEvent):void
		{
			trace(toString() + "ロードに失敗しました。 onSecurityError" + url(evt.target));
		}
		
		private static function onIOError(evt:IOErrorEvent):void
		{
			trace(toString() + "ロードに失敗しました。 onIOError" + url(evt.target));
		}
		
		private static function url(loader:*):String 
		{
			var len:uint = m_log_ary.length;
			for (var i:uint = 0; i < len; i++) 
			{
				var obj:Object = m_log_ary[i];
				if (loader == obj.loader)
				{
					m_log_ary.splice(i, 1);
					removeListener(obj.loader as URLLoader);
					obj.loader = null;
					return obj.url;
				}
			}
			
			return "";
		}
		
		public static function toString():String{
			return "jp.co.shed.net.LogLoader(";
		}
	}
}