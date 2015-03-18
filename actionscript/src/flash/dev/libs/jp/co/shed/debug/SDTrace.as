package jp.co.shed.debug 
{
	
	import flash.events.StatusEvent;
	import flash.net.LocalConnection;
	import flash.system.System;
	
	/**
	 * ログを出力するクラス。
	 * 
	 * @author yasunari ishibashi
	 */
	public class SDTrace
	{
		//初期化ブロック
		{
			//LocalConnection接続
			con = new LocalConnection();
			con.addEventListener(StatusEvent.STATUS, function onStatucChanged(e:StatusEvent):void{});			
		}
		
		/*ログを出力するかどうかのフラグ*/
		public static var verbose:Boolean = true;
		
		/*traceを出力するかどうかのフラグ*/
		public static var enabledTrace:Boolean = true;
		
		/*デバッガーを使用するかどうかのフラグ*/
		public static var enabledDebugger:Boolean = true;
		
		private static var con:LocalConnection;
		
		private static var m_timestamp:String;
		
		//private static var _startTime:Number;
		
		/**
		 * 現在時刻を返却します。
		 * 
		 * @return 現在の時刻のストリング。
		 */
		public static function get timestamp():String 
		{
			var date:Date = new Date();
			m_timestamp = date.getFullYear() + "/" + (date.getMonth() + 1) + "/" + date.getDate() + "	" + date.getHours() + ":" + date.getMinutes() + ":" + date.getSeconds() + ":" + String(date.getMilliseconds()).substr(0, 2);
			return m_timestamp + "	";
		}
		
		/**
		 * タイムスタンプとともに、ログを出力します。
		 * 
		 * @param	value 出力する値。
		 * @param	...args
		 */
		public static function dump(value:*, ...args):void 
		{
			if (!verbose) return;
			
			var time:String = timestamp ;
			var i:uint = 0;
			var len:uint = args.length;
			
			if (enabledTrace) 
			{
				trace(time+"	::	" + value);
				for ( i = 0; i < len; i++ )
				{
					trace("" + args[i]);
				}
				
				//trace("");
			}
			if (enabledDebugger) 
			{
				con.send("debugger", "output", null , time+"	::	" + value);

				for ( i = 0; i < len; i++ ) 
				{
					con.send("debugger", "output", null , ">> " + args[i]);
				}
			}
		}	
		
		/**
		 * 現在の使用メモリを出力します。
		 */
		public static function totalMemory():void
		{
			dump("★ TotalMemory : "+System.totalMemory);
		}
		
		/*
		public static function startBenchmark():void {
			//_startTime = new Date().getTime();
		}
		
		public static function endBenchmark():void {
			//trace(new Date().getTime() - _startTime);
		}
		*/
	}
	
}