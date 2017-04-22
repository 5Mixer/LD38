package ;
class DeathParticle extends Particle {
	var vx = 0.0;
	var vy = 0.0;
	var size = 1;
	var life = 0;
	var a = 0.0;
	override public function new (x,y){
		super(x,y);
		size = Math.floor(Math.random()*3);
		life = 40+Math.ceil(Math.random()*20);
	}
	override public function render(g:kha.graphics2.Graphics){
		if (life > 0){
			life--;
			a += Math.sin(life/20)/7;
			var s = Math.sin(life/30);
			x += Math.cos(a)*s;
			y += Math.sin(a)*s;
			g.color = kha.Color.fromBytes(40,0,10,80);
			g.fillRect(x,y,size,size);
			g.color = kha.Color.White;
		}
	}
}