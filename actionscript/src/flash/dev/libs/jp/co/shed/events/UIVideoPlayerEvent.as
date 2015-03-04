package jp.co.shed.events {
	import flash.events.Event;
	
	/**
	 * UIVideoPlayerオブジェクトが送出するイベントクラス。
	 * 
	 * @author yasunari ishibashi
	 */
	public class UIVideoPlayerEvent extends Event 
	{
		//NetConnection
		public static const CONNECT_SUCCESS:String = "connectSuccess";
		public static const CONNECT_FAIL:String = "connectFail";
		public static const CONNECT_CLOSE:String = "connectClose";
		public static const CONNECT_IO_ERROR:String = "connectIOError";
		public static const CONNECT_SECURITY_ERROR:String = "connectSecurityError";

		//NetStream 
		public static const LOAD_PROGRESS:String = "loadProgress";
		public static const LOAD_COMPLETE:String = "loadComplete";
		
		public static const PLAY_START:String = "playStart";
		public static const WILL_PLAY:String = "willPlay";
		public static const PLAY:String = "play";
		public static const PLAY_COMPLETE:String = "playComplete";
		public static const WILL_STOP:String = "willStop";
		public static const STOP:String = "stop";
		public static const PAUSE:String = "pause";
		public static const RESUME:String = "resume";
		public static const SEEK_START:String = "seekStart";
		public static const SEEK_COMPLETE:String = "seekComplete";
		public static const SEEK_INVALID_TIME:String = "seekInvalidTime";
		public static const MUTE:String = "mute";
		public static const VOLUME:String = "volume";
		
		public static const BUFFER_FULL:String = "bufferFull";
		public static const BUFFER_EMPTY:String = "bufferEmpty";
		
		public static const STREAM_CLOSE:String = "streamClose";
		
		public static const STREAM_FAIL:String = "streamFail";
		public static const STREAM_NOT_FOUND:String = "streamNotFound";
		
		public static const STREAM_SECURITY_ERROR:String = "streamSecuritError";
		public static const STREAM_IO_ERROR:String = "streamIOError";
		
		public static const DATA:String = "getData";
		public static const META_DATA:String = "mataData";
		public static const CUE_POINT:String = "cuePoint";
		public static const IMAGE_DATA:String = "imageData";
		public static const TEXT_DATA:String = "textData";
		
		public static const CLEAR:String = "clear";
		
		public var originalEvent:*;
		
		/**
		 * コンストラクタ
		 * 
		 * @param	type
		 * @param	evt
		 * @param	bubbles
		 * @param	cancelable
		 */
		public function UIVideoPlayerEvent(type:String, evt:* = null, bubbles:Boolean = false, cancelable:Boolean = false)
		{ 
			super(type, bubbles, cancelable);
			this.originalEvent = evt;
		} 
		
		public override function clone():Event 
		{ 
			return new UIVideoPlayerEvent(type,originalEvent, bubbles, cancelable);
		} 
		
		public override function toString():String 
		{ 
			return formatToString("UIVideoPlayerEvent", "type", "bubbles", "cancelable", "eventPhase"); 
		}
		
	}
	
}