package jp.co.shed.events 
{
	import flash.events.Event;
	import jp.co.shed.media.SoundItemChannel;
	
	/**
	 * SoundItemChannelオブジェクトが送出するイベントクラス。
	 * 
	 * @author yasunari ishibashi
	 */
	public class SoundItemChannelEvent extends Event 
	{
		
		/*サウンドの再生が終了したときに送出されるイベント名*/
		public static const SOUND_COMPLETE:String = "soundCannelComplete";
		
		/*サウンドのボリュームが変更されたときに送出されるイベント名*/
		public static const SOUND_VOLUME_CHANGE:String = "soundChannelVolumeChange";
		
		/*サウンドの再生が停止したときに送出されるイベント名*/
		public static const SOUND_STOP:String = "soundChannelStop";
	
		/**
		 * コンストラクタ
		 * 
		 * @param	type
		 * @param	bubbles
		 * @param	cancelable
		 */
		public function SoundItemChannelEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false) 
		{ 
			super(type, bubbles, cancelable);
		} 
		
		public override function clone():Event 
		{ 
			return new SoundItemChannelEvent(type, bubbles, cancelable);
		} 
		
		public override function toString():String 
		{ 
			return formatToString("SoundItemChannelEvent", "type", "bubbles", "cancelable", "eventPhase");
		}
		
	}
	
}