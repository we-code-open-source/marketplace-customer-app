import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class DataEmpty extends StatelessWidget {
  final String title;
  final String description;
  final String image;

  DataEmpty({
    this.title = "لا يوجد محتوى هنا",
    this.description = "أنشئ محتوى جديدًا لمشاهدته في هذه الصفحة",
    this.image ,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.only(top: 100,),
        child: Column(
         crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(100),
              ),
              child: image!=null? SvgPicture.asset(image ,):Icon(
                Icons.list_alt_outlined,
                size: 62,
                color: Theme.of(context).primaryColor,
              ),
            ),
            SizedBox(height: 35),
            Text(
              title,
              style:TextStyle(fontSize: 30,
              fontWeight: FontWeight.w500,
            ),
            ),
            SizedBox(height:15),
            Text(
              description,
              maxLines: 2,
              style:TextStyle(fontSize: 20,
              fontWeight: FontWeight.w400,
            ),
            ),
          ],
        ),
      ),
    );
  }
}
