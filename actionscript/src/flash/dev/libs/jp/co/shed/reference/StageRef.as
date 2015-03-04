package jp.co.shed.reference
{
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Stage;
	import flash.display.StageAlign;
	import flash.display.StageDisplayState;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.system.Capabilities;
	import flash.system.System;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	
	import jp.co.shed.events.StageRefEvent;
	
	/**
	 * stageへの参照を保持し、管理するシングルトンクラス。
	 * 
	 * @author yasunari ishibashi
	 */
	public class StageRef extends EventDispatcher
	{
		
		public static const NORMAL_W:int = 800;
		
		public static const NORMAL_H:int = 600;
		
		private static var stageRef:StageRef;
		
		private var m_stage:Stage;
		
		private var m_mainTimeline:MovieClip;
		
		private var m_normalW:int = NORMAL_W;
		
		private var m_normalH:int = NORMAL_H;
		
		private var m_maxW:int = int.MAX_VALUE;
		
		private var m_maxH:int = int.MAX_VALUE;
		
		private var m_minW:int = NORMAL_W;
		
		private var m_minH:int = NORMAL_H;
		
		private var m_isNet:Boolean;
		
		private var m_useFocusRect:Boolean;
		
		private var m_locking:Boolean;
		
		/*ロック時背景インスタンス*/
		private var lock_mc:MovieClip;
		
		/*ロック時背景の表示スピード*/
		private var displayBaseSpeed:Number = .2;

		/**
		 * コンストラクタ。
		 * このクラスはシングルトンクラスです。
		 * 
		 * @param	singleton
		 */
		public function StageRef(singleton:*)
		{
			if (!(singleton is Singleton))
				throw new Error("StageRef is singleton")
		}
		
		public static function getInstance():StageRef
		{
			if (!StageRef.stageRef)
				StageRef.stageRef = new StageRef(new Singleton());
			
			return StageRef.stageRef;
		}
		
		/**
		 * 初期化します。
		 * このメソッドは一度だけ実行可能です。
		 * align="TL",scaleMode="noScale"は、指定を使用することをお勧めします。
		 * 
		 * @param	mainTimeline		使用するメインライムラインへの参照
		 * @param	displayFocusRect	フォーカスレクトを使用するかどうかの真偽値	default:false
		 * @param	align				stage.alignの値					default:"TL"
		 * @param	scaleMode			stage.scaleModeの値				default:"noScale"
		 */
		public function init(mainTimeline:MovieClip, displayFocusRect:Boolean = false, align:String = "TL", scaleMode:String = "noScale"):void 
		{
			if (this.m_stage) 
			{
				trace(toString() + "すでに初期化されています。");
				dump();
				return ;
			}
			this.m_stage = mainTimeline.stage;
			this.m_stage.align = align;
			this.m_stage.scaleMode = scaleMode;
			this.m_mainTimeline = mainTimeline;
			this.m_isNet = this.m_stage.loaderInfo.url.substr(0, 4) == "http";
			this.m_useFocusRect = displayFocusRect;
			this.m_stage.stageFocusRect = displayFocusRect;
			
			stage.addEventListener(Event.MOUSE_LEAVE, onMouseLeave);
			stage.addEventListener(Event.FULLSCREEN, onFullScreenChange);
			stage.addEventListener(Event.RESIZE, onStageResize);
		}
		
		private function onStageResize(evt:Event):void
		{
			var event:StageRefEvent = new StageRefEvent(StageRefEvent.RESIZE, this);
			dispatchEvent(event);			
		}
		
		private function onMouseLeave(evt:Event):void 
		{
			var event:StageRefEvent = new StageRefEvent(StageRefEvent.MOUSE_LEAVE, this);
			event.mouseLeave = true;
			dispatchEvent(event);
		}
		
		private function onFullScreenChange(evt:Event):void 
		{
			dispatchEvent(new StageRefEvent(StageRefEvent.FULL_SCREEN, this));
		}
		
		/**
		 * フルスクリーンかどうかを返却します。
		 * 
		 * @return フルスクリーンかどうかの真偽値。
		 */
		public function get fullScreen():Boolean 
		{
			return stage.displayState == StageDisplayState.FULL_SCREEN;
		}
		
		public function set fullScreen(bool:Boolean):void 
		{
			if (bool && !fullScreen)
			{
				stage.displayState = StageDisplayState.FULL_SCREEN;
			}
			else if (!bool && fullScreen) 
			{
				stage.displayState = StageDisplayState.NORMAL;
			}
		}
		
		/**
		 * フルスクリーン時のステージ幅を返却します。
		 * 
		 * これはモニタのピクセル幅であり、Stage.align が StageAlign.TOP_LEFT に設定され、
		 * Stage.scaleMode が StageScaleMode.NO_SCALE に設定された場合には、ステージ幅と同じになります。
		 * 
		 * @return フルスクリーン時のステージ幅
		 */
		public function get fullScreenW():uint 
		{
			return stage.fullScreenWidth;
		}
		
		/**
		 * フルスクリーン時のステージ高を返却します。
		 * 
		 * これはモニタのピクセルの高さであり、Stage.align が StageAlign.TOP_LEFT に設定され、
		 * Stage.scaleMode が StageScaleMode.NO_SCALE に設定された場合には、ステージの高さと同じになります。
		 * 
		 * @return フルスクリーン時のステージ高
		 */		
		public function get fullScreenH():uint 
		{
			return stage.fullScreenHeight;
		}
		
		/**
		 * フルスクリーンの矩形を返却します。
		 * 
		 * 矩形のサイズに最小限度が適用されます。通常、この限度は約 260 × 30 ピクセルですが、
		 * プラットフォームおよび Flash Player のバージョンによって異なる場合があります。
		 * 無効にするには、ActionScript 3.0 では fullScreenSourceRect=null に設定します。
		 */
		public function get fullScreenRect():Rectangle
		{
			return stage.fullScreenSourceRect;
		}
		
		public function set fullScreenRect(rect:Rectangle):void
		{
			stage.fullScreenSourceRect = rect;
		}
		
		/**
		 * normal,min,maxそれぞれの値を設定します。
		 * 
		 * @param	newNormalW 標準ステージ幅 default:800
		 * @param	newNormalH 標準ステージ高 default:600
		 * @param	newMinW 最小ステージ幅 default:800
		 * @param	newMinH	最小ステージ幅 default:600
		 * @param	newMaxW	最大ステージ幅 default:int.MAX_VALUE
		 * @param	newMaxH	最大ステージ幅 default:int.MAX_VALUE
		 */
		public function setStageSize(newNormalW:int = 800, newNormalH:int = 600, newMinW:int = 800, newMinH:int = 600, newMaxW:int = -1, newMaxH:int = -1):void
		{
			normalW = newNormalW;
			normalH = newNormalH;
			minW = newMinW;
			minH = newMinH;
			maxW = newMaxW;
			maxH = newMaxH;
		}

		/**
		 * stageインスタンスへの参照を返却します。
		 * 
		 * @return stageへの参照。
		 */
		public function get stage():Stage { return m_stage; }
		
		/**
		 * メインタイムラインへの参照を返却します。
		 * 
		 * @return メインタイムラインへの参照。
		 */
		public function get mainTimeline():MovieClip { return m_mainTimeline; }
		
		/**
		 * 現在のstage.stageWidthの値を返却します。
		 * 
		 * @return stage.stageWidth
		 */
		public function get w():int 
		{
			return stage.stageWidth;
		}
		
		/**
		 * 現在のstage.stageHeightの値を返却します。
		 * 
		 * @return stage.stageHeight
		 */
		public function get h():int
		{
			return stage.stageHeight;
		}
		
		/**
		 * 現在の有効なステージ幅を返却します。
		 * 
		 * @return 現在の有効なステージ幅。
		 */
		public function get validW():int 
		{
			return (this.w > this.maxW)?this.maxW:((this.w < this.minW)?this.minW:this.w);
		}
		
		/**
		 * 現在の有効なステージ高を返却します。
		 * 
		 * @return 現在の有効なステージ高。
		 */
		public function get validH():int
		{
			return (this.h > this.maxH)?this.maxH:((this.h < this.minH)?this.minH:this.h);
		}
		
		/**
		 * 最小ステージ幅を返却します。 default:800
		 * 
		 * @default NORMAL_W = 800	
		 * @return 最小ステージ幅。
		 */
		public function get minW():int
		{ 
			return m_minW; 
		}
		
		public function set minW(value:int):void
		{
			m_minW = value < 0?0:value;
		}
		
		/**
		 * 最小ステージ高を返却します。 default:600
		 * 
		 * @default NORMAL_H = 600
		 * @return 最小ステージ高。
		 */
		public function get minH():int 
		{ 
			return m_minH; 
		}
		
		public function set minH(value:int):void
		{
			m_minH = value < 0?0:value;
		}
		
		/**
		 * 最大ステージ幅を返却します。 default:int.MAX_VALUE
		 * 
		 * @default Number.MAX_VALUE;
		 * @return 最大ステージ幅。
		 */			
		public function get maxW():Number 
		{ 
			return m_maxW; 
		}
	
		public function set maxW(value:Number):void
		{
			m_maxW = value <= 0?int.MAX_VALUE:value;
		}
		
		/**
		 * 最大ステージ高を返却します。 default:Number.MAX_VALUE
		 * 
		 * @default Number.MAX_VALUE;
		 * @return 最大ステージ高。
		 */		
		public function get maxH():int 
		{ 
			return m_maxH; 
		}
		
		public function set maxH(value:int):void
		{
			m_maxH = value <= 0?int.MAX_VALUE:value;
		}
		
		/**
		 * 標準(flaファイル)のステージ幅を返却します。デフォルト値をして使用します。[default:800]
		 * 
		 * @default NORMAL_W = 800
		 * @return 標準(flaファイル)のステージ幅。
		 */		
		public function get normalW():int
		{ 
			return m_normalW; 
		}
		
		public function set normalW(value:int):void 
		{
			m_normalW = value;
		}
		
		/**
		 * 標準(flaファイル)のステージ高を返却します。デフォルト値をして使用します。[default:600]
		 * 
		 * @default NORMAL_H = 600
		 * @return 標準(flaファイル)のステージ高。
		 */
		public function get normalH():int 
		{ 
			return m_normalH; 
		}
		
		public function set normalH(value:int):void 
		{
			m_normalH = value;
		}

		/**
		 * validW / normalWの値を返却します。(ステージ幅の拡大率です。)
		 * 
		 * @return ステージ幅の拡大率。
		 */
		public function get scaleX():Number 
		{
			return validW / normalW;
		}

		/**
		 * validH / normalHの値を返却します。(ステージ高の拡大率です。)
		 * 
		 * @return ステージ高の拡大率。
		 */
		public function get scaleY():Number
		{
			return validH / normalH;
		}
		
		/**
		 * ステージのサイズと同じ大きさに変更します。
		 * 
		 * @param	target
		 */
		public function scaleToStage(target:DisplayObject):void 
		{
			target.width = w;
			target.height = h;
		}
		
		/**
		 * stage.mouseXの値を返却します。
		 * 
		 * @return stage.mouseX
		 */
		public function get mouseX():Number 
		{
			return stage.mouseX;
		}
		
		/**
		 * stage.mouseYの値を返却します。
		 * 
		 * @return stage.mouseY
		 */		
		public function get mouseY():Number 
		{
			return stage.mouseY;
		}
		
		/**
		 * stage.mouseX, stage.mouseYの値を保持したPointオブジェクトを返却します。
		 * 
		 * @return stage.mouseX,stage.mouseYのPointオブジェクト。
		 */
		public function get mousePoint():Point
		{
			return new Point(stage.mouseX, stage.mouseY);
		}

		/**
		 * Math.round((validW - normalW) / 2)の値を返却します。
		 * 
		 * @return　中央となる左上のx座標。
		 */
		public function get centerX():int 
		{
			return Math.round((validW - normalW) / 2);
		}

		/**
		 * Math.round((validH - normalH) / 2)の値を返却します。
		 * 
		 * @return　中央となる左上のy座標。
		 */		
		public function get centerY():int 
		{
			return Math.round((validH - normalH) / 2);
		}
		
		/**
		 * centerX,centerYの値を保持したPointオブジェクトを返却します。
		 */
		public function get centerPoint():Point
		{
			return new Point(centerX, centerY);
		}
		
		/**
		 * centerX,centerYの座標を、設定します。
		 * 
		 * @param	target
		 */
		public function positionCenter(target:DisplayObject, reverse:Boolean = false):void {
			if (!reverse)
			{
				target.x = centerX;
				target.y = centerY;
			}
			else
			{
				target.x = -centerX;
				target.y = -centerY;				
			}
		}
		
		/**
		 * サーバ上かどうかを返却します。
		 * [read-only]
		 * 
		 * @return サーバ上かどうかの真偽値。
		 */
		public function get isNet():Boolean { return m_isNet; }

		/**
		 * フォーカスレクトを使用するかどうかを返却します。
		 * 
		 * @return focusRectを使用するかどうかの真偽値。
		 */
		public function get useFocusRect():Boolean 
		{ 
			return m_useFocusRect; 
		}
		
		public function set useFocusRect(value:Boolean):void 
		{
			m_useFocusRect = value;
			if (stage != null && stage.stageFocusRect && !useFocusRect )
				stage.stageFocusRect = false;
		}

		/**
		 * ロック中かどうかを返却します。[read-only]
		 * 
		 * @return ロック中かどうかの真偽値。
		 */
		public function get locking():Boolean 
		{ 
			return m_locking; 
		}
		
		/**
		 * ステージ全体をロックします。
		 * 
		 * @param	displayBase 背景を表示するかどうかの真偽値。 default:false		
		 * @param	color 背景色。 default:0	
		 * @param	alpha 透明度。 default:.8	
		 * @param	animated フェードインするかどうかの真偽値。 default:false	
		 * @param	newDisplayBaseSpeed	 フェードインのスピード。default:.2	
		 */
		public function lock(displayBase:Boolean = false, color:Number = 0, alpha:Number = .8, animated:Boolean = false, newDisplayBaseSpeed:Number = .2):void 
		{
			
			
			stage.mouseChildren = false;
			stage.stageFocusRect = false;
			stage.focus = stage;
			displayBaseSpeed = newDisplayBaseSpeed;
			
			removeBase();
			
			if (displayBase)
			{
				if (stage.align != StageAlign.TOP_LEFT || stage.scaleMode != StageScaleMode.NO_SCALE) 
				{
					trace(toString() + "lock() : ロック中の背景を作成できません。. StageAlign.TOP_LEFT、StageScaleMode.NO_SCALEである必要があります。");
					return;
				}
				createBase(color, alpha, animated);
			}
			
			if (!locking)
			{
				m_locking = true;
				dispatchEvent(new StageRefEvent(StageRefEvent.LOCK, this));
			}
		}
		
		private function createBase(color:Number = 0, alpha:Number = 0, animated:Boolean = false):void 
		{
			lock_mc = new MovieClip();

			stage.addEventListener(Event.RESIZE, __onStageResize);
			stage.addChild(lock_mc);
			
			lock_mc.graphics.beginFill(color, alpha);
			lock_mc.graphics.drawRect(0, 0, w, h);
			lock_mc.graphics.endFill();
			lock_mc.width = w;
			lock_mc.height = h;
			if (animated) 
			{
				lock_mc.alpha = 0;
				lock_mc.addEventListener(Event.ENTER_FRAME, animate);
			}
		}
		
		private function animate(evt:Event) :void 
		{
			lock_mc.alpha = Math.min(1, lock_mc.alpha + displayBaseSpeed);
			if (lock_mc.alpha == 1)
				lock_mc.removeEventListener(Event.ENTER_FRAME, animate);

		}
		
		private function __onStageResize(evt:Event):void 
		{
			lock_mc.width = w;
			lock_mc.height = h;
			
		}
		
		private function removeBase():void 
		{
			if (lock_mc != null)
			{
				stage.removeChild(lock_mc);
				lock_mc.removeEventListener(Event.ENTER_FRAME, animate);
				stage.removeEventListener(Event.RESIZE, __onStageResize);
				lock_mc = null;
			}
		}
		
		/**
		 * ステージ全体のロックを解除します。
		 */
		public function unlock():void 
		{
			if (!locking)
				return;
			
			stage.stageFocusRect = useFocusRect;
			stage.mouseChildren = true;
			
			removeBase();
			
			m_locking = false;
			dispatchEvent(new StageRefEvent(StageRefEvent.LOCK, this));
		}
		
		/**
		 * 指定されたurlのページを開きます。
		 * 
		 * @param value:{url値},target:{window値}をキーとしたObject。
		 */
		public function openURL(url_obj:Object):void
		{
			if (url_obj == null)
			{
				trace(toString() + "openURL() : url_objの値がnullです。");
				return;
			}
			
			var target:String=url_obj.target;
			var url:String = url_obj.value;
			
			if (url == null)
			{
				trace(toString() + "openURL() : url_obj.valueの値がnullです。");
				return;
			}
			
			trace(toString() + "openURL() : url='" + url + "',target='" + target + "'");
			try
			{
				navigateToURL(new URLRequest(url) , target);
			}
			catch (e:Error)
			{
				
			}
		}
		
		/**
		 * osがwindowsかどうかを返却します。
		 * 
		 * @return OSがWindowsどうかの真偽値。
		 */
		public function get isWin():Boolean 
		{
			return os.indexOf("Windows") >= 0;
		}
		
		/**
		 * macかどうかを返却します。
		 */
		public function get isMac():Boolean
		{
			return !isWin;
		}
		
		/**
		 * OS名を返却します。
		 * 
		 * @return クライアントマシンのOS名。
		 */
		public function get os():String
		{
			return Capabilities.os;
		}

		/**
		 * isNetがtrueの場合は、ランダムなキャッシュを防ぐための値"?noCache={randomValue}"を返却します。
		 * isNetがfalseの場合は、空のストリング""が返却されます。
		 * 
		 * return キャッシュを防ぐためのランダムな文字列。
		 */
		public function get noCache():String
		{
			return isNet?"?noCache=" + Math.ceil(Math.random() * 1000000000):"";
		}
		
		/**
		 * このオブジェクトの詳細情報を出力,返却します。
		 * 
		 * @return 詳細情報。
		 */
		public function dump():String
		{
			var s:String = toString();
			s += "dump [";
			s += "stage='" + stage + "',";
			s += "mainTimeline='" + mainTimeline + "',";
			s += "normalW='" + normalW + "',";
			s += "normalH='" + normalH + "',";
			s += "minW='" + minW + "',";
			s += "minH='" + minH + "',";
			s += "maxW='" + maxW + "',";
			s += "maxH='" + maxH + "',";
			s += "useFocusRect='" + useFocusRect + "',";
			s += "locking='" + locking + "',";
			s += "isNet='" + isNet + "']";
			
			trace(s);
			
			return s;
		}
		
		/**
		 * クラスの完全修飾名を返却します。
		 * 
		 * @return クラスの完全修飾名
		 */
		public override function toString():String
		{
			return "jp.co.shed.reference.StageRef(";
		}
	}
}

class Singleton
{

}