package __projectname__.main 
{
	import flash.display.MovieClip;
	import flash.events.EventDispatcher;
	import flash.external.ExternalInterface;
	import jp.co.shed.data.ConfigData;
	import jp.co.shed.data.SAScene;
	import jp.co.shed.media.SoundItemChannel;
	import jp.co.shed.media.SoundManager;
	import jp.co.shed.reference.StageRef;
	import jp.co.shed.debug.SDTrace;
	import jp.co.shed.data.SAManager;
	
	/**
	 * main.swfのModel.
	 * 
	 * @author yasunari ishibashi
	 */
	public class MainModel extends EventDispatcher
	{
		
		private static var m_singleton : MainModel;
		
		/** StageRefオブジェクト. */
		public var stageRef:StageRef = StageRef.getInstance();
		
		/** ConfigDataオブジェクト. */
		public var configData:ConfigData = ConfigData.getInstance();	
		
		/** SWFAddressを管理するオブジェクト. */
		public var saManager:SAManager = SAManager.getInstance();
		
		/**
		 *  コンストラクタ
		 */
		public function MainModel(inner:Inner) 
		{
			init(); 
		}
		
		public static function getInstance() : MainModel
		{
			if(m_singleton == null)
				m_singleton = new MainModel(new Inner());
				
			return m_singleton;
		}
		
		public static function deleteInstance() : void
		{
			m_singleton = null;
		}
		
		private function init():void 
		{
			SDTrace.dump("MainModelを初期化しました。");

		}
		
		/**
		 * メインタイムラインの参照を返却します。
		 */
		public function get mainTimeline():MovieClip 
		{
			return stageRef.mainTimeline;
		}
		
		/**
		 * keyのリンクを開きます。
		 * 
		 * @param	key
		 */
		public function openURLForKey(key:String):void
		{
			stageRef.openURL(configData.getObject(key));
		}
		
		public function popUpForKey(key:String):void
		{
			if(ExternalInterface.available)
				ExternalInterface.call(configData.getObject(key).value);
		}
		
		public function get currentScene():SAScene
		{
			return saManager.scene;
		}
		
		public function get currentSceneKey():String
		{
			return currentScene.key;
		}
		
		public function playBGM():void
		{
			stopBGM();
			SoundManager.getInstance().play("bgm", NaN, 1, 0, SoundItemChannel.LOOP_SOUND_COUNT);
		}
		
		public function stopBGM():void
		{
			SoundManager.getInstance().stop("bgm",0);
		}
	}
	
}

class Inner{}