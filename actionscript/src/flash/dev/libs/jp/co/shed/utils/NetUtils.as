package jp.co.shed.utils
{
	import flash.display.Stage;
	import flash.external.ExternalInterface;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	
	/**
	 * 
	 * @author yasunari ishibashi
	 */
	public class NetUtils
	{

		/**
		 * サーバー上か確認し、サーバ上であれば、有効なキャッシュ値を返却します。<br>
		 * それ以外は空を返却します。
		 * 
		 * <p>返却する値は'?noCache=乱数'もしくは空のストリングです。</p>
		 * 
		 * @return  ?noCache=乱数を返却します。
		 */
		public static function noCache():String{
			return "?noCache=" + Math.ceil(Math.random() * 1000000000);
		}
		
		/**
		 * 指定されたurlのページを開きます。
		 * 
		 * @param data {url : , target : }を持つオブジェクト
		 */
		public static function openURL(data:Object):void {
			if (data == null) {
				trace(toString() + " error openURL : data is null");
				return;
			}
			var target:String=data.target;
			var url:String = data.value;
			trace(toString() + " open URL : " + target , url);
			if (url == null) {
				return;
			}
			try{
				navigateToURL(new URLRequest(url) , target);
			}catch(e:Error){
			}
		}
		
		public static function toString():String {
			return "jp.co.shed.utils.NetUtils";
		}

		/**
		 * 指定されたjavascriptを実行します。
		 * 
		 * <p>この関数は、調整中です。</p>
		 * 
		 * @param data {value :  }を持つオブジェクト
		 */		
		public static function callJavaScript(data:Object):void{
			ExternalInterface.call(data.value);
		}
		
		
	}
}