package jp.co.shed.net 
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.net.URLRequest;
	import flash.events.*;
	import flash.system.LoaderContext;
	import jp.co.shed.events.LoaderEvent;
	
	/**
	 * swf,gif,png,jpgの表示ファイルのロードを管理するクラス。
	 * 
	 * @author yasunari ishibashi
	 */
	public class DisplayLoader extends AbstractLoader
	{

		private var m_loader:Loader;

		private var m_loaderInfo:LoaderInfo;
		
		public var loaderContext:LoaderContext;

		/**
		 * コンストラクタ。
		 * 
		 * @param	url
		 * @param	tryCount
		 * @param	noCache
		 */
		public function DisplayLoader(url:String , tryCount:uint = 0, noCache:Boolean=false )
		{
			percent = 0;
			bytesLoaded = 0;
			bytesTotal = 0;
			currentTryCount = 0;
			
			this.tryCount = tryCount;
			this.url = url;
			this.excuteURL = url + (noCache?"?noCache=" + Math.round(Math.random() * 10000000):"");
			this.urlRequest = new URLRequest(excuteURL);
			this.m_loader = new Loader();
			this.loaderContext = new LoaderContext();
			this.loaderInfo = this.loader.contentLoaderInfo;
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

				this.loader.load(this.urlRequest, loaderContext);
			}
		}
		
		/**
		 * アンロードします。
		 */
		public override function unload():void 
		{
			if (loaded) 
			{
				loader.unload();
				loaded = false;
			}
			else if
			(loading)
			{
				close();
			}
			currentTryCount = 0;
			removeListeners();
		}
		
		/**
		 * リスナを登録します。
		 */
		public override function addListeners():void 
		{
			this.loaderInfo.addEventListener(Event.OPEN, onOpen);
			this.loaderInfo.addEventListener(Event.INIT, onInit);
			this.loaderInfo.addEventListener(ProgressEvent.PROGRESS, onProgress);
			this.loaderInfo.addEventListener(Event.COMPLETE, onComplete);
			this.loaderInfo.addEventListener(Event.UNLOAD, onUnload);
			
			this.loaderInfo.addEventListener(IOErrorEvent.IO_ERROR, onIOError);
			this.loaderInfo.addEventListener(SecurityErrorEvent.SECURITY_ERROR , onSecurityError);
			
			this.loaderInfo.addEventListener(HTTPStatusEvent.HTTP_STATUS , onHttpStatus);
		}

		/**
		 * リスナを削除します。
		 */
		public override function removeListeners():void 
		{
			this.loaderInfo.removeEventListener(Event.OPEN, onOpen);
			this.loaderInfo.removeEventListener(Event.INIT, onInit);
			this.loaderInfo.removeEventListener(ProgressEvent.PROGRESS, onProgress);
			this.loaderInfo.removeEventListener(Event.COMPLETE, onComplete);
			this.loaderInfo.removeEventListener(Event.UNLOAD, onUnload);
			
			this.loaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, onIOError);
			this.loaderInfo.removeEventListener(SecurityErrorEvent.SECURITY_ERROR , onSecurityError);
			
			this.loaderInfo.removeEventListener(HTTPStatusEvent.HTTP_STATUS , onHttpStatus);
		}

		/**
		 * ロードを中止します。
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
			dispatchEvent(new LoaderEvent(LoaderEvent.STATUS_COMPLETE, this, evt));
			dispatchEvent(new LoaderEvent(LoaderEvent.STATUS_CHANGE, this, evt));

			if (bitmap)
			{
				bitmap.smoothing = true;
			}
		}
		
		private function onUnload(evt:Event):void
		{
			currentTryCount = 0;
			loaded = false;
			loading = false;
			
			//dispatchEvent(evt);
			dispatchEvent(new LoaderEvent(LoaderEvent.STATUS_CHANGE, this, evt));
		}

		private function onIOError(evt:IOErrorEvent):void 
		{
			loading = false;
			trace(toString() + "url : "+excuteURL + " このパーツのロードに失敗しました。IOError");
			if (retry) 
			{
				trace("再度ロードします。" + currentTryCount);
				currentTryCount++;
				
				load();
			}
			else
			{
				//dispatchEvent(evt);
				dispatchEvent(new LoaderEvent(LoaderEvent.STATUS_ERROR, this, evt));
				dispatchEvent(new LoaderEvent(LoaderEvent.STATUS_CHANGE, this, evt));
				
				currentTryCount = 0;
			}
		}

		private function onSecurityError(evt:SecurityErrorEvent):void 
		{
			loading = false;
			trace(toString()+"url : "+excuteURL + " このサウンドのロードに失敗しました。SecurityError");
			if (retry) {
				trace("再度ロードします。" + currentTryCount);
				currentTryCount++;
				load();
			}
			else
			{
				//dispatchEvent(evt);
				dispatchEvent(new LoaderEvent(LoaderEvent.STATUS_ERROR, this, evt));
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
		 * LoaderInfoオブジェクトを返却します。
		 */
		public function get loaderInfo():LoaderInfo { return m_loaderInfo; }
		public function set loaderInfo(value:LoaderInfo):void {m_loaderInfo = value;}
		
		/**
		 * Loaderオブジェクトを返却します。
		 */
		public function get loader():Loader { return m_loader; }

		/**
		 * ロードしたcontentを返却します。
		 */
		public function get content():DisplayObject
		{
			return loader.content;
		}
		
		/**
		 * ロードしたBitmapオブジェクトを返却します。
		 */
		public function get bitmap():Bitmap
		{
			return loader.content as Bitmap;
		}
		
		/**
		 * ロードしたBitmapDataを返却します。
		 */
		public function get bitmapData():BitmapData
		{
			return bitmap?bitmap.bitmapData:null;
		}
		
		/**
		 * ロードしたBitmapDataのクローンを返却します。
		 * 
		 * @return
		 */
		public function cloneBitmapData():BitmapData
		{
			if (bitmapData == null) return null;
			
			return bitmapData.clone();
		}
		
		/**
		 * ロードしたBitmapのクローンを返却します。
		 * 
		 * @return
		 */
		public function cloneBitmap():Bitmap
		{
			var btmd:BitmapData = cloneBitmapData();
			
			if (btmd == null) return null;
			
			return new Bitmap(btmd, "auto", true);
		}
		
		/**
		 * クラスの完全修飾名を返却します。
		 * 
		 * @return
		 */
		public override function toString():String
		{
			return "jp.co.shed.net.DisplayLoader(";
		}
		
	}
	
}