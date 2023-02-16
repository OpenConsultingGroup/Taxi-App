part of 'taxi_booking_bloc.dart';

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

  TaxiBookingNotSelectedState({this.taxisAvailable});

  @override
  List<Object> get props => null;
}

class DetailsNotFilledState extends TaxiBookingState {
  final TaxiBooking booking;

  DetailsNotFilledState({this.booking});
  @override
  List<Object> get props => [booking];
}

class TaxiNotSelectedState extends TaxiBookingState {
  final TaxiBooking booking;

  TaxiNotSelectedState({this.booking});

  @override
  List<Object> get props => [booking];
}

class PaymentNotInitializedState extends TaxiBookingState {
  final TaxiBooking booking;
  final List<PaymentMethod> methodsAvailable;

  PaymentNotInitializedState({
    this.booking,
    this.methodsAvailable,
  });

  @override
  List<Object> get props => [booking];
}

class TaxiNotConfirmedState extends TaxiBookingState {
  final TaxiDriver driver;
  final TaxiBooking booking;

  TaxiNotConfirmedState({this.driver, this.booking});

  @override
  List<Object> get props => [driver, booking];
}

class TaxiConfirmedState extends TaxiBookingState {
  final TaxiDriver driver;
  final TaxiBooking booking;

  TaxiConfirmedState({this.driver, this.booking});

  @override
  List<Object> get props => [driver, booking];
}

class TaxiBookingCancelledState extends TaxiBookingState {
  @override
  List<Object> get props => null;
}

class TaxiBookingLoadingState extends TaxiBookingState {
  final TaxiBookingState state;

  TaxiBookingLoadingState({this.state});
  @override
  List<Object> get props => [state];
}

class TaxiBookingConfirmedState extends TaxiBookingState {
  final TaxiDriver driver;
  final TaxiBooking booking;

  TaxiBookingConfirmedState({this.driver, this.booking});
  @override
  List<Object> get props => [driver];
}
