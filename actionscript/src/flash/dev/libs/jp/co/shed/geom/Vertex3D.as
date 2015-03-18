package jp.co.shed.geom
{
	import jp.co.shed.geom.Point3D;
	import jp.co.shed.geom.Matrix3D;
	
	import caurina.transitions.Tweener;
	
	/**
	 * 頂点座標を管理するクラス。
	 * 
	 * @author yasunari ishibashi
	 */
	public class Vertex3D
	{
		
		/**
		 * オリジナルの頂点座標 
		 */		
		private var m_originalPoint3D:Point3D;
		
		/**
		 * Matrix3Dで、変換した頂点座標 
		 */		
		private var m_point3D:Point3D;
		
		private var m_matrix3D:Matrix3D;
		
		/**
		 * 変換したディスプレイ座標 
		 */		
		private var m_screenX:Number;
		private var m_screenY:Number;
		
		private var m_scale:Number;
		
		
		public var extra:Object;
		
		
		public function Vertex3D(p3D:Point3D=null)
		{
			extra={};
			
			m_screenX=0;
			m_screenY=0;
			m_scale = 1;
			
			if (p3D == null) {
				p3D = new Point3D();
			}

			m_originalPoint3D = p3D.clone();
			m_point3D = p3D.clone();
			
			m_matrix3D = new Matrix3D();
		}
		
		/**
		 * オリジナル座標に対して、
		 * 指定したマトリックスで変換します。 
		 * 
		 * @param mat
		 */		
		public function transformOriginalPoint(mat:Matrix3D):void{
			m_point3D = mat.transformPoint(m_originalPoint3D);
			m_matrix3D = mat;
		}
		
		public function transformPoint(mat:Matrix3D = null):void {
			if (mat != null) {
				m_matrix3D = mat;
			}
			
			m_point3D = m_matrix3D.transformPoint(m_point3D);
		}

		public function rotateX(radian:Number , time:Number=1 , scope:*=null , callBackFunction:Function=null):void {
			var matrix:Matrix3D = new Matrix3D();
			
			Tweener.addTween(matrix, { rotateX:radian , time:time , onUpdate:callBackFunction , onUpdateParams:[scope, matrix] } );
		}

		
		/**
		 * プロジェクション（透視座標変換）を実行します。
		 * @param	mat
		 */
		public function projection(fl:Number):void {
			perspective(fl);
		}		
		
		/**
		 * 透視変換します。
		 *  
		 * @param fl
		 * 
		 */		
		public function perspective(fl:Number):void{
			m_scale=fl/(fl+m_point3D.z);

			//m_scale=fl/(m_point3D.z);
			m_screenX=m_point3D.x*m_scale;
			m_screenY=m_point3D.y*m_scale;
		}
		
		/**
		 * ディスプレイ表示x座標を返却します。 
		 * @return 
		 * 
		 */		
		public function get screenX():Number{
			return m_screenX;
		}	

		/**
		 * ディスプレイ表示y座標を返却します。 
		 * @return 
		 * 
		 */		
		public function get screenY():Number{
			return m_screenY;
		}	
		
		public function get scale():Number{
			return m_scale;
		}
		
		/**
		 * 変換したx座標を返却します。 
		 */		
		public function get x3D():Number{
			return m_point3D.x;
		}
		/**
		 * @private
		 */
		public function set x3D(x:Number):void{
			m_point3D.x = x;
		}
		
		/**
		 * 変換したy座標を返却します。 
		 */	
		public function get y3D():Number{
			return m_point3D.y;
		}
		/**
		 * @private
		 */
		public function set y3D(y:Number):void{
			m_point3D.y = y;
		}
		
		/**
		 * 変換したz座標を返却します。 
		 */	
		public function get z3D():Number{
			return m_point3D.z;
		}
		/**
		 * @private
		 */
		public function set z3D(z:Number):void{
			m_point3D.z = z;
		}		
		
		/**
		 * オリジナルのPoint3Dを返却します。
		 */
		public function get originalPoint3D():Point3D { return m_originalPoint3D; }
		/**
		 * @private
		 */
		public function set originalPoint3D(value:Point3D):void 
		{
			m_originalPoint3D = value;
		}
		
		/**
		 * オリジナル座標を設定し、matrix3Dをリセットします。
		 */
		public function reset():void {
			m_point3D = m_originalPoint3D.clone();
			m_matrix3D.reset();
		}
		
		public function resetMatrix3D():void {
			m_matrix3D.reset();
		}
		
		/**
		 * 現在のPoint3Dを返却します。
		 */
		public function get point3D():Point3D { 
			return m_point3D; 
		}
		
		public function set point3D(value:Point3D):void 
		{
			m_point3D = value;
			m_originalPoint3D = value.clone();
		}
		
		/**
		 *　現在のMatrix3Dを返却します。
		 */
		public function get matrix3D():Matrix3D { return m_matrix3D; }
		
		public function set matrix3D(value:Matrix3D):void 
		{
			m_matrix3D = value;
		}
		 

		public function toString():String{
 			return 	"screenX		:	" + screenX + " , screenY	:	" + screenY + " , scale : " + scale;

		}

	}
}