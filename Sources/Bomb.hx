package ;

class Bomb extends WorldObject {
	override public function new (x:Int, y:Int,p:Project){
		super(x,y,p);
	}
	override public function onCollide(){
		for (i in 0...10)
			project.particles.push(new ExplosionParticle(Math.floor((x+Math.random())*8),Math.floor((y+Math.random())*8)));
	}
	override public function render(g:kha.graphics2.Graphics){
		g.drawSubImage(kha.Assets.images.bomb,(x)*8,(y)*8,0,0,8,8);
	}
}