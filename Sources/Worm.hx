package ;

typedef WormSegment = {
	var x:Int;
	var y:Int;
	var rotation:Int;
}

class Worm {
	public var segments:Array<WormSegment> = [];
	public var grow = false;
	public var justHead = true;
	public var dropping = false;
	public var energy = 5;
	var map:WorldGrid;
	public function new (map:WorldGrid){
		segments.push({x:1,y:3,rotation:0});
		this.map = map;
	}
	public function render (g:kha.graphics2.Graphics){
		
		for (segment in segments){
			var head = segment;
			var x = head.x*8;
			var y = head.y*8;
			var angle = (Math.PI*2)*(.25*head.rotation);
			if (angle != 0) g.pushTransformation(g.transformation.multmat(kha.math.FastMatrix3.translation(x + 4, y + 4)).multmat(kha.math.FastMatrix3.rotation(angle)).multmat(kha.math.FastMatrix3.translation(-x - 4, -y - 4)));
			g.drawSubImage(kha.Assets.images.worm,head.x*8,head.y*8,8,0,8,8);
			if (angle != 0) g.popTransformation();

		}
		var head = segments[0];
		var x = head.x*8;
		var y = head.y*8;
		var angle = (Math.PI*2)*(.25*head.rotation);
		if (angle != 0) g.pushTransformation(g.transformation.multmat(kha.math.FastMatrix3.translation(x + 4, y + 4)).multmat(kha.math.FastMatrix3.rotation(angle)).multmat(kha.math.FastMatrix3.translation(-x - 4, -y - 4)));
		g.drawSubImage(kha.Assets.images.worm,head.x*8,head.y*8,0,0,8,8);
		if (angle != 0) g.popTransformation();

	}
	public function turnLeft(){
		segments[0].rotation--;
		segments[0].rotation = segments[0].rotation%4;
		if (segments[0].rotation<0)segments[0].rotation = 3;
	}
	public function turnRight(){
		segments[0].rotation++;
		segments[0].rotation = segments[0].rotation%4;
		if (segments[0].rotation<0)segments[0].rotation = 3;

	}
	public function move (){
		var newSegments = [];
		var head = {x:segments[0].x,y:segments[0].y,rotation:segments[0].rotation};
		var newHead = {x:head.x,y:head.y,rotation:head.rotation};
		if (head.rotation == 0){
			newHead.x++;
		}
		if (head.rotation == 1){
			newHead.y++;
		}
		if (head.rotation == 2){
			newHead.x--;
		}
		if (head.rotation == 3){
			newHead.y--;
		}
		if (dropping || map.get(newHead.x,newHead.y).id!=9){
			head = newHead;
		}
		if (dropping){
			if (newHead.x > 0 && newHead.y > 0)
				dropping = false;
		}
		
		segments.insert(0,head);
		if (!grow){
			segments.pop();
		}
		
		if (justHead){
			segments = [head];
		}
		// if (grow)
		// 	segments.pop();
	}
}