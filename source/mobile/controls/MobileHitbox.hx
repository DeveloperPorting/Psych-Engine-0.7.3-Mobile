package mobile.controls;

import flixel.FlxG;
import flixel.util.FlxDestroyUtil;
import openfl.display.BitmapData;
import openfl.display.Shape;
import mobile.backend.MobileUtil;
import mobile.backend.flixel.TouchButton;
import mobile.backend.flixel.input.TouchInputManager;
import mobile.backend.flixel.input.TouchInputID;

/**
 * Hitbox... HIT
 * @author StarNova (Cream.BR)
 */
 
class MobileHitbox extends TouchInputManager
{
	public var buttons:Array<TouchButton> = [];
	
	public var buttonLeft:TouchButton;
	public var buttonDown:TouchButton;
	public var buttonUp:TouchButton;
	public var buttonRight:TouchButton;

	private final alphaTarget:Float = 0.2;
	
	private var _cachedGraphics:Map<Int, flixel.graphics.FlxGraphic> = new Map();

	public function new():Void
	{
		super();

		var buttonWidth:Int = Std.int(FlxG.width / 4);
		var data = [
			{color: 0xFF00FF, ids: [TouchInputID.NOTE_LEFT]},
			{color: 0x00FFFF, ids: [TouchInputID.NOTE_DOWN]},
			{color: 0x00FF00, ids: [TouchInputID.NOTE_UP]},
			{color: 0xFF0000, ids: [TouchInputID.NOTE_RIGHT]}
		];
		
		for (i in 0...data.length) {
			var btn = createHint(i * buttonWidth, 0, buttonWidth, FlxG.height, data[i].color, data[i].ids);
			add(btn);
			buttons.push(btn);
		}

		buttonLeft  = buttons[0];
		buttonDown  = buttons[1];
		buttonUp    = buttons[2];
		buttonRight = buttons[3];

		scrollFactor.set();
		refreshMappedButtons();
	}

	private function createHint(X:Float, Y:Float, Width:Int, Height:Int, Color:FlxColor, IDs:Array<TouchInputID>):TouchButton
	{
		var hint:TouchButton = new TouchButton(X, Y, IDs);
		
		var graphicKey:Int = Color + Width;
		var bgGraphic:flixel.graphics.FlxGraphic = _cachedGraphics.get(graphicKey);
		
		if (bgGraphic == null) {
			var bitmap:BitmapData = new BitmapData(Width, Height, true, (Color & 0x00FFFFFF) | 0x88000000);
			bgGraphic = FlxG.bitmap.add(bitmap, false, "hitbox_" + graphicKey);
			_cachedGraphics.set(graphicKey, bgGraphic);
		}
		
		hint.loadGraphic(bgGraphic);
		hint.solid = hint.moves = false;
		hint.immovable = true;
		hint.scrollFactor.set();
		hint.alpha = 0.00001;

        if (!ClientPrefs.data.invisibleHitbox) {
			var hintTween:FlxTween = null;
			hint.onDown.callback = function() {
			    if (hintTween != null) hintTween.cancel();
			    
			    hintTween = FlxTween.tween(hint, {alpha: alphaTarget}, 0.075, {
			        ease: FlxEase.circInOut,
			        onComplete: function(_) { hintTween = null; }
			    });
			}
			
			hint.onUp.callback = function() {
			    if (hintTween != null) hintTween.cancel();
			    
			    hintTween = FlxTween.tween(hint, {alpha: 0.00001}, 0.15, {
			        ease: FlxEase.circInOut,
			        onComplete: function(_) { hintTween = null; }
			    });
			}
			
			hint.onOut.callback = hint.onUp.callback;
		}

		#if FLX_DEBUG
		hint.ignoreDrawDebug = true;
		#end
		
		return hint;
	}

    // It will be used for skins in the future
	/*private function createHintGraphic(Width:Int, Height:Int, Color:Int):BitmapData
	{
		var shape:Shape = new Shape();
		shape.graphics.beginFill(Color);
		shape.graphics.drawRect(0, 0, Width, Height);
		shape.graphics.endFill();

		var bitmap:BitmapData = new BitmapData(Width, Height, true, 0);
		bitmap.draw(shape);
		return bitmap;
	}*/
	
	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
	
		MobileUtil.setControlsState(this, buttons);
	}

	override function destroy():Void
	{
		super.destroy();
		for (btn in buttons)
			FlxDestroyUtil.destroy(btn);
			
		for (key in _cachedGraphics.keys()) {
			var graphic = _cachedGraphics.get(key);
			FlxG.bitmap.remove(graphic);
			graphic.destroy();
		}
		_cachedGraphics.clear();
	}
}
