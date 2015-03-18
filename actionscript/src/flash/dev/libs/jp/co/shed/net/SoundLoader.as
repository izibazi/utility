package jp.co.shed.net 
{

	import flash.media.Sound;
	import flash.media.SoundLoaderContext;
	import flash.net.URLRequest;
	import flash.events.*;
	import jp.co.shed.events.LoaderEvent;
	
	/**
	 * サウンドファイルのロードを管理するクラス。
	 * 
	 * @author yasunari ishibashi
	 */
	public class SoundLoader extends AbstractLoader
	{
		private var m_loader:Sound;

		public var soundLoaderContent:SoundLoaderContext;

		/**
		 * コンストラクタ
		 * 
		 * @param	url
		 * @param	tryCount
		 * @param	noCache
		 */
		public function SoundLoader(url:String , tryCount:uint = 0, noCache:Boolean = false )
		{
			percent = 0;
			bytesLoaded = 0;
			bytesTotal = 0;
			currentTryCount = 0;
			
			this.tryCount = tryCount;
			this.url = url;
			this.excuteURL = url + (noCache?"?noCache=" + Math.round(Math.random() * 10000000):"");
			this.urlRequest = new URLRequest(excuteURL);
			m_loader = new Sound();
		}
		
		/**
		 * ロードします。
		 */
		public override function load():void
		{

			if (!loading) {
				addListeners();
				loading = true;
				percent = 0;
				bytesLoaded = 0;
				bytesTotal = 0;
				loaded = false;
				this.loader.load(this.urlRequest, soundLoaderContent);

			}
		}
		
		/**
		 * アンロードします。
		 * close()メソッドと同じです。
		 */
		public override function unload():void 
		{
			close();
		}
		
		/**
		 * リスナの登録をします。
		 */
		public override function addListeners():void
		{
			this.loader.addEventListener(Event.OPEN, onOpen);
			this.loader.addEventListener(Event.INIT, onInit);
			this.loader.addEventListener(ProgressEvent.PROGRESS, onProgress);
			this.loader.addEventListener(Event.COMPLETE, onComplete);
			this.loader.addEventListener(Event.ID3, onID3);
			
			this.loader.addEventListener(IOErrorEvent.IO_ERROR, onIOError);
			this.loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR , onSecurityError);
			
			this.loader.addEventListener(HTTPStatusEvent.HTTP_STATUS , onHttpStatus);
		}

		/**
		 * リスナを削除します。
		 */
		public override function removeListeners():void
		{
			this.loader.removeEventListener(Event.OPEN, onOpen);
			this.loader.removeEventListener(Event.INIT, onInit);
			this.loader.removeEventListener(ProgressEvent.PROGRESS, onProgress);
			this.loader.removeEventListener(Event.COMPLETE, onComplete);
			this.loader.removeEventListener(Event.ID3, onID3);
			
			this.loader.removeEventListener(IOErrorEvent.IO_ERROR, onIOError);
			this.loader.removeEventListener(SecurityErrorEvent.SECURITY_ERROR , onSecurityError);
			
			this.loader.removeEventListener(HTTPStatusEvent.HTTP_STATUS , onHttpStatus);
		}

		
		/**
		 * 中止します。
		 * unload()メソッドと同じです。
		 */
		public override function close():void
		{
			currentTryCount = 0;
			removeListeners();
			if (loading)
			{
				try
				{
					this.loader.close();
				}
				catch (e:Error)
				{
					trace(toString() + "catch > " + e);
				}
				loading = false;
			}
		}
		
		private function onOpen(evt:Event):void 
		{
			//dispatchEvent(evt);
			dispatchEvent(new LoaderEvent(LoaderEvent.STATUS_CHANGE, this, evt));
		}
		
		private function onInit(evt:Event):void 
		{
			//dispatchEvent(evt);
			dispatchEvent(new LoaderEvent(LoaderEvent.STATUS_CHANGE, this, evt));
			
		}
		
		private function onProgress(evt:ProgressEvent):void 
		{
			this.percent = evt.bytesLoaded / evt.bytesTotal;
			this.bytesLoaded = evt.bytesLoaded;
			this.bytesTotal = evt.bytesTotal;
			
			//dispatchEvent(evt);
			dispatchEvent(new LoaderEvent(LoaderEvent.STATUS_CHANGE, this, evt));
		}
		
		private function onComplete(evt:Event):void
		{
			currentTryCount = 0;
			loaded = true;
			loading = false;
			
			//dispatchEvent(evt);
			dispatchEvent(new LoaderEvent(LoaderEvent.STATUS_CHANGE, this, evt));
		}
		
		private function onID3(evt:Event):void 
		{
			dispatchEvent(new LoaderEvent(LoaderEvent.STATUS_CHANGE, this, evt));
		}

		private function onIOError(evt:IOErrorEvent):void 
		{
			loading = false;
			trace(toString() + "url : "+excuteURL + " このサウンドのロードに失敗しました。IOError");
			if (retry) 
			{
				trace("再度ロードします。" + currentTryCount);
				currentTryCount++;
				
				load();
			}
			else
			{				
				dispatchEvent(new LoaderEvent(LoaderEvent.STATUS_CHANGE, this, evt));
				currentTryCount = 0;
			}
		}

		private function onSecurityError(evt:SecurityErrorEvent):void
		{
			loading = false;
			trace(toString()+"url : "+excuteURL + " このサウンドのロードに失敗しました。SecurityError");
			if (retry) 
			{			
				trace("再度ロードします。" + currentTryCount);
				currentTryCount++;
				load();
			}
			else
			{			
				dispatchEvent(new LoaderEvent(LoaderEvent.STATUS_CHANGE, this, evt));
				currentTryCount = 0;
			}
		}
		
		private function onHttpStatus(evt:HTTPStatusEvent):void
		{
			//dispatchEvent(evt);
			dispatchEvent(new LoaderEvent(LoaderEvent.STATUS_CHANGE, this, evt));
		}
		
		/**
		 * Soundオブジェクトを返却します。[readonly]
		 */
		public function get loader():Sound { return m_loader; }
		
		/**
		 * クラスの完全修飾名を返却します。
		 * 
		 * @return
		 */
		public override function toString():String
		{
			return "jp.co.shed.net.SoundLoader(";
		}
		
	}
	
}