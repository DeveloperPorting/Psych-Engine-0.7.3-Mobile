package mobile.backend;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxCamera;
import flixel.math.FlxMath;
import openfl.display.BitmapData;
import flixel.graphics.FlxGraphic;
import flixel.util.FlxDestroyUtil;

/**
 * Pause? PAUSE!!
 *
 * @author StarNova (Cream.BR)
 */
class PauseButton extends FlxSprite
{
	public var onClick:Void->Void;
	
	private var buttonCamera:FlxCamera;

	private var targetScale:Float = 0.8;
	private final defaultScale:Float = 0.8;
	private final pressScale:Float = 0.6;

	public function new(x:Float = 0, y:Float = 0, ?onClick:Void->Void)
	{
		var posX:Float = (x == 0) ? FlxG.width - 130 : x;
		var posY:Float = (y == 0) ? 25 : y;

		super(posX, posY);

		#if mobile
		var bitmap:BitmapData = null;
		var path:String = 'assets/mobile/images/pauseButton.png';

		try
		{
			bitmap = BitmapData.fromFile(path);
		} catch(e:Dynamic) {
			trace("PauseButton graphic not found.");
		}

		if (bitmap != null)
		{
			loadGraphic(FlxGraphic.fromBitmapData(bitmap));
		}

		antialiasing = true;
		scrollFactor.set();
		alpha = 0.7;
		scale.set(defaultScale, defaultScale);
		updateHitbox();

		this.onClick = onClick;

		buttonCamera = new FlxCamera();
		buttonCamera.bgColor.alpha = 0;
		FlxG.cameras.add(buttonCamera, false);
		this.cameras = [buttonCamera];

		FlxG.signals.postUpdate.add(globalUpdate);
		#else
		trace('PauseButton only Avaliable for Mobile Targets!');
		visible = false;
		active = false;
		#end
	}

	#if mobile
	private function globalUpdate():Void
	{
		if (!visible || !active) return;

		scale.x = FlxMath.lerp(scale.x, targetScale, FlxG.elapsed * 15);
		scale.y = FlxMath.lerp(scale.y, targetScale, FlxG.elapsed * 15);

		var isPressed = false;

		for (touch in FlxG.touches.list)
		{
			if (touch.overlaps(this, buttonCamera))
			{
				isPressed = true;
				
				if (touch.justPressed)
				{
					targetScale = pressScale;
					if (onClick != null) onClick();
					break;
				}
			}
		}

		if (!isPressed)
		{
			targetScale = defaultScale;
		}
	}
	#end

	override function destroy()
	{
		#if mobile
		FlxG.signals.postUpdate.remove(globalUpdate);
		
		if (buttonCamera != null)
		{
			FlxG.cameras.remove(buttonCamera);
			buttonCamera = FlxDestroyUtil.destroy(buttonCamera);
		}
		#end
		
		super.destroy();
	}
}