package;

import kha.System;

class Main {
	public static var state:State;
	public function new (){
		System.init({title: "Project", width: 800, height: 600}, function () {
			kha.Assets.loadEverything(function (){
				state = new Menu();

				kha.Scheduler.addTimeTask(update, 0, 1 / 60);
				System.notifyOnRender(render);
			});
		});
	}
	public static function main() {
		new Main();
		
	}
	public function update (){
		state.update();
	}
	public function render(g:kha.Framebuffer){
		state.render(g);
	}
}
