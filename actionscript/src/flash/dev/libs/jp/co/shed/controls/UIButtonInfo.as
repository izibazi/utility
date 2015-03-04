package jp.co.shed.controls 
{
	/**
	 * UIButtonのコールバックファンクションに渡される引数となるクラス。
	 * 
	 * @author yasunari ishibashi
	 */
	public class UIButtonInfo 
	{
		
		public var btnControl:UIButton;
		
		public var eventType:String;
		
		/**
		 * コンストラクタ。
		 * 
		 * @param	btnControl
		 * @param	eventType
		 */
		public function UIButtonInfo(btnControl:UIButton, eventType:String) 
		{
			this.btnControl = btnControl;
			this.eventType = eventType;
		}
		
	}
	
}