package mobile;

import flixel.FlxCamera;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.graphics.atlas.FlxAtlas;
import flixel.graphics.atlas.FlxNode;
import flixel.graphics.frames.FlxTileFrames;
import flixel.input.FlxInput;
import flixel.input.FlxPointer;
import flixel.input.IFlxInput;
import flixel.input.touch.FlxTouch;
import flixel.math.FlxPoint;
#if (flixel >= "5.3.0")
import flixel.sound.FlxSound;
#else
import flixel.system.FlxSound;
#end
import flixel.text.FlxText;
import flixel.util.FlxDestroyUtil;
import mobile.input.FlxMobileInputID;

/**
 * A simple button class
 * @author: StarNova (CreamBR)
 */
class MobileButton extends MobileTypedButton<FlxText>
{
    public static inline var NORMAL:Int = 0;
    public static inline var HIGHLIGHT:Int = 1;
    public static inline var PRESSED:Int = 2;

    public var text(get, set):String;
    public var IDs:Array<FlxMobileInputID> = [];

    public function new(X:Float = 0, Y:Float = 0, ?IDs:Array<FlxMobileInputID>, ?Text:String, ?OnClick:Void->Void)
    {
        super(X, Y, OnClick);

        for (point in labelOffsets)
            point.set(point.x, point.y + 3);

        if (Text != null) initLabel(Text);
        if (IDs != null) this.IDs = IDs;
    }

    override function resetHelpers():Void
    {
        super.resetHelpers();
        if (label != null)
        {
            label.fieldWidth = label.frameWidth = Std.int(width);
            label.size = label.size; 
        }
    }

    inline function initLabel(Text:String):Void
    {
        if (label == null)
        {
            label = new FlxText(x, y, 80, Text);
            label.setFormat(null, 8, 0x333333, 'center');
            label.alpha = labelAlphas[status];
            label.drawFrame(true);
        }
        else
        {
            label.text = Text;
        }
    }

    inline function get_text():String return (label != null) ? label.text : null;

    inline function set_text(Text:String):String
    {
        if (label == null) initLabel(Text);
        else label.text = Text;
        return Text;
    }
}

#if !display
@:generic
#end
class MobileTypedButton<T:FlxSprite> extends FlxSprite implements IFlxInput
{
    public var label(default, set):T;
    public var labelOffsets:Array<FlxPoint> = [FlxPoint.get(), FlxPoint.get(), FlxPoint.get(0, 1)];
    public var labelAlphas:Array<Float> = [0.8, 1.0, 0.5];
    public var statusAnimations:Array<String> = ['normal', 'highlight', 'pressed'];
    public var allowSwiping:Bool = true;
    public var maxInputMovement:Float = Math.POSITIVE_INFINITY;
    public var status(default, set):Int;

    public var onUp(default, null):MobileButtonEvent;
    public var onDown(default, null):MobileButtonEvent;
    public var onOver(default, null):MobileButtonEvent;
    public var onOut(default, null):MobileButtonEvent;

    public var justReleased(get, never):Bool;
    public var released(get, never):Bool;
    public var pressed(get, never):Bool;
    public var justPressed(get, never):Bool;

    var _spriteLabel:FlxSprite;
    var input:FlxInput<Int>;
    var currentInput:IFlxInput;
    var lastStatus:Int = -1;

    public function new(X:Float = 0, Y:Float = 0, ?OnClick:Void->Void)
    {
        super(X, Y);
        loadDefaultGraphic();

        onUp = new MobileButtonEvent(OnClick);
        onDown = new MobileButtonEvent();
        onOver = new MobileButtonEvent();
        onOut = new MobileButtonEvent();

        status = MobileButton.NORMAL;
        scrollFactor.set();

        statusAnimations[MobileButton.HIGHLIGHT] = 'normal';
        labelAlphas[MobileButton.HIGHLIGHT] = 1;

        input = new FlxInput(0);
    }

    function loadDefaultGraphic():Void
        loadGraphic('flixel/images/ui/button.png', true, 80, 20);

    override public function destroy():Void
    {
        label = FlxDestroyUtil.destroy(label);
        _spriteLabel = null;
        onUp = FlxDestroyUtil.destroy(onUp);
        onDown = FlxDestroyUtil.destroy(onDown);
        onOver = FlxDestroyUtil.destroy(onOver);
        onOut = FlxDestroyUtil.destroy(onOut);
        labelOffsets = FlxDestroyUtil.putArray(labelOffsets);
        labelAlphas = null;
        currentInput = null;
        input = null;
        super.destroy();
    }

