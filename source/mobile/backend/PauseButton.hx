package mobile.backend;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxCamera;
import openfl.display.BitmapData;
import flixel.graphics.FlxGraphic;

/**
 * Pause? PAUSE!!
 *
 * @author StarNova (Cream.BR)
 */
class PauseButton extends FlxSprite
{
	public var onClick:Void->Void;

	private var _lastTouchId:Int = -1;

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
		}

		if (bitmap != null)
		{
			loadGraphic(FlxGraphic.fromBitmapData(bitmap));
		}

		antialiasing = true;
		scrollFactor.set();
		alpha = 0.7;
		scale.set(0.8, 0.8);
		updateHitbox();

		this.onClick = onClick;
		#else
        trace('PauseButton only Avaliable for Mobile Targets!');
		visible = false;
		active = false;
		#end
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		#if mobile
		if (!visible || !active || onClick == null)
			return;

		for (touch in FlxG.touches.list)
		{
			if (touch.justPressed && touch.overlaps(this, camera))
			{
				onClick();
				break;
			}
		}
		#end
	}
}
