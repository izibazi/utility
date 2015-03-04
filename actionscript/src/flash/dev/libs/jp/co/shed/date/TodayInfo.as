package jp.co.shed.date 
{

	import jp.co.shed.utils.NumberUtils;
	
	/**
	 * 今の時間を保持します。
	 * 
	 * @author Shed ishibashi
	 */
	public class TodayInfo 
	{
		
		private var m_dateInfo:DateInfo;
		
		private var m_hour:Number;
		
		private var m_min:Number;
		
		private var m_sec:Number;
		
		private var m_millisec:Number;
		
		private var m_HHMMSS:Boolean = true;
		
		private var m_ampm:String;
		
		public function TodayInfo() 
		{
			init();
		}
		
		private function init():void 
		{
			m_dateInfo = new DateInfo();
			m_dateInfo.YYYYMMDD = HHMMSS;
			
			var info:Date = dateInfo.info;
			m_hour = info.getHours();
			m_min = info.getMinutes();
			m_sec = info.getSeconds();
			m_millisec = info.getMilliseconds();
			
			m_ampm = (m_hour >= 0 && m_hour < 12)?"AM":"PM";
		}
		
		public function get dateInfo():DateInfo { return m_dateInfo; }
		
		public function get hour():String 
		{ 			
			return digit(m_hour , 2); 
		}
		
		public function get min():String
		{ 
			return digit(m_min , 2);
		}
		
		public function get sec():String 
		{ 
			return digit(m_sec , 2);; 
		}
		
		public function get millisec():String 
		{ 
			return digit(m_millisec , 4);
		}
		
		public function get HHMMSS():Boolean { return m_HHMMSS; }
		
		public function set HHMMSS(value:Boolean):void 
		{
			m_HHMMSS = value;
			if (m_dateInfo != null)
			{
				m_dateInfo.YYYYMMDD = value;
			}
		}
		
		public function get ampm():String { return m_ampm; }
		
		public function digit(value:Number , displayDigit:Number):String 
		{
			var _value:String = String(value);
			if (HHMMSS) 
			{
				_value = NumberUtils.digit(value , displayDigit);
			}
			
			return _value;
		}
		
		public function get hourNum():Number
		{
			return m_hour;
		}
		
		public function get minNum():Number 
		{
			return m_min;
		}
		
		public function get secNum():Number
		{
			return m_sec;
		}
		
		public function get millisecNum():Number
		{
			return m_millisec;
		}
	}
	
}