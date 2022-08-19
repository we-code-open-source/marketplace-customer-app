import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../helpers/helper.dart';
import '../repository/settings_repository.dart' as sett;

class ChooseScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: ()=>Helper.of(context).onWillPop(),
    child: Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Theme.of(context).accentColor,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'سابق',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Center(
      child:Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children:[
          InkWell(
            onTap: () {
              sett.isRestaurant.value = 0;
              Navigator.of(context)
                  .pushNamed('/Pages', arguments: 1);
            },
            child: Image.asset('assets/img/shopping.png',width: 200,height: 200),

          ),
          InkWell(
              onTap: () {
                sett.isRestaurant.value = 1;
                Navigator.of(context)
                    .pushNamed('/Pages', arguments: 1);
              },
              child: Image.asset('assets/img/fast-food.png',width: 200,height: 200,),
               ),
        ],
      ),
    )
    )
    );
  }
}
