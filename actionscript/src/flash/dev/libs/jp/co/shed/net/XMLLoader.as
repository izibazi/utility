package jp.co.shed.net 
{
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.net.URLVariables;
	import flash.system.System;
	import flash.events.*;
	import jp.co.shed.events.LoaderEvent;
	
	/**
	 * XMLファイルのロードを管理するクラス。
	 * 
	 * @author yasunari ishibashi
	 */
	public class XMLLoader extends AbstractLoader
	{

		private var m_loader:URLLoader;
		
		private var m_unicode:Boolean;
		
		private var m_xml:XML;
		
		public var isXMLFile:Boolean = true;
		
		/**
		 * コンストラクタ。
		 * 
		 * @param	url
		 * @param	isUnicode = true
		 * @param	tryCount
		 * @param	noCache
		 * @param	method
		 * @param	data
		 * @param	dataformat
		 */
		public function XMLLoader(url:String , isUnicode:Boolean = true, tryCount:uint = 0, noCache:Boolean = false, method:String = "GET", data:Object = null, dataformat:String = "text")
		{
			percent = 0;
			bytesLoaded = 0;
			bytesTotal = 0;
			currentTryCount = 0;
			System.useCodePage = !isUnicode;
			
			this.tryCount = tryCount;
			this.m_unicode = isUnicode;
			this.url = url;
			this.excuteURL = url + (noCache?"?noCache=" + Math.round(Math.random() * 10000000):"");
			this.urlRequest = new URLRequest(excuteURL);
			this.urlRequest.method = method;
			this.m_loader = new URLLoader();
			this.loader.dataFormat = dataformat;
			
			if (data != null) 
			{
				urlRequest.data = new URLVariables();
				for (var i:* in data) urlRequest.data[i] = (data[i]);
			}
		}
		
		/**
		 * ロードします。
		 */
		public override function load():void 
		{
			if (!loading)
			{
				addListeners();
				loading = true;
				percent = 0;
				bytesLoaded = 0;
				bytesTotal = 0;
				this.loader.load(this.urlRequest);
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
		
		/**
		 * リスナの登録をします。
		 */
		public override function addListeners():void 
		{
			this.loader.addEventListener(Event.OPEN, onOpen);
			this.loader.addEventListener(Event.INIT, onInit);
			this.loader.addEventListener(ProgressEvent.PROGRESS, onProgress);
			this.loader.addEventListener(Event.COMPLETE, onComplete);
			
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
			
			this.loader.removeEventListener(IOErrorEvent.IO_ERROR, onIOError);
			this.loader.removeEventListener(SecurityErrorEvent.SECURITY_ERROR , onSecurityError);
			
			this.loader.removeEventListener(HTTPStatusEvent.HTTP_STATUS , onHttpStatus);
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
			
			if (isXMLFile)
			{
				if (loader.dataFormat == URLLoaderDataFormat.VARIABLES) 
				{
					m_xml = new XML(unescape(loader.data));
				}
				else
				{
					m_xml = new XML(loader.data);
				}				
			}

			
			parseXML();

			//dispatchEvent(evt);
			dispatchEvent(new LoaderEvent(LoaderEvent.STATUS_COMPLETE, this, evt));
			dispatchEvent(new LoaderEvent(LoaderEvent.STATUS_CHANGE, this, evt));
		}
		
		/**
		 * 取得したデータを返却します。
		 */
		public function get data():*
		{
			if (loader == null) return null;
			
			return loader.data;
		}
		
		protected function parseXML():void { };

		private function onIOError(evt:IOErrorEvent):void 
		{
			loading = false;
			trace(toString() + "url : "+excuteURL + " このxmlのロードに失敗しました。IOError");
			if (retry) 
			{
				trace("再度ロードします。" + currentTryCount);
				currentTryCount++;
				
				load();
			}
			else
			{
				dispatchEvent(new LoaderEvent(LoaderEvent.STATUS_ERROR, this, evt));
				dispatchEvent(new LoaderEvent(LoaderEvent.STATUS_CHANGE, this, evt));
				currentTryCount = 0;
			}
		}

		private function onSecurityError(evt:SecurityErrorEvent):void 
		{
			loading = false;
			trace(toString() + "url : "+excuteURL + " このxmlのロードに失敗しました。SecurityError");
			if (retry) 
			{
				trace("再度ロードします。" + currentTryCount);
				currentTryCount++;
				load();
			}
			else
			{
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
		 * URLLoaderオブジェクトを返却します。[readonly]
		 */
		public function get loader():URLLoader { return m_loader; }
		
		/**
		 * unicodeかどうかを返却します。[readonly]
		 */
		public function get unicode():Boolean { return m_unicode; }

		/**
		 * XMLオブジェクトを返却します。[readonly]
		 */
		public function get xml():XML { return m_xml; }

		public function set xml(value:XML):void 
		{
			m_xml = value;
		}
		
		/**
		 * クラスの完全修飾名を返却します。
		 * 
		 * @return
		 */
		public override function toString():String 
		{
			return "jp.co.shed.net.XMLLoader(";
		}
		
	}
	
}