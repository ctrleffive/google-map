import 'package:meta/meta.dart';

import 'package:location/location.dart' as location;
import 'package:google_maps_webservice/directions.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:map/src/constants/common.dart';

class MapProvider {
  /// Get user's current location.
  Future<location.LocationData> getCurrentLocation() async {
    /// TODO: There are some issues with the location plugin. Please figure it out.
    // final location.Location _location = location.Location();
    // location.LocationData locationData;
    // try {
    //   locationData = await _location.getLocation();
    // } catch (e) {
    //   locationData = location.LocationData.fromMap({'latitude': 8.592128, 'longitude': 76.8547989});
    // }
    // return locationData;
    final location.LocationData locationData = location.LocationData.fromMap({
      'latitude': 8.592128,
      'longitude': 76.8547989,
    });
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
