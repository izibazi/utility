package jp.co.shed.data {
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import jp.co.shed.events.SAManagerEvent;
	import jp.co.shed.SWFAddress;
	import jp.co.shed.SWFAddressEvent;
	
	/**
	 * SWFAddressを管理するクラス。
	 * このクラスを利用する場合、SWAddressクラスを直接アクセスしてはいけません。
	 * 
	 * 下記の属性を指定できます。
	 * 
	 * @param	key	
	 * @param	folder ブラウザに表示されるアドレスのフォルダ名
	 * @param	title ブラウザに表示されるタイトル
	 * @param	parameterNames 有効なパラメータ名(複数存在する場合は、,で区切る)
	 * @param	swfPath 外部swfの場合のパス
	 * @param	panel パネルかどうかの真偽値
	 * 
	 * @example
	 * 
	 * 	<scene key="index" folder="" title="タイトル index"/>
	 *	<scene key="cm" folder="cm" title="タイトル cm" swfPath="contents/cm.swf"/>
	 *	<scene key="tv" folder="tv" title="タイトル tv" swfPath="contents/tv.swf"/>
	 *	<scene key="download" folder="download" title="タイトル download" swfPath="contents/download.swf"/>
	 *	<scene key="usp" folder="usp" title="タイトル usp" swfPath="contents/usp.swf" panel="true" />
	 *	<scene key="calender" folder="calender" title="タイトル calender" swfPath="contents/calender.swf"/>
	 * 
	 * @author yasunari ishibashi
	 */
	public class SAManager extends EventDispatcher
	{		
		
		private static var singleton : SAManager;
		
		private var contentScenes:Array;

		private var scenes:Object;
		
		private var m_prevScene:SAScene;
		
		private var m_scene:SAScene;
		
		private var addressScene:SAScene;
		
		private var m_isFirst:Boolean = true;
		
		private var locked:Boolean = true;
		
		/**
		 * このクラスのシングルトンオブジェクトを返却します。
		 */
		public static function getInstance() : SAManager
		{
			if(singleton == null)
				singleton = new SAManager(new Inner());
				
			return singleton;
		}
		
		/**
		 * このクラスのシングルトンオブジェクトを破棄します。
		 */
		public static function deleteInstance() : void
		{
			singleton = null;
		}
		
		/**
		 *  コンストラクタ
		 */
		public function SAManager(inner:Inner)
		{
			
		}
		
		/**
		 * 初期化します。
		 * 
		 * @param	xmlList
		 * @param	verbose
		 */
		public function init(xmlList:XMLList, verbose:Boolean = false):void 
		{
			if (xmlList == null) 
			{
				//trace(toString() + "init() : xmlListがnullです。");
				return;
			}
			else if (xmlList.length() == 0) 
			{
				//trace(toString() + "init() : xmlListが空です。");
				return;				
			}

			addXMLList(xmlList, verbose);
		}
		
		/**
		 * 開始します。
		 */
		public function start():void 
		{
			locked = false;
			SWFAddress.addEventListener(SWFAddressEvent.CHANGE , onSWFAddressChanged);
		}
		
		/**
		 * ロックします。
		 */
		public function lock():void 
		{
			if (locked) return;
			
			locked = true;
			SWFAddress.removeEventListener(SWFAddressEvent.CHANGE , onSWFAddressChanged);
		}
		
		/**
		 * アンロックします。
		 */
		public function unlock():void 
		{
			if (!locked) return;
			
			locked = false;
			SWFAddress.addEventListener(SWFAddressEvent.CHANGE , onSWFAddressChanged);
		}

		private function addXMLList(xmlList:XMLList, verbose:Boolean = false) : void
		{
			var len:uint = xmlList.length();
			if (len == 0) 
			{
				trace(toString()+"addXMLList() xmlListの値が不正です。中断しました。xmlList:"+xmlList);
				return;
			}
			contentScenes = [];
			scenes = { };
			
			for (var i:uint = 0; i < len; i++) 
			{
				contentScenes[i] = parse(xmlList[i],null, [], verbose);
				contentScenes[i].id = i + 1;
			}
		}
		
		private function parse(xmlList:XML, contentSWFPath:String, pathNames:Array, verbose:Boolean = false, root:SAScene = null):SAScene 
		{
			var key:String=xmlList.@key;
			var title:String=xmlList.@title;
			var swfPath:String;
			if (contentSWFPath != null)
			{
				swfPath = contentSWFPath;
			}
			else
			{
				swfPath = xmlList.@swfPath;
			}
			
			var folder:String = xmlList.@folder;
			var panel:Boolean = xmlList.@panel == "true";
			
			var newPathNames:Array = [];
			for (var j:uint = 0; j < pathNames.length; j++)
				newPathNames[j] = pathNames[j];
				
			newPathNames.push(folder);

			var validParameterNames:Array = [];
			try{
				validParameterNames = (xmlList.@parameterNames).split(",");
			}catch (e:Error) {}

			var newScene:SAScene = new SAScene(key, title, newPathNames, swfPath, validParameterNames, panel, root);
			if (scenes[key] == null)
			{
				scenes[key] = newScene;

				var attrList:XMLList = xmlList.attributes();
				var attrListLen:uint = attrList.length();
			
				for (var t:uint = 0; t < attrListLen; t++ ) 
				{
					var name:String = attrList[t].name();
					var value:*= attrList[t];
					newScene.attrs[name] = value;
				}
			}
			else
			{
				trace(toString() + "parse() key=" + key + " : このkeyはすでに存在しています。keyはユニークな値を指定する必要があります。");
			}
			
			var len:uint = xmlList.children().length();
			for (var i:uint = 0; i < len; i++)
				parse(xmlList.children()[i], swfPath, newPathNames, verbose, newScene.root);
			
			if(verbose)
				trace(newScene.toString());
				
			return newScene;
		}

		private function onSWFAddressChanged(evt:SWFAddressEvent = null):void
		{
			if (locked) 
			{
				return;
			}
			
			var newScene:SAScene = getSAScene(evt);
			
			//シーンが存在し、パラメータも存在する場合。
			if (newScene != null && evt.parameters != null)
			{
				newScene.queryValue = "";
				for (var i:* in evt.parameters) 
				{
					if (i != "")
					{
						newScene.queryValue += (i + "=" + evt.parameters[i] + "&");
					}
				}
				newScene.queryValue = newScene.queryValue.substr(0, newScene.queryValue.length - 1);
			}
			else
			{
				//シーンが存在する場合。
				if (newScene != null)
				{
					newScene.queryValue = null;
				}
			}
			//trace("newScene.queryValuenewScene.queryValue"+newScene.queryValue);
			__update(newScene);
		}
		
		private function __update(newScene:SAScene):void
		{
			//初回
			if (m_scene == null) 
			{
				m_isFirst = true;
				//無効なアドレスならば、トップへ。
				if (newScene == null)
				{
					//一番最初のシーンを指定する。
					forceChangeSWFAddress(contentScenes[0]);
				}
				else
				{
					//更新する。
					updateSAScene(newScene);
					dispatchEvent(new SAManagerEvent(SAManagerEvent.CHANGE, this, m_scene));
					
					if (newScene.isPanel)
					{
						//初回がパネルの場合は、最初のSASceneオブジェクトを以前に指定する。
						m_prevScene = contentScenes[0];
						dispatchEvent(new SAManagerEvent(SAManagerEvent.PANEL_CHANGE, this, m_scene));
					}//else{
						//dispatchEvent(new SAManagerEvent(SAManagerEvent.CHANGE, this, m_scene));
					//}
					
					dispatchEvent(new SAManagerEvent(SAManagerEvent.START, this, m_scene));
				}
			}
			else 
			{
				m_isFirst = false;
				//シーンが見つからない、無効である、または、現在と完全に、等しい場合は、何もしない。
				//if(newScene==null||equal(evt))return;
				if (newScene == null) return;
				
				//更新する。
				updateSAScene(newScene);
				
				dispatchEvent(new SAManagerEvent(SAManagerEvent.CHANGE,this,m_scene));
				if (changedContent())
				{
					//コンテンツが変化した。
					if (m_scene.isPanel)
					{
						dispatchEvent(new SAManagerEvent(SAManagerEvent.PANEL_CHANGE, this, m_scene));
					}
					else
					{
						if (m_prevScene != null && m_prevScene.isPanel)
						{
							dispatchEvent(new SAManagerEvent(SAManagerEvent.PANEL_CHANGE, this, m_scene));
						}
						else 
						{
							dispatchEvent(new SAManagerEvent(SAManagerEvent.SCENE_CHANGE, this, m_scene));
						}
					}
				}
				else
				{
					//コンテンツ内の状態が変化した。
					dispatchEvent(new SAManagerEvent(SAManagerEvent.SCENE_STATUS_CHANGE,this,m_scene));
				}
			}
		}
		
		private function updateSAScene(newScene:SAScene):void 
		{
			m_prevScene = m_scene;
			m_scene = newScene;
			SWFAddress.setTitle(newScene.title);
		}
		
		/**
		 * ひとつ前のシーンと等しいかどうかを返却します。
		 * 
		 * @return
		 */
		public function equealPrevScene():Boolean 
		{
			return m_prevScene == scene;
		}
		
		private function getSAScene(evt:SWFAddressEvent):SAScene
		{
			for (var p:* in scenes)
			{
				if (evt.path == scenes[p].path)
				{
					var _m_scene:SAScene = scenes[p];
					_m_scene.parameters=evt.parameters;
					_m_scene.parameterNames = evt.parameterNames;
					_m_scene.value = evt.value;
					_m_scene.path = evt.path;
					return _m_scene;
				}
			}
			
			return null;
		}
		
		private function changedContent():Boolean
		{
			if (m_prevScene == null) return true;
			return m_prevScene.rootPathName != m_scene.rootPathName;
		}
		
		private function equal(evt:SWFAddressEvent):Boolean
		{
			return evt.value==m_scene.value;
		}
		
		/**
		 * SWFAddressの値を変更します。
		 */
		private function forceChangeSWFAddress(newScene:SAScene):void
		{
			SWFAddress.setValue(newScene.path);
		}
		
		/**
		 * 指定したキーのシーンに、変更します。
		 * 
		 * @param	key
		 * @param	queryValue
		 */
		public function change(key:String, queryValue:String = null, force:Boolean = false):void 
		{
			var newScene:SAScene = scenes[key];
			if (newScene == null) 
			{
				trace(toString() + "change() : key=" + key + " このキーのシーンは存在しません。アドレスの変更を中止しました。");
				return;
			}
			newScene.queryValue = queryValue;
			if (force) 
			{
				SWFAddress._value = null;
			}
			SWFAddress.setValue(newScene.path + (queryValue == null?"":("?" + queryValue)));
			SWFAddress.setTitle(newScene.title);			
		}
		
		/**
		 * インデックス(トップ)に、移動します。
		 */
		public function goIndex():void
		{
			var scene:SAScene = contentScenes[0];
			change(scene.key);
		}
		
		/**
		 * 指定したキーのSASceneオブジェクトを返却します。
		 * @param	key
		 * @return
		 */
		public function getSASceneByKey(key:String):SAScene 
		{
			return scenes[key];
		}
		
		/**
		 * 現在のSASceneオブジェクトを返却します。[read-only]
		 */
		public function get scene():SAScene
		{
			return m_scene;
		}
		
		/**
		 * 現在のSASceneがパネルコンテンツかどうかを返却します。[read_only]
		 */
		public function get isPanel():Boolean
		{
			if (m_scene == null) return false;
			return m_scene.isPanel;
		}
		
		/**
		 * 現在のブラウザのタイトルを返却します。[read-only]
		 */
		public function get title():String
		{
			return m_scene.title;
		}
		
		/**
		 * 現在の値(パス値+クエリ値)を返却します。[read-only]
		 */
		public function get value():String
		{
			return m_scene.value;
		}
		
		/**
		 * 現在のパス値を返却します。[read-only]
		 */
		public function get path():String
		{
			return m_scene.path;
		}
		
		/**
		 * 現在のパスの各フォルダ名の配列を返却します。[read-only]
		 */
		public function get pathNames():Array
		{
			return m_scene.pathNames;
		}
		
		/**
		 * 現在のクエリの各キーと値を格納したオブジェクトを返却します。[read-only]
		 */
		public function get parameters():Object
		{
			return m_scene.parameters;
		}
		
		/**
		 * 現在のクエリ値の各キーの値を格納した配列を返却します。[read-only]
		 */
		public function get parameterNames():Array
		{
			return m_scene.parameterNames;
		}
		
		/**
		 * 直前のSASceneオブジェクトを返却します。
		 */
		public function get prevScene():SAScene { return m_prevScene; }
		
		/**
		 * 初回かどうかを返却します。
		 */
		public function get isFirst():Boolean
		{
			return m_isFirst;
		}
		/**
		 * 現在のクエリ値の指定したキーの値を返却します。[read-only]
		 */
		public function getParameterValue(paramName:String):String
		{
			return m_scene.parameterValueAt(paramName);
		}
		
		/**
		 * 前のURLに戻ります。
		 * 
		 * @param	backKeyIfNotExist
		 * @param	queryValue
		 */
		public function back(backKeyIfNotExist:String = null, queryValue:String = null):void
		{
			/*
			if (existHistory) {
				SWFAddress.back();
			}else {
				if(backKeyIfNotExist!=null){
					change(backKeyIfNotExist, queryValue);
				}else {
					goIndex();
				}
			}*/
			if (prevScene == null)
			{
				if (backKeyIfNotExist != null)
				{
					change(backKeyIfNotExist, queryValue);
				}
				else
				{
					goIndex();
				}
			}
			else 
			{
				if (scene == prevScene) 
				{
					goIndex();
				}
				else
				{
				//	trace("prevScene.queryValue : " + prevScene.queryValue);
					change(prevScene.key, prevScene.queryValue);
				}
			}
		}
		
		/**
		 * 前のURLが存在するかどうかを返却します。
		 * 
		 * @return
		 */
		public function get existHistory():Boolean
		{
			return SWFAddress.getHistory();
		}
		
		/**
		 * 外部SWFのシーンかどうかを返却します。
		 */
		public function get isOutsideSWFScene():Boolean 
		{
			return scene.swfPath != null && scene.swfPath != "";
		}
		
		public override function toString():String
		{
			var s:String="jp.co.shed.data.SAManager(";
			return s;
		}
	}
	
}

class Inner{}