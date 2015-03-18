package jp.co.shed.utils{

	/**
	 * Dateオブジェクトのユーティリティクラス。
	 * 
	 * @author yasunari ishibashi
	 */
	public class DateUtils
	{
		/*月名のラベルリスト*/
		public static const monthLabels:Array = ["January",
                  "February",
                  "March",
                  "April",
                  "May",
                  "June",
                  "July",
                  "August",
                  "September",
                  "October",
                  "November",
                  "December"];
				  
		/* 週名のラベルリスト(英語)*/
		public static const weekLabels:Array = ["Sunday",
                    "Monday",
                    "Tuesday",
                    "Wednesday",
                    "Thursday",
                    "Friday",
                    "Saturday"];
				  
		/*週名のラベルリスト(日本語)*/
		public static const weekJaLabels:Array = ["日",
                    "月",
                    "火",
                    "水",
                    "木",
                    "金",
                    "土"];
					

		/**
		 * 時間に対するあらゆる情報を返却します。
		 * 要修正。
		 * 
		 * @return 
		 */		
		public static function get detailInfo():Object
		{
			var date:Date=new Date();
			var info:Object={};
			
			info.fullYear=String(date.getFullYear());

			info.month=String(date.getMonth()+1);
			info.date=String(date.getDate());
			info.day=String(date.getDay());
			
			info.hour=String(date.getHours());
			info.minute=String(date.getMinutes());
			info.second=String(date.getSeconds());

			if (info.fullYear.length == 4)
			{
				info.year_4=info.fullYear.substr(0,1);
				info.year_3=info.fullYear.substr(1,1);
				info.year_2=info.fullYear.substr(2,1);
				info.year_1=info.fullYear.substr(3);
			}
			else if (info.fullYear.length == 3)
			{
				info.year_4="0"
				info.year_3=info.fullYear.substr(0,1);
				info.year_2=info.fullYear.substr(1,1);
				info.year_1=info.fullYear.substr(2);
			}
			else if (info.fullYear.length == 2)
			{
				info.year_4="0"
				info.year_3="0"
				info.year_2=info.fullYear.substr(0,1);
				info.year_1=info.fullYear.substr(1);
			}
			else
			{
				info.year_4="0"
				info.year_3="0"
				info.year_2="0"
				info.year_1=info.fullYear;			
			}

			if (info.date.length == 1)
			{
				info.date_2="0";
				info.date_1=info.date;
			}
			else
			{
				info.date_2=info.date.substr(0,1);
				info.date_1=info.date.substr(1);				
			}
						
			if (info.month.length == 1)
			{
				info.month_2="0";
				info.month_1=info.month;
			}
			else
			{
				info.month_2=info.month.substr(0,1);
				info.month_1=info.month.substr(1);				
			}
			
			if (info.hour.length == 1)
			{
				info.hour_2="0";
				info.hour_1=info.hour;
			}
			else
			{
				info.hour_2=info.hour.substr(0,1);
				info.hour_1=info.hour.substr(1);				
			}
			
			if (info.minute.length == 1)
			{
				info.minute_2="0";
				info.minute_1=info.minute;
			}
			else
			{
				info.minute_2=info.minute.substr(0,1);
				info.minute_1=info.minute.substr(1);				
			}
			
			if (info.second.length == 1)
			{
				info.second_2="0";
				info.second_1=info.second;
			}
			else
			{
				info.second_2=info.second.substr(0,1);
				info.second_1=info.second.substr(1);				
			}
			
			return info;
		}
		
		/**
		 * 指定した日付が存在するかどうかを返却します。
		 * 
		 * @param	year
		 * @param	month
		 * @param	date
		 * @return
		 */
		public static function existDate(year:uint , month:uint , date:uint):Boolean 
		{
			var _date:Date = new Date(year , month-1, date);			
			if (_date.getFullYear() != year)
				return false;

			if (_date.getMonth() != (month-1))
				return false;

			if (_date.getDate() != date)
				return false;
			
			return true;
		}
		
		/**
		 * ローカルマシンの日付と指定した日付が等しいかどうかを返却します。
		 * 
		 * @param	year
		 * @param	month
		 * @param	date
		 * @return
		 */
		public static function equalLocalTime(year:uint , month:uint, date:uint):Boolean
		{
			var _date:Date = new Date();
			
			if (_date.getFullYear() != year)
			{
				return false;
			}
			if (_date.getMonth() != (month - 1))
			{
				return false;
			}
			if (_date.getDate() != date) 
			{
				return false;
			}
			
			return true;
		}
		
		/**
		 * 経過日を返却します。
		 * 
		 * @param	startDate
		 * @param	currentDate
		 * @return
		 */
		public static function passageDay(startDate:Date , currentDate:Date):int 
		{
			var def:Number = currentDate.getTime() - startDate.getTime();
			def = def / (24 * 60 * 60 * 1000);
			return Math.floor(def);
		}
		
		/**
		 * {startYear}/{startMonth}の月から
		 * {endYear}/{endMonth}までの{year:value , month:value}オブジェクトの配列を返却します。
		 * 
		 * @param	startYear
		 * @param	startMonth
		 * @param	endYear
		 * @param	endMonth
		 * @return
		 */
		public static function getMonthlyList(startYear:uint, startMonth:uint, endYear:uint, endMonth:int ):Array
		{
			var ary:Array = [];
			var max:int = 12;
			var month:int = 1;
			
			for (var i:uint = startYear; i <= endYear; i++ )
			{
				month = 1;
				if (i == startYear)month = startMonth;
				if (i == endYear) max = endMonth;
				
				while (month <= max)
				{
					ary.push( { year:i, month:month } );
					month++;
				}	
			}
			
			return ary;
		}

	}

}