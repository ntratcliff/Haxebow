import haxe.io.*;

class Parser {
	public var statements:Array<String>;
	public function new(args:Array<String>) {
		var imgPath = args[0]; //path to image should always be first argument
		var rgbBytes = _getRGB(imgPath);
		statements = _bytesToStatements(rgbBytes);
	}
	
	//returns Bytes object with just RGB values of image at path
	private function _getRGB(path:String):Bytes {
		var src = _getFormatSpecificARGB(path);
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
	
	//determines file extension and returns ARGB bytes from file's format tools
	private function _getFormatSpecificARGB(path:String):Bytes {
		var ret = null;
		var ext = Path.extension(path).toLowerCase();
		var stream = sys.io.File.read(path, true);
		
		switch(ext) {
			case ImageExtension.Bmp: 
				var data = new format.bmp.Reader(stream).read();
				ret = format.bmp.Tools.extractARGB(data);
			case ImageExtension.Png:
				var data = new format.png.Reader(stream).read();
				ret = format.png.Tools.extract32(data); //returns bytes as BGRA
				format.png.Tools.reverseBytes(ret); //sets ret bytes as ARGB
		}
		
		stream.close();
		return ret;
	}
	
	//returns array of 3 byte RGB hex strings from Bytes
	private function _bytesToStatements(pixels:Bytes):Array<String>{
		var statements = new Array();
		var i = 0;
		while(i < pixels.length) {
			statements.push(pixels.sub(i, 3).toHex().toUpperCase());
			i += 3;
		}
		return statements;
	}
}

@:enum
abstract ImageExtension(String) {
	var Bmp = "bmp";
	var Png = "png";
}