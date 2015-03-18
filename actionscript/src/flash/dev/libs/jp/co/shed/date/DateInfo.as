package jp.co.shed.date 
{
	import jp.co.shed.utils.DateUtils;
	import jp.co.shed.utils.NumberUtils;
	
	/**
	 * 日付情報を管理します。
	 * 
	 * @author Shed ishibashi
	 */
	public class DateInfo 
	{
		private var m_year:Number;
		private var m_month:Number;
		private var m_date:Number;
		
		private var m_week:Number;		
		private var m_weekLabel:String;
		private var m_weekCount:Number;
		
		private var m_monthLabel:String;
		
		private var m_info:Date;
		
		private var m_YYYYMMDD:Boolean = true;
		
		private var m_isToday:Boolean = false;

		/**
		 * コンストラクタ
		 * @param	year
		 * @param	month
		 * @param	date
		 */
		public function DateInfo(year:Number = NaN, month:Number = NaN , date:Number = NaN)
		{
			init(year , month, date);
		}
		
		private function init(year:Number = NaN, month:Number = NaN , date:Number = NaN)
		{
			var _m_date:Date;
			
			if (isNaN(year) || isNaN(month) || isNaN(date))
			{
				_m_date = new Date();
			}
			else
			{
				if (!DateUtils.existDate(year, month, date)) 
				{
					//throw new Error(toString() + "指定した日付は存在しません。");
				}
				else
				{
			
					_m_date = new Date(year , month - 1 , date);
				}
				
			}
			
			m_year = _m_date.getFullYear();
				
			m_month = _m_date.getMonth()+1;
			m_monthLabel = DateUtils.monthLabels[_m_date.getMonth()];
				
			m_date = _m_date.getDate();
				
			m_week = _m_date.getDay();
			m_weekLabel = DateUtils.weekLabels[week];	
			
			this.info = _m_date;
			
			//m_isToday = DateUtils.isToday(m_year, m_month, m_date);
		}

		/**
		 * 詳細を出力します。
		 */
		public function dump():void 
		{
			trace(toString());
			trace("year : " + year);
			trace("month : " + month);
			trace("monthLabel : " + monthLabel);
			trace("date : " + date);
			trace("week : " + week);
			trace("weekLabel : " + weekLabel);
			trace("weekCount : " + weekCount);
			trace("isToday? : " + isToday);
		}
		
		public function toString():String 
		{
			return "jp.co.shed.date.DateInfo";
		}	
		
		public function get year():String 
		{ 
			return  digit(m_year , 2); 
		}
		
		public function get month():String 
		{ 
			return digit(m_month , 2);
		}
		
		public function get date():String
		{ 
			return digit(m_date , 2);
		}
		
		public function get week():Number { return m_week; }
		
		public function get weekLabel():String { return m_weekLabel; }
		
		public function set weekLabel(value:String):void 
		{
			m_weekLabel = value;
		}
		
		public function get weekCount():Number { return m_weekCount; }
		
		public function set weekCount(value:Number):void 
		{
			m_weekCount = value;
		}
		
		public function get monthLabel():String { return m_monthLabel; }
		
		public function set monthLabel(value:String):void 
		{
			m_monthLabel = value;
		}
		
		public function get info():Date { return m_info; }
		
		public function set info(value:Date):void 
		{
			m_info = value;
		}
		
		public function get YYYYMMDD():Boolean { return m_YYYYMMDD; }
		
		public function set YYYYMMDD(value:Boolean):void 
		{
			m_YYYYMMDD = value;
		}
		
		public function digit(value:Number , displayDigit:Number):String
		{
			var _value:String = String(value);
			if (YYYYMMDD) 
			{
				_value = NumberUtils.digit(value , displayDigit);
			}
			
			return _value;
		}
		
		public function get monthNum():Number 
		{
			return m_month;
		}
		
		public function get yearNum():Number
		{
			return m_year;
		}
		
		public function get dateNum():Number
		{
			return m_date;
		}
		
		public function get isToday():Boolean { return m_isToday; }
		
		public static function equalMonth(date1:DateInfo , date2:DateInfo):Boolean 
		{
			return date1.yearNum == date2.yearNum && date1.monthNum == date2.monthNum;
		}

		public static function equalToday(date1:DateInfo , date2:DateInfo):Boolean 
		{
			return date1.yearNum == date2.yearNum && date1.monthNum == date2.monthNum && date1.dateNum == date2.dateNum;
		}
		
		public static function getDateInfo(yyyymmdd:String):DateInfo
		{
			var yyyy:Number = Number(yyyymmdd.substr(0, 4));
			var mm:Number = Number(yyyymmdd.substr(4, 2));
			var dd:Number = Number(yyyymmdd.substr(6));
			
			return new DateInfo(yyyy, mm , dd);
		}
		
		public function displayDate(delimiter:String = "."):String
		{
			return year + delimiter + month + delimiter + date;
		}
		
	}
	
}