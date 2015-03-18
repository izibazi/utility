package jp.co.shed.data{
	
	/**
	 * キューを管理するクラス。
	 *  
	 * @author yasunari ishibashi
	 * 
	 */	
	public class Queue{
		public static const QUEUE_OVER_FLOW:String="queueOverFlow";
		
		public static const QUEUE_EMPTY:String = "queueEmpty";
		
		private var max:int;
		
		private var m_num:int;
		
		private var que_ary:Array;

		/**
		 * コンストラクタ
		 * 
		 * @param capacity
		 * 
		 */		
		public function Queue(capacity:int=int.MAX_VALUE){
			max = capacity;
			m_num = 0;
			this.que_ary = [];
		}
		
		/**
		 * 追加します。
		 *  
		 * @param value
		 * @return 
		 * 
		 */		
		public function push(value:*):*{
			if (num >= max) throw new Error(QUEUE_OVER_FLOW);
			
			return que_ary[m_num++] = value;
		}
		
		/**
		 * 削除します。
		 * 
		 * @param	startIndex
		 * @param	len
		 * @return
		 */
		public function remove(startIndex:int, len:int):Array {
			var r_ary:Array = que_ary.splice(startIndex, len);
			m_num -= r_ary.length;
			return r_ary;
		}
		
		/**
		 * 最後の値を返却します。
		 *  
		 * @return 
		 * 
		 */		
		public function pop():*{
			if(num<=0)throw new Error(QUEUE_EMPTY);
			
			m_num--;
			return que_ary.shift();
		}
		
		/**
		 * 最初の値を返却します。
		 *  
		 * @return 
		 * 
		 */		
		public function peek():*{
			if(num<=0)throw new Error(QUEUE_EMPTY);
			
			return que_ary[0];		
		}
		
		/**
		 * valueを検索し、見つかればそのindexを返却します。
		 * 無ければ、-1を返却います。
		 *  
		 * @param value
		 * @return 
		 * 
		 */		
		public function indexOf(value:*):int{
			for (var i:int = num - 1; i >= 0; i--) 
			{
				if (que_ary[i] == value)
				{
					return i;
				}
			}
			
			return -1;
		}
		
		/**
		 * すべて削除します。
		 */		
		public function clear():void{
			que_ary = null;
			m_num = 0;
		}
		
		/**
		 * サイズを返却します。
		 * numプロパティと同値です。
		 * 
		 * @return 
		 */		
		public function get size():int{
			return num;
		}
		
		/**
		 * サイズを返却します。
		 * sizeプロパティと同値です。
		 * 
		 * @return 
		 */			
		public function get num():int { 
			return que_ary == null?0:que_ary.length;
		}
		
		/**
		 * 最大サイズを返却します。
		 * 
		 * @return 
		 */		
		public function get capacity():int{
			return max;
		}
		
		/**
		 * 満タンかどうかを返却します。
		 * 
		 * @return 
		 */		
		public function get isFull():Boolean{
			return num >= max;
		}
		
		/**
		 * 空かどうかを返却します。
		 *  
		 * @return 
		 */		
		public function get isEmpty():Boolean{
			return num <= 0;
		}
		
		/**
		 * 現在のキュー配列を返却します。
		 *  
		 * @return 
		 */
		public function get ary():Array { return que_ary; }
		
		public function set ary(value:Array):void {
			que_ary = value;
		}

		public function toString():String {
			var s:String = "jp.co.shed.data.Queue(";
			s += "size='" + size + "',";
			s += "capacity='" + capacity + "',";
			s += "ary='" + ary + "')";
			return s ;
		}



	}
}