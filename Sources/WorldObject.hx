package ;

class WorldObject {
	public var x:Int;
	public var y:Int;
	public var project:Project;
	public var dead = false; // File from removal of owning array.
	public function new (x,y,project:Project){
		this.x = x;
		this.y = y;
		this.project = project;
	}
	public function onCollide () {

	}
	public function moveUpdate () {

	}
	public function render(g:kha.graphics2.Graphics){

	}
}