package  {
	import Controls.ControlSet;
	import org.flixel.*;
	
	/**
	 * ...
	 * @author ...
	 */
	public class MenuThing extends FlxGroup {
		//[Embed(source = "../lib/sounds/Menu/oop.mp3")] public static const oop:Class;
		//[Embed(source = "../lib/sounds/Menu/ooop.mp3")] public static const ooop:Class;
		
		protected var text:FlxText;
		protected var highlight:FlxSprite;
		protected var moused:Boolean;
		protected var fades:Boolean;
		
		protected var i:int;
		public var selected:Boolean;
		protected var nextSelected:Boolean;
		protected var onSelect:Function;
		
		public static var menuThings:Array;
		
		public function MenuThing(desc:String, OnSelect:Function = null, Fade:Boolean = true) {
			super();
			
			i = menuThings.length;
			menuThings.push(this);
			onSelect = OnSelect;
			fades = Fade;
			
			init(desc);
		}
		
		public function init(desc:String = null):void {
			var X:int = 0;
			var Y:int = FlxG.height / 4 + i * 40;
			var size:int = 20;
			var align:String = 'center';
			var font:String = C.BLOCKFONT;
			
			if (text) {
				X = text.x;
				Y = text.y;
				align = text.alignment;
				size = text.size;
				font = text.font;
				
				remove(text);
			}
			
			text = new FlxText(X, Y, FlxG.width, desc);
			text.alignment = align;
			text.font = font;
			text.size = size;
			add(text);
			
			createHighlight();
		}
		
		protected function createHighlight():void {
			if (highlight) remove(highlight);
			var X:int = text.alignment == 'center' ? FlxG.width / 2 - text.textWidth / 2 - 10 : text.x - 5;
			highlight = new FlxSprite(X, text.y - 5);
			highlight.createGraphic(text.textWidth + 20, text.height + 10, 0x80ffffff);
			highlight.visible = selected;
			add(highlight);
		}
		
		public function select():void {
			nextSelected = true;
		}
		
		public function deselect():void {
			highlight.visible = selected = false;
		}
		
		override public function update():void {
			var lastMoused:Boolean = moused;
			moused = highlight.overlapsPoint(FlxG.mouse.x, FlxG.mouse.y);
			if (!lastMoused && moused && onSelect != null)
				C.sound.play(SEL_SOUND, 0.125);
			
			if (selected) {
				if (FlxG.keys.justPressed("UP")) {
					menuThings[(i + menuThings.length - 1) % menuThings.length].select();
					C.sound.play(UP_SOUND, 0.25);
					deselect();
				} else if (FlxG.keys.justPressed("DOWN")) {
					menuThings[(i + 1) % menuThings.length].select();
					C.sound.play(DOWN_SOUND, 0.25);
					deselect();
				} else if (FlxG.keys.justPressed("ENTER"))//(ControlSet.CONFIRM_KEY.justReleased())
					choose();
			}
			
			if (nextSelected) {
				selected = highlight.visible = true;
				nextSelected = false;
			}
			
			if (moused && FlxG.mouse.justPressed())
				choose();
		}
		
		protected function choose():void {
			if (onSelect != null) {
				if (fades)
					FlxG.fade.start(0xff000000, FadeState.FADE_TIME, onFadeEnd);
				else
					onFadeEnd();
				C.sound.playPersistent(choiceSound, 0.25);
			}
		}
		
		protected function get choiceSound():Class {
			return CHOOSE_SOUND;
		}
		
		protected function onFadeEnd():void {
			onSelect(text.text);
		}
		
		public function get X():int {
			return highlight.x;
		}
		
		public function get fullWidth():int {
			return highlight.width;
		}
		
		public function get fullHeight():int {
			return highlight.height;
		}
		
		public function setY(Y:int):void {
			text.y = Y;
			highlight.y  = Y - 5;
		}
		
		public function setX(X:int):void {
			text.x = X;
			highlight.x = X - 5;
			text.alignment = 'left';
		}
		
		public function setFormat(Font:String = null, Size:Number = 8, Color:uint = 0xffffff, Alignment:String = null):MenuThing {
			text.setFormat(Font, Size, Color, Alignment);
			createHighlight();
			return this;
		}
		
		
		override public function render():void {
			highlight.visible = isHighlighted;
			super.render();
		}
		
		protected function get isHighlighted():Boolean {
			return selected || moused;
		}
		
		protected function forceRender():void {
			super.render();
		}
		
		
		public static function addColumn(newColumn:Array, X:int):void {
			var i:int;
			
			//vertically center new column
			var elementHeight:int = newColumn[0].fullHeight;
			var spacing:int = 8;
			var totalHeight:int = newColumn.length * elementHeight + (newColumn.length - 1) * spacing;
			var top:int = (FlxG.height - totalHeight) / 2;
			for (i = 0; i < newColumn.length; i++) {
				newColumn[i].setY(top + i * (spacing + elementHeight));
				newColumn[i].setX(X); //placeholder!
			}
			
			columns.push(newColumn);
			
			/*//horizontally space columns
			
			for each (var column:Array in columns)*/
				
		}
		public static var columns:Array;
		
		public static function resetThings():void {
			menuThings = [];
			columns = [];
		}
		
		[Embed(source = "../lib/sound/menu/down2.mp3")] protected const DOWN_SOUND:Class;
		[Embed(source = "../lib/sound/menu/down.mp3")] protected const UP_SOUND:Class;
		[Embed(source = "../lib/sound/menu/down3.mp3")] protected const SEL_SOUND:Class;
		[Embed(source = "../lib/sound/menu/choose2.mp3")] protected const CHOOSE_SOUND:Class;
	}

}