package jp.co.shed.data 
{
	
	/**
	 * ペアを保持するクラス。
	 * 
	 * @author yasunari ishibashi
	 */
	public class Pair 
	{
		
		private var m_first:*;
		
		private var m_second:*;
		
		/**
		 * コンストラクタ。
		 * 
		 * @param	first
		 * @param	second
		 */
		public function Pair(first:*, second:*)
		{
			m_first = first;
			m_second = second;
		}
		
		public function get first():* 
		{ 
			return m_first; 
		}
		
		public function set first(value:*):void 
		{
			m_first = value;
		}
		
		public function get second():* 
		{ 
			return m_second; 
		}
		
		public function set second(value:*):void 
		{
			m_second = value;
		}
		
		public function toString():String
		{
			var s:String = "jp.co.shed.data.Pair(";
			s += "first='" + first +"',";
			s += "second='" + second +"')";
			
			return s;
		}
	}
}