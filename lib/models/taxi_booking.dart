import 'package:taxi_app/models/payment_method.dart';

import 'google_location.dart';
import 'taxi_type.dart';

class TaxiBooking {
  final String id;
  final GoogleLocation source;
  final GoogleLocation destination;
  final int noOfPersons;
  final DateTime bookingTime;
  final TaxiType taxiType;
  final double estimatedPrice;
  final PaymentMethod paymentMethod;
  final String promoApplied;

  TaxiBooking(
      this.id,
      this.source,
      this.destination,
      this.noOfPersons,
      this.bookingTime,
      this.taxiType,
      this.estimatedPrice,
      this.paymentMethod,
      this.promoApplied);

  TaxiBooking.named({
    this.id,
    this.source,
    this.destination,
    this.noOfPersons,
    this.bookingTime,
    this.taxiType,
    this.estimatedPrice,
    this.paymentMethod,
    this.promoApplied,
  });

  TaxiBooking copyWith(TaxiBooking booking) {
    return TaxiBooking.named(
        id: booking.id ?? id,
        source: booking.source ?? source,
        destination: booking.destination ?? destination,
        noOfPersons: booking.noOfPersons ?? noOfPersons,
        bookingTime: booking.bookingTime ?? bookingTime,
        paymentMethod: booking.paymentMethod ?? paymentMethod,
        promoApplied: booking.promoApplied ?? promoApplied,
        estimatedPrice: booking.estimatedPrice ?? estimatedPrice,
        taxiType: booking.taxiType ?? taxiType);
  }
}
