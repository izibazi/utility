package jp.co.shed.utils 
{
	
	import flash.utils.ByteArray;
	
	/**
	 * Arrayクラスのスタティックユーティリティクラスです。
	 *
	 * @author yasunari ishibashi
	 */
	public class ArrayUtils 
	{

		/**
		 * すべての値を加算した結果を返却します。
		 * 
		 *	@return すべての値を加算した結果を返却
		 */
		public static function total(ary:Array):Number
		{
			var t:Number = 0;
			var len:uint = ary.length;
			for (var i:uint = 0; i < len; i++)
			{
				t += ary[i]
			}
			
			return t;
		}
		
		/**
		 * すべての値の平均値を返却します。
		 * 
		 * @return すべての値の平均値を返却
		 */
		public static function average(ary:Array):Number
		{
			return (total(ary) / ary.length);
		}
		
		/**
		 * 配列をランダムにシャッフルして返却します。
		 * 
		 * @return 配列をランダムにシャッフルして返却
		 */
		public static function shuffle(ary:Array):Array 
		{
			var i :uint= ary.length;
			while (i--) 
			{
				var j :uint= Math.floor(Math.random()*(i+1));
				var t :*= ary[i];
				ary[i] = ary[j];
				ary[j] = t;
			}

			return ary;
		}
		
		/**
		 * 配列要素をランダムに返却します。
		 * 
		 * @return 配列要素をランダムに返却
		 */
		public static function random(ary:Array):*
		{		
			var rnd:*= Math.floor(Math.random() * (ary.length));
			return ary[rnd];
		}
		
		/**
		 * 配列の最大値を返却します。
		 * 
		 *	@return 配列の最大値を返却
		 */
		public static function max(ary:Array):Number
		{
			var maxVal:Number = ary[0];
			var len:uint = ary.length;
			for (var i:int = 1; i < len; i++) 
			{
				maxVal = Math.max(maxVal, ary[i]);
			}
			
			return maxVal;
		}	
			
		/**
		 * 配列の最小値を返却します。
		 * 
		 * @return 配列の最小値を返却
		 */
		public static function min(ary:Array):Number
		{
			var minVal:Number = ary[0];
			var len:uint = ary.length;
			for (var i:int = 1; i < len; i++) 
			{
				minVal = Math.min(minVal, ary[i]);
			}
			
			return minVal;
		}			
		
		/**
		 * 配列の浅いコピーを返却します。
		 * 
		 * <p>深いコピーが必要な場合は、clone() もしくは　deepClose()メソッドを使用してください。</p>
		 * 
		 *	@return 配列の浅いコピーを返却
		 */
		public static function shallowCopy(ary:Array):Array
		{
			return ary.slice();
		}
		
		/**
		 * 配列の深いコピーを返却します。
		 * 
		 * <p>浅いいコピーが必要な場合は、shallowCopy()メソッドを使用してください。</p>
		 * 
		 * @return 配列の深いコピーを返却
		 */
		public static function deepCopy(ary:Array):Array
		{
			return clone(ary);
		}
		
		/**
		 * 配列の深いコピーを返却します。
		 * 
		 * <p>浅いいコピーが必要な場合は、shallowCopy()メソッドを使用してください。</p>
		 * 
		 * @return 配列の深いコピーを返却
		 */
		public static function clone(ary:Array):Array
		{
			var myBA:ByteArray = new ByteArray();
			myBA.writeObject(ary);
			myBA.position = 0;
			return (myBA.readObject());
		}
		
		
		/**
		 * 線形探索(番兵法による探索)で、一致した場合はその要素のindexを返却します。
		 * 見つからなかった場合は、-1を返却します。
		 *  
		 * @param target_ary
		 * @param key
		 * @param length
		 * @return 
		 * 
		 */		
		public static function linearSearch(target_ary:Array , key:* , length:uint = uint.MAX_VALUE ):int
		{
			if (length == uint.MAX_VALUE)
			{
				length = target_ary.length;
			}
			target_ary[length] = key;
			
			var i:uint = 0;
			while (true) 
			{
				if (target_ary[i] == key) 
				{
					break;
				}
				i++;
			}
			target_ary.pop();
			
			return i == length? -1:i; 
		}
		
		/**
		 * ソートされている配列の2分探索を行い、
		 * 一致した場合はその要素のindexを返却します。
		 * 見つからなかった場合は、-1を返却します。
		 *  
		 * @param target_ary
		 * @param key
		 * @param length
		 * @return 
		 * 
		 */		
		public static function binarySearch(target_ary:Array , key:* , length:uint = uint.MAX_VALUE ):int
		{
			if (length == uint.MAX_VALUE)
			{
				length=target_ary.length;
			}
			
			var first:int=0;
			var	last:int=length-1;
			
			var center:int;
			var value:*;
			
			do
			{
				center = (first + last) / 2;
				value = target_ary[center];
				if (value == key)
				{
					return center;
				}
				else if (value < key)
				{
					first = center + 1;
				}
				else
				{
					last = center - 1;
				}
			
			}while (first <= last);
			
			return -1;
		}
		
		/**
		 * 指定インデックスの前に、挿入します。
		 * 
		 * @param	target_ary
		 * @param	index
		 * @param	value
		 * @return
		 */
		public static function insertBefore(target_ary:Array,index:int, value:*):Array
		{
			var clone:Array = target_ary.concat();
			var temp:Array = clone.splice(index);
			temp.unshift(value);
			clone = clone.concat(temp);
			
			return clone;
		}
		
		/**
		 * 指定インデックスの後に、挿入します。
		 * 
		 * @param	target_ary
		 * @param	index
		 * @param	value
		 * @return
		 */
		public static function insertAfter(target_ary:Array,index:int, value:*):Array
		{
			var new_ary:Array = target_ary.concat();
			var temp:Array = new_ary.splice(index + 1);
			temp.unshift(value);
			new_ary = new_ary.concat(temp);
			
			return new_ary;
		}
	}
}






