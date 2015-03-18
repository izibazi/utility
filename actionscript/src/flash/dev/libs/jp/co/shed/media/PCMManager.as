package jp.co.shed.media 
{
	import flash.events.EventDispatcher;
	import flash.events.TimerEvent;
	import flash.media.SoundMixer;
	import flash.system.Security;
	import flash.utils.ByteArray;
	import flash.utils.Timer;
	import jp.co.shed.events.PCMManagerEvent;
	
	/**
	 * サウンド波形のデータを管理するクラス。
	 * 
	 * @author yasunari ishibashi
	 */
	public class PCMManager extends EventDispatcher
	{
		
		/** デフォルトのタイマー遅延時間. */
		public static const DEFAULT_DELAY:Number = 200;
		
		private static var singleton : PCMManager;

		private var m_stretchFactor:int = 0;
		
		private var timer:Timer;
		
		private var leftPCMs_ary:Array;
		
		private var rightPCMs_ary:Array;
		
		private var spectrums_ary:Array;
		
		private var bytes:ByteArray;
		
		public var leftMax:Number = Number.MIN_VALUE;
		
		public var rightMax:Number = Number.MIN_VALUE;
		
		public var leftMin:Number = Number.MAX_VALUE;
		
		public var rightMin:Number = Number.MAX_VALUE;
		
		public var totalPCM:Number;
		
		/**
		 *  コンストラクタ。
		 */
		public function PCMManager(inner:Inner) 
		{
			init();
		}
		
		public static function getInstance() : PCMManager
		{
			if(singleton == null)
				singleton = new PCMManager(new Inner());
				
			return singleton;
		}
		
		public static function deleteInstance() : void
		{
			singleton = null;
		}
		
		private function init():void
		{
			leftPCMs_ary = [];
			rightPCMs_ary = [];
			spectrums_ary = [];
			
			timer = new Timer(DEFAULT_DELAY);
			timer.addEventListener(TimerEvent.TIMER, onTick);			
		}
		
		private function onTick(evt:TimerEvent):void 
		{
			//セキュリティ上の制限のためにサウンドが使用できないかどうか
			if (SoundMixer.areSoundsInaccessible())
			{
				//trace("areSoundsInaccessible");
				leftPCMs_ary = [];
				rightPCMs_ary = [];
				spectrums_ary = [];
				leftMax = leftMin = rightMax = rightMin = 0;
				dispatchEvent(new PCMManagerEvent(PCMManagerEvent.NOT_AVAILABLE));
				return;
			}
			
			updatePCM();
			updateFFT();
			
			dispatchEvent(new PCMManagerEvent(PCMManagerEvent.UPDATE));
		}
		
		public function updatePCM():void 
		{
			totalPCM = 0;
			
			bytes = new ByteArray();
			try
			{
				SoundMixer.computeSpectrum(bytes, false, stretchFactor);
				leftPCMs_ary = [];
				rightPCMs_ary = [];		
				bytes.position = 0;
				
				leftMax = Number.MIN_VALUE;
				leftMin = Number.MAX_VALUE;
				for (var l:uint = 0; l < 1024; l += 4 ) 
				{
					if (bytes.bytesAvailable < 4) break;
					var left:Number = bytes.readFloat();
					leftPCMs_ary.push(left);
					leftMax = Math.max(leftMax, left);
					leftMin = Math.min(leftMin, left);
					totalPCM += Math.abs(left);
				}

				rightMax = Number.MIN_VALUE;
				rightMin = Number.MAX_VALUE;
				for (var r:uint = 1024; r < 2048; r += 4 ) 
				{
					if (bytes.bytesAvailable < 4) break;
					var right:Number = bytes.readFloat();
					rightPCMs_ary.push(right);
					rightMax = Math.max(rightMax, right);
					rightMin = Math.min(rightMin, right);
					totalPCM += Math.abs(right);
				}
			}
			catch (e:Error) 
			{
				trace(e) 
			};
		}

		public function get maxPCM():Number 
		{
			return Math.max(leftMax, rightMax);
		}
		
		public function get minPCM():Number 
		{
			return Math.min(leftMin, rightMin);
		}

		public function get percentPCM():Number 
		{
			return totalPCM / 2048;
		}
		
		private function updateFFT():void 
		{
			
			try
			{
				bytes = new ByteArray();
				spectrums_ary = [];	
				SoundMixer.computeSpectrum(bytes, true, stretchFactor);
				bytes.position = 0;
				for (var l:uint = 0; l < 2048; l += 4 )
				{
					if (bytes.bytesAvailable < 4) break;
					var value:Number = bytes.readFloat();
					spectrums_ary.push(value);
				}
					
			}
			catch (e:Error) 
			{ };
			
			//trace(spectrums_ary)
		}
		
		/**
		 * PCMデータの取得を開始いします。
		 * 
		 * @param	delay 取得する間隔(ミリ秒)
		 */
		public function start(delayTime:Number = 200):void 
		{
			if (timer.running) {
				timer.delay = delayTime;
			}else {
				timer.start();
			}
		}
		
		/**
		 * PCMデータの取得を停止します。
		 */
		public function stop():void 
		{
			timer.stop();
		}
		
		/**
		 * スタートしているかどうかを返却します。
		 */
		public function get running():Boolean 
		{
			return timer.running;
		}

		/**
		 * 取得するインターバルを返却します。
		 */
		public function get delay():Number { return timer.delay; }
		
		public function set delay(value:Number):void 
		{
			timer.delay = value;
		}
		
		/**
		 * 左チャンネルのPCMデータ配列を返却します。
		 */
		public function get leftPCMs():Array { return leftPCMs_ary; }
		
		/**
		 * 右チャンネルのPCMデータ配列を返却します。
		 */
		public function get rightPCMs():Array { return rightPCMs_ary; }
		
		/**
		 * 周波数スペクトラム配列を返却します。
		 */
		public function get spectrums():Array { return spectrums_ary; }
		
		/**
		 * サンプリング解像度を返却します。(default : 0 )
		 * 
		 * stretchFactor 値に 
		 * 0 を設定した場合、データは 44.1 KHz でサンプリングされ、
		 * 1 の場合は 22.05 KHz、
		 * 2 の場合は 11.025 KHz となります。 
		 */
		public function get stretchFactor():int { return m_stretchFactor; }
		
		public function set stretchFactor(value:int):void 
		{
			m_stretchFactor = value;
		}
		
		public override function toString():String
		{
			var s:String = "jp.co.shed.media.PCMManager(";
			s += "leftMin='" + leftMin + "',";
			s += "rightMin='" + rightMin + "',";
			s += "leftMax='" + leftMax + "',";
			s += "rightMax='" + rightMax + "',";
			s += "delay='" + delay + "')";
			
			return s;
		}
		
	}
	
}

class Inner{}