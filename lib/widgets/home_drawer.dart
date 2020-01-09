import 'package:flutter/material.dart';
import 'package:taxi_app/controllers/user_controller.dart';
import 'package:taxi_app/models/user.dart';

class HomeDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    User user = UserController.getUser();
    return Drawer(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Container(
            color: Colors.black,
            padding: EdgeInsets.fromLTRB(16, 8, 16, 24),
            child: SafeArea(
              bottom: false,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Container(
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.white, width: 2.0),
                        borderRadius: BorderRadius.circular(12.0)),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12.0),
                      child: Image.network(
                        user.photoUrl,
                        width: 42,
                        height: 42,
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 12.0,
                  ),
                  Expanded(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        Text(
                          user.name ?? "",
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.w600),
                        ),
                        SizedBox(
                          height: 4.0,
                        ),
                        Text(
                          user.mobileNumber ?? "",
                          style: TextStyle(
                              color: Colors.white60,
                              fontSize: 12.0,
                              fontWeight: FontWeight.w600),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
          buildAction("My Rides", Icons.history, () {}),
          buildAction("Promotions", Icons.card_membership, () {}),
          buildAction("My Favourites", Icons.star_border, () {}),
          buildAction("My payment", Icons.payment, () {}),
          buildAction("Notification", Icons.notifications_none, () {}),
          buildAction("Support", Icons.chat_bubble_outline, () {}),
        ],
      ),
    );
  }

  Widget buildAction(String title, IconData iconData, Function onPressed) {
    return ListTile(
      onTap: onPressed,
      title: Text(
        title,
        style: TextStyle(color: Colors.black45),
      ),
      leading: Icon(
        iconData,
        color: Colors.black,
      ),
    );
  }
}
