package jp.co.shed.utils
{
	
	import flash.display.Stage;
	import flash.geom.Point;
	import flash.geom.Rectangle;

	/**
	* マウスに関してのユーティリティクラス。
	* 
	* @author yasunari ishibashi
	*/
	public class MouseUtils
	{

		/**
		 * w,hに応じたステージでのマススポインタの位置を返却します。
		 * 
		 * BitmapDataなどの使用時に便利です。
		 * 
		 * @param	w
		 * @param	h
		 * @return
		 */
		public static function getPoint(stage:Stage, w:Number , h:Number):Point
		{
			
			var stageW:Number = stage.stageWidth;
			var stageH:Number = stage.stageHeight;
			
			var scaleX:Number = stage.mouseX / stageW;
			var scaleY:Number = stage.mouseY / stageH;
			
			return new Point(w * scaleX , h * scaleY);
		}
		
	}
	
}