package GameBonuses {
	import GameBonuses.Attack.AttackScenario;
	import org.flixel.*;
	import MainMenu.MemoryThing;
	import MainMenu.MenuState;
	import Controls.ControlSet;
	/**
	 * ...
	 * @author Nicholas "PleasingFungus" Feinberg
	 */
	public class BonusState extends FadeState {
		
		override public function create():void {
			super.create();
			loadBackground(BG, 0.65);
			
			var t:FlxText;
			
			t = new FlxText(0, 10, FlxG.width, "Bonuses");
			t.setFormat(C.TITLEFONT, 48, 0xffffff, 'center');
			add(t);
			
			MenuThing.resetThings();
			add(new MemoryThing("Attack Mode!", AttackScenario));
			add(new MemoryThing("Back", MenuState));
		}
		
		override public function update():void {
			super.update();
			if (ControlSet.CANCEL_KEY.justPressed()) {
				fadeBackTo(MenuState);
			}
		}
		
		[Embed(source = "../../lib/art/backgrounds/menu/menu_bg_bonus.jpg")] private const BG:Class;
		
	}

}