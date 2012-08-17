package {
    import flash.display.Sprite;
    import flash.text.TextField;
    import flash.text.TextFieldAutoSize;
    import flash.filters.DropShadowFilter;
    
    import flash.display.Bitmap;
    import flash.display.BitmapData;
    import flash.display.Loader;
    import flash.events.Event;
    import flash.net.URLLoader;
    import flash.net.URLRequest;
    import flash.system.LoaderContext;
    import flash.system.Security;
    public class Photo extends Sprite {
		
		private var _credit:TextField = new TextField();
		
        public function Photo() {
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
            //検索結果のロード
            var myURLLoader:URLLoader = new URLLoader();
            myURLLoader.addEventListener(Event.COMPLETE, onCompleteXML);
			
			var random:int = Math.random() * 20 + 1;
			//var imgmax:int = Math.max(stage.stageWidth, stage.stageHeight);
            var xmlURL:String = "http://photos.googleapis.com/data/feed/base/all?alt=rss&isVideo=false&kind=photo&q=sea&imglic=commercial&max-results=3&imgmax=1024&start-index=" + random;
            //crossdomain.xml（クロスドメインポリシーファイル）の位置を指定
            Security.loadPolicyFile("http://photos.googleapis.com/data/crossdomain.xml");        //*1
            myURLLoader.load(new URLRequest(xmlURL));
        }
        
        private function onCompleteXML(e:Event):void {
            //取得したデータをXML型にする。
            var myXML:XML = new XML(e.currentTarget.data);        //*2
            
            //XMLを解析
            var titleStr:String = myXML.channel.item[0].title;        //*3
            var linkURL:String = myXML.channel.item[0].link;        //*4
            //namespaceを設定
            default xml namespace = new Namespace("http://search.yahoo.com/mrss/");        //*5
            var creditStr:String = myXML.channel.item[0].group.credit;        //*6
            var imgURL:String = myXML.channel.item[0].group.content.@url;        //*7
            
            _credit.autoSize = TextFieldAutoSize.LEFT;
            _credit.width = 300;
            //_credit.x = 50;
            //_credit.y = 50;
            _credit.multiline = true;
            _credit.text = "Photo by:" + creditStr;
			_credit.textColor = 0xFFFFFF;
			_credit.background = true;
			_credit.backgroundColor = 0x000000;
			_credit.visible = false;
            addChild(_credit);
            
            //画像のロード
            var myLoader:Loader = new Loader();
            var myURLRequest:URLRequest = new URLRequest(imgURL);
            //クロスドメインポリシーファイルをドキュメントルートから取得
            var myLoaderContext:LoaderContext = new LoaderContext(true);        //*8
            myLoader.load(myURLRequest, myLoaderContext);
            myLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, onCompleteImg);
        }
        
        private function onCompleteImg(event:Event):void {
            var myBitmap:Bitmap = event.target.content;
			
			
            myBitmap.smoothing = true;
			
			var scale:Number = Math.max(stage.stageWidth / myBitmap.width, stage.stageHeight / myBitmap.height);
			myBitmap.scaleX = myBitmap.scaleY = scale;
			
			addChildAt(myBitmap, 0);
			
			_credit.x = stage.stageWidth - _credit.width;
			_credit.y = stage.stageHeight - _credit.height;
			_credit.visible = true;
        }
    }
}
