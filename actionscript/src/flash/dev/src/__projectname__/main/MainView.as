package __projectname__.main
{
	import flash.display.MovieClip;
	import flash.events.Event;
	import jp.co.shed.debug.SDTrace;
	import jp.co.shed.display.SDMovieClip;
	import jp.co.shed.events.StageRefEvent;

	/**
	 * main.swfのView.
	 * 
	 * @author yasunari ishibashi
	 */
	public class MainView extends SDMovieClip 
	{
		
		/**
		 * コンストラクタ
		 */
		public function MainView( ...args ) 
		{
			super();
			init();
		}
		
		/**
		 * 初期化します。
		 */
		private function init():void 
		{
			SDTrace.dump("MainViewを初期化しました。");
			//this.resizing = true;
			initReferences();
		}
		
		private function initReferences():void
		{
			
		}
		
		/**
		 * 表示します。
		 */
		public override function show(...args):void 
		{
			super.show(args);
		}
		
		/**
		 * 非表示にします。
		 */
		public override function hide(...args):void 
		{
			super.hide(args);
		}
		
		/**
		 * ステージリサイズ時に実行されます。
		 */
		protected override function resizedStage(evt:StageRefEvent = null):void 
		{

		}
		
		/**
		 * ステージ追加時に実行されます。
		 */
		protected override function addedToStage(evt:Event = null):void 
		{
			super.addedToStage(evt);	
		}
		
		/**
		 * ステージから削除時に実行されます。
		 */
		protected override function removedFromStage(evt:Event = null):void 
		{
			super.removedFromStage(evt);
		}
	}
}
