package __projectname__.common 
{
	import __projectname__.main.AppMain;
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import jp.co.shed.debug.SDTrace;
	import jp.co.shed.events.StageRefEvent;
	import jp.co.shed.reference.StageRef;
	import jp.co.shed.display.SDMain;

	/**
	 * 外部SWFのドキュメントクラスのスーパークラス。
	 * 
	 * @author yasunari ishibashi
	 */
	public class AppSub extends MovieClip 
	{
		
		/*必要であれば、サブクラス内で、ルートディレクトリの相対的な位置を指定します。おもに、開発時(main.swfがいない場合)に、使用するプロパティです。*/
		public static var RELATIVE_ROOT_DIR:String = "";
		
		/*必要であれば、コンテンツ名をサブクラス内で、指定します。*/
		public var CONTENT_IDENTIFIER:String ;
		
		public var verbose:Boolean = false;
		
		public var appMain:AppMain;
		
		public var stageRef:StageRef;
		
		public var standAlone:Boolean;

		/**
		 * コンストラクタ
		 * 
		 * @param	contentID	コンテンツ名
		 * @param	verbose		詳細ログを出力するかどうかの真偽値。
		 * @param	relativeRootDir	ルートディレクトリの相対的パス。
		 */
		public function AppSub(contentID:String = "", verbose:Boolean = false, relativeRootDir:String = "../") 
		{
			init(contentID,verbose,relativeRootDir);		
		}
		
		private function init(contentID:String, verbose:Boolean = false, relativeRootDir = "../"):void 
		{
			
			CONTENT_IDENTIFIER = contentID;
			this.verbose = verbose;
			
			stageRef = StageRef.getInstance();
			stageRef.addEventListener(StageRefEvent.RESIZE, resized);
			
			addEventListener(Event.REMOVED_FROM_STAGE, removed);
			
			if (stageRef.mainTimeline == null) 
			{
				standAlone = true;
				RELATIVE_ROOT_DIR = relativeRootDir;
				var configXMLPath:String = AppMain.CONFIG_XML_PATH != null?(RELATIVE_ROOT_DIR + AppMain.CONFIG_XML_PATH):null;
				appMain = new AppMain(this, configXMLPath, AppMain.existMainSWF, RELATIVE_ROOT_DIR, verbose);

				appMain.addEventListener(SDMain.ALL_LOAD_COMPLETE, startApp);	
				if (appMain.inited)
					startApp();
			}
		}
		
		private function removeListener():void 
		{
			if (appMain)
				appMain.removeEventListener(SDMain.ALL_LOAD_COMPLETE, startApp);	
		}

		/**
		 * このメソッドを、サブクラスでオーバーライドしてください。
		 * super.startApp(evt)を必ず実行しください。
		 * 
		 * @param	evt
		 * 
		 * @example
		 * <listing version="3.0">
		 * 	public override function startApp(evt:Event=null){
		 * 		super.startApp(evt);
		 * 		var controller:* = new Controller();
		 * 	}
		 * </listing>
		 */
		public function startApp(evt:Event = null):void 
		{
			if(verbose){
				SDTrace.dump(CONTENT_IDENTIFIER + "を開始します。");
			}
			resized();
			removeListener();
		}
		
		/**
		 * このSWFのマウスを無効にします。
		 */
		public function disableMouse():void 
		{
			this.mouseChildren = false;
			this.mouseEnabled = false;
		}
		
		/**
		 * 必要に応じてサブクラスでオーバーライドします。
		 * デフォルトでは、ステージの中央の座標に設定します。
		 * 
		 * @param	evt
		 */
		protected function resized(evt:StageRefEvent = null):void 
		{
			//stageRef.positionCenter(this);
			//this.x = stageRef.centerX;
		}
		
		/**
		 * 必要に応じてサブクラスでオーバーライドします。
		 * その場合、必ずsuper.removed(evt)を実行してください。
		 * 
		 * @param	evt
		 */
		protected function removed(evt:Event):void 
		{
			removeListener();
			appMain = null;
			removeEventListener(Event.REMOVED_FROM_STAGE, removed);
			stageRef.removeEventListener(StageRefEvent.RESIZE, resized);
		}
	}
}
