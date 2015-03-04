package jp.co.shed.media {
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.media.SoundChannel;
	import flash.media.SoundTransform;
	import jp.co.shed.events.SoundItemChannelEvent;
	
	import fl.transitions.Tween;
	import fl.transitions.TweenEvent;
	import fl.transitions.easing.*;
	
	/**
	 * SoundItemインスタンスから生成されたSoundChannelを管理するクラス。
	 * 
	 * @author yasunari ishibashi
	 */
	public class SoundItemChannel extends EventDispatcher
	{
		/**
		 * ルームサウンドチャンネルのloopカウント数。
		 * この値を採用すると、isLoopブーリアンは、trueに設定されます。
		 */
		public static var LOOP_SOUND_COUNT:int = int.MAX_VALUE;

		public var id:*;
		
		public var soundItem:SoundItem;
		
		public var channel:SoundChannel;
		
		public var startTime:Number;
		
		public var isLoop:Boolean;
				
		private var m_volume:Number;

		private var m_isStop:Boolean;
		
		private var m_volumeTween:Tween;
		
		private var m_transform:SoundTransform;
		
		/**
		 * コンストラクタ。
		 * 
		 * @param	channel　SoundChannelオブジェクト
		 * @param	item　このチャンネルのSoundItemオブジェクト
		 * @param	volume
		 * @param	fadeTime
		 * @param	startTime
		 * @param	isLoop
		 */
		public function SoundItemChannel(channel:SoundChannel, item:SoundItem, volume:Number, fadeTime:Number,startTime:Number,isLoop:Boolean=false):void
		{
			this.channel = channel;
			this.m_transform = this.channel.soundTransform;	
			this.isLoop = isLoop;

			this.soundItem = item;
			this.m_volume = volume;
			this.startTime = startTime;

			//fadeTimeが0以上の場合は、Tween生成。

			if (fadeTime > 0) 
			{
				this.m_transform.volume = 0;
				this.channel.soundTransform = this.m_transform;
				fade(volume, fadeTime);
			}
			else
			{
				this.m_transform.volume = volume;
				this.channel.soundTransform = this.m_transform;
			}
			//サウンド完了リスナ登録。
			this.channel.addEventListener(Event.SOUND_COMPLETE, onCompleted);
		}
		
		/**
		 * 現在の再生ヘッドの時間を返却します。
		 */
		public function get position():Number 
		{
			return channel.position;
		}
		
		public function get volume():Number { return m_volume; }
		
		public function set volume(value:Number):void 
		{
			m_volume = value;
			this.m_transform.volume = volume;
			this.channel.soundTransform = this.m_transform;
		}

		/**
		 * サウンドを停止します。
		 * 
		 * @param	fadeTime
		 */
		public function stop(fadeTime:Number = 0):void 
		{
			if (m_isStop)
				return;

			//再生完了リスナを削除します。
			this.channel.removeEventListener(Event.SOUND_COMPLETE, onCompleted);
			if (fadeTime <= 0)
			{
				this.channel.stop();
			}
			else
			{
				fade(0, fadeTime);
			}
			dispatchEvent(new SoundItemChannelEvent(SoundItemChannelEvent.SOUND_STOP));
			m_isStop = true;
		}

		/**
		 * ボリュームを変更します。
		 * 
		 * @param	volume
		 * @param	fadeTime
		 */
		public function fade(volume:Number, fadeTime:Number):void 
		{		
			removem_volumeTween();
			//停止されたサウンドでない場合。
			if (!m_isStop) 
			{
				//目的のボリューム値をセット。

				//fadeTimeが0以上の場合。
				if (fadeTime > 0) 
				{
					m_volumeTween = new Tween(m_transform, "volume", None.easeIn, m_transform.volume, volume, fadeTime, true);
					m_volumeTween.addEventListener(TweenEvent.MOTION_CHANGE, onVolumeChanged);
					m_volumeTween.addEventListener(TweenEvent.MOTION_FINISH, onVolumeChangeEnded);
				}
				else 
				{
					m_transform.volume = volume;					
					this.channel.soundTransform = m_transform;
				}
				dispatchEvent(new SoundItemChannelEvent(SoundItemChannelEvent.SOUND_VOLUME_CHANGE));
			}
			else 
			{
				log("fade() : このチャンネルはすでに停止しています。");
			}
		}
		
		private function removem_volumeTween():void 
		{
			if (m_volumeTween)
			{
				m_volumeTween.stop();
				m_volumeTween.removeEventListener(TweenEvent.MOTION_CHANGE, onVolumeChanged);
				m_volumeTween.removeEventListener(TweenEvent.MOTION_FINISH, onVolumeChangeEnded);
				m_volumeTween = null;
			}			
		}
		
		private function onCompleted(evt:Event):void
		{
			removem_volumeTween();
			this.channel.removeEventListener(Event.SOUND_COMPLETE, onCompleted);
			dispatchEvent(new SoundItemChannelEvent(SoundItemChannelEvent.SOUND_COMPLETE));
		}

		private function onVolumeChanged(evt:TweenEvent):void
		{
			channel.soundTransform = m_transform;
		}
		
		private function onVolumeChangeEnded(evt:TweenEvent):void 
		{
			//volumeが0で、m_isStopがtrueの場合。
			if (channel.soundTransform.volume == 0 && m_isStop) 
			{
				channel.stop();
			}
		}

		private function log(value:String):void
		{
			if (SoundManager.verbose) 
			{
				trace(toString() + value);
			}
		}
		
		/**
		 * このクラスの完全修飾名を返却します。
		 * 
		 * @return	このクラスの完全修飾名。
		 */
		public override function toString():String 
		{
			var s:String = "jp.co.shed.media.SoundItemChannel(";
			s += "startTime='" + startTime + "',";
			s += "volume='" + volume + "',";
			s += "m_isStop='" + m_isStop + "',";
			s += "id='" + id + "')";
			
			return s;
		}
		
	}
	
}