/*
*/
package {
    import flash.display.Sprite;
    import flash.events.Event;
    import flash.text.TextField;
    import flash.display.StageScaleMode;
    import flash.events.MouseEvent;
    import flash.geom.ColorTransform;
    import caurina.transitions.Tweener;

    public class ColorBarClock extends Sprite{
        private var loadFiles_array:Array;
        //private var fullScreen:TextField = MakeUI.newTextField([,,100,18, "FullScreen",0xFFFFFF], [["selectable", false],["visible",false]]);
        //private var fullScreenCount:int;
        private var MultiLoader:MultiLoaderClass;
        private var baseURL:String = "";
        private var dataxmlURL:String = "get.cfm";
        private var colors_array:Array;
        private var colorBar_array:Array;
        private var n_array:Array = Utill.shuffle(5);
        private var oldSec:int = -1;
        
        public function ColorBarClock(){
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
            //stage.scaleMode = StageScaleMode.NO_SCALE;
            //stage.align = "TL";
            if(!isLocalPC()){
                baseURL = "http://kuler-api.adobe.com//feeds/rss/"
                //
                //dataxmlURL = "feed://kuler-api.adobe.com//feeds/rss/get.cfm?timeSpan=30&listType=rating";
            }
            MultiLoader = new MultiLoaderClass();
            loadFiles_array = MultiLoader.setLoad([baseURL+dataxmlURL], onXMLComp);
        }
        private function isLocalPC():Boolean{
            var _str:String = stage.loaderInfo.url;
            return (_str.substr(0,5) == "file:");
        
        }
        private function onXMLComp(e:Array):void{
            var data_xml:XML = XML(loadFiles_array[0].data);
            var len:int = data_xml.channel.item.length();
            colors_array = new Array(len);
            for (var i:int = 0; i < len; i++) {
                var items1:XML= localNameParse(data_xml.channel.item[i],"themeItem");
                var items2:XMLList = localNameParse(items1,"themeSwatches").children();
                var _length:int = items2.length();
                var _array:Array = new Array(_length);
                for (var j:int = 0; j < _length; j++) {
                    _array[j] = int("0x"+localNameParse(items2[j],"swatchHexColor").toString());
                }
                colors_array[i] = _array;
            }
            setColorBar(colors_array);
            
            function localNameParse(argXML:XML,localName:String):XML{
                var _XMLList:XMLList = argXML.children();
                var _length:int = _XMLList.length();
                var resultXML:XML;
                for (var i:int = 0; i < _length; i++) {
                    if(_XMLList[i].localName() == localName){
                        resultXML = _XMLList[i];
                    }
                }
                return resultXML;
            }
        }
        
        private function setColorBar(colors_array:Array):void{
            colorBar_array = new Array(colors_array.length*2);
            for (var i:int = 0; i < 10; i++) {
                colorBar_array[i] = MakeUI.newSprite([0,0],null,[["beginFill",[0x000000]],["drawRect",[0,0,50,1]]]);
                addChild(colorBar_array[i]);
            }
            addEventListener(Event.ENTER_FRAME, clock);
            //addEventListener(MouseEvent.CLICK, onClick);
            //stage.addEventListener(MouseEvent.MOUSE_MOVE, onMouse_over);
            //addChild(fullScreen);
        }
        private function clock(e:Event = null):void{
             //if(fullScreenCount < 100){
                //fullScreenCount++;
            //}else if(fullScreenCount == 100){
                //fullScreenCount++;
                //fullScreen.visible = false;
            //}
            var i:int;
            var j:int;
            var d:Date = new Date();
            if(oldSec == d.getSeconds()){
                return;
            }
            if(oldSec == -1){
                for (j = 0; j < 5; j++) {
                    i = n_array[j];
                    colorBar_array[i].transform.colorTransform = colorBar_array[i+5].transform.colorTransform = new ColorTransform(0,0,0,1,colors_array[c][i] >> 16,colors_array[c][i] >> 8 & 0xff,colors_array[c][i] & 0xff,0);
                }
            }
            oldSec = d.getSeconds();
            var d_array:Array = [d.getDate()/31 , d.getDay()/6 , d.getHours()/23 , d.getMinutes()/59 , d.getSeconds()/59];
            var all:Number = d_array[0]+d_array[1]+d_array[2]+d_array[3]+d_array[4];
            
            var w:Number = 0;
            var p:Number = 0;
            var c:int = d.getMinutes()%colors_array.length;
            var tweener_array:Array = new Array("linear","easeInCubic","easeOutCubic","easeInExpo","easeOutExpo","linear","easeInCubic","easeOutCubic","easeInExpo","easeOutExpo");
            if(oldSec == 0){
                n_array = Utill.shuffle(5);
            }
            
            for (j = 0; j < 5; j++) {
                i = n_array[j];
                p += w;
                w = (d_array[i]/all)*stage.stageWidth;
                var r:int = colors_array[c][i] >> 16;
                var g:int = colors_array[c][i] >> 8 & 0xff;
                var b:int = colors_array[c][i] & 0xff;
                if(oldSec%2 == 0){
                    i+=5;
                }
                if(getChildIndex(colorBar_array[i]) < 5){
                    swapChildrenAt((i+5)%10,i);
                }
                if(oldSec < 57){
                    colorBar_array[i].x = p;
                    colorBar_array[i].y = 0;
                    colorBar_array[i].width = w;
                    colorBar_array[i].transform.colorTransform = new ColorTransform(0,0,0,1,r,g,b,0);
                    colorBar_array[i].height = 1;
                    Tweener.addTween(colorBar_array[i], { height: stage.stageHeight, time: 0.9, transition: tweener_array[i] } );
                }else if(oldSec == 57){
                    w = (d_array[i]/all)*stage.stageHeight;
                    colorBar_array[i].x = stage.stageWidth;
                    colorBar_array[i].y = p;
                    colorBar_array[i].height = w;
                    colorBar_array[i].transform.colorTransform = new ColorTransform(0,0,0,1,r,g,b,0);
                    colorBar_array[i].width = 1;
                    Tweener.addTween(colorBar_array[i], { width: stage.stageWidth,x: 0, time: 0.9, transition: tweener_array[i] } );
                }else if(oldSec == 58){
                    colorBar_array[i].x = stage.stageWidth-p-w;
                    colorBar_array[i].y = stage.stageHeight;
                    colorBar_array[i].width = w;
                    colorBar_array[i].transform.colorTransform = new ColorTransform(0,0,0,1,r,g,b,0);
                    colorBar_array[i].height = 1;
                    Tweener.addTween(colorBar_array[i], { height: stage.stageHeight, y: 0, time: 0.9, transition: tweener_array[i] } );
                }else{
                    w = (d_array[i]/all)*stage.stageHeight;
                    colorBar_array[i].x = 0;
                    colorBar_array[i].y = stage.stageHeight-p-w;
                    colorBar_array[i].height = w;
                    colorBar_array[i].transform.colorTransform = new ColorTransform(0,0,0,1,r,g,b,0);
                    colorBar_array[i].width = 1;
                    Tweener.addTween(colorBar_array[i], { width: stage.stageWidth, time: 0.9, transition: tweener_array[i] } );
                }
            }
        }
        
        //private function onMouse_over(e:MouseEvent = null):void{
            //fullScreen.visible = true;
            //fullScreenCount = 0;
        //}
        //private function onClick(e:MouseEvent = null):void{
            //if(stage.displayState == "normal"){
                //stage.displayState = "fullScreen";
            //}else{
                //stage.displayState = "normal";
            //}
        //}
    }
}

