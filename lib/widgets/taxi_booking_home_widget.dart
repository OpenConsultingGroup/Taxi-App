import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:taxi_app/bloc/taxi_booking_bloc.dart';
import 'package:taxi_app/bloc/taxi_booking_state.dart';
import 'package:taxi_app/widgets/loading_shimmer.dart';
import 'package:taxi_app/widgets/taxi_booking_details_widget.dart';
import 'package:taxi_app/widgets/taxi_booking_not_confirmed_widget.dart';
import 'package:taxi_app/widgets/taxi_booking_payments_widget.dart';
import 'package:taxi_app/widgets/taxi_booking_state_widget.dart';
import 'package:taxi_app/widgets/taxi_booking_taxis_widget.dart';

class TaxiBookingHomeWidget extends StatefulWidget {
  @override
  _TaxiBookingHomeWidgetState createState() => _TaxiBookingHomeWidgetState();
}

class _TaxiBookingHomeWidgetState extends State<TaxiBookingHomeWidget>
    with TickerProviderStateMixin<TaxiBookingHomeWidget> {
  AnimationController animationController;
  Animation animation;
  @override
  void initState() {
    super.initState();
    print("Home Build ");
    animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 200));
    animation = CurvedAnimation(
      curve: Curves.easeIn,
      parent: animationController,
    );
    WidgetsBinding.instance.addPostFrameCallback((duration) {
      animationController.forward();
    });
  }

  @override
  Widget build(BuildContext context) {
    double requiredHeight = MediaQuery.of(context).size.height * 2.5 / 3;
    return BlocListener<TaxiBookingBloc, TaxiBookingState>(
      listener: (context, state) async {
        if (state is TaxiBookingCancelledState)
          await animationController.reverse(from: 1.0);
      },
      child: AnimatedBuilder(
          animation: animation,
          builder: (context, child) {
            return Container(
              height: requiredHeight * animation.value,
              child: child,
            );
          },
          child: SingleChildScrollView(
            child: Container(
              height: requiredHeight,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  ClipRRect(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(40.0),
                          topRight: Radius.circular(40.0)),
                      child: TaxiBookingStateWidget()),
                  Expanded(
                    child: Container(
                      color: Colors.black,
                      child: ClipRRect(
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(36.0),
                            topRight: Radius.circular(36.0)),
                        child: Container(
                          color: Colors.white,
                          padding: EdgeInsets.all(16.0),
                          height: MediaQuery.of(context).size.height * 1 / 1.6,
                          margin: EdgeInsets.only(bottom: 24.0),
                          child: BlocBuilder<TaxiBookingBloc, TaxiBookingState>(
                            builder: (context, currentState) {
                              switch (currentState.runtimeType) {
                                case TaxiBookingLoadingState:
                                  return LoadingShimmer();
                                case DetailsNotFilledState:
                                  return TaxiBookingDetailsWidget();
                                case TaxiNotSelectedState:
                                  return TaxiBookingTaxisWidget();
                                case PaymentNotInitializedState:
                                  return TaxiBookingPaymentsWidget();
                                case TaxiNotConfirmedState:
                                  return TaxiBookingNotConfirmedWidget();
                                default:
                                  return Center(
                                    child: Text("Not Initialized"),
                                  );
                              }
                            },
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          )),
    );
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }
}
