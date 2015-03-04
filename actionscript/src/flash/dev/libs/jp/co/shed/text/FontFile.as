package jp.co.shed.text 
{
	import flash.events.EventDispatcher;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;
	import flash.text.Font;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.utils.getDefinitionByName;
	import jp.co.shed.events.LoaderEvent;
	import jp.co.shed.net.DisplayLoader;
	
	/**
	 * 外部ファイルのフォントの埋め込みを管理するクラス。
	 * 
	 * 外部font.swfのアウトラインフォーマットは、
	 * TextFieldの場合は、DF3、
	 * TLFの場合は、DF4にチェックする。
	 * 
	 * package  {
	 * 
	 * import flash.display.MovieClip;
	 * import flash.events.Event;
	 * import flash.text.Font;
	 * import flash.text.TextField;
	 * import flash.text.TextFieldAutoSize;
	 * import flash.text.TextFormat;
	 * import jp.co.shed.events.LoaderEvent;
	 * import jp.co.shed.text.FontFile;
	 * 
	 * public class FontFileTest extends MovieClip 
	 * {
	 * 
	 * 		private var fontFile:FontFile;
	 * 		
	 * 		private var fontClassName:String = "EmbedFont";
	 * 
	 * 		public function FontFileTest()
	 * 		{
	 * 			initFontFile();
	 * 		}
	 * 
	 * 		private function initFontFile():void 
	 * 		{
	 * 			fontFile = new FontFile("fontFileKey","fonts.swf",[fontClassName]);
	 * 			fontFile.addEventListener(LoaderEvent.STATUS_COMPLETE, onLoaded);
	 * 			fontFile.load()
	 * 		}
	 * 		
	 * 		private function onLoaded(e:LoaderEvent):void
	 * 		{
	 * 			trace(fontFile);
	 * 			
	 * 			var t:TextField = fontFile.getTextFieldByClassName(fontClassName);
	 * 			var fmt:TextFormat = fontFile.getTextFormatByClassName(fontClassName);
	 * 			var font:Font = fontFile.getFontByClassName(fontClassName);
	 * 			var f:String = fontFile.getFontNameByClassName(fontClassName);
	 * 			
	 * 			trace(t, fmt, font, f);
	 * 			
	 * 			addChild(t);
	 * 			t.autoSize = TextFieldAutoSize.LEFT;
	 * 			t.text = "フォントの埋め込みに成功したかどうかのテスト。";
	 * 		}
	 * }
	 * }
	 * 
	 * @author yasunari ishibashi
	 */
	public class FontFile extends EventDispatcher
	{

		private var m_key:String;

		private var m_filePath:String;

		private var m_embedFontClassName_ary:Array;
		
		private var m_displayLoader:DisplayLoader;

		private var m_loading:Boolean;
		
		private  var m_loaded:Boolean;
		
		/**
		 * コンストラクタ。
		 * 
		 * @param	key						:	キー。
		 * @param	filePath				:	ファイル名。
		 * @param	embedFontClassName_ary	:	埋め込むフォントクラス名の配列。
		 */
		public function FontFile(key:String, filePath:String, embedFontClassName_ary) 
		{
			m_key = key;
			m_filePath = filePath;
			m_embedFontClassName_ary = embedFontClassName_ary;
		}
		
		/**
		 * フォントファイルをロードします。
		 */
		public function load():void
		{
			if (m_loaded) {
				return;
			}
			if (m_loading)
			{
				return;
			}
			
			if (m_displayLoader)
			{
				m_displayLoader.close();
				m_displayLoader = null;
			}
			
			m_loading = true;
			m_displayLoader = new DisplayLoader(m_filePath);
			m_displayLoader.loaderContext = new LoaderContext(true, ApplicationDomain.currentDomain);
			m_displayLoader.addEventListener(LoaderEvent.STATUS_CHANGE, onLoadStatusChanged);		
			m_displayLoader.addEventListener(LoaderEvent.STATUS_COMPLETE, onLoadCompleted);	
			m_displayLoader.addEventListener(LoaderEvent.STATUS_ERROR, onLoadError);	
			
			m_displayLoader.load();
		}

		
		private function onLoadCompleted(e:LoaderEvent):void
		{
			m_loading = false;
			m_loaded = true;
			registerFont();
			dispatchEvent(e);
		}
		
		private function onLoadError(e:LoaderEvent):void
		{
			m_loading = false;
			m_loaded = false;
			dispatchEvent(e);
		}		
		
		private function onLoadStatusChanged(e:LoaderEvent):void
		{
			dispatchEvent(e);
		}
		
		private function registerFont():void
		{
			var len:int = m_embedFontClassName_ary.length;
			for (var i:uint = 0; i < len; i++ )
			{
				try
				{
					var fontClass:Class = getDefinitionByName(m_embedFontClassName_ary[i]) as Class;
					Font.registerFont(fontClass);					
				}catch (e:Error)
				{
					trace("フォントクラス名'"+m_embedFontClassName_ary[i] + "'の埋め込みに失敗しました。");
					return;
				}
			}
		}
		
		/**
		 * Fontインスタンスを返却します。
		 * 
		 * @param	className
		 * @return
		 */
		public function getFontByClassName(className:String):Font
		{
			try 
			{
				var classRef:Class = getDefinitionByName(className) as Class;
				var font:Font = new classRef();
				
				return font;
			}
			catch (e:Error)
			{

			}
			
			return null;
		}
		
		/**
		 * フォント名を返却します。
		 * 
		 * @param	className
		 * @return
		 */
		public function getFontNameByClassName(className:String):String
		{
			var font:Font = getFontByClassName(className);
			if (font)
			{
				return font.fontName;
			}

			return null;
		}
		
		/**
		 * 指定したフォントのTextFormatを返却します。
		 * 
		 * @param	className
		 * @return
		 */
		public function getTextFormatByClassName(className:String):TextFormat
		{
			return  new TextFormat(getFontNameByClassName(className));
		}
		
		/**
		 * 指定したフォントのTextFieldを返却します。
		 * 
		 * @param	className
		 * @return
		 */
		public function getTextFieldByClassName(className):TextField
		{
			var txt:TextField = new TextField();
			txt.embedFonts = true;
			txt.defaultTextFormat = getTextFormatByClassName(className);
			
			return txt; 
		}
		
		/**
		 * このインスタンスのキーを返却します。
		 */
		public function get key():String { return m_key; }
		
		/**
		 * フォントファイルのパスを返却します。
		 */
		public function get filePath():String { return m_filePath; }
		
		/**
		 * 埋め込むフォントのクラス名を格納した配列を返却します。
		 */
		public function get embedFontClassName_ary():Array { return m_embedFontClassName_ary; }
		
		/**
		 * すべてのフォントが埋め込まれたかどうかを返却します。
		 */
		public function get embeded():Boolean { 
			
			var len:int = m_embedFontClassName_ary.length;
			for (var i:uint = 0; i < len; i++ )
			{
				var font:Font = getFontByClassName(m_embedFontClassName_ary[i]);
				if (font == null) return false;
			}

			return true;
		}
		
		/**
		 * ロード中かどうかを返却します。
		 */
		public function get loading():Boolean { return m_loading; }
		
		/**
		 * ロードに成功したかどうかを返却します。
		 */
		public function get loaded():Boolean { return m_loaded; }
		
		public override function toString():String
		{
			var s:String = "jp.co.shed.text.FontFile(";
			s += "key='" + key + "',";
			s += "filePath='" + filePath + "',";
			s += "embeded='" + embeded + "',";
			s += "loading='" + loading + "',";
			s += "loaded='" + loaded + "',";
			s += "embedFontClassName_ary='" + embedFontClassName_ary + "')";

			return s;
		}		
	}

}