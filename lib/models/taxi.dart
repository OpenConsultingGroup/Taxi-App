import 'package:equatable/equatable.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:taxi_app/models/taxi_type.dart';

class Taxi extends Equatable {
  final String id;
  final String title;
  final bool isAvailable;
  final String plateNo;
  final TaxiType taxiType;
  final LatLng position;

  Taxi(this.id, this.title, this.isAvailable, this.plateNo, this.taxiType,
      this.position);

  Taxi.named({
    this.id,
    this.title,
    this.isAvailable,
    this.plateNo,
    this.taxiType,
    this.position,
  });

  @override
  List<Object> get props => [title, isAvailable, plateNo, taxiType];
}
