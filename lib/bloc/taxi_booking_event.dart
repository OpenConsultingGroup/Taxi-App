import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:taxi_app/models/google_location.dart';
import 'package:taxi_app/models/payment_method.dart';
import 'package:taxi_app/models/taxi_type.dart';

abstract class TaxiBookingEvent extends Equatable {
  TaxiBookingEvent();
}

class TaxiBookingStartEvent extends TaxiBookingEvent {
  @override
  List<Object> get props => null;
}

class DestinationSelectedEvent extends TaxiBookingEvent {
  final LatLng destination;

  DestinationSelectedEvent({@required this.destination});

  @override
  List<Object> get props => [destination];
}

class DetailsSubmittedEvent extends TaxiBookingEvent {
  final GoogleLocation source;
  final GoogleLocation destination;
  final int noOfPersons;
  final DateTime bookingTime;

  DetailsSubmittedEvent(
      {@required this.source,
      @required this.destination,
      @required this.noOfPersons,
      @required this.bookingTime});

  @override
  List<Object> get props => [source, destination, noOfPersons, bookingTime];
}

class TaxiSelectedEvent extends TaxiBookingEvent {
  final TaxiType taxiType;

  TaxiSelectedEvent({@required this.taxiType});

  @override
  List<Object> get props => [taxiType];
}

class PaymentMadeEvent extends TaxiBookingEvent {
  final PaymentMethod paymentMethod;

  PaymentMadeEvent({@required this.paymentMethod});

  @override
  List<Object> get props => [paymentMethod];
}

class BackPressedEvent extends TaxiBookingEvent {
  @override
  List<Object> get props => null;
}

class TaxiBookingCancelEvent extends TaxiBookingEvent {
  @override
  List<Object> get props => null;
}
