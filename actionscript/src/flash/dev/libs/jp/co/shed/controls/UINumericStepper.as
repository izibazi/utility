package jp.co.shed.controls 
{
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.FocusEvent;
	import flash.events.TimerEvent;
	import flash.text.TextField;
	import flash.text.TextFieldType;
	import flash.utils.Timer;
	
	/**
	 * ナメリックステッパーを管理するクラス。
	 * 
	 * @author yasunari ishibashi
	 */
	public class UINumericStepper extends EventDispatcher
	{

		public static const VALUE_CHANGE:String = "jp.co.shed.controls.UINumericStepper.VALUE_CHANGE";
		
		public static const NEXT_ROLL_OVER:String = "jp.co.shed.controls.UINumericStepper.NEXT_ROLLOVER";
		
		public static const PREV_ROLL_OVER:String = "jp.co.shed.controls.UINumericStepper.PREVP_ROLL_OVER";
		
		public static const NEXT_ROLL_OUT:String = "jp.co.shed.controls.UINumericStepper.NEXT_ROLL_OUT";
		
		public static const PREV_ROLL_OUT:String = "jp.co.shed.controls.UINumericStepper.PREV_ROLL_OUT";
		
		public static const NEXT_PRESS:String = "jp.co.shed.controls.UINumericStepper.NEXT_PRESS";
		
		public static const PREV_PRESS:String = "jp.co.shed.controls.UINumericStepper.PREV_PRESS";
		
		public static const NEXT_RELEASE:String = "jp.co.shed.controls.UINumericStepper.NEXT_RELEASE";
		
		public static const PREV_RELEASE:String = "jp.co.shed.controls.UINumericStepper.PREV_RELEASE";
		
		public static const FOCUS_IN:String = "jp.co.shed.controls.UINumericStepper.FOCUS_IN";
		
		public static const FOCUS_OUT:String = "jp.co.shed.controls.UINumericStepper.FOCUS_OUT";
		
		public static const INVALID_VALUE:String = "jp.co.shed.controls.UINumericStepper.INVALID_VALUE";
		
		private var m_maxValue:Number;
		
		private var m_minValue:Number;
		
		private var m_step:Number;
				
		private var m_initValue:Number;
		
		private var m_next_btn:MovieClip;
		
		private var m_prev_btn:MovieClip;
		
		private var m_input_txt:TextField;
		
		private var m_base_mc:MovieClip;
		
		private var m_useFocusDisplay:Boolean = true;
		
		private var m_focusDisplayAlpha:Number = .8;
		
		private var m_continuos:Boolean = true;

		private var m_value:Number;
		
		private var m_nextBtnControl:UIButton;
		
		private var m_prevBtnControl:UIButton;
		
		private var m_timer:Timer;
		
		private var m_timerDelay:Number = 150;
		
		private var m_btnRollOverAlpha:Number = .8;
		
		private var m_btnPressAlpha:Number = .8;
		
		/**
		 * コンストラクタ。
		 * 
		 * @param	next_btn
		 * @param	prev_btn
		 * @param	input_txt
		 * @param	initValue
		 * @param	minValue
		 * @param	maxValue
		 * @param	stepValue
		 */
		public function UINumericStepper(	next_btn:MovieClip, 
											prev_btn:MovieClip, 
											input_txt:TextField,
											initValue:Number = .5, 
											minValue:Number = 0, 
											maxValue:Number = 1,
											stepValue:Number = .1)
		{
			m_initValue = initValue;
			m_minValue = minValue;
			m_maxValue = maxValue;						  
			m_step = stepValue;
			
			m_next_btn = next_btn;
			m_prev_btn = prev_btn;
			m_input_txt = input_txt;
		
			//指定値の確認。
			checkValues();
			initAssets();
		}
		
		private function checkValues():void
		{
			if (m_maxValue < m_minValue)
			{
				var temp:Number = m_maxValue;
				m_maxValue = m_minValue;
				m_minValue = temp;
				trace("!waring:minValueとmaxValueが正しいか確認してください。");
			}
			
			//TODO 警告。
			m_initValue = m_initValue < m_minValue ? m_minValue :
						  m_initValue > m_maxValue ? m_maxValue :
						  m_initValue;
						  
			if (m_step < 0)
				throw new Error("stepは0以上の値を指定してください。");
				
			if (m_maxValue-m_minValue < m_step)
				throw new Error("stepの値が大きすぎます。");
			
			if (m_next_btn == null || m_prev_btn == null || m_input_txt == null)
				throw new Error("next_btn,prev_btn,input_txtがnullの可能性があります。");
		}
		
		private function initAssets():void
		{
			value = initValue;
			m_input_txt.type = TextFieldType.INPUT;
			m_input_txt.restrict = "0-9.-";
			m_input_txt.maxChars = m_maxValue.toString().length;
			
			m_input_txt.addEventListener(FocusEvent.FOCUS_IN, onFocusIn);
			m_input_txt.addEventListener(FocusEvent.FOCUS_OUT, onFocusOut);
			m_input_txt.addEventListener(Event.CHANGE, onValueChanged);
			
			m_nextBtnControl = new UIButton(m_next_btn, onReleased, onRolledOver, onRolledOut);
			m_nextBtnControl.onButtonPress = onPressed;
			
			m_prevBtnControl = new UIButton(m_prev_btn, onReleased, onRolledOver, onRolledOut);
			m_prevBtnControl.onButtonPress = onPressed;
		}
		
		/**
		 * タイマーを停止します。
		 */
		public function stopTimer():void
		{
			if (m_timer)
			{
				m_timer.stop();
				m_timer = null;
			}
		}
		
		public function onPressed(info:UIButtonInfo):void
		{
			var btn:MovieClip = info.btnControl.target_mc;
			stopTimer();
			btn.alpha = m_btnPressAlpha;
			if (btn == m_next_btn)
			{
				value += m_step;
			}
			else
			{
				value-= m_step;
			}
			
			m_timer = new Timer(m_timerDelay, 0);
			m_timer.addEventListener(TimerEvent.TIMER, btn == m_next_btn?onNextTick:onPrevTick);
			m_timer.start();
			
			dispatchEvent(new Event(btn==m_next_btn?NEXT_PRESS:PREV_PRESS));
		}
		
		private function onNextTick(e:TimerEvent):void
		{
			value += m_step;
		}
		
		public function onReleased(info:UIButtonInfo):void
		{
			var btn:MovieClip = info.btnControl.target_mc;
			m_prev_btn.alpha = 1;
			m_next_btn.alpha = 1;
			stopTimer();
			value = m_value;
			dispatchEvent(new Event(btn==m_next_btn?NEXT_RELEASE:PREV_RELEASE));
		}	

		private function onPrevTick(e:TimerEvent):void
		{
			value -= m_step;
		}

		public function onRolledOver(info:UIButtonInfo):void
		{
			var btn:MovieClip = info.btnControl.target_mc;
			btn.alpha = m_btnRollOverAlpha;
			stopTimer();
			dispatchEvent(new Event(btn==m_next_btn?NEXT_ROLL_OVER:PREV_ROLL_OVER));
		}
		
		public function onRolledOut(info:UIButtonInfo):void
		{
			var btn:MovieClip = info.btnControl.target_mc;
			btn.alpha = 1;
			stopTimer();
			dispatchEvent(new Event(btn==m_next_btn?NEXT_ROLL_OUT:PREV_ROLL_OUT));
		}			
		
		/**
		 * 現在の値を返却します。
		 */
		public function get value():Number
		{
			return Number(m_input_txt.text);
		}
		
		public function set value(newValue:Number):void
		{
			var tempValue:Number;
			
			if (isNaN(newValue))
			{
				tempValue = m_initValue;
			}

			tempValue = m_minValue > newValue ? m_minValue : 
						m_maxValue < newValue ? m_maxValue :
						newValue;	
					
			m_value = tempValue;
			
			m_input_txt.removeEventListener(Event.CHANGE, onValueChanged);
			m_input_txt.text = tempValue + "";
			m_input_txt.addEventListener(Event.CHANGE, onValueChanged);
			
			if (m_continuos || (!m_continuos && m_timer == null))
			{
				if (tempValue != newValue)
				{
					dispatchEvent(new Event(INVALID_VALUE));
				}
				else
				{
					dispatchEvent(new Event(VALUE_CHANGE));
				}
			}
		}
		
		private function onValueChanged(e:Event):void
		{
			//TODO 取りあえず入力では、整数のみを許可。
			value = Math.round(Number(m_input_txt.text));
		}
		
		private function onFocusIn(e:FocusEvent):void
		{
			if (m_useFocusDisplay)
			{
				m_input_txt.alpha = m_focusDisplayAlpha;
			}
			
			dispatchEvent(new Event(FOCUS_IN));
		}
		
		private function onFocusOut(e:FocusEvent):void
		{
			m_input_txt.alpha = 1;
			dispatchEvent(new Event(FOCUS_OUT));
		}
		
		/**
		 * フォーカス時のテキストフィールドの透明度を返却します。
		 */
		public function get focusDisplayAlpha():Number { return m_focusDisplayAlpha; }
		
		public function set focusDisplayAlpha(value:Number):void 
		{
			m_focusDisplayAlpha = value;
			
			if (m_focusDisplayAlpha < 0) m_focusDisplayAlpha = 0;
			if (m_focusDisplayAlpha > 1) m_focusDisplayAlpha = 1;
		}
		
		/**
		 * テキストフィールドにフォーカス時に、表示を変更するかどうかを返却します。
		 */
		public function get useFocusDisplay():Boolean { return m_useFocusDisplay; }
		
		public function set useFocusDisplay(value:Boolean):void 
		{
			m_useFocusDisplay = value;
		}
		
		/**
		 * ボタンプレス時に、変更を継続的に通知するかどうかを返却します。
		 */
		public function get continuos():Boolean { return m_continuos; }
		
		public function set continuos(value:Boolean):void 
		{
			m_continuos = value;
		}
		
		/**
		 * 文字数を指定します。
		 */
		public function get maxChars():Number { return m_input_txt.maxChars; }
		
		public function set maxChars(value:Number):void 
		{
			m_input_txt.maxChars = value;
		}
		
		/**
		 * ボタンプレス時に、stepに基づいて、更新する遅延時間を返却します。
		 */
		public function get timerDelay():Number { return m_timerDelay; }
		
		public function set timerDelay(value:Number):void 
		{
			m_timerDelay = value;
		}
		
		/**
		 *　最大値を返却します。(read-only)
		 */
		public function get maxValue():Number { return m_maxValue; }
		
		/**
		 * 最小値を返却します。(read-only)
		 */
		public function get minValue():Number { return m_minValue; }
		
		/**
		 * ステップ数を返却します。(read-only)
		 */
		public function get step():Number { return m_step; }

		/**
		 * 初期値を返却します。(read-only)
		 */
		public function get initValue():Number { return m_initValue; }
		
		/**
		 * ボタンロールオーバー時の透明度を返却します。
		 */
		public function get btnRollOverAlpha():Number { return m_btnRollOverAlpha; }
		
		public function set btnRollOverAlpha(value:Number):void 
		{
			m_btnRollOverAlpha = value;
		}
		
		/**
		 * ボタンロールプレス時の透明度を返却します。
		 */		
		public function get btnPressAlpha():Number { return m_btnPressAlpha; }
		
		public function set btnPressAlpha(value:Number):void 
		{
			m_btnPressAlpha = value;
		}

		/**
		 * 破棄します。
		 */
		public function dispose():void
		{
			stopTimer();
			m_nextBtnControl.dispose();
			m_prevBtnControl.dispose();
		}
	}

}