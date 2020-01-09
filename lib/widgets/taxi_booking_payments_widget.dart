import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:taxi_app/bloc/taxi_booking_bloc.dart';
import 'package:taxi_app/bloc/taxi_booking_event.dart';
import 'package:taxi_app/bloc/taxi_booking_state.dart';
import 'package:taxi_app/models/payment_method.dart';
import 'package:taxi_app/widgets/rounded_button.dart';

class TaxiBookingPaymentsWidget extends StatefulWidget {
  @override
  _TaxiBookingPaymentsWidgetState createState() =>
      _TaxiBookingPaymentsWidgetState();
}

class _TaxiBookingPaymentsWidgetState extends State<TaxiBookingPaymentsWidget> {
  List<PaymentMethod> methods = [];
  PaymentMethod selectedMethod;

  @override
  void initState() {
    super.initState();
    methods = (BlocProvider.of<TaxiBookingBloc>(context).state
            as PaymentNotInitializedState)
        .methodsAvaiable;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Text(
                      "Select Payment",
                      style: Theme.of(context).textTheme.headline,
                    ),
                    ListView.separated(
                      itemBuilder: (context, index) {
                        return buildPaymentMethod(methods[index]);
                      },
                      padding: EdgeInsets.symmetric(vertical: 24.0),
                      separatorBuilder: (context, index) => Container(
                        height: 18.0,
                      ),
                      physics: ClampingScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: methods.length,
                    ),
                    Text(
                      "Promo Code",
                      style: Theme.of(context).textTheme.headline,
                    ),
                    SizedBox(
                      height: 18.0,
                    ),
                    buildInputWidget(null, "Add promo code", () {})
                  ],
                ),
              ),
            ),
          ),
          Row(
            children: <Widget>[
              RoundedButton(
                onTap: () {
                  BlocProvider.of<TaxiBookingBloc>(context)
                      .add(BackPressedEvent());
                },
                iconData: Icons.keyboard_backspace,
              ),
              SizedBox(
                width: 18.0,
              ),
              Expanded(
                flex: 2,
                child: RoundedButton(
                  text: "Confirm Payment",
                  onTap: () {
                    BlocProvider.of<TaxiBookingBloc>(context)
                        .add(PaymentMadeEvent(paymentMethod: selectedMethod));
                  },
                ),
              )
            ],
          ),
        ],
      ),
    );
  }

  Widget buildPaymentMethod(PaymentMethod method) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedMethod = method;
        });
      },
      child: Container(
        padding: EdgeInsets.all(12.0),
        decoration: BoxDecoration(
            color: Color(0xffeeeeee).withOpacity(0.5),
            borderRadius: BorderRadius.circular(12.0)),
        child: Row(
          children: <Widget>[
            ClipRRect(
              borderRadius: BorderRadius.circular(16.0),
              child: Image.network(
                method.icon,
                width: 56.0,
                height: 56.0,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(
              width: 16.0,
            ),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Text(
                    "${method.title}",
                    style: Theme.of(context).textTheme.title,
                  ),
                  SizedBox(
                    height: 4.0,
                  ),
                  Text(
                    "${method.description}",
                    style: Theme.of(context).textTheme.subtitle,
                  ),
                ],
              ),
            ),
            selectedMethod == method
                ? Icon(
                    Icons.check_circle,
                    size: 28.0,
                  )
                : Container(
                    width: 0,
                    height: 0,
                  )
          ],
        ),
      ),
    );
  }

  Widget buildInputWidget(String text, String hint, Function() onTap) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 24.0, horizontal: 16.0),
      decoration: BoxDecoration(
        color: Color(0xffeeeeee).withOpacity(0.5),
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Text(
        text ?? hint,
        style: Theme.of(context)
            .textTheme
            .title
            .copyWith(color: text == null ? Colors.black45 : Colors.black),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}
