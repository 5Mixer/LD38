package ;

class Star {
	var x:Int;
	var y:Int;
	var size:Int;
	var z:Float;
	var p:Project;
	public function new (x,y,p:Project){
		this.x = x;
		this.y = y;
		this.size = Math.ceil(Math.random()*2);
		this.z = -1 + (Math.random()*.3)*size;
		this.p = p;
	}
	public function render (g:kha.graphics2.Graphics){
		g.color = kha.Color.fromBytes(229,229,213);
		g.fillRect(x-((p.cam.x/8) * z),y-((p.cam.y/8) * z),size,size);
	}
}