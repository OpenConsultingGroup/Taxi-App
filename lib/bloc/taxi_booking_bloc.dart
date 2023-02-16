import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:taxi_app/controllers/location_controller.dart';
import 'package:taxi_app/controllers/payment_method_controller.dart';
import 'package:taxi_app/controllers/taxi_booking_controller.dart';
import 'package:taxi_app/models/google_location.dart';
import 'package:taxi_app/models/payment_method.dart';
import 'package:taxi_app/models/taxi.dart';
import 'package:taxi_app/models/taxi_booking.dart';
import 'package:taxi_app/models/taxi_driver.dart';
import 'package:taxi_app/models/taxi_type.dart';
import 'package:taxi_app/storage/taxi_booking_storage.dart';

part 'taxi_booking_event.dart';
part 'taxi_booking_state.dart';

class TaxiBookingBloc extends Bloc<TaxiBookingEvent, TaxiBookingState> {
  TaxiBookingBloc() : super(TaxiBookingNotInitializedState()) {
    on<TaxiBookingStartEvent>(_taxiBookingStarted);
    on<DestinationSelectedEvent>(_destinationSelected);
    on<DetailsSubmittedEvent>(_detailsSubmitted);
    on<TaxiSelectedEvent>(_taxSelected);
    on<PaymentMadeEvent>(_paymentMade);
    on<TaxiBookingCancelEvent>(_taxiBookingCancelled);
    on<BackPressedEvent>(_backPressed);
  }

  Future<void> _taxiBookingStarted(
      TaxiBookingStartEvent event, Emitter<TaxiBookingState> emit) async {
    List<Taxi> taxis = await TaxiBookingController.getTaxisAvailable();
    emit(TaxiBookingNotSelectedState(taxisAvailable: taxis));
  }

  Future<void> _destinationSelected(
      DestinationSelectedEvent event, Emitter<TaxiBookingState> emit) async {
    TaxiBookingStorage.open();
    emit(TaxiBookingLoadingState(state: DetailsNotFilledState(booking: null)));
    GoogleLocation source = await LocationController.getCurrentLocation();
    GoogleLocation destination =
        await LocationController.getLocationfromId(event.destination);

    await TaxiBookingStorage.addDetails(
      TaxiBooking.named(
        source: source,
        destination: destination,
        noOfPersons: 1,
      ),
    );

    TaxiBooking taxiBooking = await TaxiBookingStorage.getTaxiBooking();
    emit(DetailsNotFilledState(booking: taxiBooking));
  }

  Future<void> _detailsSubmitted(
      DetailsSubmittedEvent event, Emitter<TaxiBookingState> emit) async {
    emit(TaxiBookingLoadingState(state: TaxiNotSelectedState(booking: null)));
    await Future.delayed(Duration(seconds: 1));
    await TaxiBookingStorage.addDetails(
      TaxiBooking.named(
        source: event.source,
        destination: event.destination,
        noOfPersons: event.noOfPersons,
        bookingTime: event.bookingTime,
      ),
    );
    TaxiBooking booking = await TaxiBookingStorage.getTaxiBooking();
    emit(TaxiNotSelectedState(booking: booking));
  }

  Future<void> _taxSelected(
      TaxiSelectedEvent event, Emitter<TaxiBookingState> emit) async {
    emit(TaxiBookingLoadingState(
        state:
            PaymentNotInitializedState(booking: null, methodsAvailable: [])));
    TaxiBooking previousBooking = await TaxiBookingStorage.getTaxiBooking();
    double price = await TaxiBookingController.getPrice(previousBooking);
    await TaxiBookingStorage.addDetails(
        TaxiBooking.named(taxiType: event.taxiType, estimatedPrice: price));
    TaxiBooking booking = await TaxiBookingStorage.getTaxiBooking();
    List<PaymentMethod> methods = await PaymentMethodController.getMethods();
    emit(PaymentNotInitializedState(
        booking: booking, methodsAvailable: methods));
  }

  Future<void> _paymentMade(
      PaymentMadeEvent event, Emitter<TaxiBookingState> emit) async {
    emit(TaxiBookingLoadingState(
        state:
            PaymentNotInitializedState(booking: null, methodsAvailable: null)));
    TaxiBooking booking = await TaxiBookingStorage.addDetails(
        TaxiBooking.named(paymentMethod: event.paymentMethod));
    TaxiDriver taxiDriver = await TaxiBookingController.getTaxiDriver(booking);
    emit(TaxiNotConfirmedState(booking: booking, driver: taxiDriver));
    await Future.delayed(Duration(seconds: 1));
    emit(TaxiBookingConfirmedState(booking: booking, driver: taxiDriver));
  }

  Future<void> _taxiBookingCancelled(
      TaxiBookingCancelEvent event, Emitter<TaxiBookingState> emit) async {
    emit(TaxiBookingCancelledState());
    await Future.delayed(Duration(milliseconds: 500));
    List<Taxi> taxis = await TaxiBookingController.getTaxisAvailable();
    emit(TaxiBookingNotSelectedState(taxisAvailable: taxis));
  }

  Future<void> _backPressed(
      BackPressedEvent event, Emitter<TaxiBookingState> emit) async {
    switch (state.runtimeType) {
      case DetailsNotFilledState:
        List<Taxi> taxis = await TaxiBookingController.getTaxisAvailable();
        emit(TaxiBookingNotSelectedState(taxisAvailable: taxis));
        break;
      case PaymentNotInitializedState:
        emit(TaxiNotSelectedState(
            booking: (state as PaymentNotInitializedState).booking));
        break;
      case TaxiNotSelectedState:
        emit(DetailsNotFilledState(
            booking: (state as TaxiNotSelectedState).booking));
        break;
    }
  }
}
