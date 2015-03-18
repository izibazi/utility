package __projectname__.__content__ 
{
	import flash.display.MovieClip;
	import flash.events.EventDispatcher;
	import jp.co.shed.data.ConfigData;
	import jp.co.shed.reference.StageRef;
	import jp.co.shed.debug.SDTrace;
	import jp.co.shed.data.SAManager;
	import __projectname__.common.AppSub;
	import __projectname__.main.MainModel;
	
	/**
	 * __content__.swfのModel.
	 * 
	 * @author yasunari ishibashi
	 */
	public class ContentModel extends EventDispatcher
	{
		
		private static var m_singleton : ContentModel;
		
		/** StageRefオブジェクト. */
		public var stageRef:StageRef = StageRef.getInstance();
		
		/** ConfigDataオブジェクト. */
		public var configData:ConfigData = ConfigData.getInstance();	
		
		/** SWFAddressを管理するオブジェクト. */
		public var saManager:SAManager = SAManager.getInstance();

		/** MainModelオブジェクト. */
		public var mainModel:MainModel = MainModel.getInstance();
		
		/** このappのmainTimeline. */
		public var appSub:AppSub;
		
		/**
		 *  コンストラクタ
		 */
		public function ContentModel(inner:Inner) 
		{
			init();
		}
		
		public static function getInstance() : ContentModel
		{
			if(m_singleton == null)
				m_singleton = new ContentModel(new Inner());
				
			return m_singleton;
		}
		
		public static function deleteInstance() : void
		{
			m_singleton = null;
		}
		
		private function init():void
		{
			SDTrace.dump("ContentModelを初期化しました。");

		}
	}
}

class Inner
{

}