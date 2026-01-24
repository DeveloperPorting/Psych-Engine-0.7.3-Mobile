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
    private static function get_folderName():String {
        return Application.current.meta.get('file');
    }

    public static inline function getStorageDirectory():String
	  	return #if android Path.addTrailingSlash(Environment.getExternalStorageDirectory() + '/.' + folderName) #elseif ios lime.system.System.documentsDirectory #else Sys.getCwd() #end;

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
    public static function getPermissions():Void {
        #if android
        if (VERSION.SDK_INT >= VERSION_CODES.TIRAMISU) {
            Permissions.requestPermissions([
                'READ_MEDIA_IMAGES',
                'READ_MEDIA_VIDEO',
                'READ_MEDIA_AUDIO',
                'READ_MEDIA_VISUAL_USER_SELECTED'
            ]);
        } else {
            Permissions.requestPermissions([
                'READ_EXTERNAL_STORAGE', 
                'WRITE_EXTERNAL_STORAGE'
            ]);
        }

        // Android 11+
        if (VERSION.SDK_INT >= VERSION_CODES.R) { // SDK 30 = Android 11
            if (!Environment.isExternalStorageManager()) {
                Settings.requestSetting('MANAGE_APP_ALL_FILES_ACCESS_PERMISSION');
            }
		}

        try
		{
			if (!FileSystem.exists(getDirectory())) {
				FileSystem.createDirectory(getDirectory());
				Tools.showAlertDialog("Requirements", "Please copy the Assets and Mods folder to " + getDirectory() + " to be able to play.", {name: "OK", func: null}, null);
			} else if (!FileSystem.exists(getDirectory() + "assets") && !FileSystem.exists(getDirectory() + "mods")) {
		 	   Tools.showAlertDialog("Requirements", "Please copy the Assets and Mods folder to " + getDirectory() + " to be able to play.", {name: "OK", func: null}, null);
			}
		}
		catch (e:Dynamic)
		{
			Tools.showAlertDialog("Requires permissions", "Please allow the necessary permissions to play.\nPress OK & let's see what happens", {name: "OK", func: null}, null);
		}
        #else
        trace("Permissions request not required or not implemented for this platform.");
        #end
    }
}