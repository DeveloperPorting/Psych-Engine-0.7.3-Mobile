package mobile.controls;

import flixel.FlxG;
import flixel.graphics.FlxGraphic;
import flixel.graphics.frames.FlxTileFrames;
import flixel.math.FlxPoint;
import flixel.util.FlxDestroyUtil;
import mobile.input.FlxMobileInputManager;
import mobile.input.FlxMobileInputID;
import openfl.utils.Assets;

enum MobileDPadMode {
  UP_DOWN;
  LEFT_RIGHT;
  UP_LEFT_RIGHT;
  LEFT_FULL;
  NONE;
}

enum MobileActionMode {
  A;
  A_B;
  A_B_C;
  NONE;
}

class MobileVirtualPad extends FlxMobileInputManager {
  
    public var buttonLeft:MobileButton;
    public var buttonUp:MobileButton;
    public var buttonRight:MobileButton;
    public var buttonDown:MobileButton;
  
    public var buttonA:MobileButton;
    public var buttonB:MobileButton;
    public var buttonC:MobileButton;

    private var _buttons:Array<MobileButton> = [];

    public function new(DPad:MobileDPadMode, Action:MobileActionMode)
    {
        super();

        switch (DPad)
        {
            case UP_DOWN:
                buttonUp = createButton(0, FlxG.height - 255, 'up', 0x00FF00, [UP, noteUP]);
                buttonDown = createButton(0, FlxG.height - 135, 'down', 0x00FFFF, [DOWN, noteDOWN]);
            case LEFT_RIGHT:
                buttonLeft = createButton(0, FlxG.height - 135, 'left', 0xFF00FF, [LEFT, noteLEFT]);
                buttonRight = createButton(127, FlxG.height - 135, 'right', 0xFF0000, [RIGHT, noteRIGHT]);
            case UP_LEFT_RIGHT:
                buttonUp = createButton(105, FlxG.height - 243, 'up', 0x00FF00, [UP, noteUP]);
                buttonLeft = createButton(0, FlxG.height - 135, 'left', 0xFF00FF, [LEFT, noteLEFT]);
                buttonRight = createButton(207, FlxG.height - 135, 'right', 0xFF0000, [RIGHT, noteRIGHT]);
            case LEFT_FULL:
                buttonUp = createButton(105, FlxG.height - 345, 'up', 0x00FF00, [UP, noteUP]);
                buttonLeft = createButton(0, FlxG.height - 243, 'left', 0xFF00FF, [LEFT, noteLEFT]);
                buttonRight = createButton(207, FlxG.height - 243, 'right', 0xFF0000, [RIGHT, noteRIGHT]);
                buttonDown = createButton(105, FlxG.height - 135, 'down', 0x00FFFF, [DOWN, noteDOWN]);
            case NONE:
                //Nothing LMAO
        }

        switch (Action)
        {
            case A:
                buttonA = createButton(FlxG.width - 132, FlxG.height - 135, 'a', 0xFF0000, [A]);
            case A_B:
                buttonB = createButton(FlxG.width - 258, FlxG.height - 135, 'b', 0xFFCB00, [B]);
                buttonA = createButton(FlxG.width - 132, FlxG.height - 135, 'a', 0xFF0000, [A]);
            case A_B_C:
                buttonC = createButton(FlxG.width - 384, FlxG.height - 135, 'c', 0x44FF00, [C]);
                buttonB = createButton(FlxG.width - 258, FlxG.height - 135, 'b', 0xFFCB00, [B]);
                buttonA = createButton(FlxG.width - 132, FlxG.height - 135, 'a', 0xFF0000, [A]);
            case NONE:
                //Nothing LMAO
        }

        scrollFactor.set();
        updateTrackedButtons();
    }

    private function createButton(x:Float, y:Float, graphicName:String, color:Int, ids:Array<FlxMobileInputID>):MobileButton
    {
        var path:String = 'assets/mobile/virtualpad/${graphicName}.png';
        if (!Assets.exists(path)) path = 'assets/mobile/virtualpad/default.png';

        var graphic:FlxGraphic = FlxG.bitmap.add(path);
        var button:MobileButton = new MobileButton(x, y, ids);
        
        button.frames = FlxTileFrames.fromGraphic(graphic, FlxPoint.get(Std.int(graphic.width / 3), graphic.height));
        button.solid = false;
        button.immovable = true;
        button.scrollFactor.set();
        button.color = color;
        button.alpha = 0.5;
 

        add(button);
        _buttons.push(button);
        return button;
    }

    override public function destroy():Void
    {
        super.destroy();

        for (buttons in _buttons)
            FlxDestroyUtil.destroy(buttons);
    }
}
