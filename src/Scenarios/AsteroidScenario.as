package Scenarios {
	import flash.display.BitmapData;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import InfoScreens.HelpState;
	import Mining.BaseAsteroid
	import Mining.MineralBlock;
	import Mining.Terrain;
	import Missions.AsteroidMission;
	import org.flixel.*;
	import Meteoroids.MeteoroidTracker;
	/**
	 * ...
	 * @author ...
	 */
	public class AsteroidScenario extends SpaceScenario {
		
		public function AsteroidScenario(Seed:Number = NaN) {
			super(Seed);
			
			goal = 0.75;
			missionType = AsteroidMission;
		}
		
		override protected function blockLimitToFullyMine():int {
			return 50;
		}
		
		override protected function repositionLevel():void {
			var closestLocation:Point = findClosestFreeSpot();
			
			station.core.gridLoc.x = closestLocation.x;
			station.core.gridLoc.y = closestLocation.y;
			station.centroidOffset.x = -closestLocation.x;
			station.centroidOffset.y = -closestLocation.y;
		}
		
		protected function findClosestFreeSpot():Point {
			var closestSpot:Point = new Point;
			while (rock.resourceAt(closestSpot))
				closestSpot.y -= 1;
			return closestSpot;
		}
	}
	

}