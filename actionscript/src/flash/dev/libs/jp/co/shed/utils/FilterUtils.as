package jp.co.shed.utils
{
	import flash.filters.ConvolutionFilter;
	
	/**
	 * 各フィルタークラスのスタティックユーティリティクラスです。
	 * 
	 * @author yasunari ishibashi
	 */
	public class FilterUtils
	{

		/**
		 * エッジ表示用のConvolutionFilter返却します。
		 * 
		 * @return エッジ表示用のConvolutionFilter返却
		 */
		public static function edge(value : Number = -1 , divisor:Number = 1 , bias:Number = 0 , preserveAlpha:Boolean = true):ConvolutionFilter
		{
			var matrix:Array=[
								value,value,value,
								value,8,value,
								value,value,value
			];
			
			var cf:ConvolutionFilter=new ConvolutionFilter(3,3,matrix,divisor,bias,preserveAlpha);
			
			return cf;
		}
		
		/**
		 * ラプラシアン表示用のConvolutionFilter返却します。
		 * 
		 * @return ラプラシアン表示用のConvolutionFilter返却
		 */
		public static function laplacian(value : Number = -1 , divisor:Number = 1 , bias:Number = 0 , preserveAlpha:Boolean = true):ConvolutionFilter
		{
			var matrix:Array=[
								0,1,0,
								1,-4,1,
								0,1,0
			];
			
			var cf:ConvolutionFilter=new ConvolutionFilter(3,3,matrix,divisor,bias,preserveAlpha);
			
			return cf;
		}
		
		/**
		 * エンボス表示用のConvolutionFilter返却します。
		 * 
		 * @return エンボス表示用のConvolutionFilter返却
		 */
		public static function emboss(value : Number = 1 , divisor:Number = 1 , bias:Number = 0, preserveAlpha:Boolean = true):ConvolutionFilter
		{
			var matrix:Array=[
								-value,-value,0,
								-value,0,value,
								0,value,value
			];
			
			var cf:ConvolutionFilter=new ConvolutionFilter(3,3,matrix,divisor,bias,preserveAlpha);
			
			return cf;
		}
		
		/**
		 *	平均化表示用のConvolutionFilter返却します。
		 * 
		 * @return 平均化表示用のConvolutionFilter返却
		 */
		public static function averages(value : Number = 9 , divisor:Number = 1 , bias:Number = 0, preserveAlpha:Boolean = true):ConvolutionFilter
		{
			var matrix:Array=[
								1/value,1/value,1/value,
								1/value,1/value,1/value,
								1/value,1/value,1/value
			];
			
			var cf:ConvolutionFilter=new ConvolutionFilter(3,3,matrix,divisor,bias,preserveAlpha);
			
			return cf;
		}
		
		/**
		 * アンシャープ表示用のConvolutionFilter返却します。
		 * 
		 * @return アンシャープ表示用のConvolutionFilter返却
		 */
		public static function sharp(value : Number = 9 , divisor:Number = 1 , bias:Number = 0, preserveAlpha:Boolean = true):ConvolutionFilter
		{
			var a:Number=-0.11;
			var c:Number=1.88;
			
			var matrix:Array=[
								a,a,a,
								a,c,a,
								a,a,a
			];
			
			var cf:ConvolutionFilter=new ConvolutionFilter(3,3,matrix,divisor,bias,preserveAlpha);
			
			return cf;
		}
	}
}