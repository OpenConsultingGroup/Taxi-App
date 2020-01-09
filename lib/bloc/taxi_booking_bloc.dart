import 'package:bloc/bloc.dart';
import 'package:taxi_app/bloc/taxi_booking_event.dart';
import 'package:taxi_app/bloc/taxi_booking_state.dart';
import 'package:taxi_app/controllers/location_controller.dart';
import 'package:taxi_app/controllers/payment_method_controller.dart';
import 'package:taxi_app/controllers/taxi_booking_controller.dart';
import 'package:taxi_app/models/google_location.dart';
import 'package:taxi_app/models/payment_method.dart';
import 'package:taxi_app/models/taxi.dart';
import 'package:taxi_app/models/taxi_booking.dart';
import 'package:taxi_app/models/taxi_driver.dart';
import 'package:taxi_app/storage/taxi_booking_storage.dart';

class TaxiBookingBloc extends Bloc<TaxiBookingEvent, TaxiBookingState> {
  @override
  TaxiBookingState get initialState => TaxiBookingNotInitializedState();

  @override
  Stream<TaxiBookingState> mapEventToState(TaxiBookingEvent event) async* {
    if (event is TaxiBookingStartEvent) {
      List<Taxi> taxis = await TaxiBookingController.getTaxisAvailable();
      yield TaxiBookingNotSelectedState(taxisAvailable: taxis);
    }
    if (event is DestinationSelectedEvent) {
      TaxiBookingStorage.open();
      yield TaxiBookingLoadingState(
          state: DetailsNotFilledState(booking: null));

      GoogleLocation source = await LocationController.getCurrentLocation();
      GoogleLocation destination =
          await LocationController.getLocationfromId(event.destination);
      await TaxiBookingStorage.addDetails(TaxiBooking.named(
          source: source, destination: destination, noOfPersons: 1));
      TaxiBooking taxiBooking = await TaxiBookingStorage.getTaxiBooking();
      yield DetailsNotFilledState(booking: taxiBooking);
    }
    if (event is DetailsSubmittedEvent) {
      yield TaxiBookingLoadingState(state: TaxiNotSelectedState(booking: null));
      await Future.delayed(Duration(seconds: 1));
      await TaxiBookingStorage.addDetails(TaxiBooking.named(
        source: event.source,
        destination: event.destination,
        noOfPersons: event.noOfPersons,
        bookingTime: event.bookingTime,
      ));
      TaxiBooking booking = await TaxiBookingStorage.getTaxiBooking();
      yield TaxiNotSelectedState(
        booking: booking,
      );
    }
    if (event is TaxiSelectedEvent) {
      yield TaxiBookingLoadingState(
          state:
              PaymentNotInitializedState(booking: null, methodsAvaiable: []));
      TaxiBooking prevBooking = await TaxiBookingStorage.getTaxiBooking();
      double price = await TaxiBookingController.getPrice(prevBooking);
      await TaxiBookingStorage.addDetails(
          TaxiBooking.named(taxiType: event.taxiType, estimatedPrice: price));
      TaxiBooking booking = await TaxiBookingStorage.getTaxiBooking();
      List<PaymentMethod> methods = await PaymentMethodController.getMethods();
      yield PaymentNotInitializedState(
          booking: booking, methodsAvaiable: methods);
    }
    if (event is PaymentMadeEvent) {
      yield TaxiBookingLoadingState(
          state:
              PaymentNotInitializedState(booking: null, methodsAvaiable: null));
      TaxiBooking booking = await TaxiBookingStorage.addDetails(
          TaxiBooking.named(paymentMethod: event.paymentMethod));
      TaxiDriver taxiDriver =
          await TaxiBookingController.getTaxiDriver(booking);
      yield TaxiNotConfirmedState(booking: booking, driver: taxiDriver);
      await Future.delayed(Duration(seconds: 1));
      yield TaxiBookingConfirmedState(booking: booking, driver: taxiDriver);
    }
    if (event is TaxiBookingCancelEvent) {
      yield TaxiBookingCancelledState();
      await Future.delayed(Duration(milliseconds: 500));
      List<Taxi> taxis = await TaxiBookingController.getTaxisAvailable();
      yield TaxiBookingNotSelectedState(taxisAvailable: taxis);
    }
    if (event is BackPressedEvent) {
      switch (state.runtimeType) {
        case DetailsNotFilledState:
          List<Taxi> taxis = await TaxiBookingController.getTaxisAvailable();

          yield TaxiBookingNotSelectedState(taxisAvailable: taxis);
          break;
        case PaymentNotInitializedState:
          yield TaxiNotSelectedState(
              booking: (state as PaymentNotInitializedState).booking);
          break;
        case TaxiNotSelectedState:
          yield DetailsNotFilledState(
              booking: (state as TaxiNotSelectedState).booking);
          break;
      }
    }
  }
}
