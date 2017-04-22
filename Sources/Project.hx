package;

import kha.Framebuffer;
import kha.Scheduler;
import kha.System;

class Project {
	var worldGrid:WorldGrid;
	var playerWorm:Worm;
	var input:Input;
	public var cam = {x:0.0,y:0.0};
	public var screenshake = 0.0;
	var enemyWorms:Array<Worm>;
	public var particles:Array<Particle> = [];
	var deathParticles:Array<Particle> = [];
	var worldObjects:Array<WorldObject> = [];
	var inDeath = false;
	var frame = 0;
	var moveframe = 0;
	var moves = 0;
	var stars:Array<Star> = [];
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
		for (i in 0...200){
			stars.push(new Star(Math.floor(Math.random()*60*8)-(5*8),Math.floor(Math.random()*60*8)-(5*8),this));
		}
		cam.x = ((playerWorm.segments[0].x*8*8));
		cam.y = ((playerWorm.segments[0].y*8*8));
	}

	function update(): Void {
		frame++;
		moveframe++;

		
		
		inDeath = input.keys.get(kha.Key.SHIFT);
		if (!input.keys.get(kha.Key.SHIFT)){
			playerWorm.justHead = true;
		}else{
			playerWorm.justHead = false;
		}
		if (((input.keys.get(kha.Key.UP) || input.chars.get("w")) && moveframe%10==0)||input.justUpKeys.indexOf(kha.Key.UP)!=-1 || input.justUpChars.indexOf("w")!=-1){
			moveframe = 0;
			if (playerWorm.justHead){
				if (playerWorm.segments.length > 1){
					//Finished a pause time.

					kha.audio1.Audio.play(kha.Assets.sounds.magic);
					for (segment in playerWorm.segments){
						for (i in 0...20)
							particles.push(new MagicParticle(segment.x*8 + Math.floor(Math.random()*8),segment.y*8+Math.floor(Math.random()*8)));
					}
				}
			}

			playerWorm.move();
			moveWorld();

			
		}
		if (input.justUpKeys.indexOf(kha.Key.LEFT)!=-1 || input.justUpChars.indexOf("a")!=-1){
			playerWorm.turnLeft();
		}
		if (input.justUpKeys.indexOf(kha.Key.RIGHT)!=-1 || input.justUpChars.indexOf("d")!=-1){
			playerWorm.turnRight();
		}


		input.justUpKeys = [];
		input.justUpChars = [];
	}

	function moveWorld (){

		moves++;
		if (moves % 10 == 0){
			worldObjects.push(new Bomb(Math.floor(Math.random()*(worldGrid.width-2))+1,Math.floor(Math.random()*(worldGrid.height-2))+1,this));
		}
		if (moves % 30 == 0){

			var worm = new Worm(worldGrid);
			worm.segments = [];
			
			worm.segments.push({x:-4,y:5,rotation:0});
			worm.segments.push({x:-5,y:5,rotation:0});
			worm.segments.push({x:-6,y:5,rotation:0});
			worm.grow = false;
			worm.dropping = true;
			worm.justHead = false;
			enemyWorms.push(worm);
		
		}
		kha.audio1.Audio.play(kha.Assets.sounds.walk1);
		for (object in worldObjects){
			if (playerWorm.segments[0].x == object.x && playerWorm.segments[0].y == object.y){
				object.onCollide();
			}
		}
		for (worm in enemyWorms){
			if (!inDeath){
				worm.move();
				if (!worm.dropping){
					if (Math.random()>.5)
						worm.turnLeft();

					if (Math.random()>.5)
						worm.turnRight();
				}
			}
			
			for (object in worldObjects){
				if (worm.segments[0].x == object.x && worm.segments[0].y == object.y){
					object.onCollide();
				}
				if (object.dead)
					worldObjects.remove(object);
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
		g.translate(-cam.x+framebuffer.width/2+(screenshake*Math.random()),-cam.y+framebuffer.height/2+(screenshake*Math.random()));
		g.transformation._00 = 4;
		g.transformation._11 = 4;

		cam.x -= (((cam.x)-(playerWorm.segments[0].x*8*g.transformation._00))/2)/5;
		cam.y -= (((cam.y)-(playerWorm.segments[0].y*8*g.transformation._11))/2)/5;

		for (star in stars)
			star.render(g);
			
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

		screenshake *= .7;
	}
}
