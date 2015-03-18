package jp.co.shed.date {
	
	/**
	 * カレンダーの情報を管理するクラス。
	 * 
	 * @author yasunari ishibashi
	 */
	public class Calender
	{
		
		/*有効な最大の年*/
		private var m_maxYear:uint = 3000;
		
		/*有効な最小の年*/
		private var m_minYear:uint = 1979;
		
		/*有効な最大の年の最大の月*/
		private var m_maxYearMonth:uint = 12;
		
		/*有効な最小の年の最小の月*/
		private var m_minYearMonth:uint = 1;
		
		private var date_ary:Array;

		private var maxDate:Date;
		
		private var minDate:Date;
		
		private const MAX_DATE:uint = 31;
		
		private const MAX_WEEK:uint = 6;
		
		/**　カレンダーに紐ずいている情報 */
		public var extra:*;
		
		/**
		 * コンストラクタ。
		 * 
		 * @param	year	開始の年
		 * @param	month	開始の月
		 * @param	minYear	最小の年	[default:1979]
		 * @param	minYearMonth	最小の年の最小の月	[default:1]
		 * @param	maxYear	最大の年	[default:3000]
		 * @param	maxYearMonth	最大の年の最大の月 [default:12]
		 */
		public function Calender(year:Number , month:Number, minYear:uint = 1979, minYearMonth:uint = 1, maxYear:uint = 3000, maxYearMonth:uint = 12) 
		{
			m_maxYear = maxYear;
			m_minYear = minYear;
			m_maxYearMonth = maxYearMonth;
			m_minYearMonth = minYearMonth;
			
			maxDate = new Date(m_maxYear , m_maxYearMonth - 1);
			minDate = new Date(m_minYear , m_minYearMonth - 1);
		
			setCalender(year, month);
		}

		private function setCalender(year:uint, month:uint):void 
		{
			//最大年月を超えている場合は、最大年月を使用。
			if (overMaxYearMonth(year , month)) {
				year = maxDate.getFullYear();
				month = maxDate.getMonth() + 1;
			//最小年月より以前の場合は、最小年月を使用。
			}else if (overMinYearMonth(year, month)) {
				year = minDate.getFullYear();
				month = minDate.getMonth() + 1;				
			}
			
			date_ary = [];
			
			var currentWeekCount:Number = 1;
			
			for (var i:uint = 1; i <= MAX_DATE; i++ )
			{
				//指定した日が存在するかどうかの真偽値
				var existDate:Boolean = existDate(year , month , i);
				if (existDate) 
				{
					var dateItem:DateItem = new DateItem(year , month , i);
					//第何周目かの値
					dateItem.weekCount = currentWeekCount;
					if (dateItem.week == MAX_WEEK) 
					{
						currentWeekCount++;
					}
					date_ary.push(dateItem);
				}else {
					//存在しない場合ときは、終了。
					break;
				}
			}
		}
		
		/**
		 * 指定した年月が、最大の有効年月を超えているかどうかを返却します。
		 * 
		 * @param	year
		 * @param	month
		 * @return
		 */
		public function overMaxYearMonth(year:uint , month:uint):Boolean
		{
			return maxDate.getTime() < new Date(year, month - 1).getTime();
		}
		
		/**
		 * 指定した月が、最小の有効年月よりも以前かどうかを返却します。
		 * 
		 * @param	year
		 * @param	month
		 * @return
		 */
		public function overMinYearMonth(year:uint , month:uint):Boolean 
		{
			return minDate.getTime() > new Date(year, month-1).getTime();
		}
		
		/**
		 * 指定した年月が有効かどうかを返却します。
		 * @param	year
		 * @param	month
		 * @return
		 */
		public function valideYearMonth(year:uint, month:uint):Boolean
		{
			return !(overMaxYearMonth(year, month)) && !(overMinYearMonth(year, month));
		}

		/**
		 * 次の年月が有効化どうかを返却します。
		 */
		public function get validNext():Boolean 
		{			
			var month:Number = fistDateItem.monthNum;
			var year:Number = fistDateItem.yearNum;
			
			if (month == 12)
			{
				month = 1;
				year++;
			}
			else
			{
				month++;
			}
			
			return !overMaxYearMonth(year , month);
		}
		
		/**
		 * 前の月が有効化どうかを返却します。
		 */
		public function get validPrev():Boolean
		{
			var month:Number = fistDateItem.monthNum;
			var year:Number = fistDateItem.yearNum;
			
			if (month == 1)
			{
				month = 12;
				year--;
			}
			else
			{
				month--;
			}
			
			return !overMinYearMonth(year , month);
		}

		/**
		 * この年月のDateItemオブジェクトを格納した配列を返却します。
		 */
		public function get dateList():Array
		{ 
			return date_ary; 
		}
		
		/**
		 * この年月の最終日の日付を返却します。
		 */
		public function get totalDate():uint
		{
			return date_ary.length;
		}
		
		/**
		 * この年月の最終日のDateItemオブジェクトを返却します。
		 */
		public function get lastDateItem():DateItem
		{
			return date_ary[totalDate - 1];
		}
		
		/**
		 * この年月の最大週を返却します。
		 */
		public function get totalWeek():uint
		{
			return date_ary[totalDate - 1].weekCount;
		}
		
		/**
		 * 有効な最大の年を返却します。
		 */
		public function get maxYear():uint { return m_maxYear; }
		
		/**
		 * 有効な最小の年を返却します。
		 */
		public function get minYear():uint { return m_minYear; }
		
		/**
		 * 有効な最大の年の最大の月を返却します。
		 */
		public function get maxYearMonth():uint { return m_maxYearMonth; }
		
		/**
		 * 有効な最小の年の最小の月を返却します。
		 */
		public function get minYearMonth():uint { return m_minYearMonth; }
		
		/**
		 * 初日のDateItemオブジェクトを返却します。
		 */
		public function get fistDateItem():DateItem { return date_ary[0]; }
		
		/**
		 * 月の値を返却します。
		 */
		public function get monthNum():uint 
		{
			return fistDateItem.monthNum;
		}
		
		/**
		 * 年の値を返却します。
		 */
		public function get yearNum():uint 
		{
			return fistDateItem.yearNum;
		}
		
		/**
		 * 次の月のカレンダーを設定します。
		 * 存在しない場合は、最大年月を設定します。
		 */
		public function next():void 
		{
			var month:Number = fistDateItem.monthNum;
			var year:Number = fistDateItem.yearNum;

			if (++month > 12) {
				month = 1;
				year++;
			}
			setCalender(year , month);
		}
		
		/**
		 * 前の月のカレンダーを設定します。
		 * 存在しない場合は、最小年月を設定します。
		 */
		public function prev():void 
		{
			var month:Number = fistDateItem.monthNum;
			var year:Number = fistDateItem.yearNum;

			if (--month < 1)
			{
				month = 12;
				year--;
			}

			setCalender(year , month);
		}
		
		/**
		 * 指定した日が存在するかどうかを返却します。
		 * 
		 * @param	year
		 * @param	month
		 * @param	date
		 * @return
		 */
		public static function existDate(year:uint , month:uint , date:uint):Boolean 
		{
			var _date:Date = new Date(year , month - 1, date);	
			if (_date.getFullYear() != year)
				return false;

			if (_date.getMonth() != (month-1))
				return false;

			if (_date.getDate() != date)
				return false;
			
			return true;			
		}
		
		/**
		 * 指定したDateItemオブジェクトの次の日のDateItemオブジェクトを返却します。
		 * 
		 * @param	dateItem
		 * @return
		 */
		public static function nextDateItem(dateItem:DateItem):DateItem
		{
			var time:Number = dateItem.info.getTime();
			time += 24 * 60 * 60 * 1000;
			var date:Date = new Date();
			date.setTime(time);

			return new DateItem(date.getFullYear(), date.getMonth() + 1, date.getDate());
		}
		
		/**
		 * 指定したDateItemオブジェクトの前の日のDateItemオブジェクトを返却します。
		 * 
		 * @param	dateItem
		 * @return
		 */		
		public static function prevDateItem(dateItem:DateItem):DateItem
		{
			var time:Number = dateItem.info.getTime();
			time -= 24 * 60 * 60 * 1000;
			var date:Date = new Date();
			date.setTime(time);

			return new DateItem(date.getFullYear(), date.getMonth() + 1, date.getDate());			
		}
		
		/**
		 * 二つの日付の日数を返却します。
		 * 
		 * @param	dateItem_1
		 * @param	dateItem_2
		 * @return
		 */
		public static function duration(dateItem_1:DateItem, dateItem_2:DateItem):int
		{
			return (dateItem_1.info.getTime() - dateItem_2.info.getTime()) / (24 * 60 * 60 * 1000);
		}
		
		/**
		 * クラスの完全修飾名を返却します。
		 * 
		 * @return
		 */
		public function toString():String 
		{
			var s:String = "jp.co.shed.date.Calender(";
			s += "year='" + fistDateItem.year + "',";
			s += "month='" + fistDateItem.month + "',";
			s += "totalWeek='" + totalWeek + "',";
			s += "totalDate='" + totalDate + "',";
			s += "minYear='" + minYear + "',";
			s += "minYearMonth='" + minYearMonth + "',";
			s += "maxYear='" + maxYear + "',";
			s += "maxYearMonth='" + maxYearMonth + "')";
			
			return s;
		}
		
	}
	
}