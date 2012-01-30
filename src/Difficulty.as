package  {
	/**
	 * ...
	 * @author Nicholas "PleasingFungus" Feinberg
	 */
	public class Difficulty {
		
		public var setting:Number = V_EASY;
		public function Difficulty() {
			
		}
		
		public function load():void {
			setting = C.save.read("difficulty") as int;
		}
		
		public function save():void {
			C.save.write("difficulty", setting);
		}
		
		
		public function increaseDifficulty():void {
			setting = setting + (MAX_DIFFICULTY - setting) / 4;
		}
		
		public function get meteoroidMultiplier():Number {
			return Math.floor(setting) / 2;
		}
		
		public function get meteoroidSpeedFactor():Number {
			return Math.floor(setting) / 2;
		}
		
		public function get blockSlack():Number {
			if (setting >= V_HARD)
				return 0;
			return 1 + 1 / (1 + setting)
		}
		
		public function waveSpacing():Number {
			if (setting <= EASY)
				return 1.5;
			else if (setting <= NORMAL)
				return 1;
			return 0.75;
		}
		
		
		
		public function name(forSetting:Number = -1):String {
			if (forSetting == -1)
				forSetting = setting;
			return ["V. Easy", "Easy", "Normal", "Hard", "V. Hard"][Math.floor(forSetting)];
		}
		
		protected const V_EASY:Number = 0;
		protected const EASY:Number = 1;
		protected const NORMAL:Number = 2;
		protected const HARD:Number = 3;
		protected const V_HARD:Number = 4;
		public const MAX_DIFFICULTY:Number = 5;
	}

}