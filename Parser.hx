import haxe.io.*;

class Parser {
	public var statements:Array<String>;
	public function new(args:Array<String>) {
		var imgPath = args[0]; //path to image should always be first argument
		var rgbBytes = getRGB(imgPath);
		statements = bytesToStatements(rgbBytes);
	}
	
	function getRGB(path:String):Bytes {
		var stream = sys.io.File.read(path, true);
		var data = new format.bmp.Reader(stream).read();
		
		stream.close();
		
		var src = format.bmp.Tools.extractARGB(data);
		var srcLen = src.length;
		var retLen = Std.int(srcLen / 4) * 3;
		var ret = Bytes.alloc(retLen);
		var srcLoc = 1;
		var retLoc = 0;
		
		while(srcLoc < srcLen) {
			if(srcLoc % 4 != 0) {
				ret.set(retLoc, src.get(srcLoc));
				retLoc++;
			}
			srcLoc++;
		}
		
		return ret;
	}
	
	function bytesToStatements(pixels:Bytes):Array<String>{
		var statements = new Array();
		var i = 0;
		while(i < pixels.length) {
			statements.push(pixels.sub(i, 3).toHex().toUpperCase());
			i += 3;
		}
		return statements;
	}
}