package jp.co.shed.utils
{
	import flash.display.BitmapData;
	import flash.display.MovieClip;
	import flash.display.Bitmap;
	
	/**
	 * BitmapDataを操作するスタティックユーティリティクラスです。
	 * 
	 * @author yasunari ishibashi
	 */
	public class BitmapUtils
	{
		
		/**
		 * 第一引数に指定したソースイメージを、第二引数のターゲットに表示します。
		 * 
		 * @param src_mc ソースイメージ
		 * @param draw_mc ソースイメージをbitmapとして表示するターゲットMovieClip
		 * @param smoothing スムージングを有効にするかどうかのフラグ
		 */
		public static function draw(src_mc:* , draw_mc:* , smoothing:Boolean = true):void
		{
			var bitmapData:BitmapData=new BitmapData(src_mc.width , src_mc.height , false , 0x000000);
			bitmapData.draw(src_mc , null , null , null , null , smoothing);
			var bitmap:Bitmap=new Bitmap(bitmapData);
			bitmap.name="bitmap";	
			draw_mc.addChild(bitmap);
		}

	}
}