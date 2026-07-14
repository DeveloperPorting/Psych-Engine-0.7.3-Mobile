package mobile.controls;

import flixel.FlxG;
import flixel.graphics.FlxGraphic;
import flixel.graphics.frames.FlxTileFrames;
import flixel.math.FlxPoint;
import flixel.util.FlxDestroyUtil;

import mobile.backend.flixel.TouchButton;

import openfl.utils.Assets;
import openfl.display.BitmapData;

import mobile.backend.MobileUtil;
import mobile.backend.flixel.input.TouchInputManager;
import mobile.backend.flixel.input.TouchInputID;

#if MODS_ALLOWED
import sys.FileSystem;
#end

enum MobileDPadMode
{
	UP_DOWN;
	LEFT_RIGHT;
	UP_LEFT_RIGHT;
	LEFT_FULL;
	RIGHT_FULL;
	CHART_EDITOR;
	NONE;
}

enum MobileActionMode
{
	A;
	B;
	X;
	A_B;
	A_B_C;
	STORYMENU;
	FREEPLAY;
	CHART_EDITOR;
	CHARACTER_EDITOR;
    NOTE_SPLASH_DEBUG;
	NONE;
}

/**
 * Virtual Pad.... Virtual... Buttons
 *
 * @author StarNova (Cream.BR)
 */
class MobileVirtualPad extends TouchInputManager
{
	public var buttons:Array<TouchButton> = [];
	
	public var buttonLeft:TouchButton;
	public var buttonUp:TouchButton;
	public var buttonRight:TouchButton;
	public var buttonDown:TouchButton;
	public var buttonLeft2:TouchButton;
	public var buttonUp2:TouchButton;
	public var buttonRight2:TouchButton;
	public var buttonDown2:TouchButton;
	
	public var buttonA:TouchButton;
	public var buttonB:TouchButton;
	public var buttonC:TouchButton;
	public var buttonD:TouchButton;
	public var buttonE:TouchButton;
	public var buttonR:TouchButton;
	public var buttonV:TouchButton;
	public var buttonX:TouchButton;
	public var buttonY:TouchButton;
	public var buttonZ:TouchButton;
	public var buttonS:TouchButton;
	
