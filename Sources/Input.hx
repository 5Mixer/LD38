package ;

class Input {
	public var keys = new Map<kha.Key,Bool >();
	public var chars = new Map<String,Bool >();
	public var justUpChars = new Array<String>();
	public var justUpKeys = new Array<kha.Key>();
	
	public function new (){
		kha.input.Keyboard.get().notify(kDown,kUp);
	}
	function kDown(key:kha.Key,char:String){
		keys.set(key,true);
		chars.set(char,true);
		justUpChars.push(char);
		justUpKeys.push(key);
	}
	function kUp(key:kha.Key,char:String){
		keys.set(key,false);
		chars.set(char,false);
	}
}