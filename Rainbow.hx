using Interpreter.PrintFormat;

class Rainbow {
	static public function main() { 
		//get runtime arguments
		var args = Sys.args(); 
		
		//create a new instance of the parser and pass command line arguments
		var parser = new Parser(args);

		//get print format from arguments
		var format:PrintFormat = PrintFormat.ASCII;
		switch(args[1]) {
			case "-d": format = PrintFormat.Decimal;
			case "-h": format = PrintFormat.Hex;
		}
		
		//create a new instance of interpreter and begin execution
		var interpreter = new Interpreter(parser.statements, format);
		interpreter.begin();
	}
}