package 
{
	import flash.display.Sprite;
	import flash.events.Event;
	
	/**
	 * ...
	 * @author umhr
	 */
	[SWF(width = 465, height = 465, backgroundColor = 0x000000, frameRate = 60)]
	public class Main extends Sprite 
	{
		
		public function Main():void 
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
			stage.scaleMode = "noScale";
			stage.align = "TL";
			stage.displayState = "fullScreen";
			
			addChild(new Canvas());
			
		}
		
	}
	
}