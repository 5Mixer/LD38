let fs = require('fs');
let path = require('path');
let project = new Project('Space Worm', __dirname);
project.targetOptions = {"html5":{},"flash":{},"android":{},"ios":{}};
project.setDebugDir('build/windows');
Promise.all([Project.createProject('build/windows-build', __dirname), Project.createProject('c:/Users/Owner/Desktop/Kode/resources/app/extensions/kha/Kha', __dirname), Project.createProject('c:/Users/Owner/Desktop/Kode/resources/app/extensions/kha/Kha/Kore', __dirname)]).then((projects) => {
	for (let p of projects) project.addSubProject(p);
	let libs = [];
	Promise.all(libs).then((libprojects) => {
		for (let p of libprojects) project.addSubProject(p);
		resolve(project);
	});
});
