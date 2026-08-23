package mobile.backend;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxCamera;
import openfl.display.BitmapData;
import flixel.graphics.FlxGraphic;
import flixel.graphics.frames.FlxAtlasFrames;
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
	private var _isAnimating:Bool = false;
	private var _isFadingOut:Bool = false;
	private final defaultAlpha:Float = 0.7;

	public function new(x:Float = 0, y:Float = 0, ?onClick:Void->Void)
	{
		var posX:Float = (x == 0) ? FlxG.width - 130 : x;
		var posY:Float = (y == 0) ? 25 : y;

		super(posX, posY);

		#if mobile
		var bitmap:BitmapData = null;
		var path:String = 'assets/mobile/images/pauseButton.png';
		var xmlPath:String = 'assets/mobile/images/pauseButton.xml';

		try
		{
			bitmap = BitmapData.fromFile(path);
		} catch(e:Dynamic) {
			trace("PauseButton graphic not found.");
		}

		if (bitmap != null)
		{
			var graphic:FlxGraphic = FlxGraphic.fromBitmapData(bitmap);
			
			frames = FlxAtlasFrames.fromSparrow(graphic, openfl.utils.Assets.getText(xmlPath));
			
			animation.addByPrefix('idle', 'pause0000', 24, false);
			animation.addByPrefix('press', 'pause', 24, false);
			animation.play('idle');
		}

		antialiasing = true;
		scrollFactor.set();
		alpha = defaultAlpha;
		scale.set(0.8, 0.8);
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
		if (!active) return;

		var hasSubState:Bool = (FlxG.state != null && FlxG.state.subState != null);

		if (hasSubState && _isAnimating)
		{
			animation.update(FlxG.elapsed);
		}

		if (_isAnimating && animation.finished)
		{
			_isAnimating = false;
			_isFadingOut = true;
		}

		if (_isFadingOut)
		{
			alpha -= FlxG.elapsed * 3;
			if (alpha <= 0)
			{
				alpha = 0;
				_isFadingOut = false;
			}
		}

		if (!hasSubState)
		{
			_isAnimating = false;
			_isFadingOut = false;
			
			if (alpha < defaultAlpha)
			{
				alpha += FlxG.elapsed * 4;
				if (alpha >= defaultAlpha) alpha = defaultAlpha;
			}

			if (frames != null && animation.name != 'idle') animation.play('idle');
		}

		if (alpha >= defaultAlpha && !_isAnimating && !_isFadingOut && !hasSubState)
		{
			for (touch in FlxG.touches.list)
			{
				if (touch.justPressed && touch.overlaps(this, buttonCamera))
				{
					_isAnimating = true;
					if (frames != null) animation.play('press');
					
					if (onClick != null) onClick();
					break;
				}
			}
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