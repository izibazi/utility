package jp.co.shed.graphics 
{
	import flash.display.BitmapData;
	import flash.display.Graphics;
	import flash.display.MovieClip;
	import flash.display.Shape;
	import flash.geom.Point;
	/**
	 * ...
	 * @author yasunari ishibashi
	 */
	public class Circle implements iGraphics
	{
		public static const toDegree:Number = 180 / Math.PI;
		
		public static const toRadian:Number = Math.PI / 180;
		
		private var m_anglePerPoint:Number;
		
		private var m_numOfPoint:int;
		
		private var m_points_ary:Array;

		public function Circle(anglePerPoint:Number = 360)
		{

			this.anglePerPoint = anglePerPoint;		
		}
		
		public function clone():Circle
		{
			var c:Circle = new Circle();
			c.m_anglePerPoint = m_anglePerPoint;
			c.m_numOfPoint = m_numOfPoint;
			c.m_points_ary = m_points_ary.concat([]);
			return c;
		}
		
		public function set anglePerPoint(angle:Number):void
		{
			m_anglePerPoint = angle;
			m_numOfPoint = 360 / m_anglePerPoint;
			
			var degree:Number = 0;
			var radian:Number = 0;
			m_points_ary = [];
			for (var i:int = 0; i < m_numOfPoint; i++ )
			{
				radian = degree * toRadian;
				m_points_ary.push(new Point(Math.cos(radian), Math.sin(radian)));
				degree += m_anglePerPoint;
			}	
		}
		
		public function get anglePerPoint():Number
		{
			return m_anglePerPoint;
		}	
		
		public function get numOfPoint():Number
		{
			return m_numOfPoint;
		}	
		
		public function get points_ary():Array 
		{ 
			return m_points_ary; 
		}
		
		/**
		 * 円を描きます。
		 * 
		 * @param	graphics
		 * @param	radius
		 * @param	baseColor
		 * @param	baseAlpha
		 * @param	line
		 * @param	lineColor
		 * @param	lineAlpha
		 */
		public function drawCircle(	graphics:Graphics,
									radius:Number, 
									baseColor:Number = 0xFFFFFF, 
									baseAlpha:Number = 1, 
									line:Number = 0, 
									lineColor:Number = 0, 
									lineAlpha:Number = 0):void
		{
			if (lineAlpha > 0)
			{
				graphics.lineStyle(line, lineColor, lineAlpha);
			}
			
			graphics.beginFill(baseColor, baseAlpha);
			var p:Point = m_points_ary[i];
			var sP:Point = p;
			graphics.moveTo(p.x * radius, p.y * radius);
			for (var i:uint = 0; i < m_numOfPoint; i++ )
			{
				p = m_points_ary[i];
				graphics.lineTo(p.x * radius, p.y * radius);
			}
			
			graphics.lineTo(sP.x * radius, sP.y * radius);
			graphics.endFill();
		}
		
		/**
		 * 円のShapeを返却します。
		 * 
		 * @param	radius
		 * @param	baseColor
		 * @param	baseAlpha
		 * @param	line
		 * @param	lineColor
		 * @param	lineAlpha
		 * @return
		 */
		public function makeCircle(	radius:Number, 
									baseColor:Number = 0xFFFFFF, 
									baseAlpha:Number = 1, 
									line:Number = 0, 
									lineColor:Number = 0, 
									lineAlpha:Number = 0):Shape
		{
			var mc:Shape = new Shape();
			drawCircle(mc.graphics, baseColor, baseAlpha, line, lineColor, lineAlpha);
			
			return mc;
		}
		
		/**
		 * 扇形を描きます。
		 * 
		 * @param	graphics
		 * @param	radiusS
		 * @param	radiusL
		 * @param	numOfPoint
		 * @param	baseColor
		 * @param	baseAlpha
		 * @param	line
		 * @param	lineColor
		 * @param	lineAlpha
		 */
		public function drawSector(	graphics:Graphics,
									radiusS:Number = 10,
									radiusL:Number = 30,
									startPointIndex:int = 10,
									endPointIndex:int = 20,
									baseColor:Number = 0xFF0000, 
									baseAlpha:Number = 1, 
									line:Number = 0, 
									lineColor:Number = 0, 
									lineAlpha:Number = 0):void
		{
			if (startPointIndex > endPointIndex)
			{
				var temp:int = startPointIndex;
				startPointIndex = endPointIndex;
				endPointIndex = temp;
			}
			if (lineAlpha > 0)
			{
				graphics.lineStyle(line, lineColor, lineAlpha);
			}
			if (baseAlpha > 0)
			{
				graphics.beginFill(baseColor, baseAlpha);
			}
			
			var i:int;
			var p:Point = m_points_ary[startPointIndex];
			var sP:Point = p;
			graphics.moveTo(p.x * radiusS, p.y * radiusS);
			
			//endPointIndexがポイント総数より大きいか調べる。
			var len:int = endPointIndex >= m_numOfPoint?(m_numOfPoint - 1):endPointIndex;
			for (i = startPointIndex; i <= len; i++ )
			{
				//if (i >= m_numOfPoint) continue;
				p = m_points_ary[i];
				graphics.lineTo(radiusS * p.x, radiusS * p.y);
			}
			
			if (endPointIndex == numOfPoint)
			{
				graphics.lineTo(radiusS * m_points_ary[0].x, radiusS * m_points_ary[0].y);
				graphics.lineTo(radiusL * m_points_ary[0].x, radiusL * m_points_ary[0].y);
			}
			
			for (i = len ; i >= startPointIndex; i-- )
			{
				//if (i >= m_numOfPoint) continue;
				p = m_points_ary[i];			
				graphics.lineTo(radiusL * p.x, radiusL * p.y);
			}

			graphics.lineTo(radiusS * sP.x, radiusS * sP.y);
			if (baseAlpha > 0)
			{
				graphics.endFill();
			}
		}
		
		public function makeSector(	radiusS:Number = 10,
									radiusL:Number = 30,
									startPointIndex:int = 10,
									endPointIndex:int = 20,
									baseColor:Number = 0xFF0000, 
									baseAlpha:Number = 1, 
									line:Number = 0, 
									lineColor:Number = 0, 
									lineAlpha:Number = 0):Shape
		{
			var mc:Shape = new Shape();
			drawSector(mc.graphics, radiusS, radiusL, startPointIndex, endPointIndex, baseColor, baseAlpha, line, lineColor, lineAlpha);
			return mc;
		}
		
		/**
		 * 
		 * @param	degree
		 * @param	radius
		 * @return
		 */
		public function getPoint(degree:Number, radius:Number):Point
		{
			var radian:Number = degree * toRadian;
			var x:Number = Math.cos(radian) * radius;
			var y:Number = Math.sin(radian) * radius;
			return new Point(x, y);
		}
		
		/**
		 * 
		 * @param	pointIndex
		 * @param	radius
		 * @return
		 */
		public function getPointByPointIndex(pointIndex:int, radius:Number):Point
		{
			var p:Point = m_points_ary[pointIndex];
			return new Point(p.x * radius, p.y * radius);
		}
		

		public function getNumOfPoint(width:Number, radius:Number):int
		{
			var num:int = 0;
			var w:Number = 0;
			var radian:Number = 0;
			
			while (w < width)
			{
				num++;
				radian = (num * anglePerPoint) * toRadian;
				var x:Number = Math.cos(radian) * radius;
				var y:Number = Math.sin(radian) * radius;
			
				w = Point.distance(new Point(radius, 0), new Point(x, y));
				//trace(w)
			}
			
			return num;
		}
	}

}