	public function new(DPad:MobileDPadMode, Action:MobileActionMode)
	{
		super();
		
		var screenW = FlxG.width;
		var screenH = FlxG.height;
		var dPad2_X = 420; // Move para os lados (maior = mais para a direita)
		var dPad2_Y = screenH - 620; // Move para cima/baixo (maior = mais para cima) só para mim n esquecer sempre q for mexer
		
		switch (DPad)
		{
			case UP_DOWN:
				buttonUp = add(createButton(0, FlxG.height - 255, 'up', 0x00FF00, [UP]));
				buttonDown = add(createButton(0, FlxG.height - 135, 'down', 0x00FFFF, [DOWN]));
			case LEFT_RIGHT:
				buttonLeft = add(createButton(0, FlxG.height - 135, 'left', 0xFF00FF, [LEFT]));
				buttonRight = add(createButton(127, FlxG.height - 135, 'right', 0xFF0000, [RIGHT]));
			case UP_LEFT_RIGHT:
				buttonUp = add(createButton(105, FlxG.height - 243, 'up', 0x00FF00, [UP]));
				buttonLeft = add(createButton(0, FlxG.height - 135, 'left', 0xFF00FF, [LEFT]));
				buttonRight = add(createButton(207, FlxG.height - 135, 'right', 0xFF0000, [RIGHT]));
			case LEFT_FULL:
				buttonUp = add(createButton(105, FlxG.height - 345, 'up', 0x00FF00, [UP]));
				buttonLeft = add(createButton(0, FlxG.height - 243, 'left', 0xFF00FF, [LEFT]));
				buttonRight = add(createButton(207, FlxG.height - 243, 'right', 0xFF0000, [RIGHT]));
				buttonDown = add(createButton(105, FlxG.height - 135, 'down', 0x00FFFF, [DOWN]));
			case CHART_EDITOR:
                buttonUp = add(createButton(305, FlxG.height - 345, 'up', 0x00FF00, [UP]));
				buttonLeft = add(createButton(200, FlxG.height - 243, 'left', 0xFF00FF, [LEFT]));
				buttonRight = add(createButton(407, FlxG.height - 243, 'right', 0xFF0000, [RIGHT]));		
				buttonDown = add(createButton(305, FlxG.height - 135, 'down', 0x00FFFF, [DOWN]));
			case NONE:
				// lmao
			default:
				buttonUp = add(createButton(0, FlxG.height - 255, 'up', 0x00FF00, [UP]));
				buttonDown = add(createButton(0, FlxG.height - 135, 'down', 0x00FFFF, [DOWN]));
		}
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
			case STORYMENU:
			    buttonR = add(createButton(screenW - 510, screenH - 135, 'r', 0x00D0FF, [NONE]));
				buttonC = add(createButton(screenW - 384, screenH - 135, 'c', 0x44FF00, [C]));
				buttonB = add(createButton(screenW - 258, screenH - 135, 'b', 0xFFCB00, [B]));
				buttonA = add(createButton(screenW - 132, screenH - 135, 'a', 0xFF0000, [A]));
			case FREEPLAY:
			    buttonX = add(createButton(screenW - 132, screenH - 255, 'x', 0x99062D, [X]));
			    buttonR = add(createButton(screenW - 510, screenH - 135, 'r', 0x00D0FF, [NONE]));
				buttonC = add(createButton(screenW - 384, screenH - 135, 'c', 0x44FF00, [C]));
				buttonB = add(createButton(screenW - 258, screenH - 135, 'b', 0xFFCB00, [B]));
				buttonA = add(createButton(screenW - 132, screenH - 135, 'a', 0xFF0000, [A]));
			case CHART_EDITOR:
				buttonV = add(createButton(screenW - 510, screenH - 255, 'v', 0x49A9B2, [V]));
				buttonD = add(createButton(screenW - 510, screenH - 135, 'd', 0x0078FF, [D]));
				buttonX = add(createButton(screenW - 384, screenH - 255, 'x', 0x99062D, [X]));
				buttonC = add(createButton(screenW - 384, screenH - 135, 'c', 0x44FF00, [C]));
				buttonY = add(createButton(screenW - 258, screenH - 255, 'y', 0x4A35B9, [Y]));
				buttonB = add(createButton(screenW - 258, screenH - 135, 'b', 0xFFCB00, [B]));
				buttonZ = add(createButton(screenW - 132, screenH - 255, 'z', 0xCCB98E, [Z]));
				buttonA = add(createButton(screenW - 132, screenH - 135, 'a', 0xFF0000, [A]));
			case CHARACTER_EDITOR:
				buttonV = add(createButton(screenW - 384, screenH - 255, 'v', 0x49A9B2, [V]));
				buttonD = add(createButton(screenW - 510, screenH - 135, 'd', 0x0078FF, [D]));
				buttonX = add(createButton(screenW - 258, screenH - 255, 'x', 0x99062D, [X]));
				buttonC = add(createButton(screenW - 384, screenH - 135, 'c', 0x44FF00, [C]));
				buttonB = add(createButton(screenW - 258, screenH - 135, 'b', 0xFFCB00, [B]));
				buttonZ = add(createButton(screenW - 132, screenH - 255, 'z', 0xCCB98E, [Z]));
				buttonA = add(createButton(screenW - 132, screenH - 135, 'a', 0xFF0000, [A]));
			case NOTE_SPLASH_DEBUG:
				buttonUp2 = add(createButton(screenW - 105, screenH - 345, 'up', 0x00FF00, [UP2]));
				buttonLeft2 = add(createButton(screenW - 207, screenH - 243, 'left', 0xFF00FF, [LEFT2]));
				buttonRight2 = add(createButton(screenW, screenH - 243, 'right', 0xFF0000, [RIGHT2]));
				buttonDown2 = add(createButton(screenW - 105, screenH - 135, 'down', 0x00FFFF, [DOWN2]));
				buttonV = add(createButton(screenW - 510, screenH - 255, 'v', 0x49A9B2, [V]));
				buttonD = add(createButton(screenW - 510, screenH - 135, 'd', 0x0078FF, [D]));
				buttonX = add(createButton(screenW - 384, screenH - 255, 'x', 0x99062D, [X]));
				buttonC = add(createButton(screenW - 384, screenH - 135, 'c', 0x44FF00, [C]));
				buttonY = add(createButton(screenW - 258, screenH - 255, 'y', 0x4A35B9, [Y]));
				buttonB = add(createButton(screenW - 258, screenH - 135, 'b', 0xFFCB00, [B]));
				buttonZ = add(createButton(screenW - 132, screenH - 255, 'z', 0xCCB98E, [Z]));
				buttonA = add(createButton(screenW - 132, screenH - 135, 'a', 0xFF0000, [A]));
			case NONE:
				// lmao
			default:
				buttonB = add(createButton(screenW - 258, screenH - 135, 'b', 0xFFCB00, [B]));
				buttonA = add(createButton(screenW - 132, screenH - 135, 'a', 0xFF0000, [A]));
		}
		
		scrollFactor.set();
		refreshMappedButtons();
	}
	
	private function createButton(X:Float, Y:Float, Graphic:String, Color:Int, IDs:Array<TouchInputID>):TouchButton
	{
		var graphic:FlxGraphic = null;
		var path:String = 'assets/mobile/virtualpad/${Graphic}.png';
		var cacheKey:String = path;
		
		#if MODS_ALLOWED
		var modsPath:String = Paths.modFolders('mobile/virtualpad/${Graphic}.png');
		if (FileSystem.exists(modsPath))
		{
			cacheKey = modsPath;
			graphic = FlxG.bitmap.get(cacheKey);
			
			if (graphic == null) graphic = FlxGraphic.fromBitmapData(BitmapData.fromFile(modsPath), false, cacheKey);
		}
		else
		#end
		{
			if (!Assets.exists(path))
			{
				path = 'assets/mobile/virtualpad/default.png';
				cacheKey = path;
			}
			
			graphic = FlxG.bitmap.get(cacheKey);
			if (graphic == null) graphic = FlxGraphic.fromBitmapData(Assets.getBitmapData(path), false, cacheKey);
		}
		
		var button = new TouchButton(X, Y, IDs);
		
		button.frames = FlxTileFrames.fromGraphic(graphic, FlxPoint.weak(Std.int(graphic.width / 3), graphic.height));
		
		button.solid = false;
		button.moves = false;
		button.immovable = true;
		button.scrollFactor.set();
		button.color = Color;
		button.alpha = 0.5;
		button.active = MobileUtil.isTouchActive;
		button.visible = MobileUtil.isTouchActive;
		
		#if FLX_DEBUG button.ignoreDrawDebug = true; #end
		
		buttons.push(button);
		return button;
	}
	
	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
	
		MobileUtil.setControlsState(this, buttons);
	}
	
	override public function destroy():Void
	{
		for (btn in buttons)
			FlxDestroyUtil.destroy(btn);
			
		super.destroy();
	}
}