    override public function update(elapsed:Float):Void
    {
        super.update(elapsed);

        if (visible)
        {
            #if FLX_POINTER_INPUT
            updateButton();
            #end
            if (lastStatus != status)
            {
                animation.play(statusAnimations[status]);
                lastStatus = status;
            }
        }
        input.update();
    }

    function updateButton():Void
    {
        var overlapFound = checkTouchOverlap();

        if (currentInput != null && currentInput.justReleased && overlapFound)
            onUpHandler();

        if (status != MobileButton.NORMAL && (!overlapFound || (currentInput != null && currentInput.justReleased)))
            onOutHandler();
    }

    function checkTouchOverlap():Bool
    {
        for (touch in FlxG.touches.list)
        {
            for (camera in cameras)
            {
                if (checkInput(touch, touch, touch.justPressedPosition, camera))
                    return true;
            }
        }
        return false;
    }

    function checkInput(pointer:FlxPointer, input:IFlxInput, justPressedPosition:FlxPoint, camera:FlxCamera):Bool
    {
        var screenPos = pointer.getScreenPosition(FlxPoint.weak());
        
        if (maxInputMovement != Math.POSITIVE_INFINITY && 
            justPressedPosition.distanceTo(screenPos) > maxInputMovement && 
            input == currentInput)
        {
            currentInput = null;
            return false;
        }
        else if (overlapsPoint(pointer.getWorldPosition(camera, _point), true, camera))
        {
            updateStatus(input);
            return true;
        }
        return false;
    }

    function updateStatus(input:IFlxInput):Void
    {
        if (input.justPressed)
        {
            currentInput = input;
            onDownHandler();
        }
        else if (status == MobileButton.NORMAL)
        {
            if (allowSwiping && input.pressed) onDownHandler();
            else onOverHandler();
        }
    }

    function updateLabelPosition()
    {
        if (_spriteLabel != null)
        {
            _spriteLabel.x = (pixelPerfectPosition ? Math.floor(x) : x) + labelOffsets[status].x;
            _spriteLabel.y = (pixelPerfectPosition ? Math.floor(y) : y) + labelOffsets[status].y;
        }
    }

    /* Handler Methods */
    function onUpHandler():Void { status = MobileButton.NORMAL; input.release(); currentInput = null; onUp.fire(); }
    function onDownHandler():Void { status = MobileButton.PRESSED; input.press(); onDown.fire(); }
    function onOverHandler():Void { status = MobileButton.HIGHLIGHT; onOver.fire(); }
    function onOutHandler():Void { status = MobileButton.NORMAL; input.release(); onOut.fire(); }

    /* Setters & Getters */
    function set_label(Value:T):T
    {
        if (Value != null) Value.scrollFactor.copyFrom(scrollFactor);
        label = Value;
        _spriteLabel = label;
        updateLabelPosition();
        return Value;
    }

    function set_status(Value:Int):Int
    {
        status = Value;
        if (_spriteLabel != null && labelAlphas.length > status)
            _spriteLabel.alpha = alpha * labelAlphas[status];
        return status;
    }

    override function set_x(Value:Float):Float { super.set_x(Value); updateLabelPosition(); return x; }
    override function set_y(Value:Float):Float { super.set_y(Value); updateLabelPosition(); return y; }
    
    inline function get_justReleased():Bool return input.justReleased;
    inline function get_released():Bool return input.released;
    inline function get_pressed():Bool return input.pressed;
    inline function get_justPressed():Bool return input.justPressed;
}

private class MobileButtonEvent implements IFlxDestroyable
{
    public var callback:Void->Void;
    #if FLX_SOUND_SYSTEM
    public var sound:FlxSound;
    #end

    public function new(?Callback:Void->Void, ?sound:FlxSound)
    {
        callback = Callback;
        #if FLX_SOUND_SYSTEM
        this.sound = sound;
        #end
    }

    public inline function destroy():Void
    {
        callback = null;
        #if FLX_SOUND_SYSTEM
        sound = FlxDestroyUtil.destroy(sound);
        #end
    }

    public inline function fire():Void
    {
        if (callback != null) callback();
        #if FLX_SOUND_SYSTEM
        if (sound != null) sound.play(true);
        #end
    }
}
