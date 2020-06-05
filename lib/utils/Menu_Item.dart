import 'package:flutter/material.dart';

class MenuItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final Function onTap;

  const MenuItem({this.icon, this.title, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Row(
          children: <Widget>[
            Icon(
              icon,
              color: Colors.white,
              size: 30
            ),
            SizedBox(
              width: 20,
            ),
            Text(
              title,
              style: TextStyle(
                decoration: TextDecoration.none,
                fontWeight: FontWeight.w300, fontSize: 20, color: Colors.white
              ),
            )
          ],
        ),
      ),
    );
  }
}