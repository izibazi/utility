package jp.co.shed.transitions 
{
	
	import caurina.transitions.Tweener;
	import caurina.transitions.properties.*;
	import flash.display.DisplayObject;
	
	/**
	 * Tweenerライブラリのラッパースタティッククラス。
	 * 
	 * このクラスは、処理落ちが問題となる場合は、使用をお勧めしません。
	 * 
	 * useFrameの切り替えをこのクラスのuseFrameスタティックプロパティで設定でき、usaFrame=trueの場合も
	 * timeは、秒数での指定が可能です。
	 * 
	 * ユーティリティメソッドは下記です。
	 * tween,tweenParam,delay,scale,bright,color,position,rotate,fade,removeメソッドです。
	 * 
	 * @author yasunari ishibashi
	 */
	public class SDTweener
	{

		/*下記、頻繁に使用するTweenerのtransition名。*/
		public static const LINEAR:String = "linear";
		
		public static const O_ELASTIC:String = "easeoutelastic";
		
		public static const O_EASE:String = "easeoutexpo";
		
		public static const O_BOUNCE:String = "easeoutbounce";
		
		public static const O_BACK:String = "easeoutbounce";
		
		public static const I_EASE:String = "easeinexpo";
		
		/*フレームレート*/
		public static var fps:int = 30;
		
		/*frameを使用するかどうかの真偽値*/
		public static var useFrames:Boolean = false;
		
		//スタティック初期化ブロック
		{
			ColorShortcuts.init();
			DisplayShortcuts.init();
			FilterShortcuts.init();
			TextShortcuts.init();		
			CurveModifiers.init();
		}
		
		/**
		 * トゥイーン実行します。
		 * 
		 * @param	p_scopes
		 * @param	time
		 * @param	delay
		 * @param	p_parameters　Tweener.addTweenの第二引数と同値(ただしuseFrames,time,delayの値は、上書きされます。)
		 * 
		 * @return　
		 */
		public static function tween(p_scopes:Object, time:Number = .2, delay:Number = 0, p_parameters:Object = null):Boolean 
		{
			p_parameters = setParams(p_parameters, time, delay);			

			return Tweener.addTween(p_scopes, p_parameters);
		}
		
		
		/**
		 * 指定したパラメーターを、トゥイーン実行します。
		 * 
		 * @param	p_scopes
		 * @param	param
		 * @param	to
		 * @param	time
		 * @param	delay
		 * @param	transition
		 * @param	p_parameters Tweener.addTweenの第二引数と同値(ただしparam,useFrames,time,delayの値は、上書きされます。)
		 * @return
		 */
		public static function tweenParam(p_scopes:Object, param:String, to:Number, time:Number = 0, delay:Number = 0, transition:String = "", p_parameters:Object = null):Boolean 
		{
			p_parameters = setParams(p_parameters,time, delay);

			p_parameters.transition = transition == null?"":transition;
			p_parameters[param] = to;

			return Tweener.addTween(p_scopes, p_parameters);
		}
		
		/**
		 * 遅延時間経過後、メソッドを実行します。
		 * 
		 * @param	p_scopes
		 * @param	func
		 * @param	args
		 * @param	time
		 * @param	count
		 * @return
		 */
		public static function delay(p_scopes:Object, func:Function, args:Array = null, time:Number = 0):Boolean 
		{
			var p_parameters:Object = { };
			p_parameters = setParams(p_parameters, time, 0);
			p_parameters.count = 1;
			p_parameters.onUpdate = func;
			p_parameters.onUpdateParams = args;
			return Tweener.addCaller(p_scopes, p_parameters);
		}
		
		/**
		 * スケールを変更します。
		 * 
		 * @param	p_scopes
		 * @param	from
		 * @param	to
		 * @param	time
		 * @param	delay
		 * @param	transition　トランジション名 default:easeoutElastic
		 * @param	p_parameters　Tweener.addTweenの第二引数と同値(ただしuseFrames,time,delayの値は、上書きされます。)
		 * 
		 * @return　
		 */
		public static function scale(p_scopes:Object, from:Number = NaN, to:Number = 1, time:Number = 0, delay:Number = 0, transition:String = "easeoutElastic", p_parameters:Object = null ):Boolean 
		{
			p_parameters = setParams(p_parameters,time, delay);

			p_parameters.transition = transition == null?O_ELASTIC:transition;
			p_parameters._scale = to;

			if (!isNaN(from))
			{
				p_parameters.onStartParams = [from, p_scopes, p_parameters.onStartParams, p_parameters.onStart];
				p_parameters.onStart = _onScaleStart;
			}
			return Tweener.addTween(p_scopes, p_parameters);
		}
		
		private static function _onScaleStart(from:Number, p_scopes:Object, onStartParams:Array = null, onStart:Function = null):void {
			p_scopes.scaleX = p_scopes.scaleY = from;
			if (onStart != null) 
			{
				onStart.apply(null, onStartParams);
			}
		}
		
		/**
		 *　フェードイン、アウトします。
		 * 
		 * @param	p_scopes
		 * @param	to
		 * @param	time
		 * @param	delay
		 * @param	transition　トランジション名 default:linear
		 * @param	p_parameters　Tweener.addTweenの第二引数と同値(ただしuseFrames,time,delayの値は、上書きされます。)
		 * 
		 * @return　
		 */
		public static function fade(p_scopes:Object, from:Number = NaN, to:Number = 1, time:Number = 0, delay:Number = 0, transition:String = "linear", p_parameters:Object = null ):Boolean 
		{
			p_parameters = setParams(p_parameters,time, delay);

			p_parameters.transition = transition == null?LINEAR:transition;
			p_parameters._autoAlpha = to;
			if (!isNaN(from))
			{
				p_parameters.onStartParams = [from, p_scopes, p_parameters.onStartParams, p_parameters.onStart];
				p_parameters.onStart = _onFadeStart;
			}			
			
			return Tweener.addTween(p_scopes, p_parameters);
		}
	
		
		private static function _onFadeStart(from:Number, p_scopes:Object, onStartParams:Array = null, onStart:Function = null):void 
		{
			p_scopes.alpha = from;
			if (onStart != null)
			{
				onStart.apply(null, onStartParams);
			}
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
		public static function bright(p_scopes:Object, from:Number = 1, to:Number = 0, time:Number = 0, delay:Number = 0, transition:String = "", p_parameters:Object = null ):Boolean
		{
			p_parameters = setParams(p_parameters,time, delay);

			p_parameters.transition = transition == null?O_EASE:transition;
			p_parameters._brightness = to;
			
			if (!isNaN(from))
			{
				p_parameters.onStartParams = [from, p_scopes, p_parameters.onStartParams, p_parameters.onStart];
				p_parameters.onStart = _onBrightStart;
			}			
			
			return Tweener.addTween(p_scopes, p_parameters);
		}
	
		
		private static function _onBrightStart(from:Number, p_scopes:Object, onStartParams:Array = null, onStart:Function = null):void
		{
			p_scopes.visible = true;
			//Tweener.addTween(p_scopes, { _brightness:from } );
			ColorShortcuts._brightness_set(p_scopes, from,[]);
			if (onStart != null) 
			{
				onStart.apply(null, onStartParams);
			}
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
		public static function color(p_scopes:Object, from:Number = NaN, to:Number = 0, time:Number = 0, delay:Number = 0, transition:String = "linear", p_parameters:Object = null ):Boolean 
		{
			p_parameters = setParams(p_parameters,time, delay);

			p_parameters.transition = transition == null?LINEAR:transition;
			p_parameters._color = to;
			if (!isNaN(from))
			{
				p_parameters.onStartParams = [from, p_scopes, p_parameters.onStartParams, p_parameters.onStart];
				p_parameters.onStart = _onColorStart;
			}			
			return Tweener.addTween(p_scopes, p_parameters);
		}
	
		
		private static function _onColorStart(from:Number, p_scopes:Object, onStartParams:Array = null, onStart:Function = null):void 
		{
			p_scopes.visible = true;
			Tweener.addTween(p_scopes, { _color:from } );
			if (onStart != null)
			{
				onStart.apply(null, onStartParams);
			}
		}
		
		/**
		 * 回転します。
		 * 
		 * @param	p_scopes
		 * @param	to
		 * @param	time
		 * @param	delay
		 * @param	transition　トランジション名 default:ealseoutexpo
		 * @param	p_parameters　Tweener.addTweenの第二引数と同値(ただしuseFrames,time,delayの値は、上書きされます。)
		 * 
		 * @return　
		 */
		public static function rotate(p_scopes:Object, from:Number = NaN, to:Number = 0, time:Number = 0, delay:Number = 0, transition:String = "ealseoutexpo", p_parameters:Object = null ):Boolean 
		{
			p_parameters = setParams(p_parameters,time, delay);

			p_parameters.transition = transition == null?O_EASE:transition;
			p_parameters.rotation = to;
			if (!isNaN(from))
			{
				p_parameters.onStartParams = [from, p_scopes, p_parameters.onStartParams, p_parameters.onStart];
				p_parameters.onStart = _onRotateStart;
			}	
			return Tweener.addTween(p_scopes, p_parameters);
		}
		
		private static function _onRotateStart(from:Number, p_scopes:Object, onStartParams:Array = null, onStart:Function = null):void 
		{
			p_scopes.rotation = from;
			if (onStart != null)
			{
				onStart.apply(null, onStartParams);
			}
		}
		
		/**
		 * 座標を移動します。
		 * 
		 * @param	p_scopes
		 * @param	toX
		 * @param	toY
		 * @param	time
		 * @param	delay
		 * @param	transition　トランジション名 default:ealseoutexpo
		 * @param	p_parameters　Tweener.addTweenの第二引数と同値(ただしuseFrames,time,delayの値は、上書きされます。)
		 * 
		 * @return　
		 */
		public static function position(p_scopes:Object, fromX:Number = NaN, fromY:Number = NaN, toX:Number = 0, toY:Number = 0, time:Number = 0, delay:Number = 0, transition:String = "ealseoutexpo", p_parameters:Object = null ):Boolean
		{
			p_parameters = setParams(p_parameters,time, delay);

			p_parameters.transition = transition == null?O_EASE:transition;
			p_parameters.x = toX;
			p_parameters.y = toY;
			
			if (!isNaN(fromX) || !isNaN(fromY)) 
			{
				p_parameters.onStartParams = [fromX,fromY, p_scopes, p_parameters.onStartParams, p_parameters.onStart];
				p_parameters.onStart = _onPositionStart;
			}
			
			return Tweener.addTween(p_scopes, p_parameters);
		}
		
		private static function _onPositionStart(fromX:Number, fromY:Number, p_scopes:Object, onStartParams:Array = null, onStart:Function = null):void 
		{
			if (!isNaN(fromX))
			{
				p_scopes.x = fromX;
			}
			if (!isNaN(fromY))
			{
				p_scopes.y = fromY;
			}
			
			if (onStart != null) 
			{
				onStart.apply(null, onStartParams);
			}
		}
		
		/**
		 * 指定したTweenを停止、削除します。
		 * 
		 * @param	target
		 */
		public static function remove(target:*):void
		{
			if (target is Array)
			{
				var len:uint = target.length;
				for (var i:uint = 0; i < len ; i++ ) 
				{
					Tweener.removeTweens(target[i]);
				}
			}
			else
			{
				Tweener.removeTweens(target);
			}
		}

		/**
		 * @private
		 * 
		 * @param	p_parameters
		 * @param	time
		 * @param	delay
		 * 
		 * @return
		 */
		private static function setParams( p_parameters:Object = null, time:Number = 0, delay:Number = 0):Object 
		{
			if (p_parameters == null) p_parameters = { };
			p_parameters.useFrames = useFrames;
			if (useFrames)
			{
				p_parameters.time = time * fps;
				p_parameters.delay = delay * fps;
			}
			else
			{
				p_parameters.time = time;
				p_parameters.delay = delay;				
			}
			
			return p_parameters;
		}	
		
		/**
		 * Tweener.addTweenを実行します。
		 * 
		 * @param	scopes
		 * @param	parameters
		 * @return
		 */
		public static function addTween(scopes:Object = null, parameters:Object = null):Boolean 
		{
			return Tweener.addTween(scopes, parameters);
		}
		
		/**
		 * Tweener.addCallerを実行します。
		 * 
		 * @param	scopes
		 * @param	parameters
		 * @return
		 */
		public static function addCaller(scopes:Object = null, parameters:Object = null):Boolean 
		{
			return Tweener.addCaller(scopes, parameters);
		}
	}
}