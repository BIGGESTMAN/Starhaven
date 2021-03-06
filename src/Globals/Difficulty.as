package Globals {
	import GrabBags.BagType;
	/**
	 * ...
	 * @author Nicholas "PleasingFungus" Feinberg
	 */
	public class Difficulty {
		
		public var initialSetting:Number = EASY;
		public var setting:Number = EASY;
		public var scaleSetting:int = MEDIUM;
		public var bagSize:int = -1; //needs to be set by scenario!
		public function Difficulty() {
			
		}
		
		public function load():void {
			setting = (C.save.read("difficulty") as int) - 1;
			if (setting == -1) setting = EASY;
			
			initialSetting = (C.save.read("initDifficulty") as int) - 1;
			if (initialSetting == -1) initialSetting = EASY;
			
			scaleSetting = (C.save.read("scaleSetting") as int) - 1;
			if (scaleSetting == -1) scaleSetting = MEDIUM;
		}
		
		public function save():void {
			C.save.write("difficulty", setting+1);
			C.save.write("initDifficulty", initialSetting+1);
			C.save.write("scaleSetting", scaleSetting+1);
		}
		
		
		public function increaseDifficulty():void {
			setting = setting + (MAX_DIFFICULTY - setting) / 10;
		}
		
		public function get meteoroidMultiplier():Number {
			if (C.IN_TUTORIAL)	
				return 1;
			return setting / 2;
		}
		
		public function get meteoroidSpeedFactor():Number {
			if (C.IN_TUTORIAL || setting <= EASY)	
				return 0.6;
			if (setting < NORMAL)
				return 0.6 + (setting - EASY) * 0.4; //0.6 to 1.0 [easy]
			if (setting < HARD)
				return 1.0 + (setting - EASY) * 0.3; //1.0 to 1.3 [normal]
			if (setting < V_HARD)
				return 1.3 + (setting - HARD) * 0.2; //1.3 to 1.5 [hard]
			return 1.5 + (setting - HARD) * 0.1; 	 //1.5 to 1.6 [v.hard]
		}
		
		public function initialWaveSpacing():Number {
			if (setting <= EASY && !C.IN_TUTORIAL)
				return 1.5;
			return 1;
		}
		
		public function laterWaveSpacing():Number {
			if (C.IN_TUTORIAL)
				return 1/2;
			
			var remainingTime:int = GlobalCycleTimer.notionalMiningTime - initialWaveSpacing() * bagSize;
			
			var desiredWaves:int;
			if (setting <= EASY)
				desiredWaves = 3;
			else
				desiredWaves = 4;
			
			var waveSpacing:Number = remainingTime / (desiredWaves - 1);
			
			if (waveSpacing < bagSize / 2)
				waveSpacing = bagSize / 2;
			
			C.log("Later wave spacing: " + bagSize, remainingTime, desiredWaves, waveSpacing);
			return waveSpacing / bagSize; //multiplied by bagSize on the other end, because, good code
		}
		
		
		public function scale(forSetting:int = -1):Number {
			if (forSetting == -1)
				forSetting = scaleSetting;
			return [3/4, 1, 3/2][forSetting];
		}
		
		public function name(forSetting:Number = -1):String {
			if (forSetting == -1)
				forSetting = initialSetting;
			return ["Beginner", "Easy", "Normal", "Hard", "Too Hard"][Math.floor(forSetting)];
		}
		
		public function scaleName(forSetting:int = -1):String {
			if (forSetting == -1)
				forSetting = scaleSetting;
			return ["Small", "Medium", "Large"][forSetting];
		}
		
		public const V_EASY:Number = 0;
		public const EASY:Number = 1;
		public const NORMAL:Number = 2;
		public const HARD:Number = 3;
		public const V_HARD:Number = 4;
		public const MAX_DIFFICULTY:Number = 5;
		
		public const SMALL:int = 0;
		public const MEDIUM:int = 1;
		public const LARGE:int = 2;
		public const MAX_SIZE:int = 3;
	}

}