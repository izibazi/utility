package jp.co.shed.date 
{

	import jp.co.shed.utils.DateUtils;
	import jp.co.shed.utils.NumberUtils;
	
	/**
	 * 日付情報を管理するクラス。
	 * 
	 * @author yasunari ishibashi
	 */
	public class DateItem 
	{
		
		/*詳細ログを出力するかどうかの真偽値 [default:false]*/
		public static var verbose:Boolean = false;
		
		public static const ORDERED_ASCENDING:int = -1;
		
		public static const ORDERED_SAME:int = 0;
		
		public static const ORDERED_DESCENDING:int = 1;
		
		private var m_year:uint;
		
		private var m_month:uint;
		
		private var m_date:uint;
		
		private var m_week:uint;		
		
		private var m_weekLabel:String;
		
		private var m_weekCount:uint;
		
		private var m_monthLabel:String;
		
		private var _info:Date;
		
		private var m_YYYYMMDD:Boolean = true;
		
		private var m_equalLocalTime:Boolean = false;

		/**　日付に紐ずいている情報 */
		public var extra:*;
		
		/**
		 * コンストラクタ
		 * 
		 * @param	year
		 * @param	month
		 * @param	date
		 * @param	YYYYMMDD
		 */
		public function DateItem(year:uint = 0 , month:uint = 0  , date:uint = 0, YYYYMMDD:Boolean = true)
		{
			this.m_YYYYMMDD = YYYYMMDD;
			init(year , month, date);
		}
		
		private function init(year:uint, month:uint , date:uint):void 
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
					_m_date = new Date();
					if(verbose)
						trace("jp.co.shed.date.DateItem :: 指定した日付 : " + year + "/" + month + "/" + date + "は、存在しません。ローカル時間を使用します。");
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
			_info = _m_date;
			m_equalLocalTime = DateUtils.equalLocalTime(m_year, m_month, m_date);
		}	

		private function digit(value:uint , displayDigit:uint):String 
		{
			var _value:String = String(value);
			if (YYYYMMDD)
				_value = NumberUtils.digit(value , displayDigit);

			return _value;
		}
		
		/**
		 * 年を返却します。
		 * (一桁の場合に、0を追加したStringです。)
		 */
		public function get year():String
		{ 
			return  digit(m_year , 2); 
		}
		
		/**
		 * 月を返却します。
		 * (一桁の場合に、0を追加したStringです。)
		 */		
		public function get month():String 
		{ 
			return digit(m_month , 2);
		}
		
		/**
		 * 日を返却します。
		 * (一桁の場合に、0を追加したStringです。)
		 */
		public function get date():String
		{ 
			return digit(m_date , 2);
		}
		
		/**
		 * 曜日を返却します。[min:0 max:6]
		 */
		public function get week():uint { return m_week; }
		
		/**
		 * 曜日名を返却します。
		 */
		public function get weekLabel():String { return m_weekLabel; }
		
		/**
		 * 何週目かを返却します。
		 */
		public function get weekCount():uint { return m_weekCount; }
		
		public function set weekCount(value:uint):void
		{
			m_weekCount = value;
		}
		/**
		 * 月名を返却します。
		 */
		public function get monthLabel():String { return m_monthLabel; }
		
		/**
		 * Dateオブジェクトを返却します。
		 */
		public function get info():Date { return _info; }
		
		/**
		 * 月の値を返却します。
		 */
		public function get monthNum():uint 
		{
			return m_month;
		}
		
		/**
		 * 年の値を返却します。
		 */
		public function get yearNum():uint
		{
			return m_year;
		}
		
		/**
		 * 日の値を返却します。
		 */
		public function get dateNum():uint
		{
			return m_date;
		}
		
		/**
		 * yyyy{delimiter}mm{delimiter}dateの値を返却します。
		 * 
		 * @param	delimiter
		 * @return
		 */
		public function displayDate(delimiter:String = "."):String 
		{
			return year + delimiter + month + delimiter + date;
		}
		
		/**
		 * クラスの完全修飾名を返却します。
		 * 
		 * @return
		 */
		public function toString():String
		{
			var s:String = "jp.co.shed.date.DateItem(";
			s += "year='" + year + "',";
			s += "month='" + month + "',";
			s += "monthLabel='" + monthLabel + "',";
			s += "date='" + date + "',";
			s += "week='" + week + "',";
			s += "weekLabel='" + weekLabel + "',";
			s += "weekCount='" + weekCount + "',";
			s += "equalLocalTime='" + equalLocalTime + "')";

			return s;
		}
		
		/**
		 * ローカル時間の日付と等しいかどうかを返却します。
		 */
		public function get equalLocalTime():Boolean { return m_equalLocalTime; }
		
		/**
		 * YYYYMMDD表示かどうかを返却します。
		 */
		public function get YYYYMMDD():Boolean { return m_YYYYMMDD; }
		
		/**
		 * 比較します。
		 * @param	date1
		 * 
		 * @return ORDERED_ASCENDING(前),ORDERED_SAME(同じ),ORDERED_DESCENDING(後ろ)のいずれかの値を返却します。
		 */
		public function compareDate(date1:DateItem):int {
			
			if (info.getTime() > date1.info.getTime()) 
			{
				return ORDERED_DESCENDING;
			}
			else if 
			(info.getTime() < date1.info.getTime()) 
			{
				return ORDERED_ASCENDING;
			}
			return ORDERED_SAME;
		}
		
		/**
		 * 年月が等しいかどうかを返却します。
		 * 
		 * @param	date1
		 * @param	date2
		 * @return
		 */
		public static function equalMonth(date1:DateItem , date2:DateItem):Boolean
		{
			return date1.yearNum == date2.yearNum && date1.monthNum == date2.monthNum;
		}

		/**
		 * 同じ日かどうかを返却します。
		 * 
		 * @param	date1
		 * @param	date2
		 * @return
		 */
		public static function equalDate(date1:DateItem , date2:DateItem):Boolean 
		{
			return date1.yearNum == date2.yearNum && date1.monthNum == date2.monthNum && date1.dateNum == date2.dateNum;
		}
		
		/**
		 * 指定した値のDateItemオブジェクトを返却します。
		 * 
		 * @param	yyyymmdd
		 * @return
		 */
		public static function getDateItem(yyyymmdd:String):DateItem 
		{
			var yyyy:uint = uint(yyyymmdd.substr(0, 4));
			var mm:uint = uint(yyyymmdd.substr(4, 2));
			var dd:uint = uint(yyyymmdd.substr(6));
			
			return new DateItem(yyyy, mm , dd);
		}
		
	}
	
}