package jp.co.shed.utils 
{
	import flash.geom.Point;
	
	/**
	 * ...
	 * @author yasunari ishibashi
	 */
	public class PointUtils 
	{
		
		public static function limit(point:Point, distance:Number = 1):Point 
		{
			var p:Point = point;
			if (point.length > distance) {
				p = p.normalize(distance);
			}
			
			return p;
		}
		
		public static function multPoint(point_1:Point, point_2:Point):Point
		{
			return new Point(point_1.x * point_2.x, point_1.y * point_2.y);
		}
		
		public static function mult(point:Point , num:Number = 1):Point 
		{
			return new Point(point.x * num, point.y * num);
		}
		
		public static function div(point:Point , num:Number = 1):Point 
		{
			return new Point(point.x / num, point.y / num);
		}
		
		public static function divPoint(point_1:Point, point_2:Point):Point
		{
			return new Point(point_1.x / point_2.x, point_1.y/ point_2.y);
		}
		
		public static function magnitude(point:Point):Number 
		{
			return point.length * point.length;
		}
	}
	
}