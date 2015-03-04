package jp.co.shed.graphics 
{
	import flash.display.Graphics;
	import flash.display.MovieClip;
	import flash.geom.Point;

	import jp.co.shed.utils.MathUtils;
	
	import flash.display.JointStyle;
	import flash.display.LineScaleMode;
	import flash.display.CapsStyle;
	
	/**
	 * 円弧を描くクラス。
	 * 
	 * @author Shed ishibashi
	 */
	public class Arc
	{
		
		private var graphics:Graphics;
		
		private var target:MovieClip;
		
		public var centerX:Number;
		
		public var centerY:Number;
		
		public var width:Number;
		
		public var height:Number;
		
		public var start:Number;
		
		public var end:Number;
		
		public var useAngle:Boolean = false;
		
		public var stroke:Boolean = true;
		
		public var strokeWeight:Number = 1;
		
		public var strokeColor:Number = 0xFFFFFF;
		
		public var strokeAlpha:Number = 1;
		
		public var fillColor:Number = 0xFF0000;
		
		public var fillAlpha:Number = 1;
		
		private var fill:Boolean = true;
		
		public var dividingRadian:Number = Math.PI / 360;
		
		public var dividingAngle:Number = 1;
		
		private var closeArc:Boolean = false;
		
		public var strokePixelHinting:Boolean = false;
		
		public var strokeScaleMode:String = "normal";
		
		public var strokeCaps:String = null;
		
		public var strokeJoint:String = null;
		
		public var strokeMiterLimit:Number = 3;
	
		public static const toRadian:Number = Math.PI / 180;
		
		private var strokeMode:Boolean;
	
		/**
		 * コンストラクタ
		 * 
		 * @param	target
		 * @param	centerX
		 * @param	centerY
		 * @param	width
		 * @param	height
		 * @param	start
		 * @param	end
		 */
		public function Arc(target:MovieClip , centerX:Number = 0, centerY:Number = 0,width:Number=10,height:Number=10,start:Number=0,end:Number=6.14 ) 
		{
			this.target = target;
			this.graphics = target.graphics;
			this.graphics.clear();
			
			this.centerX = centerX;
			this.centerY = centerY;
			this.width = width;
			this.height = height;
			this.start = start;
			this.end = end;
			
			strokeCaps = CapsStyle.NONE;
			strokeScaleMode = LineScaleMode.NONE;
			strokeJoint = JointStyle.BEVEL;
		}
		
		/**
		 * 円弧を描きます。
		 */
		public function draw():void 
		{
			var startRadian:Number = start;
			var endRadian:Number = end;
			
			if (end < start) 
			{
				startRadian = end;
				endRadian = start;
			}
			
			if (useAngle)
			{
				startRadian = Arc.radian(start);
				endRadian = Arc.radian(end);
			}
			
			graphics.clear();
			drawStroke(startRadian , endRadian);
			drawFill(startRadian , endRadian);
		}
		
		private function drawFill(startRadian:Number , endRadian:Number):void 
		{
			if (!fill)
			{
				return;
			}
			strokeMode = false;
			
			graphics.beginFill(fillColor, fillAlpha);
			setPoints(startRadian , endRadian);
			setClosePoint(startRadian);
			graphics.endFill();		
			
			
		}
		
		private function drawStroke(startRadian:Number , endRadian:Number):void 
		{
			if (!stroke)
			{
				return;
			}
			strokeMode = true;
			
			graphics.beginFill(strokeColor, strokeAlpha);
			setPoints(startRadian , endRadian );
			setClosePoint(startRadian);
			graphics.endFill();
			
			if (closeArc)
			{
				setClosePoint(startRadian);
			}	
		}
		
		private function setClosePoint(startRadian:Number):void 
		{
			graphics.lineTo(centerX, centerY);
			var startPoint:Point = getPoint(startRadian);
			graphics.lineTo(startPoint.x, startPoint.y);			
		}
		
		private function setPoints(startRadian:Number , endRadian:Number):void 
		{
			var currentRadian:Number = startRadian;			
			var startPoint:Point = getPoint(startRadian);
			graphics.moveTo(startPoint.x, startPoint.y);
				
			var currentPoint:Point;
			while (currentRadian < endRadian)
			{					
				currentRadian += dividingRadian;
						
				currentRadian = Math.min(endRadian , currentRadian);
				if (currentRadian != endRadian)
				{
					currentPoint= getPoint(currentRadian);
					graphics.lineTo(currentPoint.x, currentPoint.y);
				}
			}
				
			var endPoint:Point = getPoint(endRadian);	
			graphics.lineTo(endPoint.x, endPoint.y);			
		}
		
		private function getPoint(radian:Number):Point 
		{
			var w:Number = width;
			var h:Number = height;
			
			
			if (!strokeMode)
			{
				if (stroke)
				{
					w = width - strokeWeight;
					h = height - strokeWeight;
				}
			}
			var x:Number = centerX + Math.cos(radian) * w;
			var y:Number = centerY + Math.sin(radian) * h;
			return new Point(x, y);
		}
		
		/**
		 * 角度からラジアンに変更して返却します
		 * 
		 * @param degree 角度
		 * 
		 * @return ラジアン値
		*/
		public static function radian(degree:Number):Number
		{
			return degree*toRadian;
		}

	}	
}