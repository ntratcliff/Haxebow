import cpp.UInt8;

class Interpreter {

	static private var _statements:Array<String>;
	static private var _loc:Int;
	
	static private var _mem:Array<UInt8>;
	
	static private var _format:PrintFormat;
	
	static public function main() { 
		//get runtime arguments
		var args = Sys.args(); 
		
		//create a new instance of the parser and pass command line arguments
		var parser = new Parser(args);

		//get statements from parser
		_statements = parser.statements;
		
		//get print format from arguments
		_format = PrintFormat.ASCII;
		switch(args[1]) {
			case "-d": _format = PrintFormat.Decimal;
			case "-h": _format = PrintFormat.Hex;
		}
		
		_loc = 0; 
		
		//create memory tape
		_mem = new Array();
		
		//fill memory tape with 0 values
		for(i in 0...255) { 
			_mem[i] = 0;
		}
		
		//begin interpreting program
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
				case Instruction.Exit: return; //exit
				case Instruction.Set: _mem[addr] = val;
				case Instruction.Print: _print(addr, addr2, _format);
				case Instruction.In: _input(addr, addr2);
				case Instruction.Label: //label, do nothing
				case Instruction.Lookback: _lookback(val);
				case Instruction.Lookahead: _lookahead(val);
				case Instruction.Add: _mem[addr] = _mem[addr] + val; //add val to cell at addr
				case Instruction.Sub: _mem[addr] = _mem[addr] - val; //sub val from cell at addr
				case Instruction.Mul: _mem[addr] = _mem[addr] * val; //mul cell at addr by val
				case Instruction.Div: _mem[addr] = Std.int(_mem[addr] / val); //div cell at addr by val
				case Instruction.Mod: _mem[addr] = _mem[addr] % val; //mod cell at addr by val
				default: trace("Unexpected instruction encountered: " + statement);
			}
			_loc++; //iterate to next statement
		}
	}
	
	//print contents of the memory tape
	static private function _memdump() {
		_print(0, _mem.length - 1, PrintFormat.Hex);
	}
	
	//print contents of memory tape from addr to addr2 with specified format
	static private function _print(addr:Int, addr2:Int, format:PrintFormat) {
		var i = addr;
		switch(format) {
			case ASCII: 
				while(i <= addr2) { 
					Sys.print(String.fromCharCode(_mem[i])); 
					i++;
				}
			case Hex: 
				while(i <= addr2) {
					Sys.print(StringTools.hex(_mem[i], 2)); 
					if(i < addr2) {
						Sys.print("-");
					}
					i++;
				}
			case Decimal: 
				while(i <= addr2) {
					Sys.print(_mem[i]);
					if(i < addr2) {
						Sys.print("-");
					}
					i++;
				}
			default: trace("something went very wrong");
		}
	}
	
	//get input from stdin, write to tape starting at addr, and put last addr in cell at val
	static private function _input(addr:Int, val:Int) { 
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
	static private function _labelMatch(statement:String, val:Int):Bool {
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
	static private function _lookback(val:Int) {
		while(_loc > 0) {
			_loc--;
			if(_labelMatch(_statements[_loc], val)) {
				return;
			}
		}
	}
	
	//lookahead and begin execution at first label with value of val
	static private function _lookahead(val:Int) {
		while(_loc < _statements.length) {
			_loc++;
			if(_labelMatch(_statements[_loc],val)) {
				return;
			}
		}
	}
}

@:enum
abstract Instruction(String) {
	var Exit = "0";
	var Set = "1";
	var Print = "2";
	var In = "3";
	var Label = "5";
	var Lookback = "6";
	var Lookahead = "7";
	var Add = "A";
	var Sub = "B";
	var Mul = "C";
	var Div = "D";
	var Mod = "E";
}
	
enum PrintFormat {
	ASCII;
	Hex;
	Decimal;
}