package jp.co.shed.events 
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import jp.co.shed.controls.UIButton;
	
	/**
	 * UIButtonクラスが送出するイベントクラス。
	 * 
	 * イベント名は、UIButtonを参照してください。
	 * 
	 * @author yasunari ishibashi
	 */
	public class UIButtonEvent extends Event 
	{

		public var btnControl:UIButton;
		
		public var btnTarget:Sprite;
		
		public var btnTarget_mc:MovieClip;
		
		public function UIButtonEvent(type:String, btnControl:UIButton, bubbles:Boolean = false, cancelable:Boolean = false)
		{ 
			super(type, bubbles, cancelable);
			this.btnControl = btnControl;
			this.btnTarget = btnControl.target;
			this.btnTarget_mc = this.btnTarget as MovieClip;
		} 
		
		public override function clone():Event 
		{ 
			return new UIButtonEvent(type, btnControl, bubbles, cancelable);
		} 
		
		public override function toString():String
		{ 
			return formatToString("UIButtonEvent", "type", "btnControl", "btnTarget", "bubbles", "cancelable", "eventPhase"); 
		}
		
	}
	
}