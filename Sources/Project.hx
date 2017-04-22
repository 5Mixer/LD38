package;

import kha.Framebuffer;
import kha.Scheduler;
import kha.System;

class Project {
	var worldGrid:WorldGrid;
	var playerWorm:Worm;
	var input:Input;
	var cam = {x:0.0,y:0.0};
	var enemyWorms:Array<Worm>;
	public var particles:Array<Particle> = [];
	var deathParticles:Array<Particle> = [];
	var worldObjects:Array<WorldObject> = [];
	var inDeath = false;
	var frame = 0;
	var moves = 0;
	public function new() {
		System.notifyOnRender(render);
		Scheduler.addTimeTask(update, 0, 1 / 60);
		input = new Input();
		worldGrid = new WorldGrid(16);
		playerWorm = new Worm(worldGrid);
		enemyWorms = [];
		for (x in 0...4){
			var worm = new Worm(worldGrid);
			worm.grow = false;
			worm.justHead = false;
			enemyWorms.push(worm);
		}
		for (i in 0...60){
			deathParticles.push(new DeathParticle(Math.floor(Math.random()*kha.System.windowWidth()),Math.floor(Math.random()*kha.System.windowHeight())));
		}
		cam.x = ((playerWorm.segments[0].x*8*8));
		cam.y = ((playerWorm.segments[0].y*8*8));
	}

	function update(): Void {
		frame++;

		if (moves % 10 == 0){
			worldObjects.push(new Bomb(1+Math.floor(Math.random()*worldGrid.width*8),1+Math.floor(Math.random()*worldGrid.height*8),this));
		}
		
		inDeath = input.keys.get(kha.Key.SHIFT);
		if (!input.keys.get(kha.Key.SHIFT)){
			playerWorm.justHead = true;
		}else{
			playerWorm.justHead = false;
		}
		if (input.justUpKeys.indexOf(kha.Key.UP)!=-1 || input.justUpChars.indexOf("w")!=-1){
			if (playerWorm.justHead){
				if (playerWorm.segments.length > 1){
					trace("Explosions");
					for (segment in playerWorm.segments){
						for (i in 0...20)
							particles.push(new ExplosionParticle(segment.x*8 + Math.floor(Math.random()*8),segment.y*8+Math.floor(Math.random()*8)));
					}
				}
			}

			playerWorm.move();
			moveWorld();

			
		}
		if (input.justUpKeys.indexOf(kha.Key.LEFT)!=-1 || input.justUpChars.indexOf("a")!=-1){
			playerWorm.turnLeft();

			playerWorm.move();
			moveWorld();
		}
		if (input.justUpKeys.indexOf(kha.Key.RIGHT)!=-1 || input.justUpChars.indexOf("d")!=-1){
			playerWorm.turnRight();

			playerWorm.move();
			moveWorld();
		}

		cam.x -= (((cam.x)-(playerWorm.segments[0].x*8*8))/2)/5;
		cam.y -= (((cam.y)-(playerWorm.segments[0].y*8*8))/2)/5;

		input.justUpKeys = [];
		input.justUpChars = [];
	}

	function moveWorld (){
		moves++;
		for (object in worldObjects){
			if (playerWorm.segments[0].x == object.x && playerWorm.segments[0].y == object.y){
				object.onCollide();
			}
		}
		for (worm in enemyWorms){
			worm.move();
			if (Math.random()>.5)
				worm.turnLeft();

			if (Math.random()>.5)
				worm.turnRight();

			
			for (object in worldObjects){
				if (worm.segments[0].x == object.x && worm.segments[0].y == object.y){
					object.onCollide();
				}
			}

			for (segment in worm.segments){
				if (segment.x == playerWorm.segments[0].x && segment.y == playerWorm.segments[0].y){
					worm.segments = worm.segments.splice(0,worm.segments.indexOf(segment));
					if (worm.segments.length == 0)
						enemyWorms.remove(worm);
					break;
				}
			}
		}
	}

	function render(framebuffer: Framebuffer): Void {
		
		var g = framebuffer.g2;
		g.begin(true);
		g.pushTransformation(g.transformation);
		g.translate(-cam.x+framebuffer.width/2,-cam.y+framebuffer.height/2);
		g.transformation._00 = 8;
		g.transformation._11 = 8;
		worldGrid.render(g);

		g.pushTransformation(kha.math.FastMatrix3.identity());
		
		g.popTransformation();
		for (object in worldObjects)
			object.render(g);
		playerWorm.render(g);
		for (worm in enemyWorms){
			g.color = kha.Color.Red;
			worm.render(g);
			g.color = kha.Color.White;
		}
		for (particle in particles)
			particle.render(g);

		if (inDeath){
			for (i in 0...100){
				deathParticles.push(new DeathParticle(Math.floor(Math.random()*kha.System.windowWidth()),Math.floor(Math.random()*kha.System.windowHeight())));
			}
			for (particle in deathParticles)
				particle.render(g);
		}
		playerWorm.grow = input.keys.get(kha.Key.SHIFT);
		playerWorm.justHead = !input.keys.get(kha.Key.SHIFT); //Works but need below for effects etc.
		
		g.popTransformation();
		if (inDeath){
			g.color = kha.Color.fromBytes(20,18,25,120);
			g.fillRect(0,0,kha.System.windowWidth(),kha.System.windowHeight());
			g.color = kha.Color.White;
		}
		g.end();
	}
}
