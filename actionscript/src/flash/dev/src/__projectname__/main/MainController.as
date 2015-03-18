package __projectname__.main 
{

	import jp.co.shed.debug.SDTrace;
	import jp.co.shed.data.SAManager;
	import jp.co.shed.data.SAScene;
	import jp.co.shed.events.SAManagerEvent;
	
	/**
	 * main.swfのController.
	 * 
	 * @author yasunari ishibashi
	 */
	public class MainController 
	{

		public static var model:MainModel;
		
		public static var view:MainView;		
		
		public static function initMVC():void 
		{
			SDTrace.dump("MainControllerを初期化しました。");
			initModel();
			initView();
			
			start();
		}
		
		private static function initModel():void 
		{
			model = MainModel.getInstance();
		}
		
		private static function initView():void 
		{
			view = new MainView();
			model.mainTimeline.addChild(view);
			view.show();			
		}
		
		private static function start():void 
		{
			//debug
			//model.saManager.change("index");
			
			model.saManager.addEventListener(SAManagerEvent.SCENE_CHANGE, onSceneChanged);
			model.saManager.addEventListener(SAManagerEvent.SCENE_STATUS_CHANGE, onSceneStatusChanged);
			model.saManager.addEventListener(SAManagerEvent.START, onStart);
			model.saManager.start();
		}
		
		private static function onStart(evt:SAManagerEvent):void 
		{
			SDTrace.dump("開始します。");
			SDTrace.dump(evt.scene.key);
			//model.saManager.change("content_1");
			updateDisplay();
		}
		
		private static function onSceneChanged(evt:SAManagerEvent):void 
		{
			SDTrace.dump("ルートシーンが変更されました。");
			SDTrace.dump(evt.scene.key);
			updateDisplay();
			//model.saManager.change("content_root", "query");
		}
		
		private static function onSceneStatusChanged(evt:SAManagerEvent):void 
		{
			SDTrace.dump("ルートシーン内で、シーンが変更されました");
			SDTrace.dump(evt.scene.key);	
			//model.saManager.change("index");
		}
		
		private static function updateDisplay():void 
		{
			
		}
	}
	
}