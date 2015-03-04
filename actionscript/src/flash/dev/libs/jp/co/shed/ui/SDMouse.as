package jp.co.shed.ui
{
	import flash.display.Stage;
	import flash.events.Event;
	import flash.geom.Point;

	/**
	 * マウスを管理。
	 * 
	 * @author yasunari ishibashi
	 */
	public class SDMouse 
	{
		
		private var m_stage:Stage;
		
		private var m_prev:Point;
		
		private var m_current:Point;
		
		public function SDMouse(stage:Stage) 
		{
			m_stage = stage;
			var x:Number = m_stage.mouseX;
			var y:Number = m_stage.mouseY;
			
			m_prev = new Point(x,y);
			m_current = m_prev.clone();
		}
		
		public function play():void
		{
			m_stage.addEventListener(Event.ENTER_FRAME, onFrameChanged);
		}
		
		public function stop():void
		{
			m_stage.removeEventListener(Event.ENTER_FRAME, onFrameChanged);
		}
		
		private function onFrameChanged(e:Event):void
		{
			m_prev.x = m_current.x;
			m_prev.y = m_current.y;
			m_current.x = m_stage.mouseX;
			m_current.y = m_stage.mouseY;
		}
		
		public function get prevMouseX():Number
		{ 
			return m_prev.x; 
		}
		
		public function get prevMouseY():Number
		{ 
			return m_prev.y; 
		}
		
		public function get differenceX():Number
		{
			return m_current.x - m_prev.x;
		}
		
		public function get differenceY():Number
		{
			return m_current.y - m_prev.y;
		}
	}

}