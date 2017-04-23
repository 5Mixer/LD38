package ;


class WorldGrid implements pathfinder.IMap {
	public var tiles:Array<Tile> = [];
	public var width:Int = 0;
	public var height:Int = 0;
	
	public var rows( default, null ):Int;
	public var cols( default, null ):Int;
	var time = 0;
	var tileSize = 8;
	var p:Project;
	public function new (mapSize:Int,project:Project){
		width = height = mapSize;
		rows = height;
		cols = width;
		this.p = project;
		emptyMap();
	}
	public function emptyMap () {
		tiles = [];
		for (y in 0...height){
			for (x in 0...width){
				if (x==0||y==0||x==width-1||y==height-1){
					tiles.push(new Tile(9));
				}else{
					tiles.push(new Tile(1+Math.floor(Math.random()*7)));

				}
			}
		}
	}
	public function isWalkable( x:Int, y:Int ):Bool
	{
		for (object in p.worldObjects){
			if (Std.is(object,Wall)){
				if (object.x == x && object.y == y)
					return false;
			}
		}
		return get(x,y).id != 9;
	}
	public function get(x:Int, y:Int){
		return tiles[y*width+x];
	}
	public function render (g:kha.graphics2.Graphics){
		time++;
		for (y in 0...height){
			for (x in 0...width){
				var tile = tiles[(y*width)+x];
				
				var off =  1 - Math.min(((x*y)+time/8)-8,1);
				g.drawSubImage(kha.Assets.images.mapTiles,off/2+x*tileSize,off/2+(y*tileSize),tile.id*tileSize,0,tileSize-off,tileSize-off);
			}
		}
	}
}