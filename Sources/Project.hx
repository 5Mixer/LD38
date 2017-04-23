package;

import kha.Framebuffer;
import kha.Scheduler;
import kha.System;

class Project {
	var worldGrid:WorldGrid;
	public var playerWorm:Worm;
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
	var mainTheme:kha.audio1.AudioChannel;
	var darkTheme:kha.audio1.AudioChannel;
	var darkness = 0.0;
	var beats:Array<Int> = [];
	public function new() {
		mainTheme = kha.audio1.Audio.play(kha.Assets.sounds.Theme,true);
		darkTheme = kha.audio1.Audio.play(kha.Assets.sounds.ThemeDark,true);
		var temp = kha.Assets.blobs.Beats_txt.toString();
		var lines = temp.split("\n");
		for (line in lines)
			beats.push(Std.parseInt(line));

		System.notifyOnRender(render);
		Scheduler.addTimeTask(update, 0, 1 / 60);
		input = new Input();
		worldGrid = new WorldGrid(16);
		playerWorm = new Worm(worldGrid);
		enemyWorms = [];
		for (i in 0...60){
			deathParticles.push(new DeathParticle(Math.floor(Math.random()*kha.System.windowWidth()),Math.floor(Math.random()*kha.System.windowHeight())));
		}
		for (i in 0...200){
			stars.push(new Star(Math.floor(Math.random()*60*8)-(10*8),Math.floor(Math.random()*60*8)-(10*8),this));
		}
		cam.x = ((playerWorm.segments[0].x*8*8));
		cam.y = ((playerWorm.segments[0].y*8*8));
	}

	var lastThemePosition:Float;
	var currentBeat:Int;
	var completedBeats:Array<Int> = [];
	function update(): Void {
		frame++;
		moveframe++;


		if (inDeath){
			if (darkness < 1)
				darkness += .05;
		}else{
			if (darkness > 0)
				darkness -= .05;
		}
		darkTheme.volume = darkness;
		mainTheme.volume = 1-darkness;
		
		/*for (beat in beats){
			if (completedBeats.indexOf(beat)!=-1)continue;                       
			var beatSeconds = beat;
			if (mainTheme.position > beatSeconds){
				if (currentBeat != beat){
					currentBeat = beat;
					completedBeats.push(beat);
					for (i in 0...100){
						particles.push(new ExplosionParticle(Math.floor((16*Math.random())*8),Math.floor((16*Math.random())*8)));
					
					}
				}
				
				break;
			}
		}
		lastThemePosition = mainTheme.position;*/

		inDeath = input.keys.get(kha.Key.SHIFT) && playerWorm.energy>0 && playerWorm.segments.length < 10;
		
		playerWorm.justHead = !inDeath;
		if (((input.keys.get(kha.Key.UP) || input.chars.get("w")) && moveframe%10==0)||input.justUpKeys.indexOf(kha.Key.UP)!=-1 || input.justUpChars.indexOf("w")!=-1){
			moveframe = 0;
			if (playerWorm.energy > 0 && playerWorm.justHead){
				if (playerWorm.segments.length > 1){
					//Finished a pause time.
					playerWorm.energy--;
					kha.audio1.Audio.play(kha.Assets.sounds.magic);
					for (segment in playerWorm.segments){
						for (i in 0...20)
							particles.push(new MagicParticle(segment.x*8 + Math.floor(Math.random()*8),segment.y*8+Math.floor(Math.random()*8)));
					}
				}
			}
			if (inDeath && playerWorm.segments.length >8){

			}else{
				playerWorm.move();
				moveWorld();
			}
			
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
		if (moves % 10 == 0 && !inDeath){
			worldObjects.push(new Bomb(Math.floor(Math.random()*(worldGrid.width-2))+1,Math.floor(Math.random()*(worldGrid.height-2))+1,this));
		}
		if (moves % 40 == 0 && !inDeath){
			worldObjects.push(new Energy(Math.floor(Math.random()*(worldGrid.width-2))+1,Math.floor(Math.random()*(worldGrid.height-2))+1,this));
		}
		if (moves % 20 == 0 && !inDeath){

			var worm = new Worm(worldGrid);
			var length = 1+Math.floor(Math.random()*5);
			worm.segments = [];
			var y = 1+Math.floor(Math.random()*(worldGrid.height-2));
			var x = -15;
			for (i in 0...length){
				worm.segments.push({x:x-i,y:y,rotation:0});
			}
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
					kha.audio1.Audio.play(kha.Assets.sounds.hurt);
					screenshake += 2;
					for (cutSegment in worm.segments.splice(worm.segments.indexOf(segment),worm.segments.length))
						for (n in 0...10)
							particles.push(new ExplosionParticle(Math.floor((cutSegment.x+Math.random())*8),Math.floor((cutSegment.y+Math.random())*8)));
					
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
		g.pushTransformation(kha.math.FastMatrix3.identity());
		// g.translate(-kha.System.windowWidth()/2,-kha.System.windowHeight()/2);
		// g.translate(kha.System.windowWidth()/2,kha.System.windowHeight()/2);
		g.pushTransformation(g.transformation);
		// g.rotate(frame/10,8*8-framebuffer.width/2,8*8-framebuffer.height/2);
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
		playerWorm.grow = input.keys.get(kha.Key.SHIFT) && playerWorm.energy>0 && playerWorm.segments.length < 10;
		playerWorm.justHead = !input.keys.get(kha.Key.SHIFT) && playerWorm.energy>0 || playerWorm.segments.length > 10; //Works but need below for effects etc.
		
		g.pushTransformation(kha.math.FastMatrix3.scale(4,4));
		for (energy in 0...playerWorm.energy){
			g.drawSubImage(kha.Assets.images.icons,8+(energy*8),8,0,0,8,8);
		}
		g.popTransformation();


		g.popTransformation();
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
