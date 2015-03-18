package jp.co.shed.geom
{
	import flash.geom.Point;
	/**
	 * 
	 * 3次元ベクトルをカプセル化したクラス。
	 * 
	 * @author yasunari ishibashi
	 */
	public class Point3D
	{
			private var m_x:Number;
			
			private var m_y:Number;
			
			private var m_z:Number;
			
			/**
			 * コンストラクタ
			 *  
			 * @param x
			 * @param y
			 * @param z
			 * @return 
			 * 
			 */			
			public function Point3D(x:Number=0 , y:Number=0 , z:Number=0){
				this.x=x;
				this.y=y;
				this.z=z;
			}
			
			/**
			 * ベクトルのx成分を返却します。
			 * 
			 * @return 
			 * 
			 */			
			public function get x():Number{
				return m_x;
			}
			
			/**
			 *@private  
			 */			
			public function set x(value:Number):void{
				m_x=value;
			}
			
			/**
			 *  ベクトルのy成分を返却します。
			 * 
			 * @return 
			 * 
			 */			
			public function get y():Number{
				return m_y;
			}
			
			/**
			 * @private
			 */
			public function set y(value:Number):void{
				m_y=value;	
			}
			
			/**
			 *  ベクトルのz成分を返却します。
			 *  
			 * @return 
			 * 
			 */			
			public function get z():Number{
				return m_z;
			}
			
			/**
			 *@private  
			 */			
			public function set z(value:Number):void{
				m_z=value;
			}
			
			/**
			 * すべてを0にします。
			 * 
			 * @param	x
			 * @param	y
			 */
			public function reset():void {
				this.x = 0;
				this.y = 0;
				this.z = 0;
			}
			
			/**
			 * 指定したベクトルをコピーします。
			 * 
			 * @param	point3D
			 */
			public function copy(point3D:Point3D):void {
				this.x = point3D.x;
				this.y = point3D.y;
				this.z = point3D.z;
			}
			
			/**
			 * クローンを返却します。 
			 * @return 
			 * 
			 */			
			public function clone():Point3D{
				return new Point3D(x , y , z);
			}
			
			/**
			 * ベクトルの長さ(ノムル)を返却します。
			 * 
			 * @return
			 */
			public function get norm():Number {
				return Math.sqrt(this.x * this.x + this.y * this.y + this.z *  this.z);
			}
			
			public function get norm2():Number {
				return this.x * this.x + this.y * this.y + this.z *  this.z;
			}
			
			/**
			 * ベクトルを正規化します。
			 * 
			 * @return
			 */
			public function normalize():void {
				var norm:Number = this.norm;

				if( norm != 0 && norm != 1){
					this.x /= norm;
					this.y /= norm;
					this.z /= norm;
				}
			}
			
			/**
			 *  ベクトルを出力します。 
			 * 
			 */			
			public function toString():String{
				return ("jp.co.shed.geom.Point3D : \n" + 
						 "x = "+x +" , " + 
						 "y = "+y +" , " + 
						 "z = "+z);
			}
			
			/**
			 * 詳細を出力します。
			 */
			public function dump():void {
				trace(toString());
			}
			
			
			//static function 	-----------------------------------------------------------------------------
				
			/**
			 * 2つのベクトルの距離を返却します。
			 * @param	p1
			 * @param	p2
			 * @return
			 */
			public static function distance(p1:Point3D , p2:Point3D):Number {
				var dx:Number = p1.x - p2.x;
				var dy:Number = p1.y - p2.y;
				var dz:Number = p1.z - p2.z;
				
				return Math.sqrt(dx * dx + dy * dy + dz * dz);
			}
			
			/**
			 * 2つのベクトルの内積を返却します。
			 * 
			 * @param	p1
			 * @param	p2
			 * @return
			 */
			public static function scalar(p1:Point3D , p2:Point3D):Number {
				return (p1.x * p2.x + p1.y * p2.y + p1.z * p2.z);
			}

			/**
			 * 2つのベクトルの内積を返却します。
			 * 
			 * @param	p1
			 * @param	p2
			 * @return
			 */
			public static function dot(p1:Point3D , p2:Point3D):Number {
				return Point3D.scalar(p1, p2);
			}
			
			/**
			 * 2つのベクトルの外積を返却します。
			 * 
			 * @param	p1
			 * @param	p2
			 * @return
			 */
			public static function cross(p1:Point3D , p2:Point3D):Point3D {
				var p:Point3D = new Point3D((p2.y * p1.z - p2.z * p1.y), 
											(p2.z * p1.x - p2.x * p1.z), 
											(p2.x * p1.y - p2.y * p1.x));
				return p;
			}
			
			/**
			 * 加算結果を返却します。
			 * 
			 * @param	p1
			 * @param	p2
			 * @return
			 */
			public static function add(p1:Point3D , p2:Point3D):Point3D {
				var p:Point3D = new Point3D(p1.x + p2.x , p1.y + p2.y , p1.z + p2.z);
				return p;
			}
			
			/**
			 * 減算結果を返却します。
			 * 
			 * @param	p1
			 * @param	p2
			 * @return
			 */
			public static function sub(p1:Point3D , p2:Point3D):Point3D {
				var p:Point3D = new Point3D(p1.x - p2.x , p1.y - p2.y , p1.z - p2.z);
				return p;
			}
			
			/**
			 * p1を、p2に投影したベクトルを返却します。
			 * 
			 * @param	p1
			 * @param	p2
			 * @return
			 */
			public static function proj(p1:Point3D , p2:Point3D):Point3D {
				var p:Point3D = new Point3D();
				var scalar:Number = Point3D.scalar(p1, p2);
				
				var norm_2:Number = p2.norm2;
				var value:Number = scalar / norm_2;
				
				p.x =  value* p2.x;
				p.y = value * p2.y;
				p.z = value * p2.z;	
				
				return p;
			}
			
			/**
			 * p1のp2に関する垂直成分ベクトルを返却します。
			 * 
			 * @param	p1
			 * @param	p2
			 * @return
			 */
			public static function perp(p1:Point3D , p2:Point3D):Point3D {
				var prop:Point3D = proj(p1, p2);
				
				var p:Point3D = new Point3D();
				p.x = p1.x - prop.x;
				p.y = p1.y - prop.y;
				p.z = p1.z - prop.z;
				
				return p;
			}
			
			/**
			 * 2つのベクトルの成す角度を返却します。
			 * 
			 * @param	p1
			 * @param	p2
			 * @return
			 */
			public static function radian(p1:Point3D , p2:Point3D):Number {
				//内積
				var scalar:Number = Point3D.scalar(p1, p2);
				
				//長さ
				var norm1:Number = p1.norm;
				var norm2:Number = p2.norm;
				
				var cos:Number = 0;
				if ((norm1 * norm2) != 0) {
					cos = scalar / (norm1 * norm2);
				}
				
				return Math.acos(cos);
			}
	}
}