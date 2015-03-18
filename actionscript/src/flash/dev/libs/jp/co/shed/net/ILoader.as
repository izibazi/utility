package jp.co.shed.net 
{
	import flash.events.EventDispatcher;
	
	/**
	 * AbstractLoaderのインターフェイス。
	 * 
	 * @author yasunari ishibashi
	 */
	interface ILoader
	{
		 function load():void;
		 function close():void;
		 function unload():void;
		 function addListeners():void;
		 function removeListeners():void;
	}
	
}