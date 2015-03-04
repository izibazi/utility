package jp.co.shed.events {
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import jp.co.shed.net.AbstractLoader;
	
	/**
	 * AbstractLoaderが送出するイベントクラス。
	 * 
	 * @author yasunari ishibashi
	 */
	public class LoaderEvent extends Event {
		
		/*AbstractLoaderの状態が変更するたびに、送出されるイベント名。*/
		public static const STATUS_CHANGE:String = "statusChange";
		
		public static const STATUS_COMPLETE:String = "statusComplete";
		
		public static const STATUS_ERROR:String = "statusError";

		public var loader:AbstractLoader;
		
		public var event:Event;
		
		public var eventType:String;
		
		public var info:*;
		
		public var success:Boolean;
		
		public var errorMessage:String;
		
		/**
		 * コンストラクタ
		 * 
		 * @param	type
		 * @param	loader
		 * @param	event
		 * @param	bubbles
		 * @param	cancelable
		 */
		public function LoaderEvent(type:String, loader:AbstractLoader , event:Event, bubbles:Boolean = false, cancelable:Boolean = false) { 
			super(type, bubbles, cancelable);
			this.loader = loader;
			this.event = event;
			this.eventType = event.type;
		} 
		
		public function get isOpen():Boolean {
			return eventType == Event.OPEN;
		}
		
		public function get isInit():Boolean {
			return eventType == Event.INIT;
		}
		
		/**
		 * 成功したかどうかを返却します。
		 */
		public function get isComplete():Boolean {
			return eventType == Event.COMPLETE;
		}
		
		/**
		 * プログレスかどうかを返却します。
		 */
		public function get isProgress():Boolean {
			return eventType == ProgressEvent.PROGRESS;
		}
		
		/**
		 * エラーが発生したかどうかを返却します。
		 */
		public function get isError():Boolean {
			return eventType == IOErrorEvent.IO_ERROR || eventType == SecurityErrorEvent.SECURITY_ERROR;
		}
		
		public override function clone():Event { 
			var c:LoaderEvent = new LoaderEvent(type, loader, event, bubbles, cancelable);
			c.success = success;
			c.info = info;
			c.errorMessage = errorMessage;
			return c;
		} 
		
		public override function toString():String { 
			return formatToString("LoaderEvent", "type","eventType", "bubbles", "cancelable", "eventPhase","eventType"); 
		}

		
	}
	
}