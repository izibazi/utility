package __projectname__.main
{
	import com.pixelbreaker.ui.osx.MacMouseWheel;

	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.utils.getDefinitionByName;
	
	import jp.co.shed.data.ConfigData;
	import jp.co.shed.display.SDActivityIndicator;
	import jp.co.shed.reference.StageRef;
	import jp.co.shed.transitions.SDTweener;
	import jp.co.shed.display.SDMain;
	import jp.co.shed.debug.SDTrace;
	
	/**
	 * main.swfのドキュメントクラス。
	 *
	 * SDMainオブジェクトに委譲して、StageRefオブジェクトの初期化、
	 * ConfigDataオブジェクトの初期化、SAManagerオブジェクトの初期化、
	 * swfのロードの監視、SounaManagerオブジェクトの初期化(サウンドのロードも含む)を管理します。
	 *
	 * @author yasunari ishibashi
	 */
	public class AppMain extends MovieClip 
	{
		/** config.xmlのパス。使用しないときはnullを指定。*/
		public static const CONFIG_XML_PATH:String = "xml/config.xml";
				
		/** このアプリケーションのドキュメントクラスオブジェクトかどうかの真偽値。*/
		public static var existMainSWF:Boolean;

		public static var mainTimeline:MovieClip;
		
		public var sdMain:SDMain;
		
		public var stageRef:StageRef;
		
		public var configData:ConfigData;

		public var loadingIndicator:*;
		
		public var useLoadingIndicator:Boolean = true;

		/**
		 * コンストラクタ
		 *
		 * 各パラメータは、SDMainオブジェクトのコンストラクタで指定されます。
		 *
		 * @param	mainTimeline	メインタイムライン (nullの場合は、自分自身(this)が指定されます。)
		 * @param	configXMLPath	cofing.xmlのパス [default:xml/config.xml]
		 * @param	existMainSWF	このアプリケーションのドキュメントクラスオブジェクトかどうかの真偽値。　[default:true]
		 * @param	rootPath		ルートパス [default:""]
		 * @param	verbose			詳細を出力するかどうかの真偽値 [default:true]
		 */
		public function AppMain(mainTimeline:MovieClip = null, configXmlPath:String = "xml/config.xml", existMainSWF:Boolean = true, rootDir:String = "", verbose:Boolean = false) 
		{
			this.stop();
			AppMain.existMainSWF = existMainSWF;
			AppMain.mainTimeline = mainTimeline == null?this:mainTimeline;
			sdMain = new SDMain(AppMain.mainTimeline, AppMain.existMainSWF?CONFIG_XML_PATH:configXmlPath, rootDir, verbose);
			addSDMainListener();
			showLoadingIndicator();
			sdMain.start();
			stageRef = sdMain.stageRef;
			configData = sdMain.configData;
			
			MacMouseWheel.setup( this.stage );
		}
		
		private function addSDMainListener():void 
		{
			//config
			sdMain.addEventListener(SDMain.CONFIG_LOAD_COMPLETE, onConfigLoaded);
			sdMain.addEventListener(SDMain.CONFIG_LOAD_ERROR, onConfigError);
			//swf
			sdMain.addEventListener(SDMain.MAIN_LOAD_CHECK_START, onMainCheckStart);
			sdMain.addEventListener(SDMain.MAIN_LOAD_PROGRESS, onMainProgress);
			sdMain.addEventListener(SDMain.MAIN_LOAD_COMPLETE, onMainLoaded);
			//sound
			sdMain.addEventListener(SDMain.SOUND_LOAD_START, onSoundLoadStart);
			sdMain.addEventListener(SDMain.SOUND_LOAD_PROGRESS, onSoundLoadProgress);
			sdMain.addEventListener(SDMain.SOUND_LOAD_COMPLETE, onSoundLoadComplete);
			sdMain.addEventListener(SDMain.ALL_LOAD_COMPLETE, onAllLoaded);
		}
		
		private function removeSDMainListener():void 
		{
			sdMain.removeEventListener(SDMain.CONFIG_LOAD_COMPLETE, onConfigLoaded);
			sdMain.removeEventListener(SDMain.CONFIG_LOAD_ERROR, onConfigError);
			
			sdMain.removeEventListener(SDMain.MAIN_LOAD_CHECK_START, onMainCheckStart);
			sdMain.removeEventListener(SDMain.MAIN_LOAD_PROGRESS, onMainProgress);
			sdMain.removeEventListener(SDMain.MAIN_LOAD_COMPLETE, onMainLoaded);
			
			sdMain.removeEventListener(SDMain.SOUND_LOAD_START, onSoundLoadStart);
			sdMain.removeEventListener(SDMain.SOUND_LOAD_PROGRESS, onSoundLoadProgress);
			sdMain.removeEventListener(SDMain.SOUND_LOAD_COMPLETE, onSoundLoadComplete);
			sdMain.removeEventListener(SDMain.ALL_LOAD_COMPLETE, onAllLoaded);
		}

		private function onConfigLoaded(evt:Event):void 
		{
			//SDTrace.dump("onConfigLoaded");
		}
		
		private function onConfigError(evt:Event):void 
		{
			//SDTrace.dump("onConfigError");
		}
		
		private function onMainCheckStart(evt:Event):void 
		{
			//SDTrace.dump("onMainCheckStart");
		}
		
		private function onMainProgress(evt:Event):void 
		{
			//SDTrace.dump("onMainProgress", sdMain.appBytesLoaded + "/" + sdMain.appBytesTotal, "percent : " + sdMain.appPercent);
		}
		
		private function onMainLoaded(evt:Event):void 
		{
			//SDTrace.dump("onMainLoaded");
		}
		
		private function onSoundLoadStart(evt:Event):void 
		{
			//SDTrace.dump("onSoundLoadStart");
		}
		
		private function onSoundLoadProgress(evt:Event):void 
		{
			//SDTrace.dump("onSoundLoadProgress", sdMain.soundCurrentCount + "/" + sdMain.soundTotalCount, "percent : " + sdMain.soundPercent);
		}
		
		private function onSoundLoadComplete(evt:Event):void 
		{
			//SDTrace.dump("onSoundLoadComplete");
		}

		private function showLoadingIndicator():void 
		{
			if (!useLoadingIndicator) return;
			
			loadingIndicator = new SDActivityIndicator();
			loadingIndicator.showWithRoundRect();
			StageRef.getInstance().mainTimeline.addChild(loadingIndicator);
			loadingIndicator.resizingCenter = true;
		}
		
		private function removeLoadingIndicator():void 
		{
			if (loadingIndicator) {
				StageRef.getInstance().mainTimeline.removeChild(loadingIndicator);
				loadingIndicator = null;
			}
		}

		private function onAllLoaded(evt:Event):void 
		{

			removeSDMainListener();
			
			if (loadingIndicator)
			{
				SDTweener.delay(loadingIndicator, loadingIndicator.hide, [onLoadingIndicatorHided], .4);
			}
			else
			{
				startApp();
			}
		}

		private function onLoadingIndicatorHided():void
		{
			startApp();
		}
		
		private function startApp():void 
		{
			removeLoadingIndicator();
			dispatchEvent(new Event(SDMain.ALL_LOAD_COMPLETE));
			SDTweener.delay(this, play, null, .25);
		}

		/**
		 * 初期化が完了したかどうかを返却します。
		 */
		public function get inited():Boolean 
		{
			return sdMain.inited;
		}
	}
}
