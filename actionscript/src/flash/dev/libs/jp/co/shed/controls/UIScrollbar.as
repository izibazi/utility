package jp.co.shed.controls 
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;

	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.TimerEvent;
	import flash.utils.Timer;

	/**
	 * スクロールバーを管理するクラス。
	 * スクロールは、UISliderに委譲します。
	 * 
	 * @author yasunari ishibashi
	 */
	public class UIScrollbar extends EventDispatcher
	{

		private var m_scrollbar:Sprite;
		
		private var m_slider:UISlider;
		
		private var m_enabled:Boolean;
		
		private var upBtn:Sprite;
		
		private var downBtn:Sprite;
		
		private var upBtnControl:UIButton;
		
		private var downBtnControl:UIButton;
		
		private var m_target:Sprite;
		
		private var m_mask:Sprite;
		
		private var m_id:uint;
		
		private var upDownTimer:Timer;
		
		private var m_upDownTimerInterval:Number = 2 * 100;
		
		private var isUp:Boolean;
		
		private var autoScroll:Boolean;
		
		private var m_needScrollBar:Boolean;
		
		public var wheelArea_mc:Sprite;

		/** コンテンツのエリアを指定.この値を指定すると、targetのサイズを調べません.*/
		public var contentRect:Rectangle;

		/**
		 * コンストラクタ
		 * 
		 * @param	target
		 * @param	mask
		 * @param	scrollbar
		 * @param	wheelArea
		 * @param	upBtn
		 * @param	downBtn
		 * @param	useUpDownBtnSe
		 */
		public function UIScrollbar(target:Sprite, mask:Sprite, scrollbar:Sprite = null, wheelArea:Sprite = null, upBtn:Sprite = null, downBtn:Sprite = null, useUpDownBtnSe:Boolean = true) 
		{
			if (target == null || mask == null)
			{
				trace(toString() + "error target or mask is not defined");
				return;
			}
			this.scrollbar = scrollbar;
			this.target = target;
			this.mask = mask;
			this.mask.visible = false;
			this.target.mask = this.mask;
			
			this.upBtn = upBtn;
			this.downBtn = downBtn;
			
			if (this.upBtn != null) 
			{
				upBtnControl = new UIButton(upBtn);
				upBtnControl.useSe = useUpDownBtnSe;
				upBtnControl.onButtonPress = onUpDownButtonPressed;
				upBtnControl.onButtonRelease = onUpDownButtonReleased;
			}
			
			if (this.downBtn != null) 
			{
				downBtnControl = new UIButton(downBtn);
				downBtnControl.useSe = useUpDownBtnSe;
				downBtnControl.onButtonPress = onUpDownButtonPressed;
				downBtnControl.onButtonRelease = onUpDownButtonReleased;
			}
			
			this.wheelArea_mc = wheelArea;
			if (wheelArea_mc == null) 
			{
				this.wheelArea_mc = target;
			}

			upDownTimer = new Timer(upDownTimerInterval);
			upDownTimer.addEventListener(TimerEvent.TIMER, onUpDownTimer);
		}
		
		/**
		 * スライダーを設定します。
		 * 
		 * @param	track
		 * @param	thumb
		 * @param	indicator
		 * @param	horizontal
		 * @param	reverse
		 * @param	continues
		 * @param	animated
		 * @param	animationDuration
		 * @param	easingType
		 * @param	useMouseWheel
		 * @param	useTrackSe
		 * @param	useThumbSe
		 */
		public function setUpSlider(track:Sprite, thumb:Sprite,indicator:Sprite=null,autoThumbSize:Boolean=true,horizontal:Boolean=false,reverse:Boolean=false,continues:Boolean=true, animated:Boolean=true , animationDuration:Number=.3,easingType:Function=null,useMouseWheel:Boolean=true,useTrackSe:Boolean = true, useThumbSe:Boolean = true ):void 
		{
			slider = new UISlider(track, 
									thumb, 
									indicator, 
									horizontal, 
									reverse, 
									0, 
									0, 
									1,
									continues, 
									animated, 
									animationDuration, 
									easingType, 
									useMouseWheel, 
									useTrackSe, 
									useThumbSe);

			slider.autoThumbSize = autoThumbSize;
			slider.addEventListener(UISlider.VALUE_CHANGE, onValueChanged);
			wheelArea_mc.addEventListener(MouseEvent.MOUSE_WHEEL, onWheel);
			
			updateState();
		}
		
		/**
		 * アニメーションを有効にするかどうかを返却します。
		 */
		public function get animated():Boolean 
		{
			return slider.animated;
		}
		
		public function set animated(value:Boolean):void 
		{
			slider.animated = value;
		}
		
		private function onWheel(evt:MouseEvent):void 
		{
			//SDLog.dump (evt.delta)
			if (slider.enabled && slider.useMouseWheel && needScrollBar) {
				slider.moveByWheel(evt.delta);
			}
		}

		private function onValueChanged(evt:Event):void 
		{
			update();
		}
		
		private function getThumbDistance(trackDistance:Number = NaN):Number 
		{
			return (isNaN(trackDistance)?slider.trackDistance:trackDistance) * getPercentTargetByMask();
		}
		
		/**
		 * トラックの距離が変更し、表示を更新します。
		 * 
		 * @param	trackDistance
		 */
		public function updateState(trackDistance:Number = NaN):void 
		{
			if (scrollbar != null) scrollbar.visible = needScrollBar;
			
			var m_trackDist:Number = isNaN(trackDistance)?slider.trackDistance:trackDistance;
			if (!needScrollBar) 
			{
				slider.percent = 0;
				slider.maximumThumbDistanceInset = 0;
				slider.updateSize(m_trackDist, m_trackDist);
			}
			else
			{
				slider.maximumThumbDistanceInset = 10;
				slider.updateSize(m_trackDist, getThumbDistance(trackDistance));
			}
			
			if (downBtn != null) 
			{
				if (!slider.horizontal)
				{
					downBtn.y = slider.trackDistance + upBtn.height;
				}
				else 
				{
					downBtn.x = slider.trackDistance + upBtn.width;
				}
			}
			
			update();
		}
		
		private function update():void 
		{
			updateUpDownState();
			dispatchEvent(new Event(UISlider.VALUE_CHANGE));
		}
		
		private function onUpDownButtonPressed(evt:UIButtonInfo):void 
		{
			isUp = (evt.btnControl == upBtnControl);
			autoScroll = true;
			upDownTimer.start();
			scrollSlider();
		}
		
		private function onUpDownButtonReleased(evt:UIButtonInfo):void 
		{
			upDownTimer.stop();
			autoScroll = false;
		}
		
		private function onUpDownTimer(evt:TimerEvent):void 
		{
			scrollSlider();
		}
		
		private function scrollSlider():void 
		{
			if (isUp) 
			{
				slider.percent -= slider.mouseWheelSlidePercent;
			}
			else 
			{
				slider.percent += slider.mouseWheelSlidePercent;
			}			
		}

		private function updateUpDownState():void 
		{
			if(upBtnControl!=null){
				upBtnControl.enabled = slider.value != 0;
				downBtnControl.enabled = slider.value != 1;
				if (autoScroll) 
				{
					if (!upBtnControl.enabled || !downBtnControl.enabled) 
					{
						autoScroll = false;
						upDownTimer.stop();
					}
				}
			}
		}

		/**
		 * 現在のパーセントを返却します。
		 */
		public function get percent():Number 
		{
			return slider != null?slider.percent: 0;
		}
		
		public function set percent(pct:Number):void 
		{
			if (slider != null)
			{
				slider.percent = pct;
			}
			else 
			{
				trace(toString() + "warning slider is not defined.");
			}
		}
		
		/**
		 * スクロールが有効かどうかを返却します。
		 */
		public function get enabled():Boolean { return m_enabled; }
		
		public function set enabled(value:Boolean):void 
		{
			m_enabled = value;
			autoScroll = false;
			upDownTimer.stop();
			
			if (m_slider != null) 
			{
				m_slider.enabled = m_enabled;
			}
			if (upBtnControl != null) 
			{
				upBtnControl.enabled = m_enabled;
			}
			if (downBtnControl != null) 
			{
				downBtnControl.enabled = m_enabled;
			}
		}
		
		/**
		 * このオブジェクトが不要になった場合に、削除します。
		 * これ以降は、このオブジェクトを再利用することはできません。
		 */
		public function dispose():void 
		{
			upDownTimer.stop();
			upDownTimer = null;
			wheelArea_mc.removeEventListener(MouseEvent.MOUSE_WHEEL, onWheel);
			
			if (slider != null)
			{
				slider.dispose();
				slider.removeEventListener(Event.SCROLL, onValueChanged);
			}
		}
		
		/**
		 * オブジェクトのidを返却します。
		 */
		public function get id():uint { return m_id; }
		
		public function set id(value:uint):void 
		{
			m_id = value;
		}
		
		/**
		 * 上下のupボタン、downボタンプレス時の移動遅延時間(秒数)を返却します。[default:.2]
		 */
		public function get upDownTimerInterval():Number { return m_upDownTimerInterval; }
		
		public function set upDownTimerInterval(sec:Number):void 
		{
			m_upDownTimerInterval = sec*1000;
			upDownTimer.delay = m_upDownTimerInterval;
		}
		
		/**
		 * 現在スクロールバーが必要かどうかを返却します。
		 */
		public function get needScrollBar():Boolean { 
			return slider.horizontal?(this.contentWidth > this.mask.width):(this.contentHeight > this.mask.height); 
		}
		
		public function get targetPosition():Number
		{
			var targetPosition:Number;
			var minimumPosition:Number;
			var maximumPosition:Number = 0;
			if (!slider.horizontal) 
			{
				minimumPosition = (needScrollBar)?(mask.height - contentHeight):0;
				
				targetPosition = -(contentHeight - mask.height) * slider.percent;
				
			}
			else 
			{
				minimumPosition = (needScrollBar)?mask.width - contentWidth:0;
				targetPosition = -(contentWidth - mask.width) * slider.percent;
			}
			
			targetPosition = Math.max(minimumPosition, targetPosition);
			targetPosition = Math.min(maximumPosition, targetPosition);
			
			
			return targetPosition;
		}
		
		/**
		 * スクロールターゲットの最小座標を返却します。
		 */
		public function get minumumTargetPosition():Number
		{
			if (!slider.horizontal) 
			{
				return (mask.height - contentHeight);
			}
			else
			{
				return (mask.width - contentWidth);
			}
		}
		
		/**
		 * スクロールバーオブジェクトを返却します。
		 */
		public function get scrollbar():Sprite { return m_scrollbar; }
		
		public function set scrollbar(value:Sprite):void 
		{
			m_scrollbar = value;
		}
		
		/**
		 * スクロールターゲットを返却します。
		 */
		public function get target():Sprite { return m_target; }
		
		public function set target(value:Sprite):void 
		{
			m_target = value;
		}
		
		/**
		 * スクロールターゲットのマスクオブジェクトを返却します。
		 */
		public function get mask():Sprite { return m_mask; }
		
		public function set mask(value:Sprite):void 
		{
			m_mask = value;
		}
		
		/**
		 * UISliderオブジェクトを返却します。
		 */
		public function get slider():UISlider 
		{ 
			if (m_slider == null)
			{
				trace(toString() + "error : slider is not defined.call setUpSlider");
				throw new Error();
			}
			return m_slider; 
		}
		
		public function set slider(value:UISlider):void 
		{
			m_slider = value;
		}
		
		/**
		 * アニメーション時間を返却します。
		 * 
		 * @see jp.co.shed.controls.UISlider.as
		 */
		public function get animationDuration():Number
		{ 
			return slider.animationDuration; 
		}
		
		public function set animationDuration(value:Number):void 
		{
			slider.animationDuration = value;
		}

		/**
		 * マスクに対してのパーセントを返却します。
		 * 
		 * @return
		 */
		public function getPercentTargetByMask():Number 
		{
			if (needScrollBar)
			{
				return (slider.horizontal)?(mask.width / contentWidth):(mask.height / contentHeight);
			}
			else
			{
				return 1;
			}
		}
		
		public function get contentWidth():Number
		{
			if (contentRect == null)
			{
				return target.width;
			}
			
			return contentRect.width;
		}
		
		public function get contentHeight():Number
		{
			if (contentRect == null)
			{
				return target.height;
			}
			
			return contentRect.height;
		}

		/**
		 * クラスの完全修飾名を返却します。
		 * 
		 * @return
		 */
		public override function toString():String 
		{
			return "jp.co.shed.controls.UIScrollbar (";
		}
	}
	
}