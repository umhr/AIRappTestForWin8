package  
{
	
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import net.hires.debug.Stats;
	/**
	 * ...
	 * @author umhr
	 */
	public class Canvas extends Sprite 
	{
		private var _shape:Shape = new Shape();
		public function Canvas() 
		{
			init();
		}
		private function init():void 
		{
            if (stage) onInit();
            else addEventListener(Event.ADDED_TO_STAGE, onInit);
        }
        
        private function onInit(event:Event = null):void 
        {
			removeEventListener(Event.ADDED_TO_STAGE, onInit);
			// entry point
			
			addChild(new Photo());
			addChild(new FontClock());
			addChild(new Stats());
			addChild(new MultiTouchChecker());
			
		}
		
	}
	
}