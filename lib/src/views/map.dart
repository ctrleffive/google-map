import 'package:flutter/material.dart';

import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:map/src/helpers/map.dart';

class MapView extends StatelessWidget {
  final MapHelper _helper = MapHelper();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<LatLng>(
        future: this._helper.getCurrentLocation(),
        builder: (BuildContext context, AsyncSnapshot<LatLng> locationSnap) {
          if (!locationSnap.hasData) {
            return Center(
              child: SizedBox(
                width: 25,
                child: CircularProgressIndicator(),
              ),
            );
          }
          return GoogleMap(
            initialCameraPosition: CameraPosition(
              target: locationSnap.data,
            ),
          );
        },
      ),
    );
  }
}
