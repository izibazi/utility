package jp.co.shed.data 
{
	/**
	 * プルダウンメニューのアイテムのデータを管理するクラス。
	 * 
	 * @author yasunari ishibashi
	 */
	public class PulldownItem
	{

		public var value:String;
		
		public var label:String;

		public function PulldownItem(value:String,label:String) 
		{
			this.value = value;
			this.label = label;
		}
		
		public function toString():String 
		{
			var s:String = "jp.co.shed.data.PulldonwItem(";
			s += "value = '" + value + "',";
			s += "label = '" + label + "')";			

			return s;
		}
		
	}

}