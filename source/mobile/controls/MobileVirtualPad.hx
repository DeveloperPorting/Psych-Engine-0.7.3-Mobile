package mobile.controls;

import flixel.FlxG;
import flixel.graphics.FlxGraphic;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.graphics.frames.FlxTileFrames;
import flixel.group.FlxSpriteGroup;
import flixel.math.FlxPoint;
import flixel.util.FlxDestroyUtil;
import openfl.utils.Assets;
import openfl.display.BitmapData;
import mobile.input.FlxMobileInputID;
import mobile.input.FlxMobileInputManager;
import mobile.FlxButton;

/**
 * This is to configure the buttons
 */
enum MobileDPadMode
{
	UP_DOWN;
	LEFT_RIGHT;
	UP_LEFT_RIGHT;
	LEFT_FULL;
	RIGHT_FULL;
	NONE;
}

enum MobileActionMode
{
	A;
	B;
	C;
	A_B;
	A_B_C;
	NONE;
}

/**
 * Our own VirtualPad
 * Always willing to bring improvements
 *
 * @author StarNova (CreamBR)
 */
class MobileVirtualPad extends FlxMobileInputManager {

    public var buttonLeft:FlxButton = new FlxButton(0, 0, [FlxMobileInputID.LEFT, FlxMobileInputID.noteLEFT]);
	public var buttonUp:FlxButton = new FlxButton(0, 0, [FlxMobileInputID.UP, FlxMobileInputID.noteUP]);
	public var buttonRight:FlxButton = new FlxButton(0, 0, [FlxMobileInputID.RIGHT, FlxMobileInputID.noteRIGHT]);
	public var buttonDown:FlxButton = new FlxButton(0, 0, [FlxMobileInputID.DOWN, FlxMobileInputID.noteDOWN]);

	public var buttonA:FlxButton = new FlxButton(0, 0, [FlxMobileInputID.A]);
	public var buttonB:FlxButton = new FlxButton(0, 0, [FlxMobileInputID.B]);
	public var buttonC:FlxButton = new FlxButton(0, 0, [FlxMobileInputID.C]);

	var storedButtonsIDs:Map<String, Array<FlxMobileInputID>> = new Map<String, Array<FlxMobileInputID>>();

	/**
	 * Create the VirtualPad.
	 *
	 * @param   DPadMode     The D-Pad mode. `LEFT_FULL` for example.
	 * @param   ActionMode   The action buttons mode. `A_B_C` for example.
	 */
    public function new(DPad:MobileDPadMode, Action:MobileActionMode) {

    super();
	   for (button in Reflect.fields(this)) {
			if (Std.isOfType(Reflect.field(this, button), FlxButton))
				storedButtonsIDs.set(button, Reflect.getProperty(Reflect.field(this, button), 'IDs'));
       }

        switch (DPad) {
			case UP_DOWN:
				add(buttonUp = createButton(0, FlxG.height - 255, 'up'));
				add(buttonDown = createButton(0, FlxG.height - 135, 'down'));
			case LEFT_RIGHT:
				add(buttonLeft = createButton(0, FlxG.height - 135, 'left'));
				add(buttonRight = createButton(127, FlxG.height - 135, 'right'));
			case UP_LEFT_RIGHT:
				add(buttonUp = createButton(105, FlxG.height - 243, 'up'));
				add(buttonLeft = createButton(0, FlxG.height - 135, 'left'));
				add(buttonRight = createButton(207, FlxG.height - 135, 'right'));
			case LEFT_FULL:
				add(buttonUp = createButton(105, FlxG.height - 345, 'up'));
				add(buttonLeft = createButton(0, FlxG.height - 243, 'left'));
				add(buttonRight = createButton(207, FlxG.height - 243, 'right'));
				add(buttonDown = createButton(105, FlxG.height - 135, 'down'));
			case RIGHT_FULL:
				add(buttonUp = createButton(FlxG.width - 258, FlxG.height - 408, 'up'));
				add(buttonLeft = createButton(FlxG.width - 384, FlxG.height - 309, 'left'));
				add(buttonRight = createButton(FlxG.width - 132, FlxG.height - 309, 'right'));
				add(buttonDown = createButton(FlxG.width - 258, FlxG.height - 201, 'down'));
			case NONE:
                // Nothing like my bank account
		}

		switch (Action) {
			case A:
				add(buttonA = createButton(FlxG.width - 132, FlxG.height - 135, 'a'));
			case B:
				add(buttonB = createButton(FlxG.width - 132, FlxG.height - 135, 'b'));
		    case C:
				add(buttonC = createButton(FlxG.width - 132, FlxG.height - 135, 'c'));
			case A_B:
				add(buttonB = createButton(FlxG.width - 258, FlxG.height - 135, 'b'));
				add(buttonA = createButton(FlxG.width - 132, FlxG.height - 135, 'a'));
			case A_B_C:
				add(buttonC = createButton(FlxG.width - 384, FlxG.height - 135, 'c'));
				add(buttonB = createButton(FlxG.width - 258, FlxG.height - 135, 'b'));
				add(buttonA = createButton(FlxG.width - 132, FlxG.height - 135, 'a'));
			case NONE:
                // Nothing.. like... absolutely nothing
    }
  
    for (button in Reflect.fields(this))
		{
			if (Std.isOfType(Reflect.field(this, button), FlxButton))
				Reflect.setProperty(Reflect.getProperty(this, button), 'IDs', storedButtonsIDs.get(button));
		}
		scrollFactor.set();
		updateTrackedButtons();
	}

    /**
	 * For those with a bad phone-
	 */
	override public function destroy():Void
	{
		super.destroy();
		buttonLeft = FlxDestroyUtil.destroy(buttonLeft);
		buttonUp = FlxDestroyUtil.destroy(buttonUp);
		buttonDown = FlxDestroyUtil.destroy(buttonDown);
		buttonRight = FlxDestroyUtil.destroy(buttonRight);

		buttonA = FlxDestroyUtil.destroy(buttonA);
		buttonB = FlxDestroyUtil.destroy(buttonB);
		buttonC = FlxDestroyUtil.destroy(buttonC);
  }

  private function createButton(X:Float, Y:Float, Graphic:String, Color:Int = 0xFFFFFF):FlxButton {
   
		var graphic:FlxGraphic;
	  
		if (Assets.exists('assets/mobile/virtualpad/' + Graphic + '.png'))
			graphic = FlxGraphic.fromBitmapData(Assets.getBitmapData('assets/mobile/virtualpad/' + Graphic + '.png'));
		else
			graphic = FlxGraphic.fromBitmapData(Assets.getBitmapData('assets/mobile/virtualpad/default.png'));

		var button:FlxButton = new FlxButton(X, Y);
		button.frames = FlxTileFrames.fromGraphic(graphic, FlxPoint.get(Std.int(graphic.width / 3), graphic.height));
		button.solid = false;
		button.immovable = true;
		button.scrollFactor.set();
		button.color = Color;
		button.alpha = 0.5;
		#if FLX_DEBUG
		button.ignoreDrawDebug = true;
		#end
		return button;
  }
}