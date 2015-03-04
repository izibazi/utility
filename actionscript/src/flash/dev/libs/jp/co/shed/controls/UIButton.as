package jp.co.shed.controls
{
	import flash.display.DisplayObject;
	import flash.display.FrameLabel;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.MouseEvent;
	import flash.display.MovieClip;
	
	import jp.co.shed.events.UIButtonEvent;
	import jp.co.shed.media.SoundManager;

	/**
	 * ボタンの状態、イベント、表示を管理するクラス。
	 *
	 * @author yasunari ishibashi
	 */
	public class UIButton extends EventDispatcher
	{
		
		/** rollOverのSEのボリューム値*/
		public static var ROLL_OVER_SE_VOLUME:Number = 0.5;
		
		/** rollOutのSEのボリューム値*/
		public static var ROLL_OUT_SE_VOLUME:Number = 0.5;
		
		/** releaseSeのSEのボリューム値*/
		public static var RELEASE_SE_VOLUME:Number = 0.5;
		
		/** pressSeのSEのボリューム値*/
		public static var PRESS_SE_VOLUME:Number = 0.5;
		
		private static var dispatcher:EventDispatcher;
		
		/** 標準状態*/
		public static const NORMAL_STATE:String="NORMAL";
		
		/** ロールオーバー状態*/
		public static const ROLL_OVER_STATE:String="ROLL_OVER";
		
		/** ロールアウト状態*/
		public static const ROLL_OUT_STATE:String="ROLL_OUT";
		
		/** トグル状態*/
		public static const TOGGLE_STATE:String="TOGGLE";
		
		/** プレス状態*/
		public static const PRESS_STATE:String="PRESS";

		/** ディゼーブル状態*/	
		public static const DISABLE_STATE:String="DISABLE";
		
		/** リリース状態*/
		public static const RELEASE_STATE:String="RELEASE";
		
		/** ダブルクリック状態*/
		public static const DOUBLE_CLICK_STATE:String="DOUBLE_CLICK";
		
		//ラベル名が存在しているかどうかの情報オブジェクト
		private var labelEnabled:Object;
		
		/** プレスイベントのコールバックファンクション*/
		public var onButtonPress:Function;
		
		/** リリースイベントのコールバックファンクション*/
		public var onButtonRelease:Function;
		
		/** ロールオーバーイベントのコールバックファンクション*/
		public var onButtonRollOver:Function;
		
		/** ロールアウトイベントのコールバックファンクション*/
		public var onButtonRollOut:Function;
		
		/** ダブルクリックイベントのコールバックファンクション*/
		public var onButtonDoubleClick:Function;
		
		/** すべてのイベントのコールバックファンクション*/
		public var onButtonAction:Function;

		private var m_target:Sprite;
		
		private var m_target_mc:MovieClip;

		private var m_enabled : Boolean = true;

		private var m_toggle : Boolean;

		private var m_buttonMode:Boolean;

		private var m_doubleClickEnabled:Boolean;

		/** オブジェクト識別用ID*/
		public var id:*;
		
		/** 付加的な情報オブジェクト*/
		public var info:Object;
		
		/** SEを使用するかどうかの真偽値*/
		public var useSe:Boolean = true;
		
		/** rollOverのSEを使用するかどうかの真偽値*/
		public var useRollOverSe:Boolean = true;
		
		/** rollOutのSEを使用するかどうかの真偽値*/
		public var useRollOutSe:Boolean = true;
		
		/** releaseのSEを使用するかどうかの真偽値*/
		public var useReleaseSe:Boolean = true;
		
		/** pressのSEを使用するかどうかの真偽値*/
		public var usePressSe:Boolean = true;
		
		/** フレームラベルを使用するかどうかの真偽値*/
		public var useLabel:Boolean = false;
		
		/** rollOverのSEのボリューム値*/
		public var rollOverSeVolume :Number;
		
		/** ollOutのSEのボリューム値*/
		public var rollOutSeVolume :Number;
		
		/** releaseSeのSEのボリューム値*/
		public var releaseSeVolume :Number;
		
		/** pressSeのSEのボリューム値*/
		public var pressSeVolume :Number;

		/** SE生成用サウンド管理オブジェクト*/
		public var soundManager:SoundManager;

		/** callbackにButtonInfoオブジェクトを渡すかどうかの真偽値。*/
		public var useCallbackButtonInfo:Boolean = true;
		
		//スタティック初期化ブロック
		{
			dispatcher = new EventDispatcher();
		}
		
		/**
		 * コンストラクタ。
		 * 
		 * @param	target　ボタンを設定するターゲット
		 * @param	onRelease リリース時のコールバックファンクション
		 * @param	onRollOver オーバー時のコールバックファンクション
		 * @param	onRollOut　アウト時のコールバックファンクション
		 * @param	enabled　有効にするかどうかの真偽値
		 * @param	buttonMode マウスカーソルを指マークにするかどうかの真偽値
		 * @param	useSe デフォルトのSEを鳴らすかどうかの真偽値
		 * @param	useLabel フレームに指定したラベルを各状態時に、表示するかどうかの真偽値
		 */
		public function UIButton(target : Sprite , 
								release:Function = null,
								rollOver:Function = null,
								rollOut:Function = null,
								enabled : Boolean = true , 
								buttonMode : Boolean = true , 
								useSe:Boolean = true, 
								useLabel:Boolean = false ) 
								{
			m_target = target;
			this.onButtonRelease = release;
			this.onButtonRollOver = rollOver;
			this.onButtonRollOut = rollOut;
			
			this.target.mouseChildren = false;
			m_target_mc = target as MovieClip;
			
			this.buttonMode=buttonMode;			
			this.useSe = useSe;
			this.useLabel = target is MovieClip;
			if (this.useLabel)
			{
				this.useLabel = useLabel;
				checkExistLabel();
			}

			info = { };
			soundManager = SoundManager.getInstance();
			addListener();
			this.enabled = enabled;
		}

		private function removeListener():void
		{
			target.removeEventListener(MouseEvent.CLICK , onReleased);
			target.removeEventListener(MouseEvent.MOUSE_DOWN , onPressed);
			target.removeEventListener(MouseEvent.ROLL_OUT , onRolledOut);
			target.removeEventListener(MouseEvent.ROLL_OVER , onRolledOver);
			target.removeEventListener(MouseEvent.DOUBLE_CLICK , onDoubleClick);				
		}
		
		private function addListener():void
		{
			target.addEventListener(MouseEvent.CLICK , onReleased);
			target.addEventListener(MouseEvent.MOUSE_DOWN , onPressed);
			target.addEventListener(MouseEvent.ROLL_OUT , onRolledOut);
			target.addEventListener(MouseEvent.ROLL_OVER , onRolledOver);
			target.addEventListener(MouseEvent.DOUBLE_CLICK , onDoubleClick);
		}
		
		/**
		 * UIButtonクラスにリスナを登録します。
		 * 
		 * @param	type
		 * @param	listener
		 */
		public static function addEventListener(type:String, listener:Function):void 
		{
			dispatcher.addEventListener(type, listener);
		}
		
		/**
		 * UIButtonクラスのリスナを解除します。
		 * 
		 * @param	type
		 * @param	listener
		 */
		public static function removeEventListener(type:String, listener:Function):void 
		{
			dispatcher.removeEventListener(type, listener);
		}
		
		private function action(mouseEvent:MouseEvent , eventType:String , callBackFunc:Function):void 
		{
			if (enabled)
			{	
				if (toggle)
				{
					showStateFrame(TOGGLE_STATE);
				}
				else if (eventType == RELEASE_STATE)
				{
					showStateFrame(ROLL_OVER_STATE);
				}
				else
				{
					showStateFrame(eventType);
				}
				
				callBack(mouseEvent , eventType , callBackFunc);			
				playButtonSe(eventType);

				UIButton.dispatcher.dispatchEvent(new UIButtonEvent(eventType, this));
			}
		}
		
		private function callBack(mouseEvent:MouseEvent , eventType:String , callBackFunc:Function):void 
		{
			var info:UIButtonInfo = new UIButtonInfo(this, eventType);
			
			if (useCallbackButtonInfo)
			{
											
				if (callBackFunc != null) callBackFunc.apply(null, [info]);
			}
			else
			{
				if (callBackFunc != null) callBackFunc.apply(null, null);
			}
			
			if (onButtonAction != null) onButtonAction.apply(null, [info]);	
		}
		
		private function playButtonSe(eventType:String):void 
		{
			if (!useSe) return;
			
			switch(eventType) 
			{
				case UIButton.ROLL_OUT_STATE:
					if(useRollOutSe)playSe("ROLL_OUT_KEY", !isNaN(rollOutSeVolume)?rollOutSeVolume:ROLL_OUT_SE_VOLUME);
				break;
				case UIButton.ROLL_OVER_STATE:
					if(useRollOverSe)playSe("ROLL_OVER_KEY", !isNaN(rollOverSeVolume)?rollOverSeVolume:ROLL_OVER_SE_VOLUME);
				break;
				case UIButton.PRESS_STATE:
					if(usePressSe)playSe("PRESS_KEY", !isNaN(pressSeVolume)?pressSeVolume:PRESS_SE_VOLUME);
				break;
				case UIButton.RELEASE_STATE:
					if(useReleaseSe)playSe("RELEASE_KEY", !isNaN(releaseSeVolume)?releaseSeVolume:RELEASE_SE_VOLUME);
				break;
			}
		}
		
		/**
		 * すべてのコールバックファンクションを指定します。
		 * すでに、設定済みのファンクションは上書きされます。
		 * 
		 * @param	onRelease
		 * @param	onRollOver
		 * @param	onRollOut
		 * @param	onPress
		 * @param	onDoubleClick
		 * @param	onAction
		 */
		public function registCallBacks(onRelease:Function , 
										onRollOver:Function = null , 
										onRollOut:Function = null , 
										onPress:Function = null , 
										onDoubleClick:Function = null , 
										onAction: Function = null):void {
												onButtonRelease = onRelease;
												onButtonRollOver = onRollOver;
												onButtonRollOut = onRollOut;
												onButtonPress = onPress;
												onButtonDoubleClick = onDoubleClick;
												onButtonAction = onAction;								
										}
										
		/**
		 * @private
		 * 
		 * アウトイベントハンドラ
		 * 
		 * @param	evt
		 */		
		private function onRolledOut(evt : MouseEvent) : void
		{
			action(evt , UIButton.ROLL_OUT_STATE , onButtonRollOut);
		}

		/**
		 * @private
		 * 
		 * オーバーイベントハンドラ
		 * 
		 * @param	evt
		 */	
		private function onRolledOver(evt : MouseEvent) : void 
		{
			action(evt , UIButton.ROLL_OVER_STATE , onButtonRollOver);
		}

		/**
		 * @private
		 * 
		 * プレスイベントハンドラ
		 * 
		 * @param	evt
		 */	
		private function onPressed(evt : MouseEvent):void 
		{
			action(evt , UIButton.PRESS_STATE , onButtonPress);
		}

		/**
		 * @private
		 * 
		 * リリースイベントハンドラ
		 * 
		 * @param	evt
		 */	
		private function onReleased(evt : MouseEvent):void 
		{
			action(evt , UIButton.RELEASE_STATE , onButtonRelease);		
		}

		/**
		 * @private
		 * 
		 * ダブルクリックイベントハンドラ
		 * 
		 * @param	evt
		 */	
		private function onDoubleClick(evt : MouseEvent):void
		{
			callBack(evt , UIButton.DOUBLE_CLICK_STATE , onButtonDoubleClick);
		}
		
		/**
		*　ボタンインスタンスを返却します。
		* 
		* @return 
		*/	
		public function get target():Sprite
		{
			return m_target;
		}

		/**
		* ボタンが有効かどうか返却を返却します。
		*/	
		public function get enabled():Boolean
		{
			return m_enabled;
		}
		
		public function set enabled(bool : Boolean):void 
		{
			if (m_enabled == bool) return;

			m_enabled = bool;
			target.buttonMode = bool;
			target.mouseEnabled = bool;
			if (!buttonMode && enabled) target.buttonMode = buttonMode;
			if (target_mc != null)target_mc.enabled = bool;
			showStateFrame(enabled?NORMAL_STATE:DISABLE_STATE);		
			if (enabled) 
			{
				addListener();
			}
			else 
			{
				removeListener();
			}
		}

		
		/**
		 * トグルどうか返却します。
		 */	
		public function get toggle():Boolean
		{
			return m_toggle;
		}
		
		public function set toggle(bool : Boolean):void 
		{
			if (m_toggle == bool) return;
			
			m_toggle = bool;
			showStateFrame(toggle?UIButton.TOGGLE_STATE:UIButton.NORMAL_STATE);
		}

		/**
		* ボタンモードを返却します。
		*/	
		public function get buttonMode():Boolean{
			return m_buttonMode;
		}
	
		public function set buttonMode(mode:Boolean):void {
			if (m_buttonMode == mode) return;
			m_buttonMode = mode;
			if (enabled) target.buttonMode = m_buttonMode;
		}

		
		/**
		 * ダブルクリックが有効かどうか返却します。
		 * 
		 * @return ダブルクリックが有効かどうかの真偽値。
		 */	
		public function get doubleClickEnabled():Boolean
		{
			return m_doubleClickEnabled;
		}
		
		public function set doubleClickEnabled(bool:Boolean):void 
		{
			if (m_doubleClickEnabled == bool) return;
			m_doubleClickEnabled = bool;
			target.doubleClickEnabled = bool;
		}

		private function checkExistLabel():void
		{
			if (target_mc == null) return;
			var labels:Array = target_mc.currentLabels;
			if (labels == null || labels.length == 0) return;
			
			labelEnabled = { };
			var len:uint = labels.length;
			for (var i:uint; i < len ; i++) 
			{
				var label:FrameLabel = labels[i];
				labelEnabled[label.name] = true;
			}
		}

		private function showStateFrame(stateLabelName:String, force:Boolean = false):void 
		{
			if (useLabel)
				showFrame(stateLabelName, force);
		}

		//UTILITY -----------------------------------------------------------------------------
		
		/**
		 * サウンドを鳴らします。
		 * @param	id
		 * @param	seVolume
		 */
		public function playSe(soundName:String , volume:Number = 1):void
		{

			soundManager.play(SoundManager[soundName], volume,0 );	
		}
		
		/**
		 * 指定したラベル名のフレームを表示します。
		 * 
		 * @param	labelName
		 * @param	forc : 現在指定したフレームが表示されている場合、実行するかどうか
		 */
		public function showFrame(labelName:String , force:Boolean = false):void
		{
			target.removeEventListener(Event.ENTER_FRAME , onNextFrame);
			target.removeEventListener(Event.ENTER_FRAME , onPrevFrame);
			
			if (target_mc == null) return;
			
			if (labelEnabled != null && labelEnabled[labelName]) 
			{
				if (force || labelName != target_mc.currentLabel)
				{
					target_mc.gotoAndPlay(labelName);
				}
			}
		}
		
		/**
		 * 設定されているボタンインスタンスが非表示状態かどうかを返却します。
		 */
		public function set hiden(value:Boolean):void 
		{
			target.visible = value;
		}
		
		public function get hiden():Boolean
		{
			return target.visible;
		}
		
		public function get target_mc():MovieClip { return m_target_mc; }
		
		public function nextFrame():void
		{
			if (target != null) 
			{
				target.removeEventListener(Event.ENTER_FRAME , onPrevFrame);
				target.addEventListener(Event.ENTER_FRAME , onNextFrame);
			}
		}
		
		public function onNextFrame(evt:Event):void 
		{
			var frame:int = target_mc.currentFrame + 1;
			if (frame >= target_mc.totalFrames) 
			{
				target_mc.gotoAndStop(target_mc.currentFrame);
				target.removeEventListener(Event.ENTER_FRAME , onNextFrame);
				return;
			}
			target_mc.gotoAndStop(frame);
		}
		
		public function prevFrame():void
		{
			if (target != null) 
			{
				target.removeEventListener(Event.ENTER_FRAME , onNextFrame);
				target.addEventListener(Event.ENTER_FRAME , onPrevFrame);
			}			
		}
		
		public function onPrevFrame(evt:Event):void 
		{
			var frame:int = target_mc.currentFrame - 1;
			if (frame <= 1) 
			{
				target_mc.gotoAndStop(1);
				target.removeEventListener(Event.ENTER_FRAME , onPrevFrame);
				return;
			}
			target_mc.gotoAndStop(frame);
		}

		/**
		 * このクラスが完全に不要になったときに実行し、メモリから開放します。
		 */
		public function dispose():void 
		{
			target.removeEventListener(Event.ENTER_FRAME , onNextFrame);
			target.removeEventListener(Event.ENTER_FRAME , onPrevFrame);
			
			enabled=false;
			removeListener();
		}
		
		/**
		 * クラスの完全修飾名を返却します。
		 * 
		 * @return クラスの完全修飾名
		 */
		public override function toString():String
		{
			return "jp.co.shed.controls.UIButton (";
		}
	}
}