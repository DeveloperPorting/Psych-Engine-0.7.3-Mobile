import haxe.Json;
import haxe.io.Path;
import sys.io.File;
import sys.FileSystem;
import StringTools;

var jsonPath = "./astc-compression-data.json";

if (FileSystem.exists(jsonPath)) {
    Sys.println("=== ASTC COMPRESSOR HOOK ===");
    Sys.println("Running astc-compressor...");
    
    Sys.command("haxelib", ["run", "astc-compressor", "compress-from-json", "-json", jsonPath]);
    
    var astcExcludes:Array<String> = [];
    try {
        var jsonStr = File.getContent(jsonPath);
        var parsed = Json.parse(jsonStr);
        if (parsed.excludes != null) astcExcludes = parsed.excludes;
    } catch(e:Dynamic) {
        Sys.println("Error reading JSON from ASTC: " + e);
    }

    for (i in 0...astcExcludes.length) {
        astcExcludes[i] = StringTools.trim(astcExcludes[i]);
    }

    var isASTCExcluded = function(file:String):Bool {
        for (exclusion in astcExcludes) {
            if (StringTools.endsWith(exclusion, "/")) {
                var normalizedFilePath = Path.normalize(file);
                var normalizedExclusion = Path.normalize(exclusion);
                if (StringTools.startsWith(normalizedFilePath, normalizedExclusion)) return true;
            } else if (StringTools.endsWith(exclusion, "/*")) {
                var normalizedExclusion = Path.normalize(exclusion.substr(0, exclusion.length - 2));
                var fileDirectory = Path.directory(Path.normalize(file));
                if (fileDirectory == normalizedExclusion) return true;
            } else {
                if (file == exclusion) return true;
            }
        }
        return false;
    };

    var replacedCount = 0;
    for (asset in project.assets) {
        if (asset.type == "image" || StringTools.endsWith(asset.sourcePath, ".png")) {
            if (isASTCExcluded(asset.sourcePath)) {
                asset.sourcePath = StringTools.replace(asset.sourcePath, ".png", ".astc");
                asset.targetPath = StringTools.replace(asset.targetPath, ".png", ".astc");
                asset.type = "binary";
                replacedCount++;
            }
        }
    }
    
    Sys.println("Success! The Hook intercepted " + replacedCount + " PNGs and swapped them for ASTC in the Build.");
} else {
    Sys.println("WARNING: astc-compression-data.json not found. Ignoring conversion.");
}