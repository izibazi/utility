package jp.co.shed.graphics
{

	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.geom.Point;

	public class TriangleDrawer extends Sprite {
		
		// 分割数。
		private var m_numOfDiv:int = 10;
		
		private var m_vertices:Vector.<Number>;
		
		private var m_indices:Vector.<int>; 
		
		private var m_uvtData:Vector.<Number>;
		
		private var m_img:Bitmap;

		private var m_container_mc:Sprite;
		
		private var m_centerBottom:Boolean;
		
		/**
		 * コンストラクタ。
		 */
		public function TriangleDrawer(numOfDiv:int, bitmapData:BitmapData):void
		{
			init(numOfDiv, bitmapData);
		}

		private function init(numOfDiv:int, bitmapData:BitmapData):void
		{
			m_container_mc = new Sprite();
			addChild(m_container_mc);
			
			m_numOfDiv = numOfDiv;
			m_img = new Bitmap(bitmapData, "auto", true);
			
			initData();
		}
		
		private function initData():void
		{
			// 頂点の座標
			m_vertices = new Vector.<Number>();
			// 描画の順番
			m_indices = new Vector.<int>();
			// UVマッピングデータ
			m_uvtData = new Vector.<Number>();
			
			//分割値。
			var stepW:Number = m_img.width / m_numOfDiv; 
			var stepH:Number = m_img.height / m_numOfDiv;
			
			// 四角形を描画していくので、4を加算して調整
			var stepInd:int = 0;

			// 縦方向のループ
			for(var i:int = 0; i<m_numOfDiv; i++){
				// 横方向のループ
				for(var j:int = 0; j<m_numOfDiv; j++){
					
					// 1.頂点の座標（四角形で考える）
					m_vertices.push(
								  j * stepW,		// 頂点 0（左上）
								  i * stepH,
								  (j+1) * stepW, 	// 頂点 1（右上）
								  i * stepH,
								  (j+1) * stepW, 	// 頂点 2（右下）
								  (i+1) * stepH,
								  j * stepW,		// 頂点 3（左下）
								  (i+1) * stepH);
					
					// 2.描画の順序
					// 1つ目の三角形：0,1,3（左上、右上、左下）
					// 2つ目の三角形：1,2,3（右上、右下、左下）
					m_indices.push(stepInd, stepInd + 1, stepInd + 3, stepInd + 1, stepInd + 2, stepInd + 3);
					
					// カウントアップ
					stepInd += 4;
					
					// 3.UVマッピングデータセット
					m_uvtData.push(
								  j / m_numOfDiv,		//頂点 0（左上）U
								  i / m_numOfDiv,		//				V
								  (j+1) / m_numOfDiv,	//頂点 1（右上）U
								  i / m_numOfDiv,		//				V
								  (j+1) / m_numOfDiv,	//頂点 2（右下）U
								  (i+1) / m_numOfDiv,	//				V
								  j/m_numOfDiv,			//頂点 3（左下）U
								  (i+1) / m_numOfDiv);	//				V
				}
				
			}
		}
		
		/**
		 * データをリセットします。
		 */
		public function resetData():void
		{
			initData();
		}
		
		/**
		 * 指定した半径の扇に変形し、描画します。
		 * 
		 * @param	radius
		 */
		public function renderSector(radius:Number = 2000, centerBottom:Boolean = true):void
		{
			m_centerBottom = centerBottom;
			if (m_centerBottom)
			{
				drawSector(radius);
			}
			else
			{
				drawSector2(radius);
			}
			
			render();
		}
		
		/**
		 * 現在のデータで描画します。
		 * 
		 * @param	drawLine
		 */
		public function render(drawLine:Boolean = false):void
		{
			m_container_mc.graphics.clear();
			if(drawLine)
				m_container_mc.graphics.lineStyle(1,0xff0099);
			m_container_mc.graphics.beginBitmapFill(m_img.bitmapData);
			m_container_mc.graphics.drawTriangles(m_vertices, m_indices, m_uvtData);			
		}

		private function drawSector(radius:Number = 2000):void
		{

			var _lt:Point = new Point(0, 0);
			var _rt:Point = new Point(m_img.width,0);		
			
			var maxRadius:Number = radius;
			var minRadius:Number = maxRadius - m_img.height;
			var difW:Number = m_img.width - m_img.width * (minRadius / maxRadius);
			difW /= 2;

			var _lb:Point = new Point(difW,m_img.height);
			var _rb:Point = new Point(m_img.width - difW, m_img.height);
			
			var r:Number = Math.atan2(_rt.y + maxRadius, _rt.x);
			var center:Point = new Point((_rt.x - _lt.x) / 2 , 0);
			var centerY:Number = Math.sqrt(maxRadius * maxRadius - (center.x * center.x));
			center.y = centerY;

			//扇の高さを求める。
			var sectorH:Number = Point.distance(center, _lt) - Point.distance(center, _lb);

			// 変更後の頂点座標データ
			var newPoint:Point = new Point();
			var newVertices:Vector.<Number> = new Vector.<Number>();
			
			// 範囲
			var baseL:Point = new Point();// 左
			var baseR:Point = new Point();// 右

			// 左下と左上の差分
			var curLw:Number = _lb.x - _lt.x;// 幅
			var curLh:Number = _lb.y - _lt.y;// 高さ
			// 右下と右上の差分
			var curRw:Number = _rb.x - _rt.x;// 幅
			var curRh:Number = _rb.y - _rt.y;// 高さ

			// x,yをセットで処理するのでループ回数はm_vertices.length/2
			for (var i:int = 0; i < m_vertices.length / 2; i++) {
				
				// uvデータ取り出し
				var u:Number = m_uvtData[i*2];	 // 偶数が u
				var v:Number = m_uvtData[i*2+1]; // 奇数が v
				
				// 範囲を算出
				baseL.x = _lt.x + curLw * v;
				baseL.y = _lt.y + curLh * v;
				baseR.x = _rt.x + curRw * v;
				baseR.y = _rt.y + curRh * v;
				
				// 新しい頂点座標を算出
				newPoint.x = baseL.x + (baseR.x - baseL.x) * u;
				newPoint.y = baseL.y + (baseR.y - baseL.y) * u;
				
				//円の中心とポイントの距離を求める。
				var pointDistance:Number = Point.distance(new Point(center.x, center.y), new Point(newPoint.x, newPoint.y));
				//中心とポイントの角度を求める。
				var circleRadian:Number = Math.atan2( -newPoint.y + center.y, -newPoint.x + center.x) +Math.PI ;
				//現在のポイントの半径を求める。
				var currentRadius:Number = (maxRadius) - sectorH * v;

				//半径と現在の距離の差。
				var difRadius = ( currentRadius - pointDistance);
				
				//x,y成分に合成する。
				newPoint.x += Math.cos(circleRadian) * difRadius;
				newPoint.y += Math.sin(circleRadian) * difRadius;

				newVertices.push(newPoint.x, newPoint.y);
			}

			m_vertices = newVertices;
			
		}
		

		private function drawSector2(radius:Number = 2000):void
		{

			var maxRadius:Number = radius;
			var minRadius:Number = maxRadius - m_img.height;
			var difW:Number = m_img.width - m_img.width * (minRadius / maxRadius);
			difW /= 2;
			
			var _lt:Point = new Point(difW, 0);
			var _rt:Point = new Point(m_img.width - difW, 0);
			var _lb:Point = new Point(0,m_img.height);
			var _rb:Point = new Point(m_img.width, m_img.height);
			
			var r:Number = Math.atan2(_rb.y - maxRadius, _rb.x);
			var center:Point = new Point((_rb.x - _lb.x) / 2 , 0);
			var centerY:Number = Math.sqrt(maxRadius * maxRadius - (center.x * center.x));
			center.y = _rb.y-centerY;
			
		
			graphics.beginFill(0xFF0000, 1);
			graphics.drawCircle(center.x, center.y, 10);
			graphics.endFill();
			
			graphics.lineStyle(3, 0xFF0000, 5);
			graphics.moveTo(_lb.x, _lb.y);
			graphics.lineTo(center.x, center.y);
			graphics.moveTo(_rb.x, _rb.y);
			graphics.lineTo(center.x, center.y);	

			//扇の高さを求める。
			var sectorH:Number = Point.distance(center, _lb)-Point.distance(center, _lt);

			trace(sectorH)
			// 変更後の頂点座標データ
			var newPoint:Point = new Point();
			var newVertices:Vector.<Number> = new Vector.<Number>();
			
			// 範囲
			var baseL:Point = new Point();// 左
			var baseR:Point = new Point();// 右

			// 左下と左上の差分
			var curLw:Number = _lb.x - _lt.x;// 幅
			var curLh:Number = _lb.y - _lt.y;// 高さ
			// 右下と右上の差分
			var curRw:Number = _rb.x - _rt.x;// 幅
			var curRh:Number = _rb.y - _rt.y;// 高さ

			// x,yをセットで処理するのでループ回数はm_vertices.length/2
			for (var i:int = 0; i < m_vertices.length / 2; i++) {
				
				// uvデータ取り出し
				var u:Number = m_uvtData[i*2];	 // 偶数が u
				var v:Number = m_uvtData[i*2+1]; // 奇数が v
				
				// 範囲を算出
				baseL.x = _lt.x + curLw * v;
				baseL.y = _lt.y + curLh * v;
				baseR.x = _rt.x + curRw * v;
				baseR.y = _rt.y + curRh * v;
				
				// 新しい頂点座標を算出
				newPoint.x = baseL.x + (baseR.x - baseL.x) * u;
				newPoint.y = baseL.y + (baseR.y - baseL.y) * u;
				
				//円の中心とポイントの距離を求める。
				var pointDistance:Number = Point.distance(new Point(center.x, center.y), new Point(newPoint.x, newPoint.y));
				//中心とポイントの角度を求める。
				var circleRadian:Number = Math.atan2( -newPoint.y + center.y, -newPoint.x + center.x) - Math.PI ;
				//現在のポイントの半径を求める。
				var currentRadius:Number = (maxRadius) - sectorH * (1-v);

				//半径と現在の距離の差。
				var difRadius = ( currentRadius - pointDistance);
				//trace(circleRadian/Math.PI*180)
				//x,y成分に合成する。
				newPoint.x += Math.cos(circleRadian) * difRadius;
				newPoint.y += Math.sin(circleRadian) * difRadius;

				newVertices.push(newPoint.x, newPoint.y);
			}

			m_vertices = newVertices;
			
		}
		
		public function get numOfDiv():int { return m_numOfDiv; }
		
		public function get vertices():Vector.<Number> { return m_vertices; }
		
		public function get uvtData():Vector.<Number> { return m_uvtData; }

		public function get bitmap():Bitmap
		{
			var btmd:BitmapData = new BitmapData(width, height, true, 0);
			btmd.draw(this);
			return new Bitmap(btmd, "auto", true);
		}		
	}
}
