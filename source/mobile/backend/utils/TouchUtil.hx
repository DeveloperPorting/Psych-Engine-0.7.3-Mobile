package mobile.backend.utils;

import flixel.FlxG;
import flixel.input.touch.FlxTouch;

class TouchUtil 
{
	public static var justPressed(get, never):Bool;
	public static var pressed(get, never):Bool;
	public static var justReleased(get, never):Bool;
	public static var released(get, never):Bool;

	public static var touchCount(get, never):Int;
	public static var firstTouch(get, never):FlxTouch;

	public static var justSwiped(get, never):Bool;
	public static var swipeUp(get, never):Bool;
	public static var swipeDown(get, never):Bool;
	public static var swipeLeft(get, never):Bool;
	public static var swipeRight(get, never):Bool;

	#if mobile
	
	static function get_justPressed():Bool 
	{
		for (touch in FlxG.touches.list) if (touch.justPressed) return true;
		return false;
	}
	
	static function get_pressed():Bool 
	{
		for (touch in FlxG.touches.list) if (touch.pressed) return true;
		return false;
	}
	
	static function get_justReleased():Bool 
	{
		for (touch in FlxG.touches.list) if (touch.justReleased) return true;
		return false;
	}
	
	static function get_released():Bool 
	{
		for (touch in FlxG.touches.list) if (touch.released) return true;
		return false;
	}

	static function get_touchCount():Int 
	{
		var count = 0;
		for (touch in FlxG.touches.list) if (touch.pressed) count++;
		return count;
	}

	static inline function get_firstTouch():FlxTouch 
	{
		return FlxG.touches.getFirst();
	}

	static inline function get_justSwiped():Bool 
	{
		return FlxG.swipes.length > 0;
	}

	static inline function get_swipeUp():Bool return checkSwipeAngle(-135, -45);
	static inline function get_swipeDown():Bool return checkSwipeAngle(45, 135);
	static inline function get_swipeLeft():Bool return checkSwipeAngle(135, 180) || checkSwipeAngle(-180, -135);
	static inline function get_swipeRight():Bool return checkSwipeAngle(-45, 45);

	static function checkSwipeAngle(min:Float, max:Float):Bool 
	{
		for (swipe in FlxG.swipes) 
		{
			if (swipe.angle >= min && swipe.angle <= max) return true;
		}
		return false;
	}

	#else
	
	static inline function get_justPressed():Bool return false;
	static inline function get_pressed():Bool return false;
	static inline function get_justReleased():Bool return false;
	static inline function get_released():Bool return false;
	static inline function get_touchCount():Int return 0;
	static inline function get_firstTouch():FlxTouch return null;
	static inline function get_justSwiped():Bool return false;
	static inline function get_swipeUp():Bool return false;
	static inline function get_swipeDown():Bool return false;
	static inline function get_swipeLeft():Bool return false;
	static inline function get_swipeRight():Bool return false;
	
	#end
}