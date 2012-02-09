package Options {
	import Controls.ControlSet;
	import Controls.Key;
	import Helpers.KeyHelper;
	import org.flixel.*;
	import MainMenu.StateThing;
	/**
	 * ...
	 * @author Nicholas "PleasingFungus" Feinberg
	 */
	public class SoundState extends FadeState {
		
		protected var upKey:KeyHelper;
		protected var downKey:KeyHelper;
		protected var sliders:Vector.<VolumeSlider>;
		protected var selectedSlider:int;
		override public function create():void {
			super.create();
			
			var t:FlxText;
			
			t = new FlxText(0, 10, FlxG.width, "Volume");
			t.setFormat(C.TITLEFONT, 48, 0xffffff, 'center');
			add(t);
			
			MenuThing.resetThings();
			var backButton:StateThing = new StateThing("Back", OptionsState);
			backButton.setY(FlxG.height - 40);
			add(backButton);
			
			add(upKey = new KeyHelper(new Key("UP")));
			sliders = new Vector.<VolumeSlider>;
			sliders.push(add(new VolumeSlider(FlxG.height / 2 - 100, "Global Volume", getGlobalVolume, setGlobalVolume)));
			sliders.push(add(new VolumeSlider(FlxG.height / 2 - 30, "Music Volume", C.music.getMusicVolume, C.music.setMusicVolume)));
			sliders.push(add(new VolumeSlider(FlxG.height / 2 + 40, "Effect Volume", C.sound.getVolume, C.sound.setVolume)));
			sliders[0].selected = true;
			add(downKey = new KeyHelper(new Key("DOWN")));
			
			upKey.x = downKey.x = FlxG.width / 2 - upKey.width / 2;
			upKey.y = sliders[0].y - upKey.height - 15;
			downKey.y = sliders[sliders.length - 1].y + (sliders[sliders.length - 1].y - sliders[sliders.length - 2].y) + 15;
		}
		
		private function getGlobalVolume():Number {
			return FlxG.volume;
		}
		
		private function setGlobalVolume(n:Number):Number {
			return FlxG.volume = n;
		}
		
		override public function update():void {
			super.update();
			checkKeys();
			if (ControlSet.CANCEL_KEY.justPressed())
				fadeTo(OptionsState);
		}
		
		protected function checkKeys():void {
			if (upKey.key.justPressed()) {
				sliders[selectedSlider].selected = false;
				selectedSlider = (selectedSlider + sliders.length - 1) % sliders.length;
				sliders[selectedSlider].selected = true;
			}
			if (downKey.key.justPressed()) {
				sliders[selectedSlider].selected = false;
				selectedSlider = (selectedSlider + 1) % sliders.length;
				sliders[selectedSlider].selected = true;
			}
		}
		
	}

}