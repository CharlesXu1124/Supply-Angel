import 'package:flutter/material.dart';
import '../brand_colors.dart';

class FoodDBButton extends StatelessWidget {
  final String title;
  final Color color;
  final Function onPressed;

  FoodDBButton(
      {@required this.title, @required this.color, @required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      shape: new RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(25),
      ),
      color: color,
      textColor: Colors.white,
      child: Container(
        height: 50,
        child: Center(
          child: Text(
            title,
            style: TextStyle(fontSize: 18, fontFamily: 'Brand-Bold'),
          ),
        ),
      ),
      onPressed: onPressed,
    );
  }
}
