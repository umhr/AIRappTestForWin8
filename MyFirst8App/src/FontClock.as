package
{
	import flash.display.Sprite;
	import flash.events.TimerEvent;
	import flash.text.Font;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.utils.Timer;
	/**
	 * ...
	 * @author umhr
	 */
	[SWF(backgroundColor="0xFDFAF9")]
	public class FontClock extends Sprite {
		private var fonts:Array;
		public function FontClock():void {
			//fontのリストを取得
			fonts = Font.enumerateFonts(true);
			//1秒に一度onTimerを呼び出す。
			var timer:Timer = new Timer(1000,0);
			timer.addEventListener(TimerEvent.TIMER,onTimer);
			timer.start();
			
			this.mouseEnabled = false;
		}
		private function onTimer(e:TimerEvent):void{
			while (this.numChildren > 0) {
				this.removeChildAt(0);
			}

			var canvasYMD:Sprite = new Sprite();
			var canvasTime:Sprite = new Sprite();

			//時刻を取得
			var date:Date = new Date();
			var times:Array = [String(date.getFullYear()),"/",String(date.getMonth()+1),"/",String(date.getDate()),String(date.getHours()),":",String(date.getMinutes()),".",String(date.getSeconds())];

			//ランダムを使って、フォントを設定。
			for (var i:int = 0; i < times.length; i++) {
				var tf:TextField = new TextField();
				tf.text = times[i];
				var fontNumber:int = Math.floor(fonts.length * Math.random());
				tf.selectable = false;
				tf.textColor = 0xFFFFFF;
				if(i < 5){
					tf.setTextFormat(new TextFormat(fonts[fontNumber].fontName, 21));
					tf.autoSize = "right";
					tf.x = canvasYMD.width;
					canvasYMD.addChild(tf);
				}else {
					tf.setTextFormat(new TextFormat(fonts[fontNumber].fontName, 68));
					tf.autoSize = "right";
					tf.x = canvasTime.width;
					tf.y = canvasYMD.height;
					canvasTime.addChild(tf);
				}
			}
			
			canvasYMD.x = (canvasTime.width - canvasYMD.width) / 2;
			canvasTime.addChild(canvasYMD);
			//画面真ん中に
			canvasTime.x = 	(stage.stageWidth-canvasTime.width)/2;
			canvasTime.y = 	(stage.stageHeight-canvasTime.height)/2;
			this.addChild(canvasTime);
		}
	}
}