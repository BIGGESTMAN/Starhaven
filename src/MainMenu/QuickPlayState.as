package MainMenu {
	import org.flixel.*;
	import Scenarios.*;
	import Controls.ControlSet;
	
	/**
	 * ...
	 * @author Nicholas "PleasingFungus" Feinberg
	 */
	public class QuickPlayState extends FadeState {
		
		override public function create():void {
			super.create();
			
			var title:FlxText = new FlxText(10, 20, FlxG.width - 20, "Quick Play");
			title.setFormat(C.TITLEFONT, 48, 0xffffff, 'center');
			add(title);
			
			MenuThing.resetThings();
			var leftCol:Array = [];
			for (var i:int = 0; i < C.difficulty.MAX_DIFFICULTY; i++)
				leftCol.push(add(new DifficultyThing(C.difficulty.name(i), i)));
			MenuThing.addColumn(leftCol, FlxG.width/8);
			
			
			var rightCol:Array = [];
			addScenario(AsteroidScenario, "Asteroid", rightCol);
			addScenario(PlanetScenario, "Moon", rightCol);
			addScenario(NebulaScenario, "Nebula", rightCol);
			addScenario(WaterScenario, "Sea", rightCol);
			addScenario(DustScenario, "Dust", rightCol);
			addScenario(MountainScenario, "Mountain", rightCol);
			addScenario(TrenchScenario, "Pit", rightCol);
			MenuThing.addColumn(rightCol, FlxG.width * 5 / 8);
			
			//var info:FlxText = new FlxText(0, FlxG.height - 25, FlxG.width, "Use arrow keys to navigate and enter to select.");
			//info.setFormat(C.FONT, 12, 0xffffff, 'center');
			//add(info);
			
			//C.music.intendedMusic = Music.MENU_MUSIC;
			var cancelButton:StateThing = new StateThing("Cancel", MenuState);
			cancelButton.setY(FlxG.height - 60);
			add(cancelButton);
		}
		
		protected function addScenario(scenario:Class, name:String, rightCol:Array):void {
			rightCol.push(add(new MemoryThing(name, scenario)));
		}
		
		override public function update():void {
			super.update();
			
			if (ControlSet.CANCEL_KEY.justPressed())
				fadeTo(MenuState);
			//C.music.update();
		}
	}

}