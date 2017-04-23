package ;

class Tree {
	//Position is left most root.
	var x:Int;
	var y:Int;
	public var leaves:Int = 9;
	public function new (x,y){
		this.x = x;
		this.y = y;
	}
	public function render (g:kha.graphics2.Graphics){
		//Roots
		g.drawSubImage(kha.Assets.images.tree,x*8,y*8,0,0,8,8);
		g.drawSubImage(kha.Assets.images.tree,x*8,(y+1)*8,8,0,8,8);
		g.drawSubImage(kha.Assets.images.tree,x*8,(y+2)*8,16,0,8,8);
		//Stem.
		g.drawSubImage(kha.Assets.images.tree,(x+1)*8,(y+1)*8,24,0,8,8);
		//Leaves
		
		for (leaf in 0...leaves){
			var leafx = 0;
			var leafy = 0;
			leafy = (leaf%3) -1;
			if (leaves==1)leafy++;

			leafx = Math.floor(leaf/3);


			g.drawSubImage(kha.Assets.images.tree,(x+2+leafx)*8,(y+1+leafy)*8,32,0,8,8);

		}
	}
}