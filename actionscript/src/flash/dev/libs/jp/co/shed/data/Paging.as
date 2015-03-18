package jp.co.shed.data 
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	
	/**
	 * ページングを管理するクラス。
	 * 
	 * @author yasunari ishibashi
	 */
	public class Paging extends EventDispatcher
	{
		
		private var m_currentPage:int;
		
		private var m_totalPage:int;
		
		private var m_numPerPage:int;
		
		private var m_currentNum:int;
		
		private var m_totalNum:int;
		
		public var extra:*;
		
		/**
		 * コンストラクタ。
		 * 
		 * @param	totalItemNum	トータルアイテム数
		 * @param	startItemNum	スタートのアイテム番号
		 * @param	numPerPage	1ページに表示するアイテムの数
		 */
		public function Paging(totalItemNum:int, startItemNum:int = 1, numPerPage:int = 10 ) 
		{
			if (numPerPage <= 0)
			{
				numPerPage = 1;
			}
			if (totalItemNum <= 0)
			{
				totalItemNum = 0;
			}
			
			if (startItemNum < 1)
			{
				startItemNum = 1;
			}
			
			m_numPerPage = numPerPage;
			totalNum = totalItemNum;
			currentNum = startItemNum;
		}
		
		/**
		 * １ページに表示するアイテム数を返却します。[read_only]
		 */
		public function get numPerPage():int { return m_numPerPage; }

		/**
		 * トータルページ数を返却します。[read_only]
		 */
		public function get totalPage():int
		{  
			return Math.ceil(totalNum / numPerPage);
		}

		/**
		 * 現在のページ数を返却します。
		 */
		public function get currentPage():int { return m_currentPage; }
		
		public function set currentPage(value:int):void 
		{
			var _temp:int;
			if (value < 1)
			{
				_temp = 1;
			}
			else if (value > totalPage)
			{
				_temp = totalPage;
			}
			else
			{
				_temp = value;
			}

			if (_temp != m_currentPage)
			{
				m_currentPage = _temp;
				m_currentNum = (m_currentPage-1) * numPerPage +1;
			}
		}
		
		/**
		 * 現在表示ページの末尾の数を返却します。
		 */
		public function get to():int 
		{
			return Math.min(totalNum, (m_currentPage-1) * numPerPage +numPerPage);
		}
		
		/**
		 * 現在表示ページの先頭の数を返却します。
		 */
		public function get from():int
		{
			return (m_currentPage-1) * numPerPage +1;
		}
		
		/**
		 * 次のページのアイテム数を返却します。
		 */
		public function get nextCount():int
		{
			var value:int = totalNum - to;
			if (value >= numPerPage)
			{
				value = numPerPage;
			}
			else
			{
				if (value < 0) value = 0;
			}
			
			return value;
		}

		public function get currentNum():int { return m_currentNum; }
		
		public function set currentNum(value:int):void 
		{
			if (value < 1) 
			{
				m_currentNum = 1;
			}
			else if (value > m_totalNum)
			{
				m_currentNum = m_totalNum;
			}
			else
			{
				m_currentNum = value;
			}

			m_currentPage = Math.ceil(currentNum / numPerPage);
		}
		
		/**
		 * トータルアイテム数を返却します。
		 */
		public function get totalNum():int { return m_totalNum; }
		
		public function set totalNum(value:int):void 
		{
			m_totalNum = value;
			if (currentNum > totalNum)
			{
				m_currentNum = totalNum;
				currentPage = Math.ceil(m_currentNum / numPerPage);
			}
		}
		
		/**
		 * 次のページが存在するかどうかを返却します。
		 */
		public function get isNextPage():Boolean 
		{
			return currentPage < totalPage;
		}
		
		/**
		 * 前のページが存在するかどうかを返却します。
		 */
		public function get isPrevPage():Boolean 
		{
			return currentPage > 1;
		}
		
		/**
		 * 次のアイテムが存在するかどうかを返却します。
		 */
		public function get isNextItem():Boolean 
		{
			return currentNum < totalNum;
		}
		
		/**
		 * 前のアイテムが存在するかどうかを返却します。
		 */
		public function get isPrevItem():Boolean
		{
			return currentNum > 1;
		}
		
		/**
		 * 指定したアイテムのページ数を返却します。
		 * @param	itemNumber
		 * @return
		 */
		public function getPageAt(itemNumber:int):int 
		{
			return Math.ceil(itemNumber / numPerPage);
		}
		
		public override function toString():String 
		{
			var s:String = "jp.co.shed.data.Paging(";
			s += "currentNum='" + currentNum + "',";
			s += "totalNum='" + totalNum + "',";
			s += "currentPage='" + currentPage + "',";	
			s += "totalPage='" + totalPage + "')";	
			return s;
		}
		
	}

}