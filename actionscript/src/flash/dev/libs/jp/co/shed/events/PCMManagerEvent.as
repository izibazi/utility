package jp.co.shed.events 
{
	import flash.events.Event;
	
	/**
	 * PCMManagerが送出するイベントクラス。
	 * 
	 * @author yasunari ishibashi
	 */
	public class PCMManagerEvent extends Event 
	{
		/** PCMManagerが、データを更新するごとに送出されるイベント名. */
		public static const UPDATE:String = "pcmManagerUpdate";
		
		/** PCMデータを取得できない場合に送出されるイベント名. */
		public static const NOT_AVAILABLE:String = "pcmManagerNotAvailAble";
		
		public function PCMManagerEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false) 
		{ 
			super(type, bubbles, cancelable);
			
		} 
		
		public override function clone():Event 
		{ 
			return new PCMManagerEvent(type, bubbles, cancelable);
		} 
		
		public override function toString():String 
		{ 
			return formatToString("PCMManagerEvent", "type", "bubbles", "cancelable", "eventPhase"); 
		}
		
	}
	
}