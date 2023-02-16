import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:taxi_app/bloc/taxi_booking_bloc.dart';
import 'package:taxi_app/screens/home_screen.dart';

void main() => runApp(MultiBlocProvider(providers: [
      BlocProvider<TaxiBookingBloc>(
        create: (context) => TaxiBookingBloc(),
      )
    ], child: MyApp()));

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Taxi',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          primarySwatch: Colors.blue,
          primaryColor: Colors.black,
          fontFamily: 'Ubuntu',
          textTheme: TextTheme(
              titleMedium: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w600),
              titleSmall: TextStyle(color: Colors.black54),
              headlineSmall:
                  TextStyle(color: Colors.black54, fontWeight: FontWeight.w800),
              headlineMedium:
                  TextStyle(fontSize: 18.0, fontWeight: FontWeight.w800))),
      home: HomeScreen(),
    );
  }
}
