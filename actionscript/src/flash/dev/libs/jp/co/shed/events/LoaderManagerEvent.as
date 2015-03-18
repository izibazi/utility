package jp.co.shed.events 
{
	import flash.events.Event;
	import jp.co.shed.net.LoaderManager;
	
	/**
	 * LoaderManagerオブジェクトが送出するイベントクラス。
	 * 
	 * @author yasunari ishibashi
	 */
	public class LoaderManagerEvent extends Event 
	{
		/*すべてのアイテムのロードされた時に、送出されるイベント名。エラーがあった場合も送出されます。*/
		public static const ALL_COMPLETE:String = "jp.co.shed.events.LoaderManagerEvent.ALL_COMPLETE";
		
		/*各アイテムのロードが終了した時に、送出されるイベント名。*/
		public static const ITEM_COMPLETE:String = "jp.co.shed.events.LoaderManagerEvent.ITEM_COMPLETE";
		
		private var m_loadManager:LoaderManager;
		
		/**
		 * コンストラクタ
		 * 
		 * @param	type
		 * @param	loaderManager
		 * @param	bubbles
		 * @param	cancelable
		 */
		public function LoaderManagerEvent(type:String, loaderManager:LoaderManager,bubbles:Boolean=false, cancelable:Boolean=false) 
		{ 
			super(type, bubbles, cancelable);
			this.loaderManager = loaderManager;
		} 
		
		public override function clone():Event 
		{ 
			return new LoaderManagerEvent(type,loaderManager, bubbles, cancelable);
		} 
		
		public override function toString():String 
		{ 
			return formatToString("LoaderManagerEvent", "type", "bubbles", "cancelable", "eventPhase"); 
		}
		
		public function get loaderManager():LoaderManager { return m_loadManager; }
		
		public function set loaderManager(value:LoaderManager):void 
		{
			m_loadManager = value;
		}
		
	}
	
}