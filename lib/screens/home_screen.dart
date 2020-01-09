import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:taxi_app/bloc/taxi_booking_bloc.dart';
import 'package:taxi_app/bloc/taxi_booking_event.dart';
import 'package:taxi_app/bloc/taxi_booking_state.dart';
import 'package:taxi_app/widgets/destination_selection_widget.dart';
import 'package:taxi_app/widgets/home_app_bar.dart';
import 'package:taxi_app/widgets/home_drawer.dart';
import 'package:taxi_app/widgets/taxi_booking_confirmed_widget.dart';
import 'package:taxi_app/widgets/taxi_booking_home_widget.dart';
import 'package:taxi_app/widgets/taxi_map.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light
        .copyWith(statusBarColor: Colors.transparent));
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        BlocProvider.of<TaxiBookingBloc>(context).add(BackPressedEvent());
        return false;
      },
      child: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.dark,
        child: Scaffold(
          endDrawer: HomeDrawer(),
          body: Stack(
            children: <Widget>[TaxiMap(), HomeAppBar()],
          ),
          bottomSheet: BlocBuilder<TaxiBookingBloc, TaxiBookingState>(
              builder: (BuildContext context, TaxiBookingState state) {
            if (state is TaxiBookingNotInitializedState) {
              return Container();
            }
            if (state is TaxiBookingNotSelectedState) {
              return DestinationSelctionWidget();
            }
            if (state is TaxiBookingConfirmedState) {
              return TaxiBookingConfirmedWidget();
            }
            return TaxiBookingHomeWidget();
          }),
        ),
      ),
    );
  }
}
