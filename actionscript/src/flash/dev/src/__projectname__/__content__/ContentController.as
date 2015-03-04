package __projectname__.__content__ 
{
	import flash.events.Event;
	import __projectname__.common.AppSub;

	/**
	 * __content__.swfのController.
	 * 
	 * @author yasunari ishibashi
	 */
	public class ContentController
	{
		/** __content__.swfのView. */
		public static var view:ContentView;
		
		/** __content__.swfのModel. */
		public static var model:ContentModel;

		public static function initMVC(appSub:AppSub):void 
		{
			initModel(appSub);
			initView();
			
			start();
		}
		
		private static function initModel(appSub:AppSub):void
		{
			model = ContentModel.getInstance();
			model.appSub = appSub;
		}
		
		private static function initView():void 
		{
			view = new ContentView();
			model.appSub.addChild(view);
			view.addEventListener(Event.REMOVED_FROM_STAGE, remove);
			view.show();
		}
		
		//ここで、メモリを解放する。
		private static function remove(evt:Event):void 
		{
			if (!view) return;
			
			view.removeEventListener(Event.REMOVED_FROM_STAGE, remove);
			model.appSub.removeChild(view);
			ContentModel.deleteInstance();
			view = null;
			model = null;
		}
		
		private static function start():void
		{
			
		}
		
		
	}

}