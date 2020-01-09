import 'package:taxi_app/models/payment_method.dart';

class PaymentMethodController {
  static Future<List<PaymentMethod>> getMethods() async {
    return [
      PaymentMethod(
          title: "Cash",
          description: "Default",
          id: "1",
          icon:
              "https://cdn4.iconfinder.com/data/icons/aiga-symbol-signs/612/aiga_cashier_bg-512.png"),
      PaymentMethod(
          title: "Master Card",
          description: "**** **** **** 4863",
          id: "2",
          icon:
              "https://icon-library.net/images/mastercard-icon-png/mastercard-icon-png-28.jpg")
    ];
  }
}
