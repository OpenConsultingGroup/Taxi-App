import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:taxi_app/models/payment_method.dart';
import 'package:taxi_app/models/taxi.dart';
import 'package:taxi_app/models/taxi_booking.dart';
import 'package:taxi_app/models/taxi_driver.dart';

abstract class TaxiBookingState extends Equatable {
  TaxiBookingState();
}

class TaxiBookingNotInitializedState extends TaxiBookingState {
  TaxiBookingNotInitializedState();
  @override
  List<Object> get props => null;
}

class TaxiBookingNotSelectedState extends TaxiBookingState {
  final List<Taxi> taxisAvailable;

  TaxiBookingNotSelectedState({@required this.taxisAvailable});

  @override
  List<Object> get props => null;
}

class DetailsNotFilledState extends TaxiBookingState {
  final TaxiBooking booking;

  DetailsNotFilledState({@required this.booking});
  @override
  List<Object> get props => [booking];
}

class TaxiNotSelectedState extends TaxiBookingState {
  final TaxiBooking booking;

  TaxiNotSelectedState({@required this.booking});

  @override
  List<Object> get props => [booking];
}

class PaymentNotInitializedState extends TaxiBookingState {
  final TaxiBooking booking;
  final List<PaymentMethod> methodsAvaiable;

  PaymentNotInitializedState({
    @required this.booking,
    @required this.methodsAvaiable,
  });

  @override
  List<Object> get props => [booking];
}

class TaxiNotConfirmedState extends TaxiBookingState {
  final TaxiDriver driver;
  final TaxiBooking booking;

  TaxiNotConfirmedState({@required this.driver, @required this.booking});

  @override
  List<Object> get props => [driver, booking];
}

class TaxiConfirmedState extends TaxiBookingState {
  final TaxiDriver driver;
  final TaxiBooking booking;

  TaxiConfirmedState({@required this.driver, @required this.booking});

  @override
  List<Object> get props => [driver, booking];
}

class TaxiBookingCancelledState extends TaxiBookingState {
  @override
  List<Object> get props => null;
}

class TaxiBookingLoadingState extends TaxiBookingState {
  final TaxiBookingState state;

  TaxiBookingLoadingState({@required this.state});
  @override
  List<Object> get props => [state];
}

class TaxiBookingConfirmedState extends TaxiBookingState {
  final TaxiDriver driver;
  final TaxiBooking booking;

  TaxiBookingConfirmedState({@required this.driver, @required this.booking});
  @override
  List<Object> get props => [driver];
}
