package  {
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import Metagame.Campaign;
	import org.flixel.*;
	import Icons.NoCrewIcon;
	import Icons.NoPowerIcon;
	/**
	 * ...
	 * @author Nicholas Feinberg
	 */
	public class C {
		public static const VERSION:String = "0.016";
		public static const DEBUG:Boolean = true;
		public static const DEBUG_COLOR:uint = 0xffff00ff;
		public static const DEBUG_SEED:Number = 0.5089746117591858;
		public static const DISPLAY_BOUNDS:Boolean = false;
		public static const DISPLAY_DRAW_AREA:Boolean = false;
		public static const ALWAYS_SHOW_ASTEROIDS:Boolean = false;
		public static const ALWAYS_SHOW_INCOMING:Boolean = false;
		public static const DISPLAY_FIRE_AREA:Boolean = false;
		public static const FORGET_EVENTS:Boolean = false;
		public static const DEBUG_TEST_STATION:Boolean = false;
		public static const DISPLAY_COLLISION:Boolean = false;
		public static const ANNOYING_NEW_PIECE_POPUP:Boolean = true;
		public static const FORGET_PIECES:Boolean = false;
		public static const NO_CREW:Boolean = false;
		public static var HUD_ENABLED:Boolean = true;
		
		public static var DRAW_GLOW:Boolean = true;
		public static var GLOW_SCALE:Number = 6;
		public static const GLOW_ALPHA:Number = 1;
		
		[Embed(source = "../lib/fonts/CryptOfTomorrow.ttf", fontFamily = "FUTUR")] private const _1:String;
		public static const TITLEFONT:String = "FUTUR";
		[Embed(source = "../lib/fonts/StarPerv.ttf", fontFamily = "BLOCK")] private const _2:String;
		public static const BLOCKFONT:String = "BLOCK";
		public static const FONT:String = "BLOCK";
		
		
		
		
		
		public static const BLOCK_SIZE:int = 16;
		public static const CYCLE_TIME:Number = .5;
		public static var B:Bounds;
		public static var campaign:Campaign;
		public static var difficulty:Difficulty;
		//public static var music:Music;
		public static var save:FlxSave;
		public static var fluid:Mino;
		
		public static function init():void {
			B = new Bounds();
			//music = new Music();
			difficulty = new Difficulty();
			
			ICONS[MINERALS] = _minerals_icon;
			ICONS[PEOPLE] = _crew_icon;
			ICONS[POWER] = _power_icon;
			ICONS[DAMAGE] = _damage_icon;
			ICONS[HOUSING] = _housing_icon;
			ICONS[WATER] = _water_icon;
			ICONS[GOODS] = _goods_icon;
			
			save = new FlxSave();
			save.bind("Starhaven");
			difficulty.load();
		}
		
		public static function setPrintReady():void {
			if (printReady)
				return;
			
			printReady = true;
			log(initialBuffer);
			initialBuffer = null;
		}
		
		
		
		
		
		
		
		public static var iconLayer:FlxGroup;
		
		
		
		
		private static var initialBuffer:String = null;
		private static var printReady:Boolean = false;
		public static function log(...args):void {
			var outStr:String = "";
			if (args.length > 1)
				for each (var o:Object in args.slice(0, args.length - 1))
					outStr += o + ", ";
			
			outStr += args[args.length - 1];
			if (printReady)
				FlxG.log(outStr);
			else if (initialBuffer)
				initialBuffer += "\n" + outStr;
			else
				initialBuffer = outStr;
		}
		
		public static function weightedChoice(weights:Array):int {
			var total:Number = 0;
			for each (var weight:Number in weights)
				total += weight;
			
			var roll:Number = FlxU.random() * total;
			for (var i:int = 0; i < weights.length; i++) {
				if (roll < weights[i])
					return i;
				roll -= weights[i];
			}
			
			return i; //error!
		}
		
		
		public static function renderTime(totalSeconds:int):String {
			var seconds:int = totalSeconds % 60;
			var minutes:int = totalSeconds / 60;
			return minutes + ":" + (seconds < 10 ? "0" : "") + seconds;
		}
		
		public static function interpolateColors(a:uint, b:uint, aFraction:Number):uint {
			var alpha:int = ((a >> 24) & 0xff) * aFraction + ((b >> 24) & 0xff) * (1 - aFraction);
			var red:int = ((a >> 16) & 0xff) * aFraction + ((b >> 16) & 0xff) * (1 - aFraction);
			var green:int = ((a >> 8) & 0xff) * aFraction + ((b >> 8) & 0xff) * (1 - aFraction);
			var blue:int = ((a >> 0) & 0xff) * aFraction + ((b >> 0) & 0xff) * (1 - aFraction);
			return (alpha << 24) | (red << 16) | (green << 8 ) | blue;
		}
		
		
		public static const MINERALS:int = 0;
		public static const PEOPLE:int = 1;
		public static const POWER:int = 2;
		public static const DAMAGE:int = 3;
		public static const HOUSING:int = 4;
		public static const WATER:int = 5;
		public static const GOODS:int = 6;
		public static const ICONS:Array = [];
		[Embed(source = "../lib/art/ui/icon_person_2.png")] private static const _crew_icon:Class;
		[Embed(source = "../lib/art/ui/icon_minerals_2.png")] private static const _minerals_icon:Class;
		[Embed(source = "../lib/art/ui/icon_power.png")] private static const _power_icon:Class;
		[Embed(source = "../lib/art/ui/icon_damage.png")] private static const _damage_icon:Class;
		[Embed(source = "../lib/art/ui/icon_person_2.png")] private static const _housing_icon:Class;
		[Embed(source = "../lib/art/ui/icon_water.png")] private static const _water_icon:Class;
		[Embed(source = "../lib/art/ui/icon_goods.png")] private static const _goods_icon:Class;
	}

}