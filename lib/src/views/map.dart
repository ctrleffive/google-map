import 'dart:async';

import 'package:flutter/material.dart';

import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:map/src/helpers/map.dart';

class MapView extends StatefulWidget {
  @override
  _MapViewState createState() => _MapViewState();
}

class _MapViewState extends State<MapView> {
  final MapHelper _mapHelper = MapHelper();
  final Completer<GoogleMapController> _controller = Completer();
  final StreamController<Set<Polyline>> _polylineSet = StreamController<Set<Polyline>>();

  void _populatePolylines() async {
    await Future.delayed(Duration(seconds: 1));
    final List<LatLng> locations = await this._mapHelper.getDirection(
      start: LatLng(8.585805, 76.860206),
      end: LatLng(8.623443, 76.848748),
    );
    final Polyline polyline = Polyline(
      polylineId: PolylineId('1'),
      points: locations,
      color: Colors.blue,
    );
    final Set<Polyline> polylineSet = Set.from([polyline]);
    this._polylineSet.sink.add(polylineSet);
  }

  @override
  void dispose() {
    _polylineSet.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<LatLng>(
        future: this._mapHelper.getCurrentLocation(),
        builder: (BuildContext context, AsyncSnapshot<LatLng> locationSnap) {
          if (!locationSnap.hasData) {
            return Center(
              child: SizedBox(
                height: 35,
                width: 35,
                child: CircularProgressIndicator(),
              ),
            );
          }
          return StreamBuilder<Set<Polyline>>(
            initialData: Set.from([]),
            stream: this._polylineSet.stream,
            builder: (BuildContext context, AsyncSnapshot<Set<Polyline>> polylineSnap) {
              return GoogleMap(
                polylines: polylineSnap.data,
                initialCameraPosition: CameraPosition(
                  target: locationSnap.data,
                  zoom: 13
                ),
                onMapCreated: (GoogleMapController controller) {
                  this._controller.complete(controller);
                  this._populatePolylines();
                },
              );
            }
          );
        },
      ),
    );
  }
}
