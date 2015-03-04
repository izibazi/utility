package  jp.co.shed.events{
	import flash.events.Event;
	import jp.co.shed.data.SAManager;
	import jp.co.shed.data.SAScene;
	
	/**
	 * SAManagerが送出するイベントクラス。
	 * 
	 * @author yasunari ishibashi
	 */
	public class SAManagerEvent extends Event 
	{

		/*コンテンツが変更された場合に、送出されるイベント名。*/
		public static const SCENE_CHANGE : String="sceneSWFAddressChange";
		
		/*コンテンツ内の状態が変更された場合に、送出されるイベント名。*/
		public static const SCENE_STATUS_CHANGE : String="sceneStatusSWFAddressChange";
		
		/*SWFAddressが変更されると必ず、送出されるイベント名。*/
		public static const CHANGE : String = "SWFAddressChange";
		
		/*最初のSWFAddressの変更時に、一度だけ送出されるイベント名。*/
		public static const START:String = "SWFAddressStart";
		
		/*パネルのSWFAddressが指定、解除されたときに、送出されるイベント名。*/
		public static const PANEL_CHANGE:String = "panelSWFAddressChange";

		public var saManager:SAManager;
		
		public var scene:SAScene;
		
		/**
		 * コンストラクタ
		 * 
		 * @param	type
		 * @param	saManager
		 * @param	scene
		 * @param	bubbles
		 * @param	cancelable
		 */
		public function SAManagerEvent(type:String, saManager:SAManager, scene:SAScene, bubbles:Boolean = false, cancelable:Boolean = false) 
		{ 
			super(type, bubbles, cancelable);
			this.saManager = saManager;
			this.scene = scene;
		} 
		
		/**
		 * パネルコンテンツかどうかを返却します。
		 */
		public function get isPanel():Boolean 
		{
			return this.scene.isPanel;
		}
		
		public override function clone():Event 
		{ 
			return new SAManagerEvent(type, saManager,scene, bubbles, cancelable);
		} 
		
		public override function toString():String 
		{ 
			return formatToString("SAManagerEvent", "type", "scene", "bubbles", "cancelable", "eventPhase"); 
		}
		
	}
	
}