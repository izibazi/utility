package jp.co.shed.geom
{
	/**
	 * 
	 * @auther keith peters ()
	 * 
	 * @update 
	 * 	イシバシ
	 */
	public class Point3DExtends
	{

			
			/**
			 * 視点から投影面までの距離 
			 */			
			public var fl:Number=250;
			
			/**
			 * 座標を丸めるかどうか 
			 */			
			public var rounded:Boolean=false;
			
			/**
			 * 指定するx座標 
			 */			
			private var m__x:Number=0;
		
			/**
			 * 指定するy座標 
			 */	
			private var m__y:Number=0;
			
			/**
			 * 指定するz座標 
			 */	
			private var __z:Number=0;
						
			private var vpX:Number=0;
			private var vpY:Number=0;
			
			private var cX:Number=0;
			private var cY:Number=0;
			private var cZ:Number=0;
			
			private var m__originalX:Number;
			private var m__originalY:Number;
			private var m__originalZ:Number;
			
			private var angleX:Number=0;
			private var angleY:Number=0;
			
			/**
			 * コンストラクタ
			 *  
			 * @param x
			 * @param y
			 * @param z
			 * @param fl
			 */
			public function Point3DExtends(x:Number=0 , y:Number=0 , z:Number=0 , fl:Number=250){
				this.x=x;
				this.y=y;
				this.z=z;
				
				originalX=x;
				originalY=y;
				originalZ=z;

				
				this.fl=fl;
			}
			

			
			/**
			 * 収束点を設定します。
			 *  
			 * @param vpX
			 * @param vpY
			 * 
			 */
			public function setVanishPoint(vpX:Number , vpY:Number):void{
				this.vpX=vpX;
				this.vpY=vpY;
			}
			
			public function setCenter(cX:Number , cY:Number,cZ:Number):void{
				this.cX=cX;
				this.cY=cY;
				this.cZ=cZ;
			}
			
			public function centerX(value:Number):void{
				this.cX=value;
			}
			
			public function centerY(value:Number):void{
				this.cY=value;
			}
			
			public function centerZ(value:Number):void{
				this.cZ=value;
			}
			
			/**
			 * 表示するx座標を返却します。
			 *  
			 * @return 
			 * 
			 */			
			public function get screenX():Number{
				var scale:Number=fl/(fl+z+cZ);
				var xx:Number=vpX+x*scale+cX
				
				return rounded?Math.round(xx):xx;
			}
			
			/**
			 * 表示するy座標を返却します。 
			 * 
			 * @return 
			 * 
			 */			
			public function get screenY():Number{
				var scale:Number=fl/(fl+z+cZ);
				var yy:Number=vpY+y*scale+cY;

				
				return rounded?Math.round(yy):yy;
			}
			
			/**
			 * x軸を中心に回転します。
			 *  
			 * @param angle
			 * 
			 */			
			public function rotateX(angle:Number):void{
				//angle=angleX-angle;
				angleX=angle;
				
				var cos:Number=Math.cos(angle);
				var sin:Number=Math.sin(angle);
				
				var y1:Number=cos*originalY-sin*originalZ;
				var z1:Number=cos*originalZ+sin*originalY;
				
				m__y=y1;
				__z=z1;
				
			}
			
			/**
			 * y軸を中心に回転します。
			 * 
			 * @param angle
			 * 
			 */
			public function rotateY(angle:Number):void{
				angleY=angle;
				
				var cos:Number=Math.cos(angle);
				var sin:Number=Math.sin(angle);
				
				var x1:Number=cos*originalX-sin*originalZ;
				var z1:Number=cos*originalZ+sin*originalX;
				
				m__x=x1;
				__z=z1;			
			}
			
			/**
			 * z軸を中心に回転します。
			 * 
			 * @param angle
			 * 
			 */
			public function rotateZ(angle:Number):void{
				var cos:Number=Math.cos(angle);
				var sin:Number=Math.sin(angle);
				
				var y1:Number=cos*y-sin*z;
				var z1:Number=cos*z+sin*y;
				
				m__y=y1;
				__z=z1;			
			}			

			
			public function get scale():Number{
				return fl/(fl+z+cZ);
			}
			
			
			
			
			public function set z(value:Number):void{
				__z=value;
			}
			
			public function get z():Number{
				return __z;
			}
			
			public function set x(value:Number):void{
				m__x=value;
			}
			
			public function get x():Number{
				return m__x;
			}
			
			public function set y(value:Number):void{
				m__y=value;
				originalY=m__y;
			}
			
			public function get y():Number{
				return m__y;
			}
			
			public function set originalX(value:Number):void{
				m__originalX=value;
				rotateX(angleX);
				rotateY(angleY);
			}
			
			public function set originalY(value:Number):void{
				m__originalY=value;
			}
			
			public function set originalZ(value:Number):void{
				m__originalZ=value;
				rotateX(angleX);
				rotateY(angleY);
			}
			
			public function get originalX():Number{
				return m__originalX;
			}
			
			public function get originalY():Number{
				return m__originalY;
			}	
			
			public function get originalZ():Number{
				return m__originalZ;
			}	

	}
}