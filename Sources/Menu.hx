package ;

class Menu extends State {
	var worldGrid:WorldGrid;
	var active = true;
	override public function new (){
		super();
		kha.input.Mouse.get().notify(function(_,_,_){
			if (!active) return;
			active = false;
			Main.state = new Project();
		},null,null,null);
	}
	var frame = 0;
	override public function render(fb:kha.Framebuffer){
		frame++;
		var g = fb.g2;
		g.begin();
		g.color = kha.Color.fromBytes(163,206,39);
		g.fontSize = 38;
		g.font = kha.Assets.fonts.Keycard;
		g.drawString("- Spaceworm -",fb.width/2 - g.font.width(g.fontSize,"- Spaceworm -")/2,30);

		g.drawString("- Click to play -",fb.width/2 - g.font.width(g.fontSize,"- Click to play -")/2,100);
		g.end();
	}
}