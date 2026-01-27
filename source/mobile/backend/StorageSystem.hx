package mobile.backend;

import openfl.utils.Assets;
import sys.FileSystem;
import sys.io.File;
#if android
import extension.androidtools.os.Environment;
import extension.androidtools.Settings;
import extension.androidtools.Permissions;
import extension.androidtools.os.Build.VERSION;
import extension.androidtools.os.Build.VERSION_CODES;
import extension.androidtools.Tools;
#end
import lime.app.Application;
import haxe.io.Path;
import haxe.io.Bytes;
import openfl.utils.ByteArray;

using StringTools;

/** 
 * @Authors StarNova (Cream.BR)
 * @version: 0.1.2
**/
class StorageSystem
{
	private static var folderName(get, never):String;

	private static function get_folderName():String
	{
		return Application.current.meta.get('file');
	}

	public static inline function getStorageDirectory():String
		return #if android Path.addTrailingSlash(Environment.getExternalStorageDirectory() + '/.' +
			folderName) #elseif ios lime.system.System.documentsDirectory #else Sys.getCwd() #end;

	public static function getDirectory():String
	{
		#if android
		return Environment.getExternalStorageDirectory() + '/.' + folderName + '/';
		#elseif ios
		return lime.system.System.documentsDirectory;
		#else
		return Sys.getCwd();
		#end
	}

	/**
	 * Request permission to access the files
	 */
	public static function getPermissions():Void
	{
		#if android
		if (VERSION.SDK_INT >= VERSION_CODES.TIRAMISU)
		{
			Permissions.requestPermissions([
				'READ_MEDIA_IMAGES',
				'READ_MEDIA_VIDEO',
				'READ_MEDIA_AUDIO',
				'READ_MEDIA_VISUAL_USER_SELECTED'
			]);
		}
		else
		{
			Permissions.requestPermissions(['READ_EXTERNAL_STORAGE', 'WRITE_EXTERNAL_STORAGE']);
		}

		// Android 11+
		if (VERSION.SDK_INT >= VERSION_CODES.R)
		{ // SDK 30 = Android 11
			if (!Environment.isExternalStorageManager())
			{
				Settings.requestSetting('MANAGE_APP_ALL_FILES_ACCESS_PERMISSION');
			}
		}

		try
		{
			if (!FileSystem.exists(getDirectory()))
			{
				FileSystem.createDirectory(getDirectory());
				Tools.showAlertDialog("Requirements", "Please copy the Assets and Mods folder to " + getDirectory() + " to be able to play.",
					{name: "OK", func: null}, null);
				lime.system.System.exit(1);
			}
			else if (!FileSystem.exists(getDirectory() + "assets") && !FileSystem.exists(getDirectory() + "mods"))
			{
				Tools.showAlertDialog("Requirements", "Please copy the Assets and Mods folder to " + getDirectory() + " to be able to play.",
					{name: "OK", func: null}, null);
				lime.system.System.exit(1);
			}
		}
		catch (e:Dynamic)
		{
			Tools.showAlertDialog("Requires permissions", "Please allow the necessary permissions to play.\nPress OK & let's see what happens",
				{name: "OK", func: null}, null);
		}
		#else
		trace("Permissions request not required or not implemented for this platform.");
		#end
	}

	/**
	 * Saves a file in 'files' Directory
	 */
	#if sys
	public static function saveContent(name:String = 'file', ext:String = '.json', data:String = ''):Void
	{
		var saveFolder:String = Path.join([getDirectory(), "files"]);
		var fullPath:String = Path.join([saveFolder, name + ext]);

		try
		{
			if (!FileSystem.exists(saveFolder))
			{
				FileSystem.createDirectory(saveFolder);
			}

			File.saveContent(fullPath, data);

			#if android
			Tools.showAlertDialog("Sucess!", "File saved in:\n" + saveFolder + "/" + name + ext, {name: "OK", func: null}, null);
			#end
		}
		catch (e:haxe.Exception)
		{
			var errorMsg:String = "Error on Save!:\n" + e.message;
			trace('Error ' + errorMsg);

			#if android
			Tools.showAlertDialog("Error saving file", errorMsg, {name: "Close", func: null}, null);
			#end
		}
	}
	#end
}
