class Rainbow {
	static public function main() { 
		var parser = new Parser(Sys.args()); //create a new instance of the parser and pass command line arguments
		var interpreter = new Interpreter(parser.statements);
		interpreter.begin();
	}
}