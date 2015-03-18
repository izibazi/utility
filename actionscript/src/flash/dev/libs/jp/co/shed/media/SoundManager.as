package jp.co.shed.media {
	import fl.transitions.Tween;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.media.SoundMixer;
	import flash.media.SoundTransform;
	import jp.co.shed.debug.SDTrace;
	import jp.co.shed.net.AbstractLoader;

	import jp.co.shed.events.LoaderManagerEvent;
	import jp.co.shed.net.LoaderManager;
	
	import fl.transitions.Tween;
	import fl.transitions.TweenEvent;
	import fl.transitions.easing.*;
	
	/**
	 * SoundItemオブジェクトを保持し、アプリケーションのサウンドの管理をするクラス。
	 * 
	 * ※シングルとんじゃないほうがよかったので、後で変更する。
	 * 
	 * @author yasunari ishibashi
	 */
	public class SoundManager extends EventDispatcher 
	{
		
		/*traceを有効にするかどうかの真偽値*/
		public static var verbose:Boolean = false;
		
		/*mute変更時に、送出されます。*/
		public static const MUTE_CHANGE:String = "muteChange";
		
		/*グローバルボリューム変更時に、送出されます。*/
		public static const GLOBAL_VOLUME_CHANGE:String = "globalVolumeChanged";
		
		/*UIButtonインスタンスが使用するロールアウトキー*/
		public static const ROLL_OUT_KEY:String = "rollOutSE";
		
		/*UIButtonインスタンスが使用するロールオーバーキー*/
		public static const ROLL_OVER_KEY:String = "rollOverSE";
		
		/*UIButtonインスタンスが使用するプレスキー*/
		public static const PRESS_KEY:String = "pressSE";
		
		/*UIButtonインスタンスが使用するリリースキー*/		
		public static const RELEASE_KEY:String = "releaseSE";
		
		private static var m_manager:SoundManager;
		
		private var m_loaderManager:LoaderManager;
		
		private var m_soundItem_obj:Object;
		
		private var m_isMute:Boolean = false;
		
		private var m_globalVolume:Number = 1;
		
		private var m_globalVolumeTween:Tween;
		
		private var m_globalSoundTransform:SoundTransform;
		
		public static function deleteInstance():void 
		{
			m_manager = null;
		}
		
		public static function getInstance():SoundManager 
		{
			if (m_manager == null)
				m_manager = new SoundManager(new Inner());

			return m_manager;
		}
		
		/**
		 *  コンストラクタ
		 */
		public function SoundManager(inner:Inner) 
		{
			m_soundItem_obj = { };
			m_loaderManager = new LoaderManager();
			
			m_loaderManager.addEventListener(LoaderManagerEvent.ALL_COMPLETE, onSoundAllLoaded);
			m_loaderManager.addEventListener(LoaderManagerEvent.ITEM_COMPLETE, onSoundItemLoaded);
		}
		
		private function log(value:*):void 
		{
			if (verbose)
				SDTrace.dump(value);
		}
		
		/**
		 * SoundItemオブジェクトを返却します。
		 * 
		 * @param	key
		 * @return	SoundItemオブジェクト。
		 */
		public function soundItemAt(key:String):SoundItem
		{
			return m_soundItem_obj[key];
		}
		
		/**
		 * SoundItemオブジェクトが存在するかどうかを返却します。
		 * 
		 * @param	key
		 * @return	SoundItemオブジェクトが存在するかどうか真偽値。
		 */
		public function existItemAt(key:String):Boolean 
		{
			return soundItemAt(key) != null;
		}

		/**
		 * SoundItemオブジェクトを追加します。
		 * 
		 * @param	soundItem
		 * @return	追加に成功したかどうかの真偽値。
		 */
		public function addSoundItem(soundItem:SoundItem):Boolean 
		{
			var key:String = soundItem.key;
			var existSoundItem:SoundItem = soundItemAt(key);
			if (existSoundItem == null) 
			{
				m_soundItem_obj[key] = soundItem;
				//すでにロード済み、もしくはストリーミングサウンドで無い場合、LoaderManagerに追加。
				if (!soundItem.loaded && !soundItem.isStreaming) 
				{
					m_loaderManager.addLoader(soundItem.soundLoader);
				}
				return true;
			}
			else 
			{
				log(toString() + "addSoundItem() : key=" + key + "　: このキーは、すでに追加済みです。");
				log(existSoundItem.toString());
				return false;
			}
		}
		
		/**
		 * XMLListオブジェクトから、SoundItemを追加します。
		 * 
		 * <item key="releaseSE" url="sound/releaseSE.mp3" volume="1" streaming="false" bufferTime="1000" noCache="false" tryCount="1"/>
		 * <item key="pressSE" url="_sound/pressSE.mp3" volume="1" streaming="false" bufferTime="1000" />
		 * <item key="rollOverSE" url="sound/rollOverSE.mp3" volume="1" streaming="false" bufferTime="1000" />
		 * <item key="rollOutSE" url="sound/rollOutSE.mp3" volume="1"  streaming="false" bufferTime="1000" />
		 * <item key="bgm1" url="sound/1.mp3" volume="1" streaming="false" bufferTime="1000" />
		 * <item key="bgm2" url="sound/2.mp3" volume="1" streaming="false" bufferTime="1000" />
		 * <item key="bgm3" url="sound/3.mp3" volume="1" streaming="false" bufferTime="1000" />
		 * 
		 * @param	xmlList
		 * @param	dir
		 */
		public function addXMLList(xmlList:XMLList, dir:String = ""):void
		{
			var len:int = xmlList.length();

			for (var i:uint = 0; i < len; i++ )
			{
				var key:String = xmlList[i].@key;
				var _url:String = xmlList[i].@url;
				if (_url.length > 0)
				{
					_url = dir + _url;
				}
				var volume:Number = xmlList[i].@volume;
				volume = isNaN(volume)?1:volume;
				var tryCount:uint = xmlList[i].@tryCount;
				tryCount = isNaN(tryCount)?1:tryCount;
				
				var noChache:Boolean = xmlList[i].@noCache == "true";
				var streaming:Boolean = xmlList[i].@streaming == "true";
				
				var bufferTime:Number = xmlList[i].@bufferTime;
				bufferTime = isNaN(bufferTime)?1000:bufferTime;

				addSoundItem(new SoundItem(key, _url, volume, tryCount, noChache, streaming, bufferTime));
			}
		}

		/**
		 * SoundItemオブジェクトを削除します。
		 * 
		 * @param	key
		 * @return
		 */
		public function removeSoundItem(key:String):Boolean 
		{
			var existSoundItem:SoundItem = soundItemAt(key);
			if (existSoundItem != null)
			{
				m_soundItem_obj[key] = null;
				return true;
			}
			
			return false;
		}
		
		/**
		 * 追加されているSoundItemで、未ロードのサウンドをロードします。
		 */
		public function load():void
		{
			m_loaderManager.load();
		}
		
		/**
		 * ロードすべきアイテムが存在するかどうかを返却します。
		 */
		public function get needLoad():Boolean
		{
			return m_loaderManager.total > 0;
		}
		
		private function onSoundAllLoaded(evt:LoaderManagerEvent):void
		{
			dispatchEvent(evt);
		}
		
		private function onSoundItemLoaded(evt:LoaderManagerEvent):void
		{
			dispatchEvent(evt);
		}		

		/**
		 * サウンドを再生します。
		 * 
		 * @param	key
		 * @param	volume
		 * @param	fadeTime
		 * @param	startTime
		 * @param	loopCount
		 * @return
		 */
		public function play(key:String, volume:Number = NaN, fadeTime:Number = 0, startTime:Number = 0, loopCount:int = 0 ):SoundItemChannel
		{
			var soundItem:SoundItem = soundItemAt(key);
			var soundItemChannel:SoundItemChannel;
			if (soundItem == null) 
			{
				log(toString() + "play() : key=" + key + "　: このキーのサウンドは、存在しません。");
				return null;
			}
			
			var vol:Number = isNaN(volume)?soundItem.volume:volume;
			if (soundItem.isStreaming) 
			{
				soundItemChannel = soundItem.play(vol, fadeTime, startTime, loopCount);
			}
			else if 
			(soundItem.loaded)
			{
				soundItemChannel = soundItem.play(vol, fadeTime, startTime, loopCount);
			}
			else
			{
				log(toString() + "play() : key=" + key + "　: このキーのサウンドは、ロードに失敗した、もしくは、ロード中の可能性があります。");
			}
			
			return soundItemChannel;
		}

		/**
		 * サウンドを停止します。
		 * 
		 * @param	key
		 * @param	soundItemChannel
		 * @param	fadeTime
		 */
		public function stop(key:String, fadeTime:Number = 0, soundItemChannel:SoundItemChannel = null ):void 
		{
			var soundItem:SoundItem = soundItemAt(key);
			if (soundItem == null)
			{
				log(toString() + "stop() : key=" + key + "　: このキーのサウンドは、存在しません。");
				return;
			}
			
			if (soundItem.loaded || soundItem.isStreaming)
			{
				soundItem.stop(fadeTime, soundItemChannel);
			}
			else
			{
				log(toString() + "stop() : key=" + key + "　: このキーのサウンドは、ロードに失敗した、もしくは、ロード中の可能性があります。");
			}
		}
		
		/**
		 * すべてのサウンドを停止します。
		 * 
		 * @param	fadeTime
		 */
		public function stopAll(fadeTime:Number = 0):void 
		{
			for (var key:String in m_soundItem_obj)
			{
				stop(key, fadeTime);
			}
		}

		/**
		 * ボリュームを変更します。
		 * keyがnullの場合は、グローバルサウンドのvolumeを変更します。
		 * 
		 * @param	key
		 * @param	soundItemChannel
		 * @param	value
		 * @param	fadeTime
		 */
		public function volume(key:String = null, soundItemChannel:SoundItemChannel = null, value:Number = 0, fadeTime:Number = 0):void
		{
			if (key == null)
			{
				m_globalVolume = value;
				
				if (!isMute)
				{
					removeTween();
					m_globalSoundTransform = SoundMixer.soundTransform;

					if (fadeTime == 0) 
					{
						fadeTime = 0.1;
					}
					m_globalVolumeTween = new Tween(m_globalSoundTransform, "volume", None.easeNone, m_globalSoundTransform.volume, m_globalVolume, fadeTime,true);
					m_globalVolumeTween.addEventListener(TweenEvent.MOTION_CHANGE, onGlobalVolumeChanged);
					m_globalVolumeTween.addEventListener(TweenEvent.MOTION_FINISH, onGlobalVolumeChangeEnded);
					dispatchEvent(new Event(SoundManager.GLOBAL_VOLUME_CHANGE));
				}
			}
			else
			{
				var soundItem:SoundItem = soundItemAt(key);
				if (soundItem != null && soundItem.loaded)
				{
					soundItem.changeVolume(value, fadeTime, soundItemChannel);
				}
				else
				{
					log(toString() + "volume() : key=" + key + "　: このキーのサウンドは、ロードに失敗した、もしくは、ロード中の可能性があります。");
				}
			}
		}
		
		/**
		 * SoundItemの再生中のサウンド数を返却します。
		 * 
		 * @param	key
		 * @return
		 */
		public function getPlayingChannelCount(key:String):int
		{
			var soundItem:SoundItem = soundItemAt(key);
			if (soundItem != null && soundItem.loaded)
			{
				return soundItem.playingCount;
			}
			return 0;
		}
		
		/**
		 * SoundItemに再生中のChannelが存在するかどうかを返却します。
		 * 
		 * @param	key
		 * @return
		 */
		public function existPlayingChannel(key:String):Boolean
		{
			return getPlayingChannelCount(key) > 0;
		}

		/**
		 * ミュート状態を更新します。
		 * 
		 * @param	bool
		 * @param	time
		 * @return
		 */
		public function mute(bool:Boolean, fadeTime:Number = 0):Boolean
		{
			removeTween();
			m_isMute = bool;
			m_globalSoundTransform = SoundMixer.soundTransform;
			
			if (fadeTime == 0) fadeTime = 0.1;
			
			m_globalVolumeTween = new Tween(m_globalSoundTransform, "volume", None.easeNone, m_globalSoundTransform.volume, globalVolume , fadeTime, true);
			m_globalVolumeTween.addEventListener(TweenEvent.MOTION_CHANGE, onGlobalVolumeChanged);
			m_globalVolumeTween.addEventListener(TweenEvent.MOTION_FINISH, onGlobalVolumeChangeEnded);
			dispatchEvent(new Event(SoundManager.MUTE_CHANGE));
			
			return bool;
		}
		
		/**
		 * ミュート状態かどうかを返却します。
		 */
		public function get isMute():Boolean { return m_isMute; }

		public function get globalVolume():Number 
		{
			if (isMute)
			{
				return 0;
			}
			
			return m_globalVolume;
		}
		
		private function removeTween():void
		{
			if (m_globalVolumeTween != null)
			{
				m_globalVolumeTween.removeEventListener(TweenEvent.MOTION_CHANGE, onGlobalVolumeChanged);
				m_globalVolumeTween.removeEventListener(TweenEvent.MOTION_FINISH, onGlobalVolumeChangeEnded);
				m_globalVolumeTween.stop();
				m_globalVolumeTween = null;
			}
		}
		
		private function onGlobalVolumeChanged(evt:TweenEvent):void
		{
			SoundMixer.soundTransform = m_globalSoundTransform;
		}
		
		private function onGlobalVolumeChangeEnded(evt:TweenEvent):void 
		{

		}
		
		public function get percent():Number
		{
			return m_loaderManager.percent;
		}
		
		public function get loadTotal():uint 
		{
			return m_loaderManager.total;
		}
		
		public function get loadCurrentCount():uint 
		{
			return m_loaderManager.currentCount;
		}
		
		public function get currentLoader():AbstractLoader 
		{
			return m_loaderManager.currentLoader;
		}

		public override function toString():String 
		{
			var s:String = "jp.co.shed.media.SoundManager(";
			
			return s;
		}
	}
}

class Inner 
{
	
}