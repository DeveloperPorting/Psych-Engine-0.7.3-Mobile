package mobile.psychlua;

import lime.ui.Haptic;
import psychlua.FunkinLua;
import psychlua.ModchartSprite;
import psychlua.LuaUtils;

import mobile.controls.MobileVirtualPad.MobileDPadMode;
import mobile.controls.MobileVirtualPad.MobileActionMode;

class MobileFunctions
{
	private static function getTargetState():Dynamic {
		if (FlxG.state.subState != null && Std.isOfType(FlxG.state.subState, MusicBeatSubstate)) {
			return FlxG.state.subState;
		}
		if (Std.isOfType(FlxG.state, MusicBeatState)) {
			return FlxG.state;
		}
		return null;
	}

	private static function getTargetVirtualPad():Dynamic {
		var target = getTargetState();
		if (target != null && target.virtualPad != null) {
			return target.virtualPad;
		}
		return null;
	}

	private static function getTargetHitbox():Dynamic {
		var target = getTargetState();
		if (target != null && target.hitbox != null) {
			return target.hitbox;
		}
		return null;
	}

	private static function getVPadButtonStatus(button:String, statusType:String):Bool {
		var pad = getTargetVirtualPad();
		if (pad == null) return false;
		
		var btnName = button;
		if (!StringTools.startsWith(btnName, "button")) {
			btnName = "button" + button.charAt(0).toUpperCase() + button.substr(1);
		}

		var buttonObj:Dynamic = Reflect.getProperty(pad, btnName);
		if (buttonObj != null) {
			var status:Bool = Reflect.getProperty(buttonObj, statusType);
			return status == true;
		}
		return false;
	}

	private static function getHitboxButtonStatus(button:String, statusType:String):Bool {
		var hitbox = getTargetHitbox();
		if (hitbox == null) return false;

		var btnName = button;
		if (!StringTools.startsWith(btnName, "button")) {
			btnName = "button" + button.charAt(0).toUpperCase() + button.substr(1);
		}

		var buttonObj:Dynamic = Reflect.getProperty(hitbox, btnName);
		if (buttonObj != null) {
			var status:Bool = Reflect.getProperty(buttonObj, statusType);
			return status == true;
		}
		
		return false;
	}

	public static function implement(funk:FunkinLua)
	{
		#if LUA_ALLOWED
		var lua:State = funk.lua;

		#if mobile
		Lua_helper.add_callback(lua, "vibrate", function(duration:Int, ?period:Int = 0)
		{
			if (duration <= 0)
			{
				FunkinLua.luaTrace("vibrate: Invalid duration! Use seconds (ex: 0.5)", false, false, 0xFFFF0000);
				return;
			}
			Haptic.vibrate(period, Std.int(duration * 1000));
		});

		Lua_helper.add_callback(lua, "makeWallpaperSprite", function(tag:String, ?x:Float = 0, ?y:Float = 0) {
			tag = tag.replace('.', '');
			LuaUtils.resetSpriteTag(tag);
			
			var leSprite:ModchartSprite = new ModchartSprite(x, y);
			
			#if android
			var base64String = androidmanager.os.Platform.getWallpaperBase64();
			if (base64String != null && base64String != "") 
			{
				try 
				{
					var bytes = haxe.crypto.Base64.decode(base64String);
					var image = lime.graphics.Image.fromBytes(bytes);
					var bmpData = openfl.display.BitmapData.fromImage(image);

					leSprite.loadGraphic(bmpData);

					var scaleX:Float = FlxG.width / leSprite.width;
					var scaleY:Float = FlxG.height / leSprite.height;
					var maxScale:Float = Math.max(scaleX, scaleY);

					leSprite.scale.set(maxScale, maxScale);
					leSprite.updateHitbox();
					leSprite.screenCenter();
				} 
				catch (e:Dynamic) 
				{
					FunkinLua.luaTrace("makeWallpaperSprite: Error converting wallpaper bytes!", false, false, 0xFFFF0000);
				}
			} 
			else 
			{
				FunkinLua.luaTrace("makeWallpaperSprite: Java returned an empty or null wallpaper.", false, false, 0xFFFF0000);
			}
			#end
			leSprite.antialiasing = backend.ClientPrefs.data.antialiasing;
			
			PlayState.instance.modchartSprites.set(tag, leSprite);
			leSprite.active = true;
		});

		Lua_helper.add_callback(lua, "touchUtilJustPressed", TouchUtil.justPressed);
		Lua_helper.add_callback(lua, "touchUtilPressed", TouchUtil.pressed);
		Lua_helper.add_callback(lua, "touchUtilJustReleased", TouchUtil.justReleased);
		Lua_helper.add_callback(lua, "touchUtilReleased", TouchUtil.released);
		
		Lua_helper.add_callback(lua, "setHitboxVisible", function(?visible:Bool = false):Void
		{
			PlayState.instance.hitbox.visible = visible;
		});
		
		Lua_helper.add_callback(lua, "enableKeyboard", function()
		{
			FlxG.stage.window.textInputEnabled = true;
		});

		Lua_helper.add_callback(lua, "addVirtualPad", function(dPadMode:String, actionMode:String) 
		{
			var target = getTargetState();
			if (target != null) {
				try {
					var dPad:MobileDPadMode = Type.createEnum(MobileDPadMode, dPadMode);
					var action:MobileActionMode = Type.createEnum(MobileActionMode, actionMode);
					target.addVirtualPad(dPad, action);
				} catch (e:Dynamic) {
					FunkinLua.luaTrace("addVirtualPad: Error! Invalid DPadMode or ActionMode string.", false, false, 0xFFFF0000);
				}
			}
		});

		Lua_helper.add_callback(lua, "addVirtualPadCamera", function(?defaultDrawTarget:Bool = false) 
		{
			var target = getTargetState();
			if (target != null) target.addVirtualPadCamera(defaultDrawTarget);
		});

		Lua_helper.add_callback(lua, "removeVirtualPad", function() 
		{
			var target = getTargetState();
			if (target != null) target.removeVirtualPad();
		});

		Lua_helper.add_callback(lua, "virtualPadJustPressed", function(button:String):Bool {
			return getVPadButtonStatus(button, "justPressed");
		});

		Lua_helper.add_callback(lua, "virtualPadPressed", function(button:String):Bool {
			return getVPadButtonStatus(button, "pressed");
		});

		Lua_helper.add_callback(lua, "virtualPadJustReleased", function(button:String):Bool {
			return getVPadButtonStatus(button, "justReleased");
		});

		Lua_helper.add_callback(lua, "hitboxJustPressed", function(button:String):Bool {
			return getHitboxButtonStatus(button, "justPressed");
		});

		Lua_helper.add_callback(lua, "hitboxPressed", function(button:String):Bool {
			return getHitboxButtonStatus(button, "pressed");
		});

		Lua_helper.add_callback(lua, "hitboxJustReleased", function(button:String):Bool {
			return getHitboxButtonStatus(button, "justReleased");
		});
		#end
		#end
	}
}