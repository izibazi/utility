package jp.co.shed.date 
{
	
	import jp.co.shed.utils.DateUtils;
	
	/**
	 * ...
	 * @author Shed ishibashi
	 */
	public class CalenderInfo 
	{
		
		private var date_ary:Array;
		
		private var m_dateInfo:DateInfo;
		
		public static var MAX_YEAR:Number = 3000;
		
		public static var MIN_YEAR:Number = 1979;
		
		public static var MAX_YEAR_MONTH:Number = 12;
		
		public static var MIN_YEAR_MONTH:Number = 1;
		
		private var maxDate:Date;
		
		private var minDate:Date;
		

		public function CalenderInfo(year:Number=NaN , month:Number=NaN) 
		{
			setMaxDate(MAX_YEAR, MAX_YEAR_MONTH);
			setMinDate(MIN_YEAR, MIN_YEAR_MONTH);
			
			if (isNaN(year) || isNaN(month)) {
				var todayInfo:TodayInfo = new TodayInfo();
				year = todayInfo.dateInfo.yearNum;
				month = todayInfo.dateInfo.monthNum;
			}			
			setCalenderList(year, month);
		}
		
		public function setMaxDate(year:Number , month:Number):void {
			maxDate = new Date(year , month-1);
		}
		
		public function setMinDate(year:Number , month:Number):void {
			minDate = new Date(year , month-1);
		}
		
		private function overMaxYearMonth(year:Number , month:Number):Boolean {
			var date:Date = new Date(year, month-1);
			var dateSec:Number = date.getTime();
			
			var maxSec:Number = maxDate.getTime();

			return maxSec < dateSec;
		}
		
		private function overMinYearMonth(year:Number , month:Number):Boolean {
			var date:Date = new Date(year, month-1);
			var dateSec:Number = date.getTime();
			
			var minSec:Number = minDate.getTime();
			
			return minSec > dateSec;
			
		}
		
		private function setCalenderList(year:Number, month:Number):void {
			if (overMaxYearMonth(year , month)) {
				year = maxDate.getFullYear();
				month = maxDate.getMonth() + 1;
			}else if (overMinYearMonth(year, month)) {
				year = minDate.getFullYear();
				month = minDate.getMonth() + 1;				
			}
			m_dateInfo = new DateInfo(year , month, 1);
			
			date_ary = [];
			
			var currentWeekCount:Number = 1;
			
			for (var i = 1; i <= 31; i++ ) {
				var existDate:Boolean = DateUtils.existDate(year , month , i);
				if (existDate) {
					var dateInfo:DateInfo = new DateInfo(year , month , i);
					
					dateInfo.weekCount = currentWeekCount;
					if (dateInfo.week == 6) {
						currentWeekCount++;
					}
					
					date_ary.push(dateInfo);
					
					//dateInfo.dump();
				}else {
					break;
				}
			}
		}
		
		public function get dateInfo():DateInfo { 
			return m_dateInfo; 
		}
		
		public function get isNext():Boolean {			
			var month:Number = dateInfo.monthNum;
			var year:Number = dateInfo.yearNum;
			
			if (month == 12) {
				month = 1;
				year++;
			}else {
				month++;
			}
			
			return !overMaxYearMonth(year , month);
		}
		
		public function get isPrev():Boolean {
			var month:Number = dateInfo.monthNum;
			var year:Number = dateInfo.yearNum;
			
			if (month == 1) {
				month = 12;
				year--;
			}
			
			return !overMinYearMonth(year , month);
		}

		public function get dateList():Array { 
			return date_ary; 
		}
		
		public function get totalDate():Number {
			return date_ary.length;
		}
		
		public function get lastDateInfo():DateInfo {
			return date_ary[totalDate - 1];
		}
		
		public function get totalWeek():Number {
			return date_ary[totalDate - 1].weekCount;
		}
		
		public function next():void {
			var month:Number = dateInfo.monthNum;
			var year:Number = dateInfo.yearNum;
			if (month >= 12) {
				month = 1;
				year++;
			}else {
				month++;
			}
			setCalenderList(year , month);
		}
		
		public function prev():void {
			var month:Number = dateInfo.monthNum;
			var year:Number = dateInfo.yearNum;
			if (month <= 1) {
				month = 12;
				year--;
			}else {
				month--;
			}

			setCalenderList(year , month);
		}
		
		public function dump():void {
			trace("year : " + dateInfo.year);
			trace("month : " + dateInfo.month);
			trace("totalWeek : " + totalWeek);
			trace("totalDate : " + totalDate);
		}
		
	}
	
}