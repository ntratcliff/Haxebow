class Interpreter {
	private var _statements:Array<String>;
	private var _loc:Int;
	
	public function new(statements:Array<String>){
		_statements = statements;
		_loc = 0;
	}
	
	public function begin(){ //begin interpreting program
		while(_loc < _statements.length){
			var statement = _statements[_loc]; //get current statement
			var instChar = statement.charAt(0); //get first character of statement for instruction
			var addr = statement.substring(1, 2); //get addr value
			var valSwitch = 	statement.charAt(3); //get value swtich
			var val = statement.substring(4, 5); //get val value
			
			switch(instChar){
				case '0': _exit(val);
				default: trace("Unexpected instruction encountered");
			}
			
			_loc++; //iterate to next statement
		}
	}
	
	private function _exit(val) {
		trace("exit");
	}
}