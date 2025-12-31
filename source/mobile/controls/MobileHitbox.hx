package mobile.controls;

import flixel.FlxG;
import flixel.util.FlxDestroyUtil;
import flixel.util.FlxColor;
import mobile.MobileButton;
import mobile.input.FlxMobileInputManager;
import mobile.input.FlxMobileInputID;

/**
 * Hitbox... what were you expecting?
 * @author StarNova (CreamBR)
 */
class MobileHitbox extends FlxMobileInputManager {

	public var buttonLeft:MobileButton;
	public var buttonDown:MobileButton;
	public var buttonUp:MobileButton;
	public var buttonRight:MobileButton;

	public function new():Void
	{
		super();

		var w:Int = Std.int(FlxG.width / 4);
		var h:Int = FlxG.height;

		add(buttonLeft = createHint(0, 0, w, h, 0xFF00FF, [hitboxLEFT, noteLEFT]));
		add(buttonDown = createHint(w, 0, w, h, 0x00FFFF, [hitboxDOWN, noteDOWN]));
		add(buttonUp = createHint(w * 2, 0, w, h, 0x00FF00, [hitboxUP, noteUP]));
		add(buttonRight = createHint(w * 3, 0, w, h, 0xFF0000, [hitboxRIGHT, noteRIGHT]));
		
		scrollFactor.set();
		updateTrackedButtons();
	}

	override function destroy():Void
	{
		super.destroy();

		buttonLeft = FlxDestroyUtil.destroy(buttonLeft);
		buttonDown = FlxDestroyUtil.destroy(buttonDown);
		buttonUp = FlxDestroyUtil.destroy(buttonUp);
		buttonRight = FlxDestroyUtil.destroy(buttonRight);
	}

	private function createHint(X:Float, Y:Float, Width:Int, Height:Int, Color:FlxColor, IDs:Array<FlxMobileInputID>):MobileButton
	{
		var hint:MobileButton = new MobileButton(X, Y, IDs);
		
		hint.makeGraphic(1, 1, FlxColor.WHITE);
		hint.scale.set(Width, Height);
		hint.updateHitbox(); 

		hint.color = Color;
		hint.alpha = 0.00001;
		hint.solid = false;
		hint.immovable = true;
		hint.scrollFactor.set();

		// So here you go
		hint.onDown.callback = hint.onOver.callback = function() hint.alpha = 0.2;
		hint.onUp.callback = hint.onOut.callback = function() hint.alpha = 0.00001;

		return hint;
	}
}