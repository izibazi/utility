package jp.co.shed.display 
{
	import flash.display.MovieClip;
	import flash.errors.IOError;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import jp.co.shed.data.ConfigData;
	import jp.co.shed.data.SAManager;
	import jp.co.shed.events.LoaderManagerEvent;
	import jp.co.shed.media.SoundManager;
	import jp.co.shed.net.InternalSWFLoader;
	import jp.co.shed.reference.StageRef;
	import jp.co.shed.transitions.SDTweener;
	
	/**
	 * StageRefオブジェクトの初期化、 
	 * ConfigDataオブジェクトの初期化、
	 * SAManagerオブジェクトの初期化、
	 * swfのロードの監視、
	 * SounaManagerオブジェクトの初期化(サウンドのロードも含む)を行い、それぞれのイベントも送出するクラス。
	 * 
	 * config.xmlを使用しない場合は、コンストラクタの第二引数に、nullを指定します。
	 * 
	 * @example
	 * ドキュメントクラス内などで使用します。
	 * 
	 * @author yasunari ishibashi
	 */
	public class SDMain extends MovieClip 
	{
		
		/**
		 *  configのxmlのロード完了時に送出されます。
		 */
		public static const CONFIG_LOAD_COMPLETE:String = "configLoadComplete";
		
		/**
		 *  configのxmlのロード失敗時に送出されます。
		 */
		public static const CONFIG_LOAD_ERROR:String = "configLoadError";
		
		/**
		 * swfのロード状況監視開始時に送出されます。
		 */
		public static const MAIN_LOAD_CHECK_START:String = "mainLoadCheckStart";
		
		/**
		 * swfのロード状況変更時に送出されます。
		 */
		public static const MAIN_LOAD_PROGRESS:String = "mainLoadProgress";
		
		/**
		 * swfのロード完了時に送出されます。
		 */
		public static const MAIN_LOAD_COMPLETE:String = "mainLoadComplete";
		
		/**
		 * configのxmlに指定されたサウンドのロード開始時に送出されます。
		 */
		public static const SOUND_LOAD_START:String = "soundLoadStart";
		
		/**
		 * configのxmlに指定されたサウンドのロード状況変更時に送出されます。
		 */		
		public static const SOUND_LOAD_PROGRESS:String = "soudnLoadProgress";
		
		/**
		 * configのxmlに指定されたサウンドのロード完了時に送出されます。
		 */
		public static const SOUND_LOAD_COMPLETE:String = "soundLoadComplete";
		
		/**
		 * すべてのロード終了時(初期化完了時)に送出されます。
		 */
		public static const ALL_LOAD_COMPLETE:String = "allLoadComplete";		
		
		public var stageRef:StageRef;
		
		public var configData:ConfigData;
		
		public var soundManager:SoundManager;
		
		public var saManager:SAManager;
		
		public var appLoader:InternalSWFLoader;
		
		public var configXMLPath:String;
		
		public var rootPath:String;
		
		/** traceを出力するかどうかの真偽値。*/
		public var verbose:Boolean = true;
		
		private var m_inited:Boolean = false;

		/**
		 * コンストラクタ
		 * 
		 * @param	mainTimeline	メインタイムライン (nullの場合は、自分自身(this)が指定されます。)
		 * @param	configXMLPath	cofing.xmlのパス [default:xml/config.xml]
		 * @param	rootPath	ルートパス [default:""]
		 * @param	verbose	詳細を出力するかどうかの真偽値 [default:true]
		 */
		public function SDMain(mainTimeline:MovieClip = null, configXMLPath:String = "xml/config.xml", rootPath:String = "", verbose:Boolean = true) 
		{
			stageRef = StageRef.getInstance();
			stageRef.init(mainTimeline?mainTimeline:this);
			this.configXMLPath = configXMLPath;
			this.rootPath = rootPath;
			this.verbose = verbose;
			configData = ConfigData.getInstance();
		}
		
		/**
		 * 開始します。
		 */
		public function start():void {
			
			if (configXMLPath != null) 
			{
				configData.addEventListener(Event.COMPLETE, __onConfigLoaded);
				configData.addEventListener(IOErrorEvent.IO_ERROR, __onConfigIOError);
				configData.addEventListener(SecurityErrorEvent.SECURITY_ERROR, __onCofigSecurityError);
				configData.load(configXMLPath);
			}
			else 
			{
				checkProgress();
			}			
		}
		
		/**
		 * config.xmlを追加し,開始します。
		 */
		public function startWithConfigXML(xml:XML):void 
		{
			configData.addXML(xml);
			__onConfigLoaded();
		}
		
		private function __onConfigLoaded(evt:Event = null):void 
		{
			log("configのロードが完了しました。");
			configData.setDebugInfo();
			configData.setStageInfo();

			if (configData.xml.SWFAddress != null) {
				log("SAManagerを初期化しました。");
				SAManager.getInstance().init(configData.xml.swfAddress.scene);
			}
			dispatchEvent(new Event(CONFIG_LOAD_COMPLETE));
			
			checkProgress();
		}
		
		private function __onConfigIOError(evt:IOErrorEvent):void 
		{
			log("configのロードに失敗しました。IOError");
			dispatchEvent(new Event(CONFIG_LOAD_ERROR));
		}
		
		private function __onCofigSecurityError(evt:SecurityErrorEvent):void 
		{
			log("configのロードに失敗しました。SecurityError");
			dispatchEvent(new Event(CONFIG_LOAD_ERROR));
		}

		private function removedFromStage(evt:Event):void 
		{
			removeEventListener(Event.REMOVED_FROM_STAGE, removedFromStage);			
		}
		
		private function checkProgress():void 
		{
			log("mainのロードの監視を開始しました。");
			dispatchEvent(new Event(MAIN_LOAD_CHECK_START));
			
			appLoader = new InternalSWFLoader(stageRef.mainTimeline);
			appLoader.addEventListener(Event.COMPLETE, onMainLoaded);
			appLoader.addEventListener(ProgressEvent.PROGRESS, onMainProgress);
			appLoader.start();
		}
		
		private function onMainProgress(evt:ProgressEvent):void 
		{
			dispatchEvent(new Event(MAIN_LOAD_PROGRESS));
		}
		
		private function onMainLoaded(evt:Event):void 
		{
			log("swfのロードが完了しました。");
			dispatchEvent(new Event(MAIN_LOAD_COMPLETE));
			
			if (configData.soundXMLList != null) 
			{
				//SoundManager.verbose = true;
				
				soundManager = SoundManager.getInstance();
				soundManager.addXMLList(configData.soundXMLList, rootPath);
				soundManager.volume(null, null, configData.xml.sound.@initVolume);
				soundManager.addEventListener(LoaderManagerEvent.ALL_COMPLETE, onSoundAllLoaded);
				soundManager.addEventListener(LoaderManagerEvent.ITEM_COMPLETE, onSoundItemLoaded);

				if (soundManager.needLoad) 
				{
					log("soundのロードを開始しました。");
					dispatchEvent(new Event(SOUND_LOAD_START));
					soundManager.load();
				}
				else 
				{
					onAllLoaded();
				}
				
			}
			else 
			{
				onAllLoaded();
			}
		}
		
		private function onSoundItemLoaded(evt:LoaderManagerEvent):void 
		{
			dispatchEvent(new Event(SOUND_LOAD_PROGRESS));
		}

		private function onSoundAllLoaded(evt:LoaderManagerEvent):void 
		{
			soundManager.removeEventListener(LoaderManagerEvent.ALL_COMPLETE, onSoundAllLoaded);
			soundManager.removeEventListener(LoaderManagerEvent.ITEM_COMPLETE, onSoundItemLoaded);
				
			log("soundのロードが完了しました。");
			dispatchEvent(new Event(SOUND_LOAD_COMPLETE));
			onAllLoaded();
		}
		
		private function onAllLoaded():void 
		{
			configData.removeEventListener(Event.COMPLETE, __onConfigLoaded);
			configData.removeEventListener(IOErrorEvent.IO_ERROR, __onConfigIOError);
			configData.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, __onCofigSecurityError);
			appLoader.removeEventListener(Event.COMPLETE, onMainLoaded);
			appLoader.removeEventListener(ProgressEvent.PROGRESS, onMainProgress);
			
			log("すべてのロードが完了しました。");
			m_inited = true;
			dispatchEvent(new Event(ALL_LOAD_COMPLETE));
		}
		
		/**
		 * 現在のswfのロードパーセントを返却します。[min:0 max:1]
		 */
		public function get appPercent():Number 
		{
			if (appLoader == null) return 0;
			
			return appLoader.percentNumber;
		}
		
		/**
		 * swfの容量の合計バイト数を返却します。
		 */
		public function get appBytesTotal():Number 
		{
			if (appLoader == null) return 0;
			
			return appLoader.bytesTotal;			
		}
		
		/**
		 * ロード済みswfの合計バイト数を返却します。
		 */
		public function get appBytesLoaded():Number 
		{
			if (appLoader == null) return 0;
			
			return appLoader.bytesLoaded;			
		}
		
		/**
		 * ロード済みサウンドのパーセントを返却します。[min:0 max:1]
		 */
		public function get soundPercent():Number 
		{
			if (soundManager == null) return 0;
			
			return soundManager.percent;
		}
		
		/**
		 * 現在のロード中のサウンド番号を返却します。
		 */
		public function get soundCurrentCount():Number 
		{
			if (soundManager == null) return 0;
			
			return soundManager.loadCurrentCount;
		}
		
		/**
		 * ロードするサウンドのトータル数を返却します。
		 */
		public function get soundTotalCount():Number 
		{
			if (soundManager == null) return 0;
			
			return soundManager.loadTotal;
		}
		
		/**
		 * 初期化が完了したかどうかを返却します。
		 */
		public function get inited():Boolean { return m_inited; }
		
		private function log(value:String):void 
		{
			if (verbose) {
				trace(toString() + value);
			}
		}
		
		/**
		 * クラスの完全修飾名を返却します。
		 * 
		 * @return クラスの完全修飾名
		 */		
		public override function toString():String 
		{
			return "jp.co.shed.display.SDMain (";
		}
	}
}









