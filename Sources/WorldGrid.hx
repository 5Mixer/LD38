package ;


class WorldGrid {
	public var tiles:Array<Tile> = [];
	public var width:Int = 0;
	public var height:Int = 0;
	var time = 0;
	var tileSize = 8;
	public function new (mapSize:Int){
		width = height = mapSize;
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
	public function get(x:Int, y:Int){
		return tiles[y*width+x];
	}
	public function render (g:kha.graphics2.Graphics){
		time++;
		for (y in 0...height){
			for (x in 0...width){
				var tile = tiles[(y*width)+x];
				
				var off = Math.min(((Math.sqrt(Math.pow(x,2)+Math.pow(y,2))*32)+(time*8))/400,1)*8;
				g.drawSubImage(kha.Assets.images.mapTiles,x*tileSize,(y*tileSize)+off-8,tile.id*tileSize,0,tileSize,tileSize);
			}
		}
	}
}