package mobile.input;

import flixel.system.macros.FlxMacroUtil;

/**
 * A high-level list of unique values for mobile input buttons.
 * Maps enum values and strings to unique integer codes
 * @author Karim Akra
 */
@:runtimeValue
enum abstract FlxMobileInputID(Int) from Int to Int {
	public static var fromStringMap(default, null):Map<String, FlxMobileInputID> = FlxMacroUtil.buildMap("mobile.input.FlxMobileInputID");
	public static var toStringMap(default, null):Map<FlxMobileInputID, String> = FlxMacroUtil.buildMap("mobile.input.FlxMobileInputID", true);
	var ANY = -2;
	var NONE = -1;
	var A = 0;
	var B = 1;
	var C = 2;
	var D = 3;
	var E = 4;
	var V = 5;
	var X = 6;
	var Y = 7;
	var Z = 8;
	var UP = 9;
	var UP2 = 10;
	var DOWN = 11;
	var DOWN2 = 12;
	var LEFT = 13;
	var LEFT2 = 14;
	var RIGHT = 15;
	var RIGHT2 = 16;
	var hitboxUP = 17;
	var hitboxDOWN = 18;
	var hitboxLEFT = 19;
	var hitboxRIGHT = 20;
	var noteUP = 21;
	var noteDOWN = 22;
	var noteLEFT = 23;
	var noteRIGHT = 24;

	@:from
	public static inline function fromString(s:String) {
		s = s.toUpperCase();
		return fromStringMap.exists(s) ? fromStringMap.get(s) : NONE;
	}

	@:to
	public inline function toString():String {
		return toStringMap.get(this);
	}
}