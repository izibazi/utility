package jp.co.shed.net
{
	import flash.events.EventDispatcher;
	import flash.net.URLRequest;
	
	/**
	 *　DisplayLoader,SoundLoader,XMLLoaderの抽象クラス。
	 * 
	 * @author yasunari ishibashi
	 */
	public class AbstractLoader extends EventDispatcher  implements ILoader
	{
		
		private var m_tryCount:uint = 0;
		
		private var m_url:String;
		
		private var m_excuteURL:String;
		
		private var m_currentTryCount:uint = 0;
		
		private var m_urlRequest:URLRequest;
		
		private var m_loading:Boolean = false;
		
		private var m_loaded:Boolean = false;
		
		private var m_percent:Number;	
		
		private var m_bytesLoaded:Number;
		
		private var m_bytesTotal:Number;
		
		private var m_id:uint;
		
		public function get retry():Boolean 
		{
			return currentTryCount < tryCount;
		}

		public function get tryCount():uint { return m_tryCount; }
		public function set tryCount(value:uint):void {m_tryCount = value;}
		
		public function get url():String { return m_url; }
		public function set url(value:String):void {m_url = value;}
		
		public function get currentTryCount():uint { return m_currentTryCount; }
		public function set currentTryCount(value:uint):void {m_currentTryCount = value;}
		
		public function get excuteURL():String { return m_excuteURL; }
		public function set excuteURL(value:String):void {m_excuteURL = value;}
		
		public function get urlRequest():URLRequest { return m_urlRequest; }
		public function set urlRequest(value:URLRequest):void {m_urlRequest = value;}
		
		public function get loading():Boolean { return m_loading; }
		public function set loading(value:Boolean):void {m_loading = value;}
		
		public function get percent():Number { return m_percent; }
		public function set percent(value:Number):void {m_percent = value;}
		
		public function get loaded():Boolean { return m_loaded; }
		public function set loaded(value:Boolean):void {m_loaded = value;}
		
		public function get bytesLoaded():Number { return m_bytesLoaded; }
		public function set bytesLoaded(value:Number):void {m_bytesLoaded = value;}
		
		public function get bytesTotal():Number { return m_bytesTotal; }
		public function set bytesTotal(value:Number):void {m_bytesTotal = value;}
		
		public function get id():uint { return m_id; }
		public function set id(value:uint):void {m_id = value;}
		
		public function load():void{};
		public function close():void{};
		public function unload():void{};
		public function addListeners():void{};
		public function removeListeners():void{};
	}
	
}