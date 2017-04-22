package ;
class MagicParticle extends Particle {
	var vx = 0.0;
	var vy = 0.0;
	var size = 1;
	var life = 0;
	override public function new (x,y){
		super(x,y);
		vx = -.5+Math.random()*1;
		vy = -.5+Math.random()*1;
		size = Math.floor(Math.random()*3);
		life = 15+Math.ceil(Math.random()*20);
	}
	override public function render(g:kha.graphics2.Graphics){
		if (life > 0){
			life--;
			x += vx;
			y += vy;
			vx *= .8;
			vy *= .8;
			g.color = kha.Color.fromString("#cca283db");
			g.fillRect(x,y,size,size);
			g.color = kha.Color.White;
		}
	}
}