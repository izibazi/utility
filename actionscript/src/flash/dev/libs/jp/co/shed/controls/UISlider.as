package jp.co.shed.controls 
{
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.geom.Rectangle;
	import flash.utils.Timer;

	import jp.co.shed.controls.UIButtonInfo;
	
	import fl.transitions.Tween;
	import fl.transitions.TweenEvent;
	import fl.transitions.easing.*;
	
	/**
	 * スライダーを管理するクラス。
	 * 
	 * @author yasunari ishibashi
	 */
	public class UISlider extends EventDispatcher
	{
		/*ステージオブジェクト*/
		public static var stageRef:Stage;
		
		private var track:Sprite;
		
		private var thumb:Sprite;
		
		private var indicator:Sprite;
		
		private var m_thumbBtnControl:UIButton;
		
		private var m_trackBtnControl:UIButton;
		
		private var m_minimumValue:Number;
		
		private var m_maximumValue:Number;
		
		private var m_value:Number;
		
		private var m_enabled:Boolean;
		
		private var m_useMouseWheel:Boolean;
		
		private var m_useThumbSe:Boolean;
		
		private var m_useTrackSe:Boolean;
		
		private var m_animated:Boolean = true;
		
		private var m_animationDuration:Number = .2;
		
		private var m_easingType:Function = Strong.easeOut;
		
		private var m_continuos:Boolean;	
		
		private var m_stage:Stage;
		
		private var m_id:Number;
		
		private var m_mouseWheelSlidePercent:Number = .03;
		
		private var m_trackSlidePercent:Number = .4;
		
		private var m_trackSlideValue:Number = 30;
		
		private var m_minimumThumbDistance:Number = 20;
		
		private var m_maximumThumbDistanceInset:Number = 20;
		
		private var m_minimumTrackDistance:Number = 100;
		
		private var m_goalThumbDistance:Number; 
		
		private var m_trackSlideInterval:Number = .2 * 1000;
		
		/*thumbのサイズを自動的にリサイズするかどうかの真偽値*/
		public var autoThumbSize:Boolean = true;
		
		//private 
		
		private var dragThumb:Boolean;
		
		private var hitTestSlider:Boolean;
		
		private var resizing:Boolean;
		
		private var m_horizontal:Boolean;

		private var reverse:Boolean;
		
		private var thumbPositionTween:Tween;

		private var thumbDistanceTween:Tween;
		
		private var trackSlideTimer:Timer;

		/*サムのボタンリリース時に、送出されるイベント名*/
		public static const THUMB_RELEASE:String = "thumbRelease";
		
		/*サムのボタンロールオーバー時に、送出されるイベント名*/
		public static const THUMB_ROLL_OVER:String = "thumbRollOver";
		
		/*サムのボタンロールアウト時に、送出されるイベント名*/
		public static const THUMB_ROLL_OUT:String = "thumbRollOut";
		
		/*サムのボタンプレス時に、送出されるイベント名*/
		public static const THUMB_PRESS:String = "thumbPress";
		
		/*トラックリリース時に、送出されるイベント名*/
		public static const TRACK_RELEASE:String = "trackRelease";
		
		/*トラックロールオーバー時に、送出されるイベント名*/
		public static const TRACK_ROLL_OVER:String = "trackRollOver";
		
		/*トラックロールアウト時に、送出されるイベント名*/
		public static const TRACK_ROLL_OUT:String = "trackRollOut";
		
		/*トラックプレス時に、送出されるイベント名*/
		public static const TRACK_PRESS:String = "trackPress";
		
		/*サムのボタンドラッグ時に、送出されるイベント名*/
		public static const THUMB_MOVE:String = "thumbMove";
		
		/*値が変化したとき時に、送出されるイベント名*/
		public static const VALUE_CHANGE:String = "valueChange";

		/**
		 * コンストラクタ
		 * 
		 * @param	track				:	track
		 * @param	thumb				:	thumb
		 * @param	horizontal			:	水平スライダーかどうか
		 * @param	reverse				:	上下、左右を逆の値とするかどうか	
		 * @param	initValue			:	初期値
		 * @param	minimumValue		:	最小値
		 * @param	maximumValue		:	最大値
		 * @param	continues			:	thumbドラッグ時に連続的にスクロールイベントを発行するかどうか
		 * @param	animated			:	thumbをアニメーションさせるかどうか
		 * @param	animationDuration	:	アニメーション時間
		 * @param	easingType			:	イージングタイプ
		 * @param	useMouseWheel		:	マウスホイールを使用するかどうか
		 * @param	useTrackSe			:	trackのseを有効にするかどうか
		 * @param	useThumbSe			:	thumbのseを有効にするかどうか
		 */
		public function UISlider(track:Sprite, thumb:Sprite,indicator:Sprite=null,horizontal:Boolean=false,reverse:Boolean=false, initValue:Number = 0, minimumValue:Number = 0, maximumValue:Number = 1,continues:Boolean=true, animated:Boolean=true , animationDuration:Number=.2,easingType:Function=null,useMouseWheel:Boolean=true,useTrackSe:Boolean = true, useThumbSe:Boolean = true ) 
		{
			this.m_horizontal = horizontal;
			
			this.hitTestSlider = false;
			this.reverse = reverse;
			
			this.track = track;
			this.thumb = thumb;

			this.goalThumbDistance = thumbDistance;
			
			this.indicator = indicator;
			
			if (this.indicator != null) indicator.mouseEnabled = false;
			
			this.thumbBtnControl = new UIButton(thumb, onThumbReleased, null, null, true, true, useThumbSe);
			this.trackBtnControl = new UIButton(track, onTrackButtonReleased, null, null, true, true, useTrackSe);
			this.thumbBtnControl.onButtonPress = onThumbPressed;

			this.trackBtnControl.onButtonPress = onTrackButtonPressed;
			this.trackBtnControl.buttonMode = false;
			
			this.trackBtnControl.onButtonRollOver = this.thumbBtnControl.onButtonRollOver = onRolledOver;
			this.trackBtnControl.onButtonRollOut = this.thumbBtnControl.onButtonRollOut = onRolledOut;
			
			this.minimumValue = minimumValue;
			this.maximumValue = maximumValue;
			this.useMouseWheel = useMouseWheel;
			this.continues = continues;
			
			this.easingType = easingType == null?Strong.easeOut:easingType;
			this.animationDuration = animationDuration;
			
			
			this.dragThumb = false;
			this.resizing = false;

			trackSlideTimer = new Timer(trackSlideInterval);
			trackSlideTimer.addEventListener(TimerEvent.TIMER , onTrackSlideTimer);
			this.animated = animated;
			enabled = true;
			
			this.value = initValue;
		}
		
		private function onRolledOver(evt:UIButtonInfo):void 
		{		
			addMouseWheelListener();
			
			if (evt.btnControl.target == track)
			{
				dispatchEvent(new Event(TRACK_ROLL_OVER));
			}
			else 
			{
				dispatchEvent(new Event(THUMB_ROLL_OVER));
			}
		}
		
		private function onRolledOut(evt:UIButtonInfo):void 
		{
			removeMouseWheelListener();
			stopTrackSlideTimer();
			
			if (evt.btnControl.target == track)
			{
				dispatchEvent(new Event(TRACK_ROLL_OUT));
			}
			else
			{
				dispatchEvent(new Event(THUMB_ROLL_OUT));
			}
		}
		
		private function addMouseWheelListener():void 
		{
			if (stage != null)
			{
				stage.addEventListener(MouseEvent.MOUSE_MOVE , onStageMouseMove);
				stage.addEventListener(MouseEvent.MOUSE_WHEEL , onWheel);
			}			
		}
		
		private function removeMouseWheelListener():void 
		{
			if (stage != null)
			{
				stage.removeEventListener(MouseEvent.MOUSE_MOVE , onStageMouseMove);
				stage.removeEventListener(MouseEvent.MOUSE_WHEEL , onWheel);
			}		
		}
		
		private function onWheel(evt:MouseEvent):void 
		{
			if (useMouseWheel && enabled && hitTestSlider) 
			{
				moveByWheel(evt.delta);
			}
		}

		public function moveByWheel(delta:Number):void
		{
			var pct:Number = percent;
			pct += (delta > 0)? -mouseWheelSlidePercent:mouseWheelSlidePercent;
			setValueFromPercent(pct);			
		}
		
		private function onStageMouseMove(evt:MouseEvent):void
		{
			hitTestSlider = track.hitTestPoint(stage.mouseX, stage.mouseY, true);
		}
		
		private function onTrackButtonReleased(evt:UIButtonInfo):void
		{
			stopTrackSlideTimer();
			stage.removeEventListener(MouseEvent.MOUSE_MOVE, onTrackMouseMoved);
			dispatchEvent(new Event(TRACK_RELEASE));
		}

		private function onTrackButtonPressed(evt:UIButtonInfo):void 
		{	
			trackSlideTimer.stop();
			trackSlideTimer.start();
			moveByTrack();
			
			stage.addEventListener(MouseEvent.MOUSE_MOVE, onTrackMouseMoved);
			stage.addEventListener(MouseEvent.MOUSE_UP, function(e) {
				stage.removeEventListener(MouseEvent.MOUSE_MOVE, onTrackMouseMoved);
			});
			
			dispatchEvent(new Event(TRACK_PRESS));
		}
		
		private function onTrackMouseMoved(evt:MouseEvent):void 
		{
			moveByTrack();
		}
		
		private function onTrackSlideTimer(evt:TimerEvent):void 
		{
			moveByTrack();
		}
		
		private function moveByTrack():void
		{
			var upScroll:Boolean = (trackMousePosition < goalThumbPosition);
			var position:Number = goalThumbPosition;

			var limitScrollPosition:Number = trackMousePosition - goalThumbDistance / 2;
			
			position += upScroll? -trackSlideValue: trackSlideValue;
			
			if ((upScroll && limitScrollPosition > position) || (!upScroll && limitScrollPosition < position))
			{
				position = limitScrollPosition;
				stopTrackSlideTimer();
			}

			setValueFromPosition(position);
			
			if (percent >= 1 || percent <= 0)stopTrackSlideTimer();			
		}
		
		private function stopTrackSlideTimer():void 
		{
			trackSlideTimer.stop();
		}
		
		private function onThumbPressed(evt:UIButtonInfo):void 
		{
			startThumbDrag();
			dispatchEvent(new Event(THUMB_PRESS));
		}

		private function onThumbReleased(evt:UIButtonInfo):void 
		{
			stopThumbDrag();
			dispatchEvent(new Event(THUMB_RELEASE));
		}
		
		private function onThumbReleaseOutside(evt:MouseEvent):void 
		{
			stopThumbDrag();
		}
		
		private function startThumbDrag():void 
		{
			stopTrackSlideTimer();
			dragThumb = true;
			
			if (this.stage != null)
			{
				stage.addEventListener(MouseEvent.MOUSE_MOVE , onThumbMoved);
				stage.addEventListener(MouseEvent.MOUSE_UP, onThumbReleaseOutside);
				stage.addEventListener(Event.ENTER_FRAME, onDragging);
			}
			else
			{
				trace(toString()+"warning stage = null");
			}
			
			thumb.startDrag(false, new Rectangle(0, 0, horizontal?canMovingThumbMaxValue:0 , horizontal?0:canMovingThumbMaxValue));	
		}
		
		private function onDragging(evt:Event):void 
		{
			moveIndicator();
		}
		
		private function onThumbMoved(evt:MouseEvent):void 
		{
			if (continues) 
			{
				setValueFromPosition(thumbPosition);
			}
			moveIndicator();
		}
		
		private function moveIndicator():void 
		{
			if (indicator != null) 
			{
				if (horizontal) 
				{
					indicator.x = Math.round((thumb.width - indicator.width) / 2 + thumb.x);
				}
				else
				{
					indicator.y = Math.round((thumb.height - indicator.height) / 2 + thumb.y);
				}		
			}
			
			dispatchEvent(new Event(THUMB_MOVE));
		}
		
		private function stopThumbDrag():void 
		{
			stopTrackSlideTimer();
			thumb.stopDrag();
			dragThumb = false;	
			if (stage != null)
			{
				stage.removeEventListener(MouseEvent.MOUSE_MOVE , onThumbMoved);
				stage.removeEventListener(MouseEvent.MOUSE_UP, onThumbReleaseOutside);
				stage.removeEventListener(Event.ENTER_FRAME, onDragging);
			}
			setValueFromPosition(thumbPosition);
		}
		
		/**
		 * 最小値を返却します。
		 */
		public function get minimumValue():Number { return m_minimumValue; }
		
		public function set minimumValue(value:Number):void 
		{
			m_minimumValue = value;
		}
		
		/**
		 * 最大値を返却します。
		 */
		public function get maximumValue():Number { return m_maximumValue; }
		
		public function set maximumValue(value:Number):void 
		{
			m_maximumValue = value;
		}
		
		/**
		 * 有効かどうかを返却します。
		 */
		public function get enabled():Boolean { return m_enabled; }
		
		public function set enabled(value:Boolean):void 
		{
			m_enabled = value;
			thumbBtnControl.enabled = value;
			trackBtnControl.enabled = value;
			
			stopThumbDrag();
			removeMouseWheelListener();
		}
		
		/**
		 * マウスホイールを使用するかどうかを返却します。
		 */
		public function get useMouseWheel():Boolean { return m_useMouseWheel; }
		
		public function set useMouseWheel(value:Boolean):void 
		{
			m_useMouseWheel = value;
		}
		
		/**
		 * 現在の値を返却します。
		 */
		public function get value():Number { return m_value; }
		
		public function set value(value:Number):void 
		{
			var temp:Number = Math.max(minimumValue, value);
			temp = Math.min(maximumValue, value);

			//if (m_value == temp && !resizing) return;
			m_value = temp;
			moveThumb();
			if (resizing) return;
			
			if (continues)
			{
				dispatchEvent(new Event(UISlider.VALUE_CHANGE));
			}
			else if (!dragThumb)
			{
				dispatchEvent(new Event(UISlider.VALUE_CHANGE));
			}
		}
		
		/**
		 * トラックの座標から、値を設定します。
		 * 
		 * @param	position
		 */
		public function setValueFromPosition(position:Number):void 
		{
			var pct:Number = reverse?(1 - position / canMovingThumbMaxValue):(position / canMovingThumbMaxValue);
			setValueFromPercent(pct);
		}
		
		/**
		 * パーセントを使用して、値を設定します。[min:0 max:1]
		 * @param	pct
		 */
		public function setValueFromPercent(pct:Number):void
		{
			if (pct < 0) pct = 0;
			if (pct > 1) pct = 1;
			this.value = pct * valueLength + minimumValue;
		}
		
		/**
		 * 値の幅を返却します。
		 */
		public function get valueLength():Number
		{
			return (maximumValue-minimumValue);
		}
		
		private function moveThumb():void 
		{
			if (animated)
			{
				removeTween();
				
				thumbPositionTween = new Tween(thumb, (horizontal?"x":"y"), easingType , thumbPosition, goalThumbPosition, animationDuration , true);
				thumbDistanceTween = new Tween(thumb, horizontal?"width":"height", easingType, thumbDistance, goalThumbDistance, animationDuration, true);

				thumbPositionTween.addEventListener(TweenEvent.MOTION_CHANGE, onMotionChanged);
				thumbDistanceTween.addEventListener(TweenEvent.MOTION_CHANGE, onMotionChanged);
				moveIndicator();
			}
			else
			{
				setCurrentStatus();
			}
		}
		
		private function setCurrentStatus():void 
		{
				if (!horizontal)
				{
					thumb.y = goalThumbPosition;
					if (autoThumbSize)
					{
						thumb.height = goalThumbDistance;
					}
				}
				else 
				{
					thumb.x = goalThumbPosition;
					if (autoThumbSize)
					{
						thumb.width = goalThumbDistance;
					}
				}
				
				moveIndicator();			
		}

		
		private function removeTween():void 
		{
			if (thumbPositionTween != null) 
			{
				thumbPositionTween.removeEventListener(TweenEvent.MOTION_CHANGE, onMotionChanged);
				thumbPositionTween.stop();
				thumbPositionTween = null;
				
				thumbDistanceTween.removeEventListener(TweenEvent.MOTION_CHANGE, onMotionChanged);
				thumbDistanceTween.stop();
				thumbDistanceTween = null;				
			}		
		}
		
		private function onMotionChanged(evt:TweenEvent):void
		{
			moveIndicator();
		}
		
		/**
		 * 現在の値のパーセントを返却します。
		 */
		public function get percent():Number 
		{
			return (value-minimumValue) / valueLength;
		}
		
		public function set percent(pct:Number):void
		{
			setValueFromPercent(pct);
		}
		
		/**
		 * thumbの座標を返却します。
		 */
		public function get goalThumbPosition():Number
		{
			var pos:Number = Math.round(reverse?((1 - percent) * canMovingThumbMaxValue):(canMovingThumbMaxValue * percent));
			pos = Math.max(0, pos);
			return pos;
		}

		private function get canMovingThumbMaxValue():Number
		{
			return trackDistance - goalThumbDistance;
		}
		
		/**
		 * thumbの移動にアニメーションを使用するかどうかを返却します。[default:true]
		 */
		public function get animated():Boolean { return m_animated; }
		
		public function set animated(value:Boolean):void 
		{
			m_animated = value;
			if (!m_animated)
			{
				removeTween();
				setCurrentStatus();
			}
		}
		
		/**
		 * thumbの移動のアニメーション時間を返却します。[default:1(sec)]
		 */
		public function get animationDuration():Number 
		{ 
			return m_animationDuration; 
		}
		
		public function set animationDuration(value:Number):void 
		{
			m_animationDuration = value;
		}
		
		/**
		 * thumbの移動のアニメーションタイプを返却します。[default:Strong.easeOut]
		 */
		public function get easingType():Function { return m_easingType; }
		
		public function set easingType(value:Function):void 
		{
			m_easingType = value;
		}
		
		/**
		 * 値の変化をthumbの移動ごとに送出するかどうかを返却します。[default:true]
		 */
		public function get continues():Boolean { return m_continuos; }
		
		public function set continues(value:Boolean):void 
		{
			m_continuos = value;
		}
		
		/**
		 * このオブジェクトのidを返却します。
		 */
		public function get id():Number { return m_id; }
		
		public function set id(value:Number):void 
		{
			m_id = value;
		}
		
		/**
		 * stageオブジェクトを返却します。
		 */
		public function get stage():Stage 
		{ 
			if (m_stage == null) m_stage = track.stage;
			return m_stage == null?UISlider.stageRef:m_stage;
		}
		
		public function set stage(value:Stage):void 
		{
			m_stage = value;
			UISlider.stageRef = value;
		}
		
		/**
		 * メモリから破棄します。
		 */
		public function dispose():void 
		{
			removeTween();
			stopThumbDrag();
			removeMouseWheelListener();
				
			trackBtnControl.dispose();
			thumbBtnControl.dispose();
		}
		
		/**
		 * 詳細ログを返却します。
		 */
		public function dump():void 
		{
			trace(toString());
			trace("id : " + id);
			trace("value : " + value);
			trace("percent : " + percent);
			trace("minimumValue : " + minimumValue);
			trace("maximumValue : " + maximumValue);
			trace("animated : " + animated);
			trace("animationDuration : " + animationDuration);
			trace("easingType : " + easingType);
			trace("useMouseWheel : " + useMouseWheel);
		}
		
		/**
		 * trackの幅(高さ)、thumbの幅（高さ）を指定して、更新します。
		 * 
		 * @param	trackDist
		 * @param	thumbDist
		 */
		public function updateSize(trackDist:Number, thumbDist:Number):void 
		{
			if (!horizontal) 
			{
				if (autoThumbSize)
				{
					goalThumbDistance = Math.round(Math.max(minimumThumbDistance, thumbDist));
				}
				track.height = Math.round(Math.max(minimumTrackDistance, trackDist));
			}
			else 
			{
				if (autoThumbSize)
				{
					goalThumbDistance = Math.round(Math.max(minimumThumbDistance, thumbDist));
				}
				track.width = Math.round(Math.max(minimumTrackDistance, trackDist));				
			}
			
		
			if ((thumbDistance + goalThumbPosition) > this.trackDistance) 
			{
				if (horizontal)
				{
					thumb.x = goalThumbPosition;
					if (autoThumbSize)
					{
						thumb.width = goalThumbDistance;
					}
				}
				else
				{
					thumb.y = goalThumbPosition;
					if (autoThumbSize)
					{
						thumb.height = goalThumbDistance;
					}
				}
				moveIndicator();
			}

			this.resizing = true;
			this.value = this.value;
			this.resizing = false;
		}
		
		/**
		 * thumbの幅(高さ)を返却します。
		 */
		public function get thumbDistance():Number
		{
			return horizontal?thumb.width:thumb.height;
		}

		public function get trackDistance():Number 
		{
			return horizontal?track.width:track.height;
		}
		
		/**
		 * thumbのx(y)座標を返却します。
		 */
		public function get thumbPosition():Number 
		{
			return horizontal?thumb.x:thumb.y;
		}
		
		/**
		 * trackのマウス位置を返却します。
		 */
		public function get trackMousePosition():Number
		{
			return horizontal?track.mouseX*track.scaleX:track.mouseY*track.scaleY;
		}
		
		/**
		 * thumbにSEを使用するかどうかを返却します。[default:true]
		 */
		public function get useThumbSe():Boolean { return m_useThumbSe; }
		
		public function set useThumbSe(value:Boolean):void 
		{
			m_useThumbSe = value;
			thumbBtnControl.useSe = value;
		}
		
		/**
		 * trackにSEを使用するかどうかを返却します。[default:true]
		 */
		public function get useTrackSe():Boolean { return m_useTrackSe; }
		
		public function set useTrackSe(value:Boolean):void 
		{
			m_useTrackSe = value;
			trackBtnControl.useSe = value;
		}
		
		/**
		 * thumbのUIButtonオブジェクトを返却します。
		 */
		public function get thumbBtnControl():UIButton { return m_thumbBtnControl; }
		
		public function set thumbBtnControl(value:UIButton):void 
		{
			m_thumbBtnControl = value;
		}
		
		/**
		 * trackのUIButtonオブジェクトを返却します。
		 */
		public function get trackBtnControl():UIButton { return m_trackBtnControl; }
		
		public function set trackBtnControl(value:UIButton):void 
		{
			m_trackBtnControl = value;
		}
		
		/**
		 * マウスホイール時にスライドするパーセンを返却します。[default:.2]
		 */
		public function get mouseWheelSlidePercent():Number { return m_mouseWheelSlidePercent; }
		
		public function set mouseWheelSlidePercent(value:Number):void 
		{
			m_mouseWheelSlidePercent = value;
		}
		
		/**
		 * 最小thumb幅(高さ)を返却します。[default:20]
		 */
		public function get minimumThumbDistance():Number { return m_minimumThumbDistance; }
		
		public function set minimumThumbDistance(value:Number):void 
		{
			m_minimumThumbDistance = value;
		}
		
		/**
		 * 最小track幅（高さ）を返却します。[default:100]
		 */
		public function get minimumTrackDistance():Number { return m_minimumTrackDistance; }
		
		public function set minimumTrackDistance(value:Number):void 
		{
			m_minimumTrackDistance = value;
		}
		
		/**
		 * 水平モードかどうかを返却します。[default:false]
		 */
		public function get horizontal():Boolean { return m_horizontal; }
		
		/**
		 * @private
		 */
		public function get goalThumbDistance():Number 
		{ 
			return m_goalThumbDistance; 
		}
		
		public function set goalThumbDistance(value:Number):void 
		{
			m_goalThumbDistance = ((trackDistance-maximumThumbDistanceInset) < value)?(trackDistance-maximumThumbDistanceInset):value;
		}
		
		/**
		 * [default]:20
		 */
		public function get maximumThumbDistanceInset():Number { return m_maximumThumbDistanceInset; }
		
		public function set maximumThumbDistanceInset(value:Number):void 
		{
			m_maximumThumbDistanceInset = value;
		}
		
		/**
		 * trackプレス時の移動距離パーセントを返却します。
		 
		public function get trackSlidePercent():Number { return m_trackSlidePercent; }
		
		public function set trackSlidePercent(value:Number):void 
		{
			m_trackSlidePercent = value;
		}*/
		
		/**
		 * trackプレス時の移動インターバルを返却します。[default:200]
		 */
		public function get trackSlideInterval():Number { return m_trackSlideInterval; }
		
		public function set trackSlideInterval(value:Number):void 
		{
			m_trackSlideInterval = value * 1000;
			trackSlideTimer.delay = trackSlideInterval;
		}
		
		/**
		 * trackプレス時の移動距離を返却します。[default:30]
		 */
		public function get trackSlideValue():Number { return m_trackSlideValue; }
		
		public function set trackSlideValue(value:Number):void 
		{
			m_trackSlideValue = value;
		}
		
		public override function toString():String {
			var s:String = "jp.co.shed.controls.UISlider (";
			s += "value='" + value + "',";
			s += "minimumValue='" + minimumValue + "',";
			s += "maximumValue='" + maximumValue + "') ";
			
			return s;
			
			
		}		
	}
	
}