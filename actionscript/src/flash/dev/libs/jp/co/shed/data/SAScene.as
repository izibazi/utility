package jp.co.shed.data {
	
	/**
	 * SWFAddressの各シーンを管理するクラス。
	 * 	 
	 * @author yasunari ishibashi
	 */
	public class SAScene {
		
		public var id:uint;
		
		public var key:String;
		
		public var title:String;
		
		public var path:String;

		public var pathNames:Array;
		
		public var validParameterNames:Array;
		
		public var swfPath:String;
		
		public var value:String;
		
		public var parameters:Object;
		
		public var parameterNames:Array;
	
		public var isPanel:Boolean;
		
		public var attrs:Object;
		
		public var queryValue:String;
		
		public var root:SAScene;
		
		public var isRoot:Boolean;
		
		/**
		 * コンストラクタ。
		 * 
		 * @param	key 
		 * @param	title ブラウザに表示されるタイトル
		 * @param	pathNames パスとなるフォルダ名を格納した配列
		 * @param	swfPath ロードすべきswfのパス
		 * @param	validParameterNames 有効なクエリパラメータ名の配列
		 * @param	panel パネルかどうかの真偽値
		 */
		public function SAScene(key:String, title:String , pathNames:Array, swfPath:String = null, validParameterNames:Array = null, panel:Boolean = false, root:SAScene = null)
		{
			
			this.key = key;
			this.isRoot = root == null;
			this.root = isRoot?this:root;
			
			this.title = title;
			this.pathNames = pathNames;
			this.swfPath = swfPath;
			this.validParameterNames = validParameterNames;
			this.path = "/";
			this.isPanel = panel;
			
			this.attrs = { };
			
			var len:uint = pathNames.length;
			for (var i:uint = 0; i < len; i++) 
			{
				this.path += pathNames[i];
				if (i != (len - 1))
					this.path += "/";
			}
		}
		
		/**
		 * パラメータ名が有効かどうかを返却します。
		 * 
		 * @param	param パラメータ名
		 * @return	パラメータ名が有効かどうかの真偽値。
		 */
		public function isValidParameterName(param:String):Boolean 
		{
			if (validParameterNames == null)
			{
				return false;
			}
			var len:uint = validParameterNames.length;
			for (var i:uint = 0; i < len; i++ )
			{
				if (validParameterNames[i] == param)
					return true;
			}
			
			return false;
		}
		
		/**
		 * パスが等しいかどうかを返却します。
		 * 
		 * @param	pathNames_ary フォルダ名を格納した配列
		 * @return	@pathが等しいかどうかの真偽値。
		 */
		public function equelPathNames(pathNames_ary:Array):Boolean
		{
			if (pathNames_ary.length == pathNames.length)
			{
				var len:uint = pathNames_ary.length;
				for (var i:uint = 0; i < len; i++ )
				{
					if (pathNames_ary[i] != pathNames[i])
						return false;
				}
			}else {
				return false;
			}
			
			return true;
		}
		
		/**
		 * 指定したパラメータ名の値を返却します。
		 */
		public function parameterValueAt(paramName:String):*
		{
			return parameters[paramName];
		}
		
		/**
		 * コンテンツのパス名を返却します。
		 */
		public function get rootPathName():String
		{
			return pathNames[0];
		}

		public function toString():String
		{
			var s:String = "jp.co.shed.data.SAScene(";
			s += "key='" + key + "',";
			s += "pathNames='" + pathNames + "',";
			s += "swfPath='" + swfPath + "',";
			s += "isPanel='" + isPanel + "',";
			s += "validParameterNames='" + validParameterNames + "',";
			s += "path='" + path + "',";
			s += "value='" + value + "',";
			s += "parameters='" + parameters + "',";
			s += "parameterNames='" + parameterNames + "')";
			
			return s;
		}
	}
	
}