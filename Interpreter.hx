import cpp.UInt8;

class Interpreter {
	private var _statements:Array<String>;
	private var _loc:Int;
	
	private var _mem:Array<UInt8>;
	
	public function new(statements:Array<String>) {
		_statements = statements;
		_loc = 0; 
		_mem = new Array(); //memory tape
	}
	
	public function begin() { //begin interpreting program
		while(_loc < _statements.length){
			var statement = _statements[_loc]; //get current statement
			var instChar = statement.charAt(0); //get first character of statement for instruction
			var strAddr = "0x"+statement.substring(1, 3); //get addr string
			var valSwitch = 	statement.charAt(3); //get value switch
			var strVal = "0x"+statement.substring(4, 6); //get val string
			
			var addr = Std.parseInt(strAddr); //get addr
			var val = Std.parseInt(strVal); //get val
			
			if(valSwitch == '1') { //if val is an address, get the value of the cell at that address
				val = _mem[val];
			}
			
			switch(instChar) {
				case '0': return; //exit
				case '1': _mem[addr] = val; //set cell at addr to val
				case '2': for(cell in _mem) { Sys.print(String.fromCharCode(cell)); }
				case '3': //input
				case '6': //lookback
				case '7': //lookahead
				case 'A': //add
				case 'B': //sub
				case 'C': //mul
				case 'D': //div
				case 'E': //mod
				default: trace("Unexpected instruction encountered");
			}
			
			_loc++; //iterate to next statement
		}
	}
	
	//print contents of the memory tape
	public function memdump() {
		for(cell in _mem) {
			Sys.println(StringTools.hex(cell, 2));
		}
	}
}