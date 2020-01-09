import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:taxi_app/bloc/taxi_booking_bloc.dart';
import 'package:taxi_app/bloc/taxi_booking_event.dart';
import 'package:taxi_app/bloc/taxi_booking_state.dart';
import 'package:taxi_app/models/google_location.dart';
import 'package:taxi_app/models/taxi_booking.dart';
import 'package:taxi_app/widgets/rounded_button.dart';

class TaxiBookingDetailsWidget extends StatefulWidget {
  @override
  _TaxiBookingDetailsWidgetState createState() =>
      _TaxiBookingDetailsWidgetState();
}

class _TaxiBookingDetailsWidgetState extends State<TaxiBookingDetailsWidget> {
  GoogleLocation source, destination;
  int noOfPersons;
  DateTime bookingTime;
  @override
  void initState() {
    super.initState();
    TaxiBooking taxiBooking = (BlocProvider.of<TaxiBookingBloc>(context).state
            as DetailsNotFilledState)
        .booking;
    noOfPersons = taxiBooking.noOfPersons;
    bookingTime = taxiBooking.bookingTime;
    source = taxiBooking.source;
    destination = taxiBooking.destination;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          Expanded(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 6.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  SizedBox(
                    height: 20.0,
                  ),
                  Text(
                    "Address",
                    style: Theme.of(context).textTheme.headline,
                  ),
                  SizedBox(
                    height: 24.0,
                  ),
                  buildInputWidget(source?.areaDetails, "hint", () {}),
                  SizedBox(
                    height: 16.0,
                  ),
                  buildInputWidget(destination?.areaDetails,
                      "Enter your destination", () {}),
                  SizedBox(
                    height: 36.0,
                  ),
                  Text(
                    "Seat and Time",
                    style: Theme.of(context).textTheme.headline,
                  ),
                  SizedBox(
                    height: 24.0,
                  ),
                  buildPersonSelector(),
                  SizedBox(
                    height: 24.0,
                  ),
                  buildTimeSelector()
                ],
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
                  text: "See Next",
                  onTap: () {
                    BlocProvider.of<TaxiBookingBloc>(context).add(
                        DetailsSubmittedEvent(
                            bookingTime: bookingTime,
                            destination: destination,
                            source: source,
                            noOfPersons: noOfPersons));
                  },
                ),
              )
            ],
          ),
        ],
      ),
    );
  }

  Widget buildPersonSelector() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text(
          "Need Seat",
          style: Theme.of(context).textTheme.title,
        ),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [1, 2, 3]
              .map((val) => GestureDetector(
                  onTap: () {
                    setState(() {
                      noOfPersons = val;
                    });
                  },
                  child: buildContainer("$val", val == noOfPersons)))
              .toList(),
        )
      ],
    );
  }

  Widget buildTimeSelector() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(
              "Schedule Time",
              style: Theme.of(context).textTheme.title,
            ),
            bookingTime == null
                ? Container()
                : Text(
                    "${bookingTime.day}-${bookingTime.month}-${bookingTime.year}",
                    style: Theme.of(context).textTheme.subtitle,
                  )
          ],
        ),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            buildTimeContainer(
                text: "Now",
                enabled: bookingTime == null,
                onTap: () {
                  setState(() {
                    bookingTime = null;
                  });
                }),
            buildTimeContainer(
                iconData: Icons.timer,
                enabled: bookingTime != null,
                onTap: () async {
                  DateTime time = await showDatePicker(
                    context: context,
                    firstDate: DateTime.now(),
                    lastDate: DateTime(2030),
                    initialDate: DateTime.now()..add(Duration(days: 1)),
                    initialDatePickerMode: DatePickerMode.day,
                  );
                  setState(() {
                    bookingTime = time;
                  });
                })
          ],
        )
      ],
    );
  }

  Widget buildContainer(String val, bool enabled) {
    return Container(
        margin: EdgeInsets.symmetric(horizontal: 6.0),
        padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
        decoration: BoxDecoration(
            color: enabled ? Colors.black : Color(0xffeeeeee),
            borderRadius: BorderRadius.circular(12.0)),
        child: Text(
          "$val",
          style: Theme.of(context).textTheme.headline.copyWith(
              color: enabled ? Colors.white : Colors.black, fontSize: 15.0),
        ));
  }

  Widget buildTimeContainer(
      {String text,
      IconData iconData,
      bool enabled = false,
      Function() onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
          margin: EdgeInsets.symmetric(horizontal: 6.0),
          padding: EdgeInsets.all(12.0),
          decoration: BoxDecoration(
              color: enabled ? Colors.black : Color(0xffeeeeee),
              borderRadius: BorderRadius.circular(12.0)),
          child: text != null
              ? Text(
                  "$text",
                  style: Theme.of(context).textTheme.headline.copyWith(
                      color: enabled ? Colors.white : Colors.black,
                      fontSize: 15.0),
                )
              : Icon(
                  iconData,
                  color: enabled ? Colors.white : Colors.black,
                  size: 18.0,
                )),
    );
  }

  Widget buildInputWidget(String text, String hint, Function() onTap) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 18.0, horizontal: 16.0),
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