class Utill extends Sprite {
    public static function shuffle(_n:int):Array {
        var _array:Array = new Array(); 
        for (var i:int= 0; i<_n; i++){ 
            _array[i] = Math.random(); 
        } 
        return _array.sort(Array.RETURNINDEXEDARRAY); 
    } 
}




import flash.display.DisplayObject;
import flash.display.Graphics;
import flash.text.TextField;
import flash.text.TextFieldType;
import flash.text.TextFormat;
import flash.display.Sprite;
import flash.display.Shape;
import flash.display.BitmapData;
import flash.display.Bitmap;
class MakeUI{
    public static var defaultTextFormat:TextFormat = new TextFormat();
    public static function newShape(x_y_w_h_sh:Array = null,property:Array=null,graphics:Array=null):Shape{
        var i:int;
        var sh:Shape;
        if(x_y_w_h_sh && x_y_w_h_sh[4]){
            sh = x_y_w_h_sh[4];
        }else{
            sh = new Shape();
        }
        if(x_y_w_h_sh){
            if (x_y_w_h_sh[0]) { sh.x = x_y_w_h_sh[0] };
            if (x_y_w_h_sh[1]) { sh.y = x_y_w_h_sh[1] };
        }
        if(property){
            for (i = 0; i < property.length; i++) {
                if(property[i] && property[i].length > 1){
                    sh[property[i][0]] = property[i][1];
                }
            }
        }
        if(graphics){
            for (i = 0; i < graphics.length; i++) {
                if(graphics[i] && graphics[i].length > 1){
                    sh.graphics[graphics[i][0]].apply(null, graphics[i][1]);
                }
            }
            
        }
        if(x_y_w_h_sh){
            if (x_y_w_h_sh[2]) { sh.width = x_y_w_h_sh[2] };
            if (x_y_w_h_sh[3]) { sh.height = x_y_w_h_sh[3] };
        }
        return sh;
    }
    public static function newSprite(x_y_w_h_sp:Array = null,property:Array=null,graphics:Array=null,addChild:DisplayObject = null):Sprite{
        var i:int;
        var sp:Sprite;
        if(x_y_w_h_sp && x_y_w_h_sp[4]){
            sp = x_y_w_h_sp[4];
        }else{
            sp = new Sprite();
        }
        if(x_y_w_h_sp){
            if (x_y_w_h_sp[0]) { sp.x = x_y_w_h_sp[0] };
            if (x_y_w_h_sp[1]) { sp.y = x_y_w_h_sp[1] };
        }
        if(property){
            for (i = 0; i < property.length; i++) {
                if(property[i] && property[i].length > 1){
                    sp[property[i][0]] = property[i][1];
                }
            }
        }
        if(graphics){
            for (i = 0; i < graphics.length; i++) {
                if(graphics[i] && graphics[i].length > 1){
                    sp.graphics[graphics[i][0]].apply(null, graphics[i][1]);
                }
            }
            
        }
        if(addChild){
            sp.addChild(addChild);
        }
        if(x_y_w_h_sp){
            if (x_y_w_h_sp[2]) { sp.width = x_y_w_h_sp[2] };
            if (x_y_w_h_sp[3]) { sp.height = x_y_w_h_sp[3] };
        }
        return sp;
    }

