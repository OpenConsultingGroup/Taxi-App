import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:taxi_app/bloc/taxi_booking_bloc.dart';
import 'package:taxi_app/bloc/taxi_booking_event.dart';
import 'package:taxi_app/bloc/taxi_booking_state.dart';
import 'package:taxi_app/controllers/location_controller.dart';
import 'package:taxi_app/models/google_location.dart';
import 'package:taxi_app/models/taxi.dart';
import 'package:taxi_app/models/taxi_booking.dart';
import 'dart:ui' as ui;

class TaxiMap extends StatefulWidget {
  @override
  _TaxiMapState createState() => _TaxiMapState();
}

class _TaxiMapState extends State<TaxiMap> {
  GoogleMapController controller;
  Set<Marker> markers = Set<Marker>();
  Set<Polyline> polylines = Set<Polyline>();
  Set<Circle> circles = Set<Circle>();
  GoogleLocation currentLocation;

  @override
  void initState() {
    super.initState();
  }

  void clearData() {
    markers.clear();
    polylines.clear();
    circles.clear();
  }

  Circle createCircle(Color color, LatLng position) {
    return Circle(
        circleId: CircleId(position.toString()),
        fillColor: color,
        strokeColor: color.withOpacity(0.4),
        center: position,
        strokeWidth: 75,
        radius: 32.0,
        visible: true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<TaxiBookingBloc, TaxiBookingState>(
        listener: (context, state) {
          if (state is TaxiBookingNotSelectedState) {
            List<Taxi> taxis = state.taxisAvailable;
            clearData();
            addTaxis(taxis);
          }
          if (state is TaxiBookingConfirmedState) {
            clearData();

            TaxiBooking booking = (state).booking;
            addPolylines(booking.source.position, booking.destination.position);
          }
          if (state is TaxiNotConfirmedState) {
            clearData();

            TaxiBooking booking = (state).booking;
            addPolylines(booking.source.position, booking.destination.position);
          }
        },
        child: GoogleMap(
          initialCameraPosition:
              CameraPosition(target: LatLng(17.0, 24.0), zoom: 8.0),
          onMapCreated: (controller) async {
            this.controller = controller;
            BlocProvider.of<TaxiBookingBloc>(context)
                .add(TaxiBookingStartEvent());
            currentLocation = await LocationController.getCurrentLocation();
            controller.animateCamera(
                CameraUpdate.newLatLngZoom(currentLocation.position, 12));
            BlocProvider.of<TaxiBookingBloc>(context)
                .add(TaxiBookingStartEvent());
          },
          myLocationButtonEnabled: false,
          markers: markers,
          polylines: polylines,
          circles: circles,
        ),
      ),
    );
  }

  Future addTaxis(List<Taxi> taxis) async {
    GoogleLocation currentPositon =
        await LocationController.getCurrentLocation();
    circles.add(createCircle(Colors.blueAccent, currentPositon.position));
    if (this.controller == null) {
      return;
    }
    controller.moveCamera(CameraUpdate.newLatLng(currentPositon.position));
    markers.clear();
    await Future.wait(taxis.map((taxi) async {
      final Uint8List markerIcon =
          await getBytesFromAsset("images/taxi_marker.png", 100);
      BitmapDescriptor descriptor = BitmapDescriptor.fromBytes(markerIcon);
      print('Taxi ${taxi.id}');
      markers.add(Marker(
        markerId: MarkerId("${taxi.id}"),
        position: LatLng(taxi.position.latitude, taxi.position.longitude),
        infoWindow: InfoWindow(
          title: taxi.title,
        ),
        icon: descriptor,
      ));
    }));
    setState(() {});
  }

  Future<Marker> createMarker(
      Color color, LatLng position, String title) async {
    final Uint8List markerIcon =
        await getBytesFromAsset("images/location.png", 100);
    BitmapDescriptor descriptor = BitmapDescriptor.fromBytes(markerIcon);
    return Marker(
      markerId: MarkerId("${position.toString()}"),
      position: position,
      infoWindow: InfoWindow(
        title: title,
      ),
      icon: descriptor,
    );
  }

  Future<void> addPolylines(LatLng start, LatLng end) async {
    List<LatLng> result = await LocationController.getPolylines(start, end);

    setState(() {});
    Marker startM = await createMarker(Colors.black, start, "Start");
    Marker endM = await createMarker(Colors.black, end, "End");
    markers.add(startM);
    markers.add(endM);
    for (int i = 1; i < result.length; i++) {
      polylines.add(
        Polyline(
            polylineId: PolylineId("${result[i].toString()}"),
            color: Colors.black,
            points: [result[i - 1], result[i]],
            width: 3,
            visible: true,
            startCap: Cap.roundCap,
            jointType: JointType.mitered,
            endCap: Cap.roundCap,
            geodesic: true,
            patterns: [PatternItem.dash(12)],
            zIndex: 1),
      );
    }
    result.forEach((val) {});

    setState(() {});
    controller.animateCamera(CameraUpdate.newLatLngZoom(result[0], 14));
  }

  Future<Uint8List> getBytesFromAsset(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
        targetWidth: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))
        .buffer
        .asUint8List();
  }
}
