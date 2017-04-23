package ;

class Wall extends WorldObject {
	var life = 30;
	override public function new (x:Int, y:Int,p:Project){
		super(x,y,p);
	}
	override public function moveUpdate (){
		life--;
		if (life < 1){
			dead = true;
			kha.audio1.Audio.play(kha.Assets.sounds.wallcollapse);
			project.screenshake += 1;
			for (tx in 0...3)
				for (ty in 0...3)
					for (i in 0...1)
						project.particles.push(new ExplosionParticle(Math.floor((tx-1+x+Math.random())*8),Math.floor((ty-1+y+Math.random())*8)));
		
			
		}
	}
	override public function render(g:kha.graphics2.Graphics){
		if (!dead)
			g.drawSubImage(kha.Assets.images.icons,x*8,y*8,8,0,8,8);
	}
}