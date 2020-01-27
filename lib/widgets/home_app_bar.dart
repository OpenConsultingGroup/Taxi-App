import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:taxi_app/bloc/taxi_booking_bloc.dart';
import 'package:taxi_app/bloc/taxi_booking_state.dart';
import 'package:taxi_app/controllers/user_controller.dart';
import 'package:taxi_app/models/user.dart';
import 'package:taxi_app/widgets/ease_in_widget.dart';

class HomeAppBar extends StatefulWidget with PreferredSizeWidget {
  @override
  _HomeAppBarState createState() => _HomeAppBarState();

  @override
  Size get preferredSize => Size.fromHeight(64);
}

class _HomeAppBarState extends State<HomeAppBar> with TickerProviderStateMixin {
  AnimationController controller;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      vsync: this,
      duration: Duration(
        milliseconds: 500,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    User user = UserController.getUser();
    return BlocListener<TaxiBookingBloc, TaxiBookingState>(
      listener: (context, state) {
        if (state is TaxiBookingNotSelectedState) {
          controller.forward(
            from: 0,
          );
        } else {
          if (controller.value == 1) controller.reverse(from: 1.0);
        }
      },
      child: AnimatedBuilder(
          animation: controller,
          child: Container(
            padding: EdgeInsets.all(16.0),
            decoration: BoxDecoration(color: Colors.white, boxShadow: [
              BoxShadow(
                  color: Colors.black12.withOpacity(0.1),
                  blurRadius: 25.0,
                  spreadRadius: 0.2),
            ]),
            child: SafeArea(
              bottom: false,
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Text("Hey ${user.name.split(" ")[0]}",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 18.0,
                              fontWeight: FontWeight.w700,
                            )),
                        SizedBox(
                          height: 6.0,
                        ),
                        Text(
                          "Grab your new ride now",
                          style: TextStyle(
                              color: Colors.black54,
                              fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                  ),
                  EaseInWidget(
                    onTap: () {
                      Scaffold.of(context).openEndDrawer();
                    },
                    child: Container(
                      child: Icon(Icons.menu),
                      padding: EdgeInsets.all(12.0),
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                                color: Colors.black12.withOpacity(0.05),
                                blurRadius: 25.0,
                                spreadRadius: 0.2)
                          ],
                          color: Colors.white),
                    ),
                  )
                ],
              ),
            ),
          ),
          builder: (context, child) {
            return FadeTransition(
              opacity: Tween<double>(begin: 0, end: 1).animate(controller),
              child: SlideTransition(
                position: Tween<Offset>(begin: Offset(0, -1), end: Offset(0, 0))
                    .animate(controller),
                child: child,
              ),
            );
          }),
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}
