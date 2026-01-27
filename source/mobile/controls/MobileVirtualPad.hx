package mobile.controls;

import flixel.FlxG;
import flixel.graphics.FlxGraphic;
import flixel.graphics.frames.FlxTileFrames;
import flixel.math.FlxPoint;
import flixel.util.FlxDestroyUtil;
import mobile.flixel.FlxButton;
import openfl.utils.Assets;
import mobile.flixel.input.FlxMobileInputManager;
import mobile.flixel.input.FlxMobileInputID;

enum MobileDPadMode {
    UP_DOWN;
    LEFT_RIGHT;
    UP_LEFT_RIGHT;
    LEFT_FULL;
    RIGHT_FULL;
    NONE;
}

enum MobileActionMode {
    A;
    B;
    X;
    A_B;
    A_B_C;
    CHART_EDITOR;
    NONE;
}

/**
 * Virtual Pad.... Virtual... Buttons
 *
 * @author StarNova (Cream.BR)
 */

class MobileVirtualPad extends FlxMobileInputManager
{
    public var buttons:Array<FlxButton> = [];

    public var buttonLeft:FlxButton;
    public var buttonUp:FlxButton;
    public var buttonRight:FlxButton;
    public var buttonDown:FlxButton;
    public var buttonLeft2:FlxButton;
    public var buttonUp2:FlxButton;
    public var buttonRight2:FlxButton;
    public var buttonDown2:FlxButton;

    public var buttonA:FlxButton;
    public var buttonB:FlxButton;
    public var buttonC:FlxButton;
    public var buttonD:FlxButton;
    public var buttonE:FlxButton;
    public var buttonV:FlxButton;
    public var buttonX:FlxButton;
    public var buttonY:FlxButton;
    public var buttonZ:FlxButton;

    public function new(DPad:MobileDPadMode, Action:MobileActionMode)
    {
        super();

        switch (DPad)
        {
            case UP_DOWN:
                buttonUp = add(createButton(0, FlxG.height - 255, 'up', 0x00FF00, [UP, noteUP]));
                buttonDown = add(createButton(0, FlxG.height - 135, 'down', 0x00FFFF, [DOWN, noteDOWN]));
            case LEFT_RIGHT:
                buttonLeft = add(createButton(0, FlxG.height - 135, 'left', 0xFF00FF, [LEFT, noteLEFT]));
                buttonRight = add(createButton(127, FlxG.height - 135, 'right', 0xFF0000, [RIGHT, noteRIGHT]));
            case UP_LEFT_RIGHT:
                buttonUp = add(createButton(105, FlxG.height - 243, 'up', 0x00FF00, [UP, noteUP]));
                buttonLeft = add(createButton(0, FlxG.height - 135, 'left', 0xFF00FF, [LEFT, noteLEFT]));
                buttonRight = add(createButton(207, FlxG.height - 135, 'right', 0xFF0000, [RIGHT, noteRIGHT]));
            case LEFT_FULL:
                buttonUp = add(createButton(105, FlxG.height - 345, 'up', 0x00FF00, [UP, noteUP]));
                buttonLeft = add(createButton(0, FlxG.height - 243, 'left', 0xFF00FF, [LEFT, noteLEFT]));
                buttonRight = add(createButton(207, FlxG.height - 243, 'right', 0xFF0000, [RIGHT, noteRIGHT]));
                buttonDown = add(createButton(105, FlxG.height - 135, 'down', 0x00FFFF, [DOWN, noteDOWN]));
            default:
        }

        var screenW = FlxG.width;
        var screenH = FlxG.height;

        switch (Action)
        {
            case A:
                buttonA = add(createButton(screenW - 132, screenH - 135, 'a', 0xFF0000, [A]));
            case B:
				buttonB = add(createButton(screenW - 132, screenH - 135, 'b', 0xFFCB00, [B]));
		    case X:
				buttonX = add(createButton(screenW - 132, screenH - 135, 'x', 0x99062D, [X]));
            case A_B:
                buttonB = add(createButton(screenW - 258, screenH - 135, 'b', 0xFFCB00, [B]));
                buttonA = add(createButton(screenW - 132, screenH - 135, 'a', 0xFF0000, [A]));
            case A_B_C:
				buttonC = add(createButton(screenW - 384, screenH - 135, 'c', 0x44FF00, [C]));
				buttonB = add(createButton(screenW - 258, screenH - 135, 'b', 0xFFCB00, [B]));
				buttonA = add(createButton(screenW - 132, screenH - 135, 'a', 0xFF0000, [A]));
            case CHART_EDITOR:
				buttonV = add(createButton(screenW - 510, screenW - 255, 'v', 0x49A9B2, [V]));
				buttonD = add(createButton(screenW - 510, screenW - 135, 'd', 0x0078FF, [D]));
				buttonX = add(createButton(screenW - 384, screenW - 255, 'x', 0x99062D, [X]));
				buttonC = add(createButton(screenW - 384, screenW - 135, 'c', 0x44FF00, [C]));
				buttonY = add(createButton(screenW - 258, screenW - 255, 'y', 0x4A35B9, [Y]));
				buttonB = add(createButton(screenW - 258, screenW - 135, 'b', 0xFFCB00, [B]));
				buttonZ = add(createButton(screenW - 132, screenW - 255, 'z', 0xCCB98E, [Z]));
				buttonA = add(createButton(screenW - 132, screenW - 135, 'a', 0xFF0000, [A]));
            default:
        }

        scrollFactor.set();
        updateTrackedButtons();
    }

    private function createButton(X:Float, Y:Float, Graphic:String, Color:Int, IDs:Array<FlxMobileInputID>):FlxButton
    {
        var path = 'assets/mobile/virtualpad/${Graphic}.png';
        if (!Assets.exists(path)) path = 'assets/mobile/virtualpad/default.png';
        
        var graphic = FlxG.bitmap.add(path);
        var button = new FlxButton(X, Y, IDs);
        button.frames = FlxTileFrames.fromGraphic(graphic, FlxPoint.get(Std.int(graphic.width / 3), graphic.height));
        
        button.solid = button.moves = false;
        button.immovable = true;
        button.scrollFactor.set();
        button.color = Color;
        button.alpha = 0.5;
        #if FLX_DEBUG button.ignoreDrawDebug = true; #end
        
        buttons.push(button);
        return button;
    }

    override public function destroy():Void
    {
        super.destroy();
        for (btn in buttons)
            FlxDestroyUtil.destroy(btn);
    }
}