    public static function newTextField(x_y_w_h_txt_color_alpha:Array = null,property:Array=null,method:Array=null):TextField{
        var i:int;
        var ta:TextField = new TextField();
        ta.defaultTextFormat = defaultTextFormat;
        if(x_y_w_h_txt_color_alpha){
            if (x_y_w_h_txt_color_alpha[0]) { ta.x = x_y_w_h_txt_color_alpha[0] };
            if (x_y_w_h_txt_color_alpha[1]) { ta.y = x_y_w_h_txt_color_alpha[1] };
            if (x_y_w_h_txt_color_alpha[2]) { ta.width = x_y_w_h_txt_color_alpha[2] };
            if (x_y_w_h_txt_color_alpha[3]) { ta.height = x_y_w_h_txt_color_alpha[3] };
            if (x_y_w_h_txt_color_alpha[4]) { ta.text = x_y_w_h_txt_color_alpha[4] };
            if (x_y_w_h_txt_color_alpha[5]) { ta.textColor = x_y_w_h_txt_color_alpha[5] };
            if (x_y_w_h_txt_color_alpha[6]) { ta.alpha = x_y_w_h_txt_color_alpha[6] };
        }
        if(property){
            for (i = 0; i < property.length; i++) {
                if(property[i] && property[i].length > 1){
                    ta[property[i][0]] = property[i][1];
                }
            }
        }
        if(method){
            for (i = 0; i < method.length; i++) {
                if(method[i] && method[i].length > 1){
                    ta[i].apply(null, method[i][1]);
                }
            }
        }
        return ta;
    }
    
    public static function newTextFormat(_tf:TextFormat = null,property:Object = null):TextFormat{
        var tf:TextFormat;
        if(_tf){
            tf = _tf;
        }else{
            tf = new TextFormat();
        }
        if(property){
            for (var str:String in property) {
                tf[str] = property[str];
            }
        }
        return tf;
    }
    //以下はテスト
    public static function pozObject(x:Number=NaN,y:Number=NaN,width:Number=NaN,hight:Number=NaN,obj:Object = null):Object{
        if(x){obj.x = x}
        if(y){obj.y = y}
        return obj;
    }
    public static function newBitmap(x:Number=NaN,y:Number=NaN,width:Number=NaN,hight:Number=NaN,bd:BitmapData = null):Bitmap{
        var b:Bitmap = new Bitmap(bd);
        if(x){b.x = x}
        if(y){b.y = y}
        return b;
    }
}


