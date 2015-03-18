package jp.co.shed.display 
{
	import caurina.transitions.Tweener;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Rectangle;

	/**
	 * プログレスバーの表示を管理します。
	 * 
	 * @author yasunari ishibashi
	 */
	public class SDProgressBar extends MovieClip
	{
		
		private var m_base_mc:MovieClip;
		
		private var m_bar_mc:MovieClip;
		
		private var m_resizingCenter:Boolean;
		
		private var didHided:Function;
		
		public var fadeOutSpeed:Number = 0.1;
		
		public var fadeInSpeed:Number = 0.1;
		
		private var m_pct:Number = 0;

		/**
		 * デフォルトコンストラクタ。
		 */
		public function SDProgressBar() 
		{
			addEventListener(Event.ADDED_TO_STAGE, addedToStage);
		}

		private function addedToStage(e:Event = null):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, addedToStage);
			addEventListener(Event.REMOVED_FROM_STAGE, onRemoved);
			resizingCenter = m_resizingCenter;
		}
		
		public function showWithRect(baseColor:Number = 0xcfd7df,barColor:Number=0x0f3961, x:Number = 0, y:Number = 0, w:Number = 100, h:Number = 2.0):void
		{

			if (m_base_mc==null)
			{
				m_base_mc = new MovieClip();
				m_bar_mc = new MovieClip();
				addChild(m_base_mc);
				addChild(m_bar_mc);
			}
			
			m_base_mc.graphics.clear();
			m_bar_mc.graphics.clear();
			
			m_base_mc.graphics.beginFill(baseColor, 1);
			m_base_mc.graphics.drawRect(x, y, w, h);
			m_base_mc.graphics.endFill();
			
			m_bar_mc.graphics.beginFill(barColor, 1);
			m_bar_mc.graphics.drawRect(x, y, w, h);
			m_bar_mc.graphics.endFill();	
			
			m_bar_mc.x = 
			m_base_mc.x = -int(m_bar_mc.width / 2);
			m_bar_mc.y = 
			m_base_mc.y = -int(m_bar_mc.height / 2);
			
			m_bar_mc.scaleX = 0;
			
			alpha = 0;
			show();
			resizingCenter = m_resizingCenter;
			
			addEventListener(Event.ENTER_FRAME, onProgress);
		}
		
		private function onProgress(e:Event):void
		{
/*			var nextPct:Number = m_bar_mc.scaleX + 0.04;
			if (nextPct <= m_pct)
			{
				m_bar_mc.scaleX = nextPct;
			}
			
			if (nextPct >= 1)
			{
				m_bar_mc.scaleX = 1;
			}
*/
		}
		
		public function set progress(pct:Number):void
		{
			m_pct = pct;
			Tweener.addTween(m_bar_mc, { scaleX:pct, time:1,transition:"easeoutquart" } );
		}
		
		public function get progress():Number
		{
			return m_bar_mc.scaleX;
		}

		private function onRemoved(evt:Event = null):void 
		{
			graphics.clear();
			
			removeEventListener(Event.ENTER_FRAME, onProgress);
			removeEventListener(Event.ADDED_TO_STAGE, addedToStage);
			removeEventListener(Event.REMOVED_FROM_STAGE , onRemoved);

			removeEventListener(Event.ENTER_FRAME , fadeIn);
			removeEventListener(Event.ENTER_FRAME , fadeOut);
			
			if(stage)
				stage.removeEventListener(Event.RESIZE, resizeStage);

		}
		
		/**
		 * 表示します。
		 */
		private function show():void 
		{
			this.visible = true;
			removeEventListener(Event.ENTER_FRAME , fadeOut);
			addEventListener(Event.ENTER_FRAME , fadeIn);
		}
		
		private function fadeIn(evt:Event):void 
		{
			this.alpha = Math.min(this.alpha + fadeInSpeed, 1);
			if (this.alpha == 1)
				removeEventListener(Event.ENTER_FRAME , fadeIn);
		}

		/**
		 * 非表示にします。
		 * 
		 * @param	didHided
		 * @param	fadeOutSpeed
		 */
		public function hide(didHided:Function = null, fadeOutSpeed:Number = 0.1):void
		{
			removeEventListener(Event.ENTER_FRAME , fadeIn);
			addEventListener(Event.ENTER_FRAME , fadeOut);
			this.didHided = didHided;
			this.fadeOutSpeed = fadeOutSpeed;
		}
		
		private function fadeOut(evt:Event):void 
		{
			this.alpha = Math.max(this.alpha - fadeOutSpeed, 0);
			if (this.alpha == 0) {
				this.visible = false;
				removeEventListener(Event.ENTER_FRAME , fadeOut);
				
				if(didHided!=null){
					didHided.apply(null, []);
				}
			}
		}
		
		/**
		 * 指定したRectangleの中央に座標を設定します。
		 */
		public function setPositionWithRect(drawRect:Rectangle):void
		{
			x = drawRect.x + drawRect.width / 2;
			y = drawRect.y + drawRect.height / 2;
		}

		/**
		 * ステージの中央に配置するかどうかを返却します。
		 */
		public function get resizingCenter():Boolean { return m_resizingCenter; }
		
		public function set resizingCenter(value:Boolean):void 
		{
			if (stage)
				stage.removeEventListener(Event.RESIZE, resizeStage);

			m_resizingCenter = value;

			if (m_resizingCenter && stage) {
				stage.addEventListener(Event.RESIZE, resizeStage);
				resizeStage();
			}
			
		}
		
		private function resizeStage(evt:Event = null):void 
		{

			x = Math.round(stage.stageWidth / 2);
			y = Math.round(stage.stageHeight / 2);
			y += 40;
		}
		
		/**
		 * クラスの完全修飾名を返却します。
		 * 
		 * @return
		 */
		public override function toString():String
		{
			return "jp.co.shed.display.ActivityIndicator(";
		}
		
	}
	
}