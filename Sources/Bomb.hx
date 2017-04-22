package ;

class Bomb extends WorldObject {
	
	override public function new (x:Int, y:Int,p:Project){
		super(x,y,p);
	}
	override public function onCollide(){
		dead = true;
		kha.audio1.Audio.play(kha.Assets.sounds.bomb);
		project.screenshake += 5;
		for (tx in 0...3)
			for (ty in 0...3)
				for (i in 0...10)
					project.particles.push(new ExplosionParticle(Math.floor((tx-1+x+Math.random())*8),Math.floor((ty-1+y+Math.random())*8)));
	}
	override public function render(g:kha.graphics2.Graphics){
		g.drawSubImage(kha.Assets.images.bomb,x*8,y*8,0,0,8,8);
	}
}