import 'dart:math';
import 'dart:async';

import 'package:meta/meta.dart';

import 'package:location/location.dart';
import 'package:google_maps_webservice/directions.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:map/src/providers/map.dart';

class MapHelper {
  final MapProvider _provider = MapProvider();

  /// Getting user's current location from the provider.
  Future<LatLng> getCurrentLocation() async {
    final LocationData data = await this._provider.getCurrentLocation();
    final LatLng location = LatLng(data.latitude, data.longitude);
    return location;
  }

  /// Getting polyline points between two locations.
  /// Use this to draw polylines.
  Future<List<LatLng>> getDirection({@required LatLng start, @required LatLng end}) async {
    final DirectionsResponse directionsResponse = await this._provider.getDirection(start: start, end: end);

    if (directionsResponse.isDenied) throw Exception(directionsResponse.errorMessage);

    if (!directionsResponse.hasNoResults) {
      final String encodedPolyLine = directionsResponse.routes.first.overviewPolyline.points;
      final List<LatLng> decodedPoints = this._decodePolyline(encodedPolyLine);
      return decodedPoints;
    }
    return [];
  }

  static int _calcDiff(int result) {
    final bool isZero = (result & 1) == 0;
    final int val = (result >> 1);
    if (isZero) {
      return val;
    } else {
      return -val - 1;
    }
  }

  List<LatLng> _decodePolyline(String str, [_CodeOptions options]) {
    if (options == null) {
      options = _CodeOptions();
    }
    List<LatLng> coordinates = [];
    int index = 0, lat = 0, lng = 0, shift = 0, result = 0, byte, latChange, lngChange;

    while (index < str.length) {
      byte = null;
      shift = 0;
      result = 0;

      do {
        byte = str.codeUnitAt(index++) - 63;
        result |= ((byte & 0x1f) << shift);
        shift += 5;
      } while (byte >= 0x20);

      latChange = _calcDiff(result);

      shift = 0;
      result = 0;

      do {
        byte = str.codeUnitAt(index++) - 63;
        result |= ((byte & 0x1f) << shift);
        shift += 5;
      } while (byte >= 0x20);

      lngChange = _calcDiff(result);

      lat += latChange;
      lng += lngChange;

      coordinates.add(LatLng(lat / options.factor, lng / options.factor));
    }

    return coordinates;
  }
}

class _CodeOptions {
  num precision;
  num factor;
  _CodeOptions([this.precision = 5, this.factor]) {
    if (this.factor == null) {
      this.factor = pow(10, precision);
    }
  }
}
