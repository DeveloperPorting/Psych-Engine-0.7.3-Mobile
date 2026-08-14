package;

import haxe.Json;
import haxe.io.Path;
import sys.io.File;
import sys.FileSystem;

class Prebuild {
    static function main():Void
    {
        var jsonPath = "./astc-compression-data.json";
        
        if (FileSystem.exists(jsonPath)) {
            Sys.println("=== ASTC COMPRESSOR PREBUILD ===");
            Sys.println("Running astc-compressor...");
            
            Sys.command("haxelib", ["run", "astc-compressor", "compress-from-json", "-json", jsonPath]);
            
            Sys.println("ASTC compression process finished.");
        } else {
            Sys.println("WARNING: astc-compression-data.json not found. Ignoring conversion.");
        }
    }
}