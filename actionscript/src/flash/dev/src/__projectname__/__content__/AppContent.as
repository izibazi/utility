package __projectname__.__content__
{
	
	import flash.events.Event;
	import jp.co.shed.debug.SDTrace;
	import jp.co.shed.events.StageRefEvent;
	
	import __projectname__.common.AppSub;
	import __projectname__.main.AppMain;
	
	import jp.co.shed.controls.UIButton;
	import jp.co.shed.controls.UIButtonInfo;
	
	/**
	 * __content__.swfのドキュメントクラス。
	 * 
	 * AppSubクラスのサブクラスです。
	 * 
	 * @author yasunari ishibashi
	 */
	public class AppContent extends AppSub 
	{		
		
		public function AppContent() 
		{
			super("AppContent", false, "../");
		}
		
		/**
		 * コンテンツを開始します。
		 * 
		 * 必要なデータの初期化完了後に、呼ばれます。
		 * 
		 * @param	evt
		 */
		public override function startApp(evt:Event = null):void 
		{
			super.startApp(evt);
			SDTrace.dump("AppContent startApp");
			ContentController.initMVC(this);
		}

		protected override function resized(evt:StageRefEvent = null):void 
		{
		
		}
		
		/**
		 * ステージから削除時に呼ばれます。
		 * 
		 * @param	evt
		 */
		protected override function removed(evt:Event):void 
		{
			super.removed(evt);
			SDTrace.dump("AppContent removed");
		}
	}
}
