import 'package:flutter/material.dart';
import 'package:map/src/views/map.dart';

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Map',
      debugShowCheckedModeBanner: false,
      home: MapView(),
    );
  }
}