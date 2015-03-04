package jp.co.shed.utils 
{
	
	import flash.utils.ByteArray;
	import flash.media.*;

	/**
	 * サウンドに関してのユーティリティクラスです。
	 * 
	 * @author yasunari ishibashi
	 */
	public class SoundUtils 
	{

		public static const SPECTRUM_LENGTH:Number = 256 ;
		
		public static const SPECTRUM_BYTES_LENGTH:Number = 2048;
		
		public static const SPECTRUM_BYTES_LENGTH_HALF:Number = 1024;

		/**
		 * 左のサウンド周波数リストを返却します。
		 * 
		 * @param	bytes
		 * @param	FFTMode
		 * @param	factor
		 * @return
		 */
		public static function spectrumLeft(bytes:ByteArray = null , FFTMode:Boolean = false , factor:int = 0):Array 
		{
			var data_ary:Array = [];
			
			SoundMixer.computeSpectrum(bytes , FFTMode , factor);
			bytes.position = 0;
			for (var i :uint = 0; i < SPECTRUM_LENGTH; i++ ) 
			{
				data_ary[i] = bytes.readFloat();
			}
			return data_ary;
		}
		
		/**
		 * 左のサウンド周波数リストを返却します。
		 * 
		 * @param	bytes
		 * @param	FFTMode
		 * @param	factor
		 * @return
		 */
		public static function spectrumRight(bytes:ByteArray , FFTMode:Boolean = false , factor:int = 0):Array
		{
			var data_ary:Array = [];
			
			SoundMixer.computeSpectrum(bytes , FFTMode , factor);

			bytes.position = SPECTRUM_BYTES_LENGTH_HALF;
			
			for (var i :uint = 0; i < SPECTRUM_LENGTH; i++ )
			{
				data_ary[i] = bytes.readFloat();
			}
			return data_ary;
		}
		
		public static function spectrumInfo(bytes:ByteArray = null):Object 
		{
			if (bytes == null)
			{
				bytes = new ByteArray();
			}
			
			var info:Object = { };
			info.left = spectrumLeft(bytes);
			info.right = spectrumRight(bytes);			
			
			info.leftTotal = 0;
			info.rightTotal = 0;
			info.leftMin = info.left[0];
			info.leftMax = info.left[0];
			info.rightMin = info.right[0];
			info.rightMax = info.right[0];
			
			for (var i:uint = 0; i < 64; i++ ) 
			{
				info.leftTotal += info.left[i];
				info.rightTotal += info.right[i];
				
				info.leftMin = Math.min(info.leftMin , info.left[i]);
				info.rightMin = Math.min(info.rightMin , info.right[i]);
				
				info.leftMax = Math.max(info.leftMax , info.left[i]);
				info.rightMax = Math.max(info.rightMax , info.right[i]);
			}
]
			return info;
		}
		
	}
	
}