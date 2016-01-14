import haxe.io.*;

class Parser {
	public function new(args:Array<String>) {
		var imgPath = args[0]; //path to image should always be first argument
		var pixels = getRGB(imgPath);
		Sys.print(pixels.toHex());
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
}