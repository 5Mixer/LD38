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
		
		for (worldObject in project.worldObjects){
			if (worldObject == this) continue;
			if (worldObject.dead) continue;
			if (Math.abs(worldObject.x-x) < 3 && Math.abs(worldObject.y-y)<3){
				if (Std.is(worldObject,Bomb)){
					cast (worldObject,Bomb).onCollide();
				}
			}
		}
		for (worm in project.enemyWorms){
			for (segment in worm.segments){
				if (Math.abs(segment.x-x) < 3 && Math.abs(segment.y-y)<3){
					worm.dead = true;
				}
			}
		}
	}
	override public function render(g:kha.graphics2.Graphics){
		if (!dead)
			g.drawSubImage(kha.Assets.images.bomb,x*8,y*8,0,0,8,8);
	}
}