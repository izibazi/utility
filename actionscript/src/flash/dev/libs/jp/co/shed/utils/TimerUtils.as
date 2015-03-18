package jp.co.shed.utils 
{
	import flash.display.Sprite;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	/**
	 * Timerに関するユーティリティクラスです。
	 * 
	 * @author yasunari ishibashi
	 */
	public class TimerUtils 
	{
		
		private static var timers_ary:Array;
		
		private static var len:uint = 0;
		
		/**
		 * 一度だけタイマーを実行し、コールバックします。
		 * 
		 * @param	callBackFunction
		 * @param	callBackScope
		 * @param	delayTime
		 * @param	args
		 */
		public static function delay(callBackFunction:Function , callBackScope:*, delayTime:Number, args:Array = null):void
		{
			if (timers_ary == null)
			{
				timers_ary = [];
			}
			
			var timer:Timer = new Timer(delayTime * 1000, 1);
			var info:TimerInfo = new TimerInfo(timer , callBackScope , callBackFunction,args);
			
			timers_ary.push(info);
			
			len = timers_ary.length;
			
			timer.addEventListener(TimerEvent.TIMER, onTimer);
			timer.start();
		}
		
		private static function onTimer(evt:TimerEvent):void
		{
			var timer:Timer = evt.target as Timer;
			for (var i:uint = 0; i < len; i++ )
			{
				var info:TimerInfo = timers_ary[i];
				if (info.equal(timer)) 
				{
					info.excute();
					info.dispose();
					info = null;
					timers_ary.splice(i, 1);
					return;
				}
			}
			
			trace("TimerUtils.delay : 指定したタイマーが見つかりませんでした。");
		}
	}
}

import flash.utils.Timer;

class TimerInfo 
{
	
	public var timer:Timer;
	public var callBackFunction:Function;
	public var callBackScope:*;
	public var args:Array;
	
	public function TimerInfo(timer:Timer , scope:* , func:Function, args:Array = null) 
	{
		this.timer = timer;
		this.callBackFunction = func;
		this.callBackScope = scope;
		this.args = args;
	}
	
	public function equal(timer:Timer):Boolean
	{
		return this.timer == timer;
	}
	
	public function excute():void 
	{
		this.callBackFunction.apply(this.callBackScope, this.args);
	}
	
	public function dispose():void
	{
		timer = null;
		callBackFunction = null;
		callBackScope = null;
		args = null;
	}
}