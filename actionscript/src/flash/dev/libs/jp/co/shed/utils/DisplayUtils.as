package jp.co.shed.utils 
{
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Stage;
	
	/**
	 * DisplayObjectのユーティリティクラス
	 * 
	 * @author yasunari ishibashi
	 */
	public class DisplayUtils
	{
		
		public static function lock(target:*, bool:Boolean) :void 
		{
			target.mouseEnabled = bool;
			target.mouseChildren = bool;
		}
		
		/**
		 * 真中に、整列、リサイズして表示します。
		 * 
		 * @param	target_mc
		 * @param	mask_mc
		 * @param	useLonger
		 */
		public static function alignCenterOfMask(target_mc:DisplayObject, mask_mc:DisplayObject, useLonger:Boolean = false):void 
		{
			if (target_mc is Bitmap) 
			{
				(target_mc as Bitmap).smoothing = true;
			}
			
			target_mc.mask = mask_mc;
			if (useLonger)
			{
				if (target_mc.width > target_mc.height)
				{
					target_mc.width = mask_mc.width;
					target_mc.scaleY = target_mc.scaleX;					
				}
				else
				{
					target_mc.height = mask_mc.height;
					target_mc.scaleX = target_mc.scaleY;					
				}
			}
			else
			{
				target_mc.width = mask_mc.width;
				target_mc.scaleY = target_mc.scaleX;
				
				if (target_mc.height < mask_mc.height) 
				{
					target_mc.height = mask_mc.height;
					target_mc.scaleX = target_mc.scaleY;
				}				
			}
			
			target_mc.width = Math.ceil(target_mc.width);
			target_mc.height = Math.ceil(target_mc.height);

			target_mc.x = Math.round((mask_mc.width - target_mc.width) / 2) + mask_mc.x;
			target_mc.y = Math.round((mask_mc.height - target_mc.height) / 2) + mask_mc.y;
		}
	}
	
}