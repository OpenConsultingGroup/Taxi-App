part of 'taxi_booking_bloc.dart';

abstract class TaxiBookingEvent extends Equatable {
  TaxiBookingEvent();
}

class TaxiBookingStartEvent extends TaxiBookingEvent {
  @override
  List<Object> get props => null;
}

class DestinationSelectedEvent extends TaxiBookingEvent {
  final LatLng destination;

  DestinationSelectedEvent({this.destination});

  @override
  List<Object> get props => [destination];
}

class DetailsSubmittedEvent extends TaxiBookingEvent {
  final GoogleLocation source;
  final GoogleLocation destination;
  final int noOfPersons;
  final DateTime bookingTime;

  DetailsSubmittedEvent({
    this.source,
    this.destination,
    this.noOfPersons,
    this.bookingTime,
  });

  @override
  List<Object> get props => [source, destination, noOfPersons, bookingTime];
}

class TaxiSelectedEvent extends TaxiBookingEvent {
  final TaxiType taxiType;

  TaxiSelectedEvent({this.taxiType});

  @override
  List<Object> get props => [taxiType];
}

class PaymentMadeEvent extends TaxiBookingEvent {
  final PaymentMethod paymentMethod;

  PaymentMadeEvent({this.paymentMethod});

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
