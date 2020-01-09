import 'package:taxi_app/models/taxi_booking.dart';

class TaxiBookingStorage {
  static TaxiBooking _taxiBooking;

  static Future<void> open() async {
    _taxiBooking = TaxiBooking.named();
  }

  static Future<TaxiBooking> addDetails(TaxiBooking taxiBooking) async {
    _taxiBooking = _taxiBooking.copyWith(taxiBooking);
    return _taxiBooking;
  }

  static Future<TaxiBooking> getTaxiBooking() async {
    return _taxiBooking;
  }
}
