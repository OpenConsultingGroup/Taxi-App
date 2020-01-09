import 'package:google_maps_flutter/google_maps_flutter.dart';

class GoogleLocation {
  final String placeId;
  final LatLng position;
  final String areaDetails;

  GoogleLocation(this.placeId, this.position, this.areaDetails);

  GoogleLocation.named({this.placeId, this.position, this.areaDetails});
}
