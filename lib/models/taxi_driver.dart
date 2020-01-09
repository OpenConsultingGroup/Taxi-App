import 'package:equatable/equatable.dart';

class TaxiDriver extends Equatable {
  final String id;
  final String driverName;
  final double driverRating;
  final String taxiDetails;
  final String driverPic;

  TaxiDriver(this.id, this.driverName, this.driverPic, this.driverRating,
      this.taxiDetails);

  TaxiDriver.named(
      {this.id,
      this.driverName,
      this.driverPic,
      this.driverRating,
      this.taxiDetails});

  @override
  List<Object> get props =>
      [id, driverName, driverPic, driverRating, taxiDetails];
}
