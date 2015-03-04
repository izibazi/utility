package jp.co.shed.data
{
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.NetStatusEvent;
	import flash.events.SecurityErrorEvent;
	import flash.events.ErrorEvent;
	import flash.net.URLLoader;
	import flash.xml.XMLNode;
	
	import jp.co.shed.debug.SDTrace;
	import jp.co.shed.events.LoaderEvent;
	import jp.co.shed.reference.StageRef;
	import jp.co.shed.net.XMLLoader;

	/**
	 * config.xmlを管理するクラス。
	 * このオブジェクトの各メソッドを利用するには、
	 * 指定されたフォーマットのxmlを、ロード（追加）する必要があります。
	 * 
	 * @author yasunari ishibashi
	 */
	public class ConfigData  extends EventDispatcher
	{

		public static const SOUND_KEY:String = "sound";
		
		public static const STAGE_KEY:String = "stage";
		
		public static const DEBUG_KEY:String = "debug";
		
		public static const KEY_VALUE_KEY:String = "keyValue";

		private static var configData:ConfigData;
		
		private var loader:XMLLoader;

		public var data:Object;
		
		private var stageRef:StageRef;
		
		private var m_xml:XML;
		
		public static function getInstance():ConfigData 
		{
			if (configData == null)
				configData = new ConfigData(new Singleton());
			
			return configData;
		}
		
		public function ConfigData(singleton:Singleton) 
		{
			stageRef = StageRef.getInstance();
		}

		/**
		 * ロードします。
		 * 
		 * @param	mainTimeline
		 * @param	url
		 * @param	isUnicode
		 * @param	tryCount
		 */
		public function load(url:String  , isUnicode:Boolean = true , tryCount:uint = 0):void
		{	
			
			if (stageRef.mainTimeline == null) 
			{
				trace(toString() + "load() このメソッドを実行する前に、StageRefオブジェクトのinitメソッドを実行する必要があります。");
				return;
			}

			loader = new XMLLoader(url, isUnicode , tryCount , stageRef.isNet);

			loader.addEventListener(LoaderEvent.STATUS_CHANGE, onLoadEvent);
			loader.load();
		}
		
		private function onLoadEvent(evt:LoaderEvent):void 
		{
			if (evt.eventType == IOErrorEvent.IO_ERROR || evt.eventType == SecurityErrorEvent.SECURITY_ERROR) 
			{
			}
			else if (evt.eventType == Event.COMPLETE) 
			{
				addXML(loader.xml);			
			}
			dispatchEvent(evt.event);
			dispatchEvent(evt);
		}

		/**
		* xmlを追加します。
		*/
		public  function addXML(m_xml:XML):void 
		{
			if (this.xml) 
			{
				this.xml.appendChild(m_xml);
			}
			else
			{
				this.xml = m_xml;
			}
			
			var keyValue:XMLList = m_xml[KEY_VALUE_KEY];
			var length:uint = keyValue.item.length();

			if (data == null) data = { };
			
			for (var i:uint; i < length; i++)
			{
				var item:XML = keyValue.item[i];

				var attr:XMLList = item.attributes();
				var attrLength:uint = attr.length();
			
				var obj:Object = { };
				
				for (var j:uint = 0 ; j < attrLength ; j++) 
				{
					var name:String = attr[j].name();
					obj[name] = String(attr[j]);
				}
				obj.value = String(item);
				obj.xmlList = keyValue.item[i].children();
				
				if (obj.key != null && obj.key != "")
				{
					if (data[obj.name] != null)
					{
						trace(toString() + "addXML() key:" + obj.key + " は、すでに存在します。");
					}
					data[obj.key] = obj;
				}
			}
		}
		
		/**
		 * サウンドのXMLListオブジェクトを返却します。
		 * 
		 * @return 	サウンドのXMLListオブジェクト。
		 */
		public function get soundXMLList():XMLList
		{
			return xml[SOUND_KEY].item;
		}
		
		/**
		 * getObject(STAGE_KEY)の値をもとに、StageRefオブジェクトのプロパティを設定します。
		 */
		public function setStageInfo():void 
		{
			var stageInfo:* = xml[STAGE_KEY];
			if (stageInfo != null) 
			{
				var normalW:Number = stageInfo.@normalW;
				var normalH:Number = stageInfo.@normalH;
				var maxW:Number = stageInfo.@maxW;
				var maxH:Number = stageInfo.@maxH;
				var minW:Number = stageInfo.@minW;
				var minH:Number = stageInfo.@minH;
				
				stageRef.normalW = (isNaN(normalW) || normalW <= 0)?stageRef.normalW:normalW;
				stageRef.normalH = (isNaN(normalH) || normalH <= 0)?stageRef.normalH:normalH;
				stageRef.maxW = (isNaN(maxW) || maxW <= 0)?stageRef.maxW:maxW;
				stageRef.maxH = (isNaN(maxH) || maxH <= 0)?stageRef.maxH:maxH;
				stageRef.minW = (isNaN(minW) || minW <= 0)?stageRef.minW:minW;
				stageRef.minH = (isNaN(minH) || minH <= 0)?stageRef.minH:minH;
				
				if (stageRef.minW > stageRef.normalW) 
				{
					stageRef.minW = stageRef.normalW;
				}
				
				if (stageRef.minH > stageRef.normalH) 
				{
					stageRef.minH = stageRef.normalH;
				}
				
				if (stageRef.normalW > stageRef.maxW) 
				{
					stageRef.maxW = stageRef.normalW;
				}
				
				if (stageRef.normalH > stageRef.maxH)
				{
					stageRef.minH = stageRef.normalH;
				}
			}
		}
		
		/**
		 *  getObject(DEBUG_KEY)の値をもとに、SDTraceクラスのプロパティを設定します。
		 */
		public function setDebugInfo():void 
		{
			var useDebugger:Boolean = xml[DEBUG_KEY].@useDebugger == "1";
			var useTrace:Boolean = xml[DEBUG_KEY].@useTrace == "1";

			SDTrace.enabledDebugger = useDebugger;
			SDTrace.enabledTrace = useTrace;
			SDTrace.verbose = useTrace || useDebugger;
		}

		/**
		 * key,valueを追加します。
		 * 
		 * @param	key
		 * @param	value
		 */
		public  function addObjectValue(key:String , value:*):void
		{
			if (data == null) data = { };
			if (data[key] != null)
				trace(toString() + "addObjectValue() key:" + key + " は、すでに存在します。");

			data[key] = { key : key , value :value };
		}
		
		/**
		 * objの各キーの値を、追加します。
		 * xmlプロパティは変更されません。
		 * 
		 * @param	key
		 * @param	obj
		 */
		public  function addObject(key:String , obj:Object):void
		{
			if (data == null) data = { };
			
			var info :Object = { };
			for (var i:* in obj) info[i] = obj[i];	
			if (data[key] != null)
				trace(toString() + "addObject() key:" + obj.key + " は、すでに存在します。");
				
			data[key] = info;
		}
		
		/**
		 * オブジェクトを返却します。
		 * 
		 * @param	key
		 * @return
		 */
		public  function getObject(key:String):Object
		{
			try
			{
				var d:Object = data[key];
				
			}
			catch (e : Error)
			{
				trace(toString() + "getObject() key=" + key + "は、存在しません。");
			}

			return d;
		}
		
		/**
		 * velue値を返却します。
		 * 
		 * @param	key
		 * @return
		 */
		public  function getValue(key:String):*
		{
			var d :Object = getObject(key);
			if (d == null)return null;

			return d.value;
		}
		
		/**
		 * xmlListを返却します。
		 * 
		 * @param	key
		 * @return
		 */
		public function getXMLList(key:String):XMLList 
		{
			var d :Object = getObject(key);
			if (d == null) return null;
			
			return XMLList(d.xmlList);
		}
		
		/**
		 * 指定したパラメータ値を返却します。
		 * 
		 * @param	key
		 * @param	param
		 * @return
		 */
		public  function getAttr(key:String , param:String):*
		{
			var d :Object = getObject(key);
			if (d == null) return null;
			return d[param];
		}

		/**
		 * ロードしたxmlを返却します。
		 */
		public function get xml():XML
		{ 
			return m_xml; 
		}
		
		public function set xml(value:XML):void 
		{
			m_xml = value;
		}
		
		/**
		 *
		 * @param	key
		 * @return
		 */
		public function getItem(key:String):*
		{
			return xml.item.(@key == key);
		}
		
		public override function toString():String 
		{
			return "jp.co.shed.ConfigData(";
		}
		
	}
}

class Singleton{ }