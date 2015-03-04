package jp.co.shed.display
{
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import jp.co.shed.transitions.SDTweener;

	import jp.co.shed.data.ConfigData;	
	import jp.co.shed.events.StageRefEvent;
	import jp.co.shed.reference.StageRef;
	
	/**
	 * Shedライブラリを使用したムービークリップのサブクラス。
	 * 
	 * @author yasunari ishibashi
	 */
	public class SDSprite extends Sprite
	{

		private var m_resizing:Boolean = false;
		
		/*StageRefオブジェクト*/
		public var stageRef:StageRef;
		
		/*ConfigDataオブジェクト*/
		public var configData:ConfigData;

		/**
		 * コンストラクタ
		 */
		public function SDSprite(...args)
		{
			visible = false;
			
			stageRef = StageRef.getInstance();
			configData = ConfigData.getInstance();
			
			addEventListener(Event.ADDED_TO_STAGE , addedToStage);
			addEventListener(Event.REMOVED_FROM_STAGE , removedFromStage);
		}
		
		/**
		 * 表示します。
		 * 
		 * @param	...args
		 */
		public function show(...args):void 
		{
			visible = true;
		}
		
		/**
		 * 非表示にします。
		 * @param	...args
		 */
		public function hide(...args):void 
		{
			visible = false;
		}

		/**
		 * 指定したtargetのvisibleプロパティをtrue,alphaプロパティを1に設定し、表示にします。
		 * 
		 * @param	target DisplayObjectもしくは、その配列
		 */
		public function showAt(target:*):void
		{
			removeTweens(target);
			if (target is Array) 
			{
				var len:uint = target.length;
				for (var i:uint = 0; i < len; i++ ) 
				{
					target[i].visible = true;
					target[i].alpha = 1;
				}
			}
			else
			{
				target.visible = true;
				target.alpha = 1;
			}
		}
		
		/**
		 * 指定したtargetのvisibleプロパティをfalse,alphaプロパティを設定し、非表示にします。
		 * 
		 * @param	target DisplayObjectもしくは、その配列
		 * @param	alphaValue	default:0
		 */
		public function hideAt(target:*, alphaValue:Number = 0):void 
		{
			removeTweens(target);
			if (target is Array)
			{
				var len:uint = target.length;
				for (var i:uint = 0; i < len; i++ )
				{
					target[i].visible = false;
					target[i].alpha = alphaValue;
				}
			}
			else 
			{
				target.visible = false;
				target.alpha = alphaValue;
			}
		}
		/**
		 * 指定したtargetのscaleX,scaleYプロパティを設定します。
		 * 
		 * @param	target DisplayObjectもしくは、その配列
		 */
		public function scaleAt(target:*, value:Number = 0):void 
		{
			removeTweens(target);
			if (target is Array) 
			{
				var len:uint = target.length;
				for (var i:uint = 0; i < len; i++ )
				{
					target[i].scaleX =
					target[i].scaleY = value;
				}
			}
			else
			{
				target.scaleX =
				target.scaleY = value;
			}
		}

		protected function addedToStage(evt:Event = null):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE , addedToStage);
		}
		
		protected function removedFromStage(evt:Event = null):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE , addedToStage);
			removeEventListener(Event.REMOVED_FROM_STAGE , removedFromStage);
			stageRef.removeEventListener(StageRefEvent.RESIZE, resizedStage);
		}
		
		/**
		 * サブクラスが必要に応じてオーバーライドします。
		 * 
		 * @param	evt
		 */
		protected function resizedStage(evt:StageRefEvent = null):void
		{ 
		
		}
		
		/**
		 * StageRefEvent.RESIZEイベントを受け取るかどうかを返却します。
		 * 
		 * @return StageRefEvent.RESIZEイベントを受け取るかどうかの真偽値。
		 */
		public function get resizing():Boolean 
		{ 
			return m_resizing; 
		}
		
		public function set resizing(value:Boolean):void 
		{
			if (m_resizing == value) return;
			
			m_resizing = value;
			
			if (m_resizing)
			{
				stageRef.addEventListener(StageRefEvent.RESIZE, resizedStage);
				resizedStage(new StageRefEvent(StageRefEvent.RESIZE , stageRef));
			}
			else
			{
				stageRef.removeEventListener(StageRefEvent.RESIZE, resizedStage);
			}
		}

		/**
		 * 遅延時間経過後、指定したメソッドを一回実行します。
		 * 
		 * @param	p_scopes
		 * @param	func
		 * @param	args
		 * @param	time
		 * @return
		 */
		public function delay(p_scopes:Object, func:Function, args:Array = null, time:Number = .2):Boolean 
		{
			return SDTweener.delay(p_scopes, func, args, time);
		}
		
		/**
		 * トゥイーンを実行します。
		 * 
		 * @param	p_scopes
		 * @param	time
		 * @param	delay
		 * @param	p_parameters
		 * @return
		 */
		public function tween(p_scopes:Object, time:Number = 0, delay:Number = 0, p_parameters:Object = null):Boolean 
		{
			return SDTweener.tween(p_scopes, time, delay, p_parameters);
		}
		
		/**
		 * 指定したパラメータをトゥイーンします。
		 * 
		 * @param	p_scopes
		 * @param	param
		 * @param	to
		 * @param	time
		 * @param	delay
		 * @param	transition
		 * @param	p_parameters
		 * @return
		 */
		public function tweenParam(p_scopes:Object, param:String, to:Number, time:Number = 0, delay:Number = 0, transition:String = "", p_parameters:Object = null):Boolean 
		{
			return SDTweener.tweenParam(p_scopes, param, to, time, delay,transition, p_parameters);
		}
		
		/**
		 * 座標を変更します。
		 * 
		 * @param	p_scopes
		 * @param	fromX
		 * @param	fromY
		 * @param	toX
		 * @param	toY
		 * @param	time
		 * @param	delay
		 * @param	transition
		 * @param	p_parameters
		 * @return
		 */
		public function position(p_scopes:Object, fromX:Number = NaN, fromY:Number = NaN, toX:Number = 0, toY:Number = 0, time:Number = 0, delay:Number = 0, transition:String = "ealseoutexpo", p_parameters:Object = null ):Boolean
		{
			return SDTweener.position(p_scopes, fromX, fromY, toX, toY, time, delay, transition, p_parameters);
		}
		
		/**
		 * フェードします。
		 * 
		 * @param	p_scopes
		 * @param	from
		 * @param	to
		 * @param	time
		 * @param	delay
		 * @param	transition
		 * @param	p_parameters
		 * @return
		 */
		public function fade(p_scopes:Object, from:Number = NaN, to:Number = 1, time:Number = 0, delay:Number = 0, transition:String = "linear", p_parameters:Object = null ):Boolean 
		{
			return SDTweener.fade(p_scopes, from, to, time, delay, transition, p_parameters);
		}
		
		/**
		 * 明るさを変更します。
		 * 
		 * @param	p_scopes
		 * @param	from
		 * @param	to
		 * @param	time
		 * @param	delay
		 * @param	transition
		 * @param	p_parameters
		 * @return
		 */
		public function bright(p_scopes:Object, from:Number = 1, to:Number = 0, time:Number = 1, delay:Number = 0, transition:String = "", p_parameters:Object = null ):Boolean 
		{
			return SDTweener.bright(p_scopes, from, to, time, delay, transition, p_parameters);
		}	
		
		/**
		 * 色を変更します。
		 * 
		 * @param	p_scopes
		 * @param	from
		 * @param	to
		 * @param	time
		 * @param	delay
		 * @param	transition
		 * @param	p_parameters
		 * @return
		 */
		public function color(p_scopes:Object, from:Number = NaN, to:Number = 0, time:Number = 0, delay:Number = 0, transition:String = "linear", p_parameters:Object = null ):Boolean 
		{
			return SDTweener.color(p_scopes, from, to, time, delay, transition, p_parameters);
		}	
		
		/**
		 * スケールを変更します。
		 * 
		 * @param	p_scopes
		 * @param	from
		 * @param	to
		 * @param	time
		 * @param	delay
		 * @param	transition
		 * @param	p_parameters
		 * @return
		 */
		public function scale(p_scopes:Object, from:Number = NaN, to:Number = 1, time:Number = .7, delay:Number = 0, transition:String = "easeoutElastic", p_parameters:Object = null ):Boolean 
		{
			return SDTweener.scale(p_scopes, from, to, time, delay, transition, p_parameters );
		}
		
		/**
		 * 回転します。
		 * 
		 * @param	p_scopes
		 * @param	from
		 * @param	to
		 * @param	time
		 * @param	delay
		 * @param	transition
		 * @param	p_parameters
		 * @return
		 */
		public function rotate(p_scopes:Object, from:Number = NaN, to:Number = 0, time:Number = .2, delay:Number = 0, transition:String = "ealseoutexpo", p_parameters:Object = null):Boolean 
		{
			return SDTweener.rotate(p_scopes, from, to, time, delay, transition, p_parameters);
		}
		
		/**
		 * tweenを停止します。
		 * 
		 * @param	target
		 */
		public function removeTweens(target:*):void
		{
			SDTweener.remove(target);
		}
	}
	
}