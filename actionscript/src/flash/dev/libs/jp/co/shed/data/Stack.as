package jp.co.shed.data{
	import jp.co.shed.utils.TraceUtils;
	
	/**
	 * Stack(未完成。使用しないこと。)を管理するクラス。
	 * 
	 * @author yasunari ishibashi
	 * 
	 */	
	public class Stack
	{
		
		public static const STACK_OVER_FLOW:String="stackOverFlow";
		
		public static const STACK_EMPTY:String = "stackEmpty";
		
		private var max:int;
		
		private var stackPoint:int;
		
		private var stack_ary:Array;
		
		/**
		 * コンストラクタ
		 * 
		 * @param capacity
		 * 
		 */		
		public function Stack(capacity:int=int.MAX_VALUE)
		{
			max=capacity;
			stackPoint=0;
			this.stack_ary=[];
		}
		
		/**
		 * データを追加します。
		 *  
		 * @param value
		 * @return 
		 * 
		 */		
		public function push(value:*):*
		{
			if(stackPoint>=max){
				throw new Error(STACK_OVER_FLOW);
			}
			
			return stack_ary[stackPoint++]=value;
		}
		
		/**
		 * 頂上のデータを返却します。
		 *  
		 * @return 
		 * 
		 */		
		public function pop():*
		{
			if(stackPoint<=0){
				throw new Error(STACK_EMPTY);
			}
			
			return stack_ary[--stackPoint];
		}
		
		/**
		 * 次のデータを返却します。
		 *  
		 * @return 
		 * 
		 */		
		public function peek():*
		{
			if(stackPoint<=0){
				throw new Error(STACK_EMPTY);
			}
			
			return stack_ary[stackPoint-1];		
		}
		
		/**
		 * valueを検索し、見つかればそのindexを返却します。
		 * 失敗した場合は、-1を返却します。
		 *  
		 * @param value
		 * @return 
		 * 
		 */		
		public function indexOf(value:*):int
		{
			for (var i:int = stackPoint - 1; i >= 0; i--)
			{
				if (stack_ary[i] == value)
				{
					return i;
				}
			}
			
			return -1;
		}
		
		/**
		 * すべてのデータを削除します。 
		 * 
		 */		
		public function clear():void
		{
			stack_ary=[];
			stackPoint=0;
		}
		
		/**
		 * スタックのサイズを返却します。 
		 * @return 
		 * 
		 */		
		public function get size():int
		{
			return stackPoint;
		}
		
		/**
		 * スタックの容量を返却します。 
		 * @return 
		 * 
		 */		
		public function get capacity():int
		{
			return max;
		}
		
		/**
		 * スタックが満杯かどうかを返却します。 
		 * @return 
		 * 
		 */		
		public function get isFull():Boolean
		{
			return stackPoint>=max;
		}
		
		/**
		 * スタックが空かどうかを返却します。
		 *  
		 * @return 
		 * 
		 */		
		public function get isEmpty():Boolean
		{
			return stackPoint <= 0;
		}
	}
}