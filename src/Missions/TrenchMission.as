package Missions {
	import org.flixel.FlxU;
	import Mining.MineralBlock;
	import Mining.Terrain;
	import flash.geom.Point;
	/**
	 * ...
	 * @author Nicholas "PleasingFungus" Feinberg
	 */
	public class TrenchMission extends TerrestrialMission {
		
		public function TrenchMission(Seed:Number) {
			mapWidth = (19) * 2;
			rockDepth = 26;
			chunkSize = 3;
			atmosphere = 18;
			
			super(Seed);
		}
		
		override protected function topAt(x:int):int {
			var pitBottom:int = rockDepth - 4;
			
			var distFromCenter:int = Math.abs(x - mapWidth / 2);
			var distFraction:Number = distFromCenter / (mapWidth / 2);
			
			var offset:int = FlxU.random() * 3;
			
			var pitFraction:Number = 1 / 2;
			var pitBottomFraction:Number = 1 / 6;
			if (distFraction > pitFraction)
				return offset;
			if (distFraction < pitBottomFraction)
				return pitBottom + offset;
			
			return pitBottom * (1 - (distFraction - pitBottomFraction) / (pitFraction - pitBottomFraction)) + offset;
		}
		
		override protected function bedrockDepthAt(x:int):int {
			return Math.floor(rockDepth - (FlxU.random() * 2 + 2));
		}
		
		override protected function randomMineralType():int {
			return MineralBlock.WEAK_MINERALS;
		}
		
	}

}