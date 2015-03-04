package jp.co.shed.events 
{
	import flash.events.Event;
	import jp.co.shed.reference.StageRef;
	
	/**
	 * StageRefクラスが、送出するイベントクラス。
	 * 
	 * @author yasunari ishibashi
	 */
	public class StageRefEvent extends Event 
	{
		
		/**
		 * stageRefオブジェクトのlockingプロパティが変更されたときに、送出されるイベント名。
		 */
		public static const LOCK:String = "stageRefLockChange";
		
		/**
		 * マウスポインタが Flash Playerのウィンドウ領域から離れたときに、送出されるイベント名。
		 */
		public static const MOUSE_LEAVE:String = "stageRefMouseLeave";
		
		/**
		 * stageがリサイズされた時に、送出されるイベント名。
		 */
		public static const RESIZE:String = "stageRefResize";
		
		/**
		 * stageのdisplayStateが変更された時に、送出されるイベント名。
		 */
		public static const FULL_SCREEN:String = "stageRefFullScreen";
		
		public var stageRef:StageRef;
		
		public var locking:Boolean = false;
		
		public var mouseLeave:Boolean = false;
		
		public var fullScreen:Boolean = false;
		
		public var w:int;
		
		public var h:int;
		
		public var validW:int;
		
		public var validH:int;
		
		public var scaleX:Number;
		
		public var scaleY:Number;
		
		public var centerX:Number;
		
		public var centerY:Number;
		
		public var fullScreenW:uint;
		
		public var fullScreenH:uint;
		
		public var info:Object;
		
		/**
		 * コンストラクタ。
		 * 
		 * @param	type
		 * @param	targetStageRef StageRefオブジェクト
		 * @param	bubbles
		 * @param	cancelable
		 */
		public function StageRefEvent(type:String, targetStageRef:StageRef, bubbles:Boolean = false, cancelable:Boolean = false) 
		{ 
			super(type, bubbles, cancelable);
			stageRef = targetStageRef;
			locking = stageRef.locking;
			w = stageRef.w;
			h = stageRef.h;
			validW = stageRef.validW;
			validH = stageRef.validH;
			centerX = stageRef.centerX;
			centerY = stageRef.centerY;
			scaleX = stageRef.scaleX;
			scaleY = stageRef.scaleY;
			fullScreenW = stageRef.fullScreenW;
			fullScreenH = stageRef.fullScreenH;
			fullScreen = stageRef.fullScreen;
		} 
		
		public override function clone():Event 
		{ 
			return new StageRefEvent(type, stageRef, bubbles, cancelable);
		} 
		
		public override function toString():String 
		{ 
			return formatToString("StageRefEvent", "type", "bubbles", "cancelable", "eventPhase", 
									"w", 
									"h", 
									"validW", 
									"validH", 
									"centerX", 
									"centerY", 
									"scaleX", 
									"scaleY", 
									"locking", 
									"mouseLeave", 
									"fullScreenW",
									"fullScreenH",
									"fullScreen");
		}
		
	}
	
}