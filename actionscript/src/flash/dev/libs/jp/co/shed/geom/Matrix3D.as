package jp.co.shed.geom
{
	import flash.geom.Matrix;
	
	/**
	 * 変換マトリックスを管理するクラス。
	 * 
	　* | a , b , c , tx | 
	　* | d , e , f , ty |
	　* | g , h , i , tz |
	　* | 0 , 0 , 0 , 1  |
	 * 
	 * @author yasunari ishibashi
	　*/	
	public class Matrix3D
	{
		
		private var m_m11 : Number;
		private var m_m12 : Number;
		private var m_m13: Number;
		private var m_m14: Number;
		
		private var m_m21 : Number;
		private var m_m22 : Number;
		private var m_m23 : Number;
		private var m_m24 : Number;
		
		private var m_m31 : Number;
		private var m_m32 : Number;
		private var m_m33 : Number;
		private var m_m34 : Number;
		
		private var m_m41 : Number;
		private var m_m42 : Number;
		private var m_m43 : Number;
		private var m_m44 : Number;
		
		/**
		 * コンストラクタ
		 * 
		 * 　m11 , m12 , m13 , m14
		 * 　m21 , m22 , m23 , m24
		 * 　m31 , m32 , m33 , m34
		 * 　m41 , m42 , m43 , m44
		 * 
		 * @param	m11
		 * @param	m12
		 * @param	m13
		 * @param	m14
		 * @param	m21
		 * @param	m22
		 * @param	m23
		 * @param	m24
		 * @param	m31
		 * @param	m32
		 * @param	m33
		 * @param	m34
		 * @param	m41
		 * @param	m42
		 * @param	m43
		 * @param	m44
		 */
		public function Matrix3D(	m11:Number = 1	, m12:Number = 0 	, m13:Number = 0 , 	m14 :Number = 0 , 
									m21:Number = 0 	, m22:Number = 1 	, m23:Number = 0 , 	m24 :Number = 0,
									m31:Number = 0 	, m32:Number = 0 	, m33:Number = 1 ,	m34 :Number = 0,
									m41:Number = 0 	, m42:Number = 0 	, m43:Number = 0 ,	m44 :Number = 1
									)
		{
			
			this.m11 = m11;
			this.m12 = m12;
			this.m13 = m13;
			this.m14 = m14;
		
			this.m21 = m21;
			this.m22 = m22;
			this.m23 = m23;
			this.m24 = m24;
			
			this.m31 = m31;
			this.m32 = m32;
			this.m33 = m33;
			this.m34 = m34;

			this.m41 = m41;
			this.m42 = m42;
			this.m43 = m43;
			this.m44 = m44;
		}
		
		/**
		 * 指定した行列を合成します。
		 * 
		 * mat
		 * 　m11 , m12 , m13 , m14
		 * 　m21 , m22 , m23 , m24
		 * 　m31 , m32 , m33 , m34
		 * 　m41 , m42 , m43 , m44
		 * 
		 * 			x
		 * 
		 * 　m11 , m12 , m13 , m14
		 * 　m21 , m22 , m23 , m24
		 * 　m31 , m32 , m33 , m34
		 * 　m41 , m42 , m43 , m44
		 * 
		 * @param mat
		 * 
		 */		
		public function concat(mat:Matrix3D):void{
			var mat2:Matrix3D=this.clone();
			
			m11	= mat.m11 * mat2.m11 + mat.m12 * mat2.m21 + mat.m13 * mat2.m31 + mat.m14 * mat2.m41;
			m12	= mat.m11 * mat2.m12 + mat.m12 * mat2.m22 + mat.m13 * mat2.m32 + mat.m14 * mat2.m42;
			m13	= mat.m11 * mat2.m13 + mat.m12 * mat2.m23 + mat.m13 * mat2.m33 + mat.m14 * mat2.m43;
			m14	= mat.m11 * mat2.m14 + mat.m12 * mat2.m24 + mat.m13 * mat2.m34 + mat.m14 * mat2.m44;
			
			m21	= mat.m21 * mat2.m11 + mat.m22 * mat2.m21 + mat.m23 * mat2.m31 + mat.m24 * mat2.m41;
			m22	= mat.m21 * mat2.m12 + mat.m22 * mat2.m22 + mat.m23 * mat2.m32 + mat.m24 * mat2.m42;
			m23	= mat.m21 * mat2.m13 + mat.m22 * mat2.m23 + mat.m23 * mat2.m33 + mat.m24 * mat2.m43;
			m24	= mat.m21 * mat2.m14 + mat.m22 * mat2.m24 + mat.m23 * mat2.m34 + mat.m24 * mat2.m44;
			
			m31	= mat.m31 * mat2.m11 + mat.m32 * mat2.m21 + mat.m33 * mat2.m31 + mat.m34 * mat2.m41;
			m32	= mat.m31 * mat2.m12 + mat.m32 * mat2.m22 + mat.m33 * mat2.m32 + mat.m34 * mat2.m42;
			m33	= mat.m31 * mat2.m13 + mat.m32 * mat2.m23 + mat.m33 * mat2.m33 + mat.m34 * mat2.m43;
			m34	= mat.m31 * mat2.m14 + mat.m32 * mat2.m24 + mat.m33 * mat2.m34 + mat.m34 * mat2.m44;

			m41	= mat.m41 * mat2.m11 + mat.m42 * mat2.m21 + mat.m43 * mat2.m31 + mat.m44 * mat2.m41;
			m42	= mat.m41 * mat2.m12 + mat.m42 * mat2.m22 + mat.m43 * mat2.m32 + mat.m44 * mat2.m42;
			m43	= mat.m41 * mat2.m13 + mat.m42 * mat2.m23 + mat.m43 * mat2.m33 + mat.m44 * mat2.m43;
			m44	= mat.m41 * mat2.m14 + mat.m42 * mat2.m24 + mat.m43 * mat2.m34 + mat.m44 * mat2.m44;	
		}
		
		/**
		 * x軸を中心に回転します。
		 * 
		 * | x , y , z , 0|
		 * 		
		 * 		  *
		 * 
	     * | 1 , 0 , 0 , 0     | 
	 	 * | 0 , cos , -sin , 0 |
		 * | 0 , sin , cos ,  0 | 
		 * | 0 , 0 , 0 , 1  |
		 * 
		 * 
		 * @param radian
		 * 
		 */		
		public function rotateX(radian:Number):void{
			var cos:Number=Math.cos(radian);
			var sin:Number=Math.sin(radian);
			
			var mat:Matrix3D=new Matrix3D();
			mat.m22 = cos;
			mat.m23 = -sin;
			mat.m32 = sin;
			mat.m33 = cos;
			concat(mat);
		}
		
		/**
		 * y軸を中心に回転します。
		 * 
		 * 
		 * | x , y , z , 0|
		 * 		
		 * 		  *
		 * 
	     * | cos , 0 , -sin , 0 | 
	 	 * | 0 , 1 , 0 , 0 |
		 * | sin , 0 , cos ,  0 | 
		 * | 0 , 0 , 0 , 1  |
		 * 
		 * 　m11 , m12 , m13 , m14
		 * 　m21 , m22 , m23 , m24
		 * 　m31 , m32 , m33 , m34
		 * 　m41 , m42 , m43 , m44
		 * 
		 * @param radian
		 * 
		 */		
		public function rotateY(radian:Number):void{
			var cos:Number = Math.cos(radian);
			var sin:Number = Math.sin(radian);
			var mat:Matrix3D = new Matrix3D();
			
			mat.m11 = cos;
			mat.m13 = -sin;
			mat.m31 = sin;
			mat.m33 = cos;
			
			concat(mat);
		}
		
		/**
		 * z軸を中心に回転します。
		 * 
		 * 
		 * | x , y , z , 0|
		 * 		
		 * 		  *
		 * 
	     * | cos , -sin , 0 , 0 | 
	 	 * | sin , cos , 0 , 0 |
		 * | 0 , 0 , 1 ,  0 | 
		 * | 0 , 0 , 0 , 1  |
		 * 
		 * 　m11 , m12 , m13 , m14
		 * 　m21 , m22 , m23 , m24
		 * 　m31 , m32 , m33 , m34
		 * 　m41 , m42 , m43 , m44
		 * 
		 * @param radian
		 * 
		 */		
		public function rotateZ(radian:Number):void{
			var cos:Number=Math.cos(radian);
			var sin:Number=Math.sin(radian);
			
			var mat:Matrix3D=new Matrix3D();
			mat.m11 = cos;
			mat.m12 = -sin;
			mat.m21 = sin;
			mat.m22 = cos;

			concat(mat);
		}
		
		public function rotateXYZ(x:Number, y:Number, z:Number):void {
			rotateX(x);
			rotateY(y);
			rotateZ(z);
		}
		
		/**
		 * リセットします。
		 */
		public function reset():void {
			this.m11 = 1;
			this.m12 = 0;
			this.m13 = 0;
			this.m14 = 0;
			
			this.m21 = 0;
			this.m22 = 1;
			this.m23 = 0;
			this.m24 = 0;
			
			this.m31 = 0;
			this.m32 = 0;
			this.m33 = 1;
			this.m34 = 0;
			
			this.m41 = 0;
			this.m42 = 0;
			this.m43 = 0;
			this.m44 = 1;
		}
		
		/**
		 * 回転マトリックスをリセットします。
		 */
		public function resetRotate():void {
			this.m11 = 1;
			this.m12 = 0;
			this.m13 = 0;
			
			this.m21 = 0;
			this.m22 = 1;
			this.m23 = 0;
			
			this.m31 = 0;
			this.m32 = 0;
			this.m33 = 1;		
		}
		
		/**
		 * 平行移動します。
		 * 
		 * | x , y , z , 0 |
		 * 			
		 * 		   *
		 * 
		 * | 0 , 0 , 0 , tx |
		 * | 0 , 0 , 0 , ty |
		 * | 0 , 0 , 0 , tz |
		 * | 0 , 0 , 0 , 1 |
		 * 
		 *  
		 * @param tx
		 * @param ty
		 * @param tz
		 * 
		 */		
		public function translate(tx:Number = 0 , ty:Number = 0 , tz:Number = 0):void {
			this.m14 += tx;
			this.m24 += ty;
			this.m34 += tz;
		}
		
		/**
		 * 拡大縮小します。
		 *  
		 * | x , y , z , 0 |
		 * 			
		 * 		   *
		 * 
		 * | sx , 0 , 0 , 0 |
		 * | 0 , sy , 0 , 0 |
		 * | 0 , 0 , sz , 0 |
		 * | 0 , 0 , 0 ,  0 |
		 * 
		 * 
		 * @param sx
		 * @param sy
		 * @param sz
		 * 
		 */		
		public function scale(sx:Number , sy:Number , sz:Number):void {
			m11 = m11 * sx;
			m12 = m12 * sx;
			m13 = m13 * sx;
			m14 = m14 * sx;
				
			m21 = m21 * sy;
			m22 = m22 * sy;
			m23 = m23 * sy;
			m24 = m24 * sy;

			m31 = m31 * sz;
			m32 = m32 * sz;
			m33 = m33 * sz;
			m34 = m34 * sz;
		}
		
		/**
		 * Matrix3D オブジェクトで表現される図形変換を、
		 * 指定されたポイント3Dに適用した値を返します。
		 * 
		 * @param point
		 * @return 
		 * 
		 * @see flash.geom.Matrix.transformPoint;
		 * 
		 */		
		public function transformPoint(point:Point3D):Point3D{
			
			var x:Number = m11 * point.x + m12 * point.y + m13 * point.z + m14;
			var y:Number = m21 * point.x + m22 * point.y + m23 * point.z + m24;
			var z:Number = m31 * point.x + m32 * point.y + m33 * point.z + m34;
			
			/*
			point.x = x;
			point.y = y;
			point.z = z;
			*/
			
			return new Point3D(x , y, z);
		}
		
		/**
		 * 3x3の行列式を返却します。
		 * 
		 * detM=(-1)(i+k乗)M(ik)detM{i,k}
		 * 
		 * 　m11 , m12 , m13 
		 * 　m21 , m22 , m23 
		 * 　m31 , m32 , m33 
		 * 
		 */
		public function get det3x3():Number {
			return 	 m11 * (m22 * m33 - m23 * m32)
					-m12 * (m21 * m33 - m23 * m31)
					+m13 * (m21 * m32 - m22 * m31);
		}
		
		/**
		 * 4x4の行列式を返却します。
		 * 
		 * 　m11 , m12 , m13 , m14
		 * 　m21 , m22 , m23 , m24
		 * 　m31 , m32 , m33 , m34
		 * 　m41 , m42 , m43 , m44
		 * 
		 * 	m11	*	e	f	ty 		- b	*	d	f	ty		+ c*	d	e	ty		-tx*	d	e	f
		 * 			h	i	tz				g	i	tz				g	h	tz				g	h	i
		 * 			0	0	1				0	0	1				0	0	1				0	0	0
		 * 			
		 */

		public function get det4x4():Number {
			return 0 ;
			//return a * (e * (i) - f * h) - b(d * i - f * g) + c * (d * h - e * g);
		}

		
		public function inverse3x3(matrix:Matrix3D):void {
			var det:Number = matrix.det3x3;
	
			if (det < 0.001) {
				return;
			}
			/*
			a = 1 / det * (e * i - f * h);
			b = - 1/ det*
			*/
		}
		
		/**
		 * クローンを返却します。
		 *  
		 * @return 
		 * 
		 */		
		public function clone():Matrix3D{
			return new Matrix3D(m11 , m12 , m13 , m14,
								m21 , m22 , m23 , m24,
								m31 , m32 , m33 , m34,
								m41 , m42 , m43 , m44
								);
		}
		
		/**
		 * 各プロパティを返却します。 
		 * 
		 */		
		public function toString():String{
			var outputValue:String="jp.co.shed.geom.Matrix : \n"+
									"m11=" + m11 + " , m12=" + m12 + " , m13=" + m13 + " , m14=" + m14 + "\n" +
									"m21=" + m21 + " , m22=" + m22 + " , m23=" + m23 + " , m24=" + m24 + "\n" +
									"m31=" + m31 + " , m32=" + m32 + " , m33=" + m33 + " , m34=" + m34 + "\n" +
									"m41=" + m41 + " , m42=" + m42 + " , m43=" + m43 + " , m44=" + m44 ;
									
			return outputValue;
		}
		
		/**
		 * 詳細を出力します。
		 */
		public function dump():void {
			trace(toString());
		}
		
		public static function get init():Matrix3D {
			return new Matrix3D(
			1, 0, 0, 0,
			0, 1, 0, 0,
			0, 0, 1, 0,
			0, 0, 0, 1
			);
		}
		
		public function get m11():Number { return m_m11; }
		
		public function set m11(value:Number):void 
		{
			m_m11 = value;
		}
		
		public function get m12():Number { return m_m12; }
		
		public function set m12(value:Number):void 
		{
			m_m12 = value;
		}
		
		public function get m13():Number { return m_m13; }
		
		public function set m13(value:Number):void 
		{
			m_m13 = value;
		}
		
		public function get m14():Number { return m_m14; }
		
		public function set m14(value:Number):void 
		{
			m_m14 = value;
		}
		
		public function get m21():Number { return m_m21; }
		
		public function set m21(value:Number):void 
		{
			m_m21 = value;
		}
		
		public function get m22():Number { return m_m22; }
		
		public function set m22(value:Number):void 
		{
			m_m22 = value;
		}
		
		public function get m23():Number { return m_m23; }
		
		public function set m23(value:Number):void 
		{
			m_m23 = value;
		}
		
		public function get m24():Number { return m_m24; }
		
		public function set m24(value:Number):void 
		{
			m_m24 = value;
		}
		
		public function get m31():Number { return m_m31; }
		
		public function set m31(value:Number):void 
		{
			m_m31 = value;
		}
		
		public function get m32():Number { return m_m32; }
		
		public function set m32(value:Number):void 
		{
			m_m32 = value;
		}
		
		public function get m33():Number { return m_m33; }
		
		public function set m33(value:Number):void 
		{
			m_m33 = value;
		}
		
		public function get m34():Number { return m_m34; }
		
		public function set m34(value:Number):void 
		{
			m_m34 = value;
		}
		
		public function get m41():Number { return m_m41; }
		
		public function set m41(value:Number):void 
		{
			m_m41 = value;
		}
		
		public function get m42():Number { return m_m42; }
		
		public function set m42(value:Number):void 
		{
			m_m42 = value;
		}
		
		public function get m43():Number { return m_m43; }
		
		public function set m43(value:Number):void 
		{
			m_m43 = value;
		}
		
		public function get m44():Number { return m_m44; }
		
		public function set m44(value:Number):void 
		{
			m_m44 = value;
		}

	}
}