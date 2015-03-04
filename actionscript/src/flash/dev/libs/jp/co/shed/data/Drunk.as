package jp.co.shed.data 
{
	
	/**
	 * 酔っ払いの千鳥足のようなランダムな値を返却するクラス。
	 * 
	 * max/mspのdrunkオブジェクトのような機能をします。
	 * 
	 * @author yasunari ishibashi
	 */
	public class Drunk 
	{
		private var m_range:Number = 2;
		
		private var m_maxValue:Number = 100;
		
		private var m_minValue:Number = 0;
		
		private var m_value:Number;
		
		/**
		 * コンストラクタ。
		 * 
		 * @param	minValue
		 * @param	maxValue
		 * @param	range
		 */
		public function Drunk(minValue:Number = 0 , maxValue:Number = 100 , range:Number = 2) 
		{
			this.range = range;
			if (range < 0) {
				range *= -1;
			}
			if (range == 0) {
				range = 2;
			}
			this.maxValue = Math.max(minValue,maxValue);
			this.minValue = Math.min(minValue,maxValue);

			m_value = Math.random() * (this.maxValue - this.minValue) + this.minValue;
		}
		
		public function get value():Number 
		{
			var temp:Number = 0;
			var r:Number = Math.random() * range;
			r *= Math.random() > 0.5? -1:1;
			temp = m_value + r;
			m_value = temp;
			if (m_value > maxValue)
			{
				m_value = maxValue;
			}
			else if (m_value < minValue) 
			{
				m_value = minValue;
			}
			
			return m_value; 	
		}
		
		public function set value(val:Number):void 
		{
			m_value = val;
			if (m_value > maxValue) {
				m_value = maxValue;
			}else if (m_value < minValue) {
				m_value = minValue;
			}
		}
		
		public function get range():Number { return m_range; }
		
		public function set range(value:Number):void 
		{
			m_range = value;
		}
		
		public function get maxValue():Number { return m_maxValue; }
		
		public function set maxValue(value:Number):void 
		{
			m_maxValue = value;
		}
		
		public function get minValue():Number { return m_minValue; }
		
		public function set minValue(value:Number):void 
		{
			m_minValue = value;
		}
	}
	
}