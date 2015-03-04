package __projectname__.common.controls 
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import jp.co.shed.controls.UIButton;
	import jp.co.shed.controls.UIButtonInfo;
	import jp.co.shed.transitions.SDTweener;
	
	/**
	 * ボタンを管理するクラス。
	 * 
	 * @author yasunari ishibashi
	 */
	public class UIBrightnessButton extends UIButton
	{

		private var m_disableAlphaValue:Number = .5;
		
		private var m_brightnessValue:Number = .4;
		
		/**
		 * コンストラクタ。
		 * 
		 * @param	target
		 * @param	release
		 * @param	rollOver
		 * @param	rollOut
		 * @param	enabled
		 * @param	buttonMode
		 * @param	useSe
		 * @param	useLabel
		 */
		public function UIBrightnessButton(target : Sprite , 
								release:Function = null,
								rollOver:Function = null,
								rollOut:Function = null,
								enabled : Boolean = true , 
								buttonMode : Boolean = true , 
								useSe:Boolean = true, 
								useLabel:Boolean = false ) {
									
				super(target, release, rollOver, rollOut, enabled, buttonMode, useSe, useLabel);

				onButtonAction = onAction;
		}
		
		private function onAction(evt:UIButtonInfo):void
		{
			switch(evt.eventType)
			{
				case UIButton.ROLL_OVER_STATE:
					__onRollOver();
				break;
				case UIButton.ROLL_OUT_STATE:
					__onRollOut();
				break;
				case UIButton.PRESS_STATE:
					__onPress();
				break;		
				case UIButton.RELEASE_STATE:
					__onRelease();
				break;
				case UIButton.DOUBLE_CLICK_STATE:
					__onDoubleClick();
				break;
				default:
					//otherwise here.
					//trace(evt.eventType);
				break;
			}
		}
		
		private function __onRollOver():void 
		{
			SDTweener.bright(target_mc.base_mc, NaN, m_brightnessValue, .6);
		}
		
		private function __onRollOut():void 
		{
			SDTweener.bright(target_mc.base_mc, NaN, 0, .6);
		}
		
		private function __onPress():void 
		{
			SDTweener.bright(target_mc.base_mc, NaN, -m_brightnessValue*.5, .2);
		}
		
		private function __onRelease():void 
		{
			SDTweener.bright(target_mc.base_mc, NaN, m_brightnessValue, .6);
		}
		
		private function __onDoubleClick():void 
		{
			
		}
		
		/**
		 * 状態を更新します。
		 * 
		 * @param	enable
		 */
		public function updateEanble(enable:Boolean):void 
		{
			if (enabled == enable) return;
			
			enabled = enable;
			SDTweener.remove(target_mc.base_mc);
			target_mc.base_mc.alpha = enabled?1:disableAlphaValue;
		}
		
		/**
		 * disable状態のalpha値を返却します。[default:5, min:0 , max:1]
		 */
		public function get disableAlphaValue():Number { return m_disableAlphaValue; }
		
		public function set disableAlphaValue(value:Number):void 
		{
			m_disableAlphaValue = value;
			
			if (m_disableAlphaValue < 0) 
			{
				m_disableAlphaValue = 0;
			}
			else if (m_disableAlphaValue > 1)
			{
				m_disableAlphaValue = 1;
			}

		}
		
		public function get brightnessValue():Number { return m_brightnessValue; }
		
		public function set brightnessValue(value:Number):void 
		{
			m_brightnessValue = value;
		}
	}
}