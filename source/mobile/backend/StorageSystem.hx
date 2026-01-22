package mobile.backend;

import sys.FileSystem;
import sys.io.File;
#if android
import extension.androidtools.os.Environment;
import extension.androidtools.Settings;
import extension.androidtools.Permissions;
import extension.androidtools.os.Build.VERSION;
import extension.androidtools.os.Build.VERSION_CODES;
#end
import lime.app.Application;
import haxe.io.Path;
import openfl.utils.Assets;
import haxe.io.Bytes;

using StringTools;

/** 
* @Authors StarNova (Cream.BR)
* @version: 0.1.2
**/

class StorageSystem {
  
    public static inline function getStorageDirectory():String
	  	return #if android haxe.io.Path.addTrailingSlash(Environment.getExternalStorageDirectory() + '/.' + Application.current.meta.get('file')) #elseif ios lime.system.System.documentsDirectory #else Sys.getCwd() #end;
	
	public static function getDirectory():String
	{
		#if android
		return Environment.getExternalStorageDirectory() + '/.' + Application.current.meta.get('file') + '/';
		#elseif ios
		return lime.system.System.documentsDirectory;
		#else
		return Sys.getCwd();
		#end
	}

	/**
     * Request permission to access the files, only if they are not already granted.
     */
    public static function getPermissions():Void {
        #if android
        var needsPermissions:Bool = false;
        var sdk:Int = VERSION.SDK_INT;
        
        var granted:Array<String> = Permissions.getGrantedPermissions();
    
        if (sdk >= VERSION_CODES.TIRAMISU) {
            // Android 13+
            if (!granted.contains('READ_MEDIA_IMAGES') || !granted.contains('READ_MEDIA_AUDIO')) {
                needsPermissions = true;
                Permissions.requestPermissions([
                    'READ_MEDIA_IMAGES', 'READ_MEDIA_VIDEO', 'READ_MEDIA_AUDIO', 'READ_MEDIA_VISUAL_USER_SELECTED'
                ]);
            }
        } else {
            // Android 12 and lower
            if (!granted.contains('WRITE_EXTERNAL_STORAGE')) {
                needsPermissions = true;
                Permissions.requestPermissions(['READ_EXTERNAL_STORAGE', 'WRITE_EXTERNAL_STORAGE']);
            }
        }

        if (sdk >= VERSION_CODES.R) { 
            if (!Environment.isExternalStorageManager()) {
                needsPermissions = true;
                Settings.requestSetting('MANAGE_APP_ALL_FILES_ACCESS_PERMISSION');
            }
        }

        if (needsPermissions) {
            Tools.showAlertDialog(
                "Requires permissions", 
                "Please allow the necessary permissions to play.\nPress OK & let's see what happens", 
                {name: "OK", func: null}, 
                null
            );
        } else {
            trace("All permissions already granted.");
        }
        #else
        trace("Permissions request not required or not implemented for this platform.");
        #end
    }


	public static function copyAssetsToStorage(sources:Array<String>, targetPath:String = null):Void {
	    #if mobile
	    try {
    	    var baseDest = (targetPath == null) ? getDirectory() : targetPath;
        
  	      var allExists = true;
   	     for (source in sources) {
        	    var checkPath = Path.join([baseDest, source]);
      	      if (!FileSystem.exists(checkPath)) {
           	     allExists = false;
         	       break;
         	   }
   	     }

     	   if (allExists) {
        	    trace("Assets já existem no destino. Pulando cópia.");
        	    return;
    	    }

     	   var assetList:Array<String> = Assets.list();
   	     var filesCopied:Int = 0;

   	     for (source in sources) {
        	    var filter = Path.normalize(source);
      	      if (StringTools.endsWith(filter, "/")) {
       	         filter = filter.substring(0, filter.length - 1);
       	     }

        	    trace('Sincronizando origem: $filter');

      	      for (assetPath in assetList) {
         	       if (StringTools.startsWith(assetPath, filter)) {
                    
               	     var fullTargetPath = Path.normalize(Path.join([baseDest, assetPath]));
            	        var directory = Path.directory(fullTargetPath);

              	      if (!FileSystem.exists(directory)) {
              	          FileSystem.createDirectory(directory);
           	         }

            	        if (Assets.exists(assetPath) && !FileSystem.exists(fullTargetPath)) {
               	         var data:Bytes = Assets.getBytes(assetPath);
                 	       if (data != null) {
                   	         File.saveBytes(fullTargetPath, data);
                     	       filesCopied++;
                 	       }
             	       }
          	      }
    	        }
   	     }
        
     	   trace('Operação finalizada. Arquivos novos: $filesCopied');

	    } catch (e:Dynamic) {
  	      trace('Erro ao sincronizar pastas: $e');
   	     Application.current.window.alert('Error', 'Failed to copy files: ' + e);
 	   }
   	 #end
	}
}