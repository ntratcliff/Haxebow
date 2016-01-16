import cpp.UInt8;

class Interpreter {
	private var _statements:Array<String>;
	private var _loc:Int;
	
	private var _mem:Array<UInt8>;
	
	public function new(statements:Array<String>) {
		_statements = statements;
		_loc = 0; 
		_mem = new Array(); //memory tape
		for(i in 0...255) { //fill memory tape with 0 values
			_mem[i] = 0;
		}
	}
	
	public function begin() { //begin interpreting program
		while(_loc < _statements.length){
			var statement = _statements[_loc]; //get current statement
			var instChar = statement.charAt(0); //get first character of statement for instruction
			var strAddr = "0x"+statement.substring(1, 3); //get addr string
			var valSwitch = 	statement.charAt(3); //get value switch
			var strVal = "0x"+statement.substring(4, 6); //get val string
			
			var addr:Int = Std.parseInt(strAddr); //get addr
			var addr2:Int = Std.parseInt(strVal); //get val
			var val:Int = addr2;
			
			if(valSwitch == '1') { //if val is an address, get the value of the cell at that address
				val = _mem[addr2];
			}
			
			switch(instChar) {
				case '0': return; //exit
				case '1': _mem[addr] = val; //set cell at addr to val
				case '2': for(cell in _mem) { Sys.print(String.fromCharCode(cell)); } //rough print, not fully implemented
				case '3': _input(addr, addr2);//get input 
				case '5': //label, do nothing
				case '6': _lookback(val); //lookback
				case '7': _lookahead(val); //lookahead
				case 'A': _mem[addr] = _mem[addr] + val; //add val to cell at addr
				case 'B': _mem[addr] = _mem[addr] - val; //sub val from cell at addr
				case 'C': _mem[addr] = _mem[addr] * val; //mul cell at addr by val
				case 'D': _mem[addr] = Std.int(_mem[addr] / val); //div cell at addr by val
				case 'E': _mem[addr] = _mem[addr] % val; //mod cell at addr by val
				default: trace("Unexpected instruction encountered: " + statement);
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
	
	//get input from stdin, write to tape starting at addr, and put last addr in cell at val
	private function _input(addr:Int, val:Int) { 
		var stdin = Sys.stdin();
		var inp = stdin.readLine();
		stdin.close();
		
		var i = 0;
		
		if(Std.parseInt(inp) != null) { //if string is an integer, set the cell to the value of the string
			_mem[addr] = Std.parseInt(inp);
		}
		else {
			while(i < inp.length) {
				_mem[addr+i] = inp.charCodeAt(i);
				i++;
			}
		}
		
		
		_mem[val] = addr + i;
	}
	
	//check if statement is a label and if the value of the label matches val
	private function _labelMatch(statement:String, val:Int):Bool {
		if(statement.charAt(0) == '5') { //if statement is label
			var valSwitch = 	statement.charAt(3); //get value switch
			var strVal = "0x"+statement.substring(4, 6); //get val string
			
			var lblVal = Std.parseInt(strVal);
			
			if(valSwitch == '1') { //if val is an address, get the value of the cell at that address
				lblVal = _mem[lblVal];
			}
			
			return (val == lblVal);
		}
		
		return false;
	}
	
	//lookback and begin execution at first label with value of val
	private function _lookback(val:Int) {
		while(_loc > 0) {
			_loc--;
			if(_labelMatch(_statements[_loc], val)) {
				return;
			}
		}
	}
	
	//lookahead and begin execution at first label with value of val
	private function _lookahead(val:Int) {
		while(_loc < _statements.length) {
			_loc++;
			if(_labelMatch(_statements[_loc],val)) {
				return;
			}
		}
	}
	
}