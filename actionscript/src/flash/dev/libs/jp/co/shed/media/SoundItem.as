package jp.co.shed.media 
{
	import flash.display.Sprite;
	import flash.events.EventDispatcher;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundLoaderContext;
	import flash.media.SoundMixer;
	import flash.media.SoundTransform;
	import flash.utils.getDefinitionByName;
	
	import jp.co.shed.data.Queue;
	import jp.co.shed.events.SoundItemChannelEvent;
	import jp.co.shed.net.SoundLoader;

	/**
	 * Soundインスタンスを管理するクラス。
	 * 
	 * @author yasunari ishibashi
	 */
	public class SoundItem extends EventDispatcher
	{
		
		/*このサウンドのキー*/
		public var key:String;
		
		/* Soundオブジェクト*/
		public var sound:Sound;
		
		/*SoundLoaderオブジェクト。urlが有効でない場合は、埋め込みサウンドと判断するため、null*/
		public var soundLoader:SoundLoader;

		/* サウンドのurl*/
		public var url:String;

		/*このサウンドのマスターボリューム。コンストラクタで一度だけ指定可能。*/
		private var m_volume:Number;
		
		private var m_isStreaming:Boolean;
				
		/*再生中のSoundItemChannelを保持するキュー。*/
		private var m_channelQueue:Queue;

		/**
		 * コンストラクタ。
		 * 
		 * @param	key	
		 * @param	url 
		 * @param	volume
		 * @param	tryCount
		 * @param	noCache
		 * @param	streaming ストリーミング再生するかどうかの真偽値。
		 * @param	bufferTime ストリーミング再生の場合のバッファ時間(秒)。
		 */
		public function SoundItem(key:String, 
								url:String, 
								volume:Number = 1, 
								tryCount:uint = 0, 
								noCache:Boolean = false, 
								streaming:Boolean = false, 
								bufferTime:Number = 1000)
								{
			m_channelQueue = new Queue();
			
			this.key = key;
			this.url = url;
			this.m_volume = volume;
			
			//urlが有効な値の場合は、外部サウンドのロードの準備。
			if (this.url != null) 
			{
				if (this.url.length > 0) 
				{
					soundLoader = new SoundLoader(this.url, tryCount, noCache);
					
					m_isStreaming = streaming;
					if (streaming) 
					{
						soundLoader.soundLoaderContent = new SoundLoaderContext(bufferTime, true);
					}
					sound = soundLoader.loader;
					return;
				}
			}
			//urlが不正の場合は、埋め込みサウンドとして処理する。
			try 
			{
				var classRef:Class = getDefinitionByName(key) as Class;
				sound = new classRef();
			}
			catch (e:Error)
			{
				log("コンストラクタ　警告 key='" + key + "'の埋込みサウンドの生成に失敗しました。" + e);
			}
		}
		
		/**
		 * ロード済み、埋め込みの場合はtrueを返却します。
		 */
		public function get loaded():Boolean 
		{
			if (sound == null) 
			{
				return true;
			}
			
			//埋め込みサウンドの場合。
			if (soundLoader == null) 
			{
				return true;
			}
			//外部サウンドの場合。
			else 
			{
				return soundLoader.loaded;
			}
		}
		
		/**
		 * 埋め込みサウンドかどうかを返却します。
		 */
		public function get isEmbed():Boolean 
		{
			return soundLoader == null;
		}
		
		/**
		 * サウンドを再生します。
		 * SoundItemChannelオブブジェクトを返却します。
		 * 
		 * @param	fadeTime
		 * @param	vol
		 * @param	startTime
		 * @param	loopCount
		 * @return
		 */
		public function play(vol:Number = NaN, fadeTime:Number = 0, startTime:Number = 0, loopCount:int = 0 ):SoundItemChannel 
		{
			if (sound == null) 
			{
				log("play() : Soundオブジェクトが、nullです。サウンドを再生できません。");
				return null;
			}
			//ストリーミングサウンド.
			if (isStreaming && !soundLoader.loading && !soundLoader.loaded)
			{
				soundLoader.load();
			}
				
			//volumeの値が数字でない場合は、マスターボリューム値を採用する。
			if (isNaN(vol))
				vol = volume;

			//SoundChannel生成。
			var channel:SoundChannel = sound.play(startTime, loopCount);
			if (channel == null) return null;
			
			//SounditemChannelインスタンス生成。
			var item:SoundItemChannel = new SoundItemChannel(channel, this, vol, fadeTime, startTime, loopCount == SoundItemChannel.LOOP_SOUND_COUNT);

			//キューに追加。
			m_channelQueue.push(item);
			//trace(key,m_channelQueue.size)

			//再生完了リスナに登録。
			item.addEventListener(SoundItemChannelEvent.SOUND_COMPLETE, onComplete);

			return item;
		}
		
		private function onComplete(evt:SoundItemChannelEvent):void 
		{
			var index:int = m_channelQueue.indexOf(evt.target);

			//キュー内に、見つかった場合。
			if (index >= 0) 
			{
				//サウンド終了時、SoundItemChannelを削除する。ぶら下がり参照になる。
				var item:SoundItemChannel = m_channelQueue.remove(index, 1)[0] as SoundItemChannel;
				//ループの場合は、再び追加する。
				if (item.isLoop) 
				{
					play(0, item.volume, item.startTime, SoundItemChannel.LOOP_SOUND_COUNT);
				}
			}
		}
		
		/**
		 * ボリュームを変更します。
		 * 
		 * @param	value
		 * @param	fadeTime
		 * @param	soundItemChannel
		 */
		public function changeVolume(value:Number, fadeTime:Number = 0, soundItemChannel:SoundItemChannel = null):void 
		{
			//キューが空。
			if (m_channelQueue.isEmpty) 
			{
				log("changeVolume() : key='"+key+"'　現在再生中のチャンネルはありません。");
				return;
			}
			
			//SounditemChannelを指定。
			if (soundItemChannel != null)
			{
				var index:int = m_channelQueue.indexOf(soundItemChannel);
				//見つけた。
				if (index >= 0) 
				{
					soundItemChannel.fade(value, fadeTime);
				}
			}
			else
			{
				//すべてのSoundItemChannelのボリュームを変更する。
				for (var i:uint = 0; i < m_channelQueue.num; i++ )
				{
					var item:SoundItemChannel = m_channelQueue.ary[i];
					item.fade(value, fadeTime);	
				}
			}
		}
		
		/**
		 * このサウンドの現在のチャンネル数を返却します。
		 * 
		 * @return このサウンドの現在のチャンネル数。
		 */
		public function get playingCount():int
		{
			return m_channelQueue.num;
		}
		
		/**
		 * このサウンドインスタンスのマスターボリュームを返却します。[readonly]
		 * 
		 * @return このサウンドインスタンスのマスターボリューム。
		 */
		public function get volume():Number { return m_volume; }
		
		/**
		 * ストリーミング再生するかどうかを返却します。
		 * 
		 * @return ストリーミング再生するかどうかの真偽値。
		 */
		public function get isStreaming():Boolean { return m_isStreaming; }
		
		/**
		 * サウンドを停止します。
		 * 
		 * @param	fadeTime
		 * @param	soundItemChannel
		 */
		public function stop(fadeTime:Number = 0, soundItemChannel:SoundItemChannel = null):void
		{
			//キューが空。
			if (m_channelQueue.isEmpty)
			{
				log("stop() : key='"+key+"'　現在再生中のチャンネルはありません。");
				return;
			}
			
			//SounditemChannelを指定。
			if (soundItemChannel) 
			{
				var index:int = m_channelQueue.indexOf(soundItemChannel);
				//見つけた。
				if (index >= 0)
				{
					m_channelQueue.ary.splice(index, 1);
					soundItemChannel.stop(fadeTime);
				}
			}
			else 
			{
				//すべてのSoundItemChannelを停止し、キューを空にする。
				while (!m_channelQueue.isEmpty)
				{
					var item:SoundItemChannel = m_channelQueue.pop();
					item.stop(fadeTime);
				}
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
		 * クラスの完全修飾名を返却します。
		 * 
		 * @return	このクラスの完全修飾名。
		 */
		public override function toString():String
		{
			var s:String = "jp.co.shed.media.SoundItem(";
			s += "key='" +key + "',";
			s += "url='" +url + "',";
			s += "volume='" +volume + "',";
			s += "loaded='" +loaded + "',";
			s += "isEmbed='" +isEmbed + "')";

			return s;
		}
				
	}
	
}