import flash.display.Sprite;
class MultiLoaderClass extends Sprite{
    import flash.system.Security;
    import flash.net.URLRequest;
    import flash.net.URLLoader;
    import flash.net.URLLoaderDataFormat;
    import flash.events.Event;
    import flash.events.IOErrorEvent;
    import flash.display.Loader;
    //import flash.display.LoaderInfo;
    
    private var onComplete:Function = function(arg:Array=null):void{};
    //private var onOpen:Function = function():void{};
    private var loadNum:int;
    private var loadCompNum:int;
    private var error_array:Array = new Array();
    private var URLs_array:Array = new Array();
    private var _uniqueParam:String = "?timeSpan=30&listType=rating";
    
    public function set uniqueParam(uStr:String):void {
        //?timeSpan=30&listType=rating"
        if (uStr) {
            if (uStr.substr(0,2) == "?=") {
                _uniqueParam = uStr;
            }else {
                _uniqueParam = "?=" + uStr;
            }
        }else {
            _uniqueParam = "";
        }
    }
    public function get uniqueParam():String {
        return _uniqueParam;
    }
    
    public function MultiLoaderClass(_str:String = null,uStr:String = null){
        if(_str){
            Security.loadPolicyFile(_str);
        }
        uniqueParam = uStr;
    }
    
    public function setLoad(__item_array:Array = null, _onComp:Function = null):Array {
        loadCompNum = loadNum = 0;
        if(_onComp != null){
            onComplete = _onComp;
        }
        if (__item_array.length == 0) {
            loadNum ++;
            onComplete();
        }
        
        URLs_array = __item_array.concat();
        error_array = new Array();
        //onOpen = _onOpen;
        var _array:Array = new Array();
        var _length:int = __item_array.length;
        for (var i:int = 0; i < _length; i++) {
            error_array[i] = false;
            if (__item_array[i] == null) { continue };
            var _extension:String = __item_array[i].substr(-4,4).toLowerCase();//拡張子を取り出す。
            if (_extension == ".xml" || _extension == "html" || _extension == ".cfm") {
                loadNum ++;
                _array[i] = textFromURL(__item_array[i] + uniqueParam);
            }else if(_extension == ".jpg" || _extension == ".gif" || _extension == ".png" || _extension == ".swf"){
                loadNum ++;
                _array[i] = imgFromURL(__item_array[i] + uniqueParam);
            }else if(_extension == ".bin"){
                loadNum ++;
                __item_array[i] = __item_array[i].substr(0, __item_array[i].length - 4);
                _array[i] = binaryFromURL(__item_array[i] + uniqueParam);
            }else{
                //loadNum ++;
                //_array[i] = textFromURL(__item_array[i] + uniqueParam);
                //_array[i] = null;
            }
        }
        
        return _array;
    }
    private function binaryFromURL(__url:String):URLLoader{
        var _loader:URLLoader = new URLLoader();
        _loader.dataFormat = URLLoaderDataFormat.BINARY;
        _loader.addEventListener(Event.COMPLETE,completeHandler);
        _loader.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
        _loader.load(new URLRequest(__url));
        return _loader;
    }
    
    private function textFromURL(__url:String):URLLoader{
        var _loader:URLLoader = new URLLoader();
        _loader.addEventListener(Event.COMPLETE,completeHandler);
        _loader.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
        //_loader.addEventListener(Event.OPEN,openHandler);
        _loader.load(new URLRequest(__url));
        return _loader;
    }
    
    private function imgFromURL(__url:String):Loader{
        var _loader:Loader = new Loader();
        _loader.contentLoaderInfo.addEventListener(Event.COMPLETE, completeHandler);
        _loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
        //_loader.contentLoaderInfo.addEventListener(Event.OPEN,openHandler);
        _loader.load(new URLRequest(__url));
        return _loader;
    }
    
    private function completeHandler(event:Event = null):void {
        loadCompNum ++;
        if(loadCompNum == loadNum){
            onComplete(error_array);
        }
    }
    private function ioErrorHandler(event:IOErrorEvent):void {
        //event.text = "Error #2035: URL が見つかりません。 URL: file:///~~~~~";
        //event.text = "Error #2036: 読み込みが未完了です。 URL: http://~~~~~";
        //から、URLのみを取り出す。
        //trace(String(event.text).substr(String(event.text).indexOf(" URL: ")+6),"*****");
        for (var i:int = 0; i < URLs_array.length; i++) {
            var _str:String = String(event.text).substr(String(event.text).indexOf(" URL: ")+6).substr(-URLs_array[i].length);
            if(URLs_array[i] == _str){
                error_array[i] = true;
            }
        }
        completeHandler();
    }
}