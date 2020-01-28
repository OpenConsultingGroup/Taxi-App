# Flutter Taxi App [![PRs Welcome](https://img.shields.io/badge/PRs-welcome-brightgreen.svg?style=flat-square)](http://makeapullrequest.com)


A Flutter starter taxi app built with BLOC pattern. It has following features

  - Taxi markers showing on different position on map (Based on static position)
  - Different animations across different part of screen 
  - Polyline showing on map (Hardcoded data from Google Maps API)
  - Runs on both Android & IOS.

### Screenshots

![makephotogallery.net_1580238239.jpg](https://www.dropbox.com/s/dgd40s5752y2jsl/makephotogallery.net_1580238239.jpg?dl=0&raw=1)

### Video Recording
![video.gif](https://firebasestorage.googleapis.com/v0/b/smart-ordr.appspot.com/o/ezgif.com-resize.gif?alt=media&token=3d9a010b-ba52-4045-a24e-cb3078e2a2f1)
### Dependencies

This project is built with various awesome open sourced libraries

* [google_maps_flutter](https://pub.dev/packages/google_maps_flutter) -  to show map on screen (Still in beta version)
* [flutter_bloc](https://pub.dev/packages/flutter_bloc) - to mantain state and make every widget independent using blocs 
* [bloc](https://pub.dev/packages/bloc) - to listen events on taps by user and dispatch new state to other widgets
* [equatable](https://pub.dev/packages/equatable) - to make models comparable (Nice Library) 
* [shimmer](https://pub.dev/packages/shimmer) - to show nice loading effect
* [location](https://pub.dev/packages/location) - to get current location of user (Feature to be developed)


### Installation

Add your API_KEY and your own credentials from your firebase project to android and ios folders. Run following command in cmd and then run your app

```sh
$ pub get
```
### Credits
Kudos to [Dibbendo Pranto](https://dribbble.com/Dibbendopranto) for this design.

### Development

We love contributors. Looking forward to as many as possible.
App may still have issues and bugs that may have a quick fix that we missed while development.

### Developer

We are a team of digital nomads who believe in open-source development and free-for-all products.
We welcome anyone who is genuine and interested in developing great product that solve real world problems.

You can get in touch with us at dev@ocg.technology
