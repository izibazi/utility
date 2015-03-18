package jp.co.shed.display 
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.filters.DropShadowFilter;
	import flash.geom.Rectangle;
	import flash.utils.getDefinitionByName;
	import jp.co.shed.utils.ClassUtils;

	/**
	 * アクティビティインディケーターの表示を管理します。
	 * 
	 * UIKitのUIActivityIndicatorのようなクラスです。
	 * 
	 * @author yasunari ishibashi
	 */
	public class SDActivityIndicator extends MovieClip
	{
		
		public static var hidden:Boolean = false;
		
		private var ary:Array;
		
		private var half:int;

		private var i:uint = 0;
		
		private var t :uint = 0;

		private var didHided:Function;
		
		private var m_fadeOutSpeed:Number = 0.3;
		
		private var m_fadeInSpeed:Number = 0.3;
		
		private var m_animationSpeed:uint = 2;
		
		private var m_resizingCenter:Boolean;
		
		private var parts_mc:MovieClip;
		
		private var base_mc:MovieClip;

		private var numOfParts:int;
		
		private var drawColor:Number;
		
		private var drawX:Number;
		
		private var drawY:Number;
		
		private var drawW:Number;
		
		private var drawH:Number;
		
		private var drawEllipseW:Number;
		
		private var drawEllipseH:Number;
		
		private var container_mc:MovieClip;
		
		/**
		 * デフォルトコンストラクタ。
		 */
		public function SDActivityIndicator() 
		{
			addEventListener(Event.ADDED_TO_STAGE, addedToStage);
		}
		
		private function init():void 
		{
			onRemoved();

			container_mc = new MovieClip();
			addChild(container_mc);
			
			if (hidden)
			{
				container_mc.visible = false;
			}
			
			addEventListener(Event.REMOVED_FROM_STAGE , onRemoved);
			alpha = 0;

			base_mc = new MovieClip();
			base_mc.alpha = .3;
			container_mc.addChild(base_mc);
			
			parts_mc = new MovieClip();
			container_mc.addChild(parts_mc);

			ary = [];
			var rotateValue:Number = 360 / numOfParts;
			
			for (var i:uint = 0; i < numOfParts; i++ ) {				
				var mc:MovieClip = makePart();
				parts_mc.addChild(mc);
				mc.rotation = rotateValue * i;

				ary.push(mc);
				mc.alpha = 0;
				
				mc.base_mc = mc = makePart();
				base_mc.addChild(mc);
				mc.rotation = rotateValue * i;
			}

			half = ary.length / 2;
			addEventListener(Event.ENTER_FRAME , run);
		}
		
		private function addedToStage(e:Event = null):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, addedToStage);
			resizingCenter = m_resizingCenter;
		}
		
		/**
		 * 表示します。
		 * 
		 * @param	color
		 * @param	numOfParts
		 * @param	x
		 * @param	y
		 * @param	w
		 * @param	h
		 * @param	ellipseW
		 * @param	ellipseH
		 */
		public function showWithRoundRect(color:Number = 0xFFFFFF, numOfParts:int = 12, x:Number = 7.7, y:Number = -1.7, w:Number = 8.8, h:Number = 3.4, ellipseW:Number =  3, ellipseH:Number = 3, bitmapName:String = "activity_indicator_part.png"):void
		{
			this.numOfParts = numOfParts;
			drawColor = color;
			
			drawX = x;
			drawY = y;
			drawW = w;
			drawH = h;
			drawEllipseH = ellipseH;
			drawEllipseW = ellipseW;
			
			init();
			show();
			if (bitmapName)
			{
				partsBitmapName = bitmapName;
			}
			resizingCenter = m_resizingCenter;
		}
		
		public function set partsBitmapName(bitmapName:String):void
		{
			for (var i:uint = 0; i < numOfParts; i++ ) {				
				var mc:MovieClip = ary[i];
				mc.bt = makeBitmap(bitmapName);
				if (mc.bt == null) return;
				
				mc.addChild(mc.bt);
				mc.graphics.clear();
				mc.base_mc.graphics.clear();
				mc.base_mc.bt = makeBitmap(bitmapName);
				mc.base_mc.addChild(mc.base_mc.bt);
			}
			
			container_mc.filters = [new DropShadowFilter(3, 45, 0, .1)];
		}
		
		private function makeBitmap(name:String):Bitmap
		{
			try
			{
				var classRef:Class = getDefinitionByName(name) as Class;
				var btmd:BitmapData = new classRef(0,0) as BitmapData;
				var bt:Bitmap = new Bitmap(btmd, "auto", true);
					
				bt.y = -bt.height * .5;
				bt.x = drawX;				
			}
			catch (e:Error)
			{
				
			}
			
			return bt;
		}

		private function makePart():MovieClip
		{
			var part_mc:MovieClip = new MovieClip();
			part_mc.graphics.beginFill(drawColor, 1);
			part_mc.graphics.drawRoundRect(drawX, drawY, drawW, drawH, drawEllipseW, drawEllipseH);
			part_mc.graphics.endFill();
			
			return part_mc;
		}
		
		private function onRemoved(evt:Event = null):void 
		{
			if (ary == null) return;
			
			for (var i:uint = 0; i < ary.length; i++ )
			{
				var mc:MovieClip = ary[i];
				mc.removeEventListener(Event.ENTER_FRAME , fadeInOut);
				if (mc.bt)
				{
					mc.bt.bitmapData.dispose();
					mc.base_mc.bt.bitmapData.dispose();
					//trace("aa");
				}
			}
			ary = null;
			
			if (parts_mc)
			{
				container_mc.removeChild(parts_mc);
				container_mc.removeChild(base_mc);
				parts_mc = base_mc = null;
				removeChild(container_mc);
				container_mc = null;
			}

			removeEventListener(Event.ADDED_TO_STAGE, addedToStage);
			removeEventListener(Event.REMOVED_FROM_STAGE , onRemoved);
			
			removeEventListener(Event.ENTER_FRAME , run);
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
		
		private function run(evt:Event):void 
		{
			if (i % animationSpeed == 0)
			{
				var mc:MovieClip = ary[t];
				mc.flag = "IN";
				mc.addEventListener(Event.ENTER_FRAME , fadeInOut);
				t++;
				if (t >= ary.length)
					removeEventListener(Event.ENTER_FRAME , run);				
			}
			i++;	
		}
			
		private function fadeInOut(evt:Event):void 
		{
			var mc:MovieClip = evt.target as MovieClip;
			
			if (mc.flag == "IN") 
			{
				mc.alpha += 1 / half / animationSpeed;
				if (mc.alpha >= 1) 
				{
					mc.alpha = 1;
					mc.flag="OUT";
				}
			}
			else
			{
				mc.alpha -= 1 / half / animationSpeed;
				if (mc.alpha <= 0)
				{
					mc.alpha = 0;
					mc.flag = "IN";
				}
			}
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
		 * フェードインのスピードを返却します。[detault:.1 min:0 max:1]
		 */		
		public function get fadeInSpeed():Number { return m_fadeInSpeed; }
		
		public function set fadeInSpeed(value:Number):void 
		{
			m_fadeInSpeed = value;
		}
		
		/**
		 * フェードアウトのスピードを返却します。[detault:.1 min:0 max:1]
		 */
		public function get fadeOutSpeed():Number { return m_fadeOutSpeed; }
		
		public function set fadeOutSpeed(value:Number):void
		{
			m_fadeOutSpeed = value;
		}
		
		/**
		 * 回転するスピードを設定します。[default:2]
		 * 
		 * 大きいほど遅く回転します。
		 */
		public function get animationSpeed():uint { return m_animationSpeed; }
		
		public function set animationSpeed(value:uint):void 
		{
			m_animationSpeed = value;
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

			if (resizingCenter && stage) 
			{
				stage.addEventListener(Event.RESIZE, resizeStage);
				resizeStage();
			}
		}
		
		private function resizeStage(evt:Event = null):void 
		{
			x = Math.round(stage.stageWidth / 2);
			y = Math.round(stage.stageHeight / 2);
		}
		
		public function hideContainer():void
		{
			container_mc.visible = false;
		}
		
		public function showContainer():void
		{
			container_mc.visible = true;
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