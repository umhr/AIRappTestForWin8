package  
{
	
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.TouchEvent;
	import flash.text.TextField;
	import flash.ui.Mouse;
	import flash.ui.Multitouch;
	import flash.ui.MultitouchInputMode;
	/**
	 * ...
	 * @author umhr
	 */
	public class MultiTouchChecker extends Sprite 
	{
		
        private var _shapeList:Vector.<Shape> = new Vector.<Shape>();
        private var _textField:TextField = new TextField();
		public function MultiTouchChecker() 
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
			
            Multitouch.inputMode = MultitouchInputMode.TOUCH_POINT;

            var text:String = "";
            text += "maxTouchPoints:" + Multitouch.maxTouchPoints;
            text += "\n" + "supportedGestures:" + Multitouch.supportedGestures;
            text += "\n" + "supportsGestureEvents:" + Multitouch.supportsGestureEvents;
            text += "\n" + "supportsTouchEvents:" + Multitouch.supportsTouchEvents;
			
            _textField.width = 400;
			_textField.background = true;
			_textField.backgroundColor = 0xFFFFFF;
            _textField.selectable = false;
            _textField.text = text;
			_textField.autoSize = "left";
			_textField.y = stage.stageHeight - _textField.height;
            addChild(_textField);
			
            stage.addEventListener(TouchEvent.TOUCH_MOVE, stage_touchMove);

            if(Multitouch.maxTouchPoints){
                Mouse.hide();
                var n:int = Multitouch.maxTouchPoints;
                for (var i:int = 0; i < n; i++)
                {
                    var shape:Shape = new Shape();
                    shape.graphics.beginFill(0xFFFFFF * Math.random(), 0.5);
                    shape.graphics.drawCircle(0, 0, 20);
                    shape.graphics.endFill();
                    shape.graphics.beginFill(0x666666, 0.5);
                    shape.graphics.drawCircle(0, 0, 15);
                    shape.graphics.endFill();
                    addChild(shape);
                    _shapeList[i] = shape;
                }
            }
			
			
		}
        private function stage_touchMove(event:TouchEvent):void
        {
            var shape:Shape = _shapeList[event.touchPointID % _shapeList.length];
            shape.x = event.localX;
            shape.y = event.localY;
        }
	}
	
}