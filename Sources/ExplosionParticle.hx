package ;
class ExplosionParticle extends Particle {
	var vx = 0.0;
	var vy = 0.0;
	var size = 1;
	var life = 0;
	var max = 0;
	override public function new (x,y){
		super(x,y);
		vx = -1+Math.random()*2;
		vy = -1+Math.random()*2;
		size = Math.floor(Math.random()*3);
		life = 5+Math.ceil(Math.random()*20);
		max = life;
	}
	override public function render(g:kha.graphics2.Graphics){
		if (life > 0){
			life--;
			x += vx;
			y += vy;
			vx *= .8;
			vy *= .8;
			if (life > .1){
				g.color = kha.Color.fromString("#eef7f7f4");
			}else{
				g.color = kha.Color.fromString("#eef7f7f4");
				//g.color = kha.Color.Black;
			}
			g.fillRect(x,y,size,size);
			g.color = kha.Color.White;
		}
	}
}