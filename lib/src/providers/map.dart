import 'package:meta/meta.dart';

import 'package:location/location.dart' as l;
import 'package:google_maps_webservice/directions.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:map/src/constants/common.dart';

class MapProvider {
  /// Get user's current location.
  Future<l.LocationData> getCurrentLocation() async {
    final l.Location _location = l.Location();
    l.LocationData locationData;
    try {
      locationData = await _location.getLocation();
    } catch (e) {
      locationData = l.LocationData.fromMap({'latitude': 0.0, 'longitude': 0.0});
    }
    return locationData;
  }

  /// Get route path between two points.
  /// Polylines data is included in the response. 
  /// Decoder is available in the helper function.
  Future<DirectionsResponse> getDirection({@required LatLng start, @required LatLng end}) async {
    final GoogleMapsDirections _directions = GoogleMapsDirections(apiKey: CommonConstants.apiKey);
    final DirectionsResponse directionsResponse = await _directions.directionsWithLocation(
      Location(start.latitude, start.longitude),
      Location(end.latitude, end.longitude),
      trafficModel: TrafficModel.bestGuess,
      travelMode: TravelMode.driving,
      departureTime: DateTime.now(),
    );
    return directionsResponse;
  }
}