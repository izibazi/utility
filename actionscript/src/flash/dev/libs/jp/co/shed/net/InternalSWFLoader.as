package jp.co.shed.net
{
	import flash.display.LoaderInfo;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.ProgressEvent;

	/**
	 * 内部のswf自身のロードを監視するクラス。
	 * 
	 * @auther 石橋　泰成
	 * @version 1.0
	 *
	 */
	
	public class InternalSWFLoader extends EventDispatcher
	{
		
		private var target:MovieClip;
		
		private var m_percentNumber:Number = 0;
		
		private var m_percentInt:Number = 0;

		/**
		 * コンストラクタ
		 * 
		 * @param target 
		 */
		public function InternalSWFLoader(target:MovieClip) 
		{
			this.target = target;
		}

		/**
		 * 監視をスタートします。
		 * すでにロード済みの場合は、直後に、Event.COMPLETEを送出します。
		 * 
		 * 不要になった場合は、diposeメソッドを実行してください。
		 * 
		 * @eventType Event.COMPLETE
		 */
		public function start():void
		{
			var loader:LoaderInfo = target.loaderInfo;
			
			loader.addEventListener(ProgressEvent.PROGRESS,__onLoadProgressed);
			loader.addEventListener(Event.COMPLETE, __onLoadCompleted);

			if (loaded)dispatchEvent(new Event(Event.COMPLETE));
		}
		
		/**
		 * ロードが完了しているかどうか返却します。
		 */
		public function get loaded():Boolean
		{
			var loader:LoaderInfo=target.loaderInfo;
			var bool:Boolean = loader.bytesLoaded >= loader.bytesTotal;

			if (bool) 
			{
				m_percentInt = m_percentNumber = 1;
			}
			return bool;
		}

		private function __onLoadProgressed(evt:ProgressEvent):void
		{
			var pct:Number=(evt.bytesLoaded/evt.bytesTotal);
			m_percentNumber = pct;
			m_percentInt = Math.round(pct);
			dispatchEvent(new ProgressEvent(ProgressEvent.PROGRESS));
		}

		private function __onLoadCompleted(evt:Event):void 
		{
			m_percentNumber = m_percentInt = 1;
			dispatchEvent(new Event(Event.COMPLETE));
		}

		/**
		 * 破棄します。
		 */
		public function dispose():void
		{
			var loader:LoaderInfo = target.loaderInfo;
			
			loader.removeEventListener(ProgressEvent.PROGRESS,__onLoadProgressed);
			loader.removeEventListener(Event.COMPLETE, __onLoadCompleted);
		}
		
		/**
		 * 0.0~1のパーセントを返却します。
		 */
		public function get percentNumber():Number { return m_percentNumber; }

		/**
		 * 0~1のパーセントを返却します。
		 */
		public function get percentInt():Number { return m_percentInt; }
		
		/**
		 * 合計バイト数を返却します。
		 */
		public function get bytesTotal():Number 
		{
			var loader:LoaderInfo = target.loaderInfo;
			return loader.bytesTotal;
		}
		
		/**
		 * ロード済みバイト数を返却します。
		 */
		public function get bytesLoaded():Number 
		{
			var loader:LoaderInfo = target.loaderInfo;
			return loader.bytesLoaded;
		}
	}
}