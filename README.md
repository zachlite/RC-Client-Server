This repo contains a simple networking library, built on stream sockets.

The goal of this library is to be used as the foundation of a client server model to facilitate communication between a smart phone and RC car.

To try it out:
  run make
  ./server
  open xcode project, build and run for controller client
  
Dependencies:
  unix-like environment for socket libraries
  member of iOS developer to deploy on device. (the simulator does not have accelerometer access)
  
TODO:
  make cross-platform, android controller
  Everything car-related
  fix client to server send bug
  
  
  
  
