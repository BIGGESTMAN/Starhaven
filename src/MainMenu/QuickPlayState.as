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
			for (var i:int = C.difficulty.V_EASY; i < C.difficulty.MAX_DIFFICULTY; i++)
				if (C.unlocks.difficultyUnlocked(i))
					leftCol.push(add(new DifficultyThing(C.difficulty.name(i), i)));
				else
					leftCol.push(add(new MysteryThing));
			MenuThing.addColumn(leftCol, FlxG.width/8);
			
			
			var rightCol:Array = [];
			addScenario(PlanetScenario, rightCol);
			addScenario(AsteroidScenario, rightCol);
			addScenario(MountainScenario, rightCol);
			addScenario(NebulaScenario, rightCol);
			addScenario(WaterScenario, rightCol);
			addScenario(DustScenario, rightCol);
			addScenario(DCrescentScenario, rightCol);
			MenuThing.addColumn(rightCol, FlxG.width * 5 / 8);
			
			//var info:FlxText = new FlxText(0, FlxG.height - 25, FlxG.width, "Use arrow keys to navigate and enter to select.");
			//info.setFormat(C.FONT, 12, 0xffffff, 'center');
			//add(info);
			
			C.music.intendedMusic = C.music.MENU_MUSIC;
			var cancelButton:StateThing = new StateThing("Cancel", MenuState);
			cancelButton.setY(FlxG.height - 60);
			add(cancelButton);
		}
		
		protected function addScenario(scenario:Class, rightCol:Array):void {
			if (C.unlocks.scenarioUnlocked(scenario))
				rightCol.push(add(new MemoryThing(C.scenarioList.nameOf(scenario), scenario)));
			else
				rightCol.push(add(new MysteryThing));
		}
		
		override public function update():void {
			super.update();
			
			if (ControlSet.CANCEL_KEY.justPressed()) {
				fadeBackTo(MenuState);
			}
			//music.update();
		}
	}

}