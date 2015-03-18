package jp.co.shed.geom 
{
	
	/**
	 * 四元数による回転を行うクラス。（未完）
	 * 
	 * @author yasunari ishibashi
	 */
	public class Quaternion 
	{
		private var _w:Number;
		
		private var _x:Number;
		
		private var _y:Number;
		
		private var _z:Number;
		
		
		/**
		 * コンストラクタ
		 */
		public function Quaternion() 
		{
			
		}
		
		/**
		 * ノルムを返却します。
		 */
		public function norm():Number {
			return Math.sqrt(w * w + x * x + y * y + z * z);
		}
		
		/**
		 * 乗算します。
		 * 
		 * q1*d2=w1*w2-SCALR(u1 * u2)	+	w1*u2+w2*u1+CROSS(u1 x u2);
		 * 
		 * w=w1*w2-SCALR(u1 * u2);
		 * 
		 * 
		 * @param	qa
		 */
		public function multi(qa:Quaternion):void {
			var __w:Number = w * qa.w - (x * qa.x + y * qa.y + z * qa.z);
			
			var __x:Number = w * qa.x + qa.w * x + y * qa.z - z * qa.y;
			
			var __y:Number = w * qa.y + qa.w * y - (x * qa.z - z * qa.x);
			

			var __z:Number = w * qa.z + qa.w * z + (x * qa.y - y * qa.x);
			w = __w;
			x = __x;
			y = __y;
			z = __z;
		}
		
		public function get w():Number { return _w; }
		
		public function set w(value:Number):void 
		{
			_w = value;
		}
		
		public function get x():Number { return _x; }
		
		public function set x(value:Number):void 
		{
			_x = value;
		}
		
		public function get y():Number { return _y; }
		
		public function set y(value:Number):void 
		{
			_y = value;
		}
		
		public function get z():Number { return _z; }
		
		public function set z(value:Number):void 
		{
			_z = value;
		}
		
		public function setWXYZ(w:Number , x:Number , y:Number , z:Number):void {
			this.w = w;
			this.x = x;
			this.y = y;
			this.z = z;
		}
		
		public function toString():String {
			return ("w : " + w + " x : " + x + " y : " + y + " z : " + z);
		}
		
		public function dump():void {
			trace(toString());
		}
		
	}
	
}