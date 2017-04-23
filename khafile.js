let project = new Project('Space Worm');
project.addAssets('Assets/**');
project.addSources('Sources');
project.addLibrary('hxnoise');
project.addLibrary('Pathfinder');
resolve(project);
