package jp.co.shed.net 
{
	import flash.events.EventDispatcher;
	import flash.events.*;
	
	import jp.co.shed.data.Queue;
	import jp.co.shed.events.LoaderEvent;
	import jp.co.shed.events.LoaderManagerEvent;
	
	/**
	 * AbstractLoaderオブジェクトのロードを管理するクラス。
	 * 
	 * @author yasunari ishibashi
	 */
	public class LoaderManager extends EventDispatcher
	{
		
		private var m_queue:Queue;
		
		private var m_excutedQueue:Queue;
		
		private var m_currentLoader:AbstractLoader;
		
		private var loadExcuted:Boolean;
		
		private var m_total:uint = 0;

		/**
		 * コンストラクタ
		 */
		public function LoaderManager()
		{	
			queue = new Queue();
			m_excutedQueue = new Queue();
		}
		
		/**
		 * AbstractLoaderoオブジェクトを追加します。
		 * 
		 * @param	abstractLoader
		 */
		public function addLoader(abstractLoader:AbstractLoader):AbstractLoader
		{
			if (loadExcuted) 
			{
				clear();
			}
			queue.push(abstractLoader);
			abstractLoader.removeEventListener(LoaderEvent.STATUS_CHANGE, onLoaderEvent);
			abstractLoader.addEventListener(LoaderEvent.STATUS_CHANGE, onLoaderEvent);
			
			m_total = queue.size;
			
			return abstractLoader;
		}

		private function onLoaderEvent(evt:LoaderEvent):void
		{
			check(evt);
			dispatchEvent(evt);
		}
		
		private function check(evt:LoaderEvent):void
		{
			if (!loadExcuted) return;

			//成功か失敗の場合、次に
			if (evt.isComplete || evt.isError) 
			{
				excutedQueue.push(m_currentLoader);
				dispatchEvent(new LoaderManagerEvent(LoaderManagerEvent.ITEM_COMPLETE, null));
				
				if (queue.isEmpty)
				{
					dispatchEvent(new LoaderManagerEvent(LoaderManagerEvent.ALL_COMPLETE, null));
					m_currentLoader = null;
				}
				else
				{
					load();
				}
			}
		}
		
		/**
		 * 設定を破棄し、初期化します。
		 */
		public function clear():void
		{
			loadExcuted = false;
			queue = new Queue();
			m_excutedQueue = new Queue();
			m_currentLoader = null;
			m_total = 0;
			
			close();
		}

		private function close():void 
		{
			if (m_currentLoader != null)
			{
				try 
				{
					m_currentLoader.close();
					m_currentLoader = null;
				}
				catch (e:Error)
				{
					trace(toString() + "close() : catch " + e);
				}
			}
		}
		
		/**
		 * すべてロードに成功したかどうかを返却します。
		 * 
		 * @return すべてロードに成功したかどうかの真偽値。
		 */
		public function get allSuccess():Boolean 
		{
			if (excutedQueue.isEmpty) return false;
			if (!queue.isEmpty) return false;
			
			if (total != excutedQueue.size) return false;
			
			for (var i:uint = 0; i < total; i++ )
			{
				var loader:AbstractLoader = excutedQueue.ary[i];
				if (!loader.loaded)
				{
					return false;
				}
			}

			return true;
		}
		
		/**
		 * ロードを開始します。
		 */
		public function load():void 
		{
			if (!queue.isEmpty)
			{
				loadExcuted = true;
				m_currentLoader = queue.pop();
				m_currentLoader.load();
			}
			else 
			{
				trace(toString() + "load() : ロードするデータは存在しません。");
				dispatchEvent(new LoaderManagerEvent(LoaderManagerEvent.ALL_COMPLETE, null));
			}
		}
		
		/**
		 * 現在のロード中のAbstractLoaderオブジェクトを返却します。
		 */
		public function get currentLoader():AbstractLoader { return m_currentLoader; }
		
		public function set currentLoader(value:AbstractLoader):void 
		{
			m_currentLoader = value;
		}
		
		/**
		 * 追加したAbstractLoaderオブジェクトのQueueオブジェクトを返却します。
		 * このQueueオブジェクトには、すでにロード済みのAbstractLoaderオブジェクトは含まれません。
		 * ロード済みのQueueは、excutedQueueプロパティで取得可能です。
		 */
		public function get queue():Queue { return m_queue; }
		
		public function set queue(value:Queue):void 
		{
			m_queue = value;
		}
		
		/**
		 * すでにロード済みのAbstractLoaderオブジェクトのQueueオブジェクトを返却します。[readonly]
		 */
		public function get excutedQueue():Queue
		{ 
			return m_excutedQueue; 
		}
		
		/**
		 * 追加したAbstractLoader数を返却します。[readonly]
		 */
		public function get total():uint 
		{ 
			return m_total; 
		}
		
		/**
		 * 現在ロード済みのAbstractLoaderオブジェクト数を返却します。[readonly]
		 */
		public function get currentCount():uint 
		{ 
			return excutedQueue.size; 
		}
		
		/**
		 * ロード状況のパーセントを返却します。[min:0 max:1]
		 * 
		 */
		public function get percent():Number 
		{
			if (excutedQueue == null )
				return 0;

			return currentCount / m_total ;
			
		}
		
		/**
		 * クラスの完全修飾名を返却します。
		 * 
		 * @return
		 */
		public override function toString():String
		{
			var s:String = "jp.co.shed.net.LoaderManager(";
			s += "total='"+total+"',";
			s += "currentCount='" + currentCount + "',";
			s += "percent='" + percent + "')";
			return s;
		}

	}
	
}