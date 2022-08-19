import 'package:flutter/material.dart';

class ButtonWidget extends StatelessWidget {
  final onTap;
  final String title;
  final String icon;
  final Color color;
  final Color textColor;

  const ButtonWidget({Key key, this.onTap, this.title,this.color,this.textColor,this.icon}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: onTap,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 1),
          child: Container(
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(10.0),
                boxShadow: [
                  BoxShadow(
                      color: Colors.grey.withOpacity(0.3), offset: Offset(0, 10), blurRadius: 20)
                ]),
            alignment: Alignment.center,
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 18, horizontal: 18),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                 icon!=null? Image.asset(icon,width: 30,height: 30,):Container(),
                  SizedBox(width: 10,),
                  Text(
                    title,
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: textColor),
                  ),
                ],
              )
            ),
          ),
        ));
  }
}
