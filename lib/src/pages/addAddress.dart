import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../generated/l10n.dart';
import '../controllers/delivery_addresses_controller.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:google_map_location_picker/google_map_location_picker.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import '../repository/settings_repository.dart';
import '../helpers/app_config.dart' as config;

class AddAddress extends StatefulWidget {
  AddAddress({Key key}) : super(key: key);

  @override
  _AddAddressWidgetState createState() => _AddAddressWidgetState();
}

class _AddAddressWidgetState extends StateMVC<AddAddress> {
  DeliveryAddressesController _con;

  _AddAddressWidgetState() : super(DeliveryAddressesController()) {
    _con = controller;
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      key: _con.scaffoldKey,
      resizeToAvoidBottomInset: false,
      body: Stack(
        alignment: AlignmentDirectional.topCenter,
        children: <Widget>[
          Positioned(
            top: 0,
            child: Container(
              width: config.App(context).appWidth(100),
              height: config.App(context).appHeight(29.5),
              decoration: BoxDecoration(color: Theme.of(context).accentColor),
            ),
          ),
          Positioned(
            top: 50,
            right: 50,
            child: Container(
              child: IconButton(
                  icon: new Icon(Icons.arrow_back, color: Theme.of(context).primaryColor),
                  onPressed: () {
                    Navigator.of(context).pop();

                  }),
            ),
          ),
          Positioned(
            top: config.App(context).appHeight(29.5) - 120,
            child: Container(
              width: config.App(context).appWidth(84),
              height: config.App(context).appHeight(29.5),
              child: Text(
                S.of(context).add_New_address,
                style: Theme.of(context)
                    .textTheme
                    .headline2
                    .merge(TextStyle(color: Theme.of(context).primaryColor)),
              ),
            ),
          ),
          Positioned(
            top: config.App(context).appHeight(29.5) - 50,
            child: Container(
              decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  boxShadow: [
                    BoxShadow(
                      blurRadius: 50,
                      color: Theme.of(context).hintColor.withOpacity(0.2),
                    )
                  ]),
              margin: EdgeInsets.symmetric(
                horizontal: 20,
              ),
              padding: EdgeInsets.symmetric(vertical: 50, horizontal: 27),
              width: config.App(context).appWidth(88),
              child: Form(
                key: _con.addressFormKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    TextFormField(
                      keyboardType: TextInputType.text,
                      onSaved: (input) => _con.address.address = input.trim(),
                      maxLength: 30,
                      validator: MultiValidator([
                        RequiredValidator(errorText: "Please enter Address"),
                        MaxLengthValidator(30,
                            errorText:
                               'should be more than 30 letters'),
                      ]),
                      decoration: InputDecoration(
                        labelText: S.of(context).address,
                        labelStyle:
                            TextStyle(color: Theme.of(context).accentColor),
                        contentPadding: EdgeInsets.all(12),
                        hintText: S.of(context).address_ex,
                        hintStyle: TextStyle(
                            color:
                                Theme.of(context).focusColor.withOpacity(0.7)),
                        prefixIcon: Icon(Icons.home,
                            color: Theme.of(context).accentColor),
                        border: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Theme.of(context)
                                    .focusColor
                                    .withOpacity(0.2))),
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Theme.of(context)
                                    .focusColor
                                    .withOpacity(0.5))),
                        enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Theme.of(context)
                                    .focusColor
                                    .withOpacity(0.2))),
                      ),
                    ),
                    TextFormField(
                      keyboardType: TextInputType.text,
                      onSaved: (input) =>
                          _con.address.description = input.trim(),
                      maxLength: 60,
                      decoration: InputDecoration(
                        labelText: S.of(context).description,
                        labelStyle:
                            TextStyle(color: Theme.of(context).accentColor),
                        contentPadding: EdgeInsets.all(12),
                        hintText: "جنب الجامع الازراق",
                        hintStyle: TextStyle(
                            color:
                                Theme.of(context).focusColor.withOpacity(0.7)),
                        prefixIcon: Icon(Icons.description,
                            color: Theme.of(context).accentColor),
                        border: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Theme.of(context)
                                    .focusColor
                                    .withOpacity(0.2))),
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Theme.of(context)
                                    .focusColor
                                    .withOpacity(0.5))),
                        enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Theme.of(context)
                                    .focusColor
                                    .withOpacity(0.2))),
                      ),
                    ),

                    SizedBox(
                      width: (size.width * .4),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary: Theme.of(context).accentColor,
                          textStyle:
                              TextStyle(color: Theme.of(context).primaryColor),
                          shape: RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(30.0),
                          ),
                        ),
                        child: Padding(
                          padding: EdgeInsets.only(
                              right: 4, left: 4, top: 8, bottom: 8),
                          child: Text(
                              S.of(context).detect_location,
                            style: TextStyle(fontSize: 16, color: Colors.white),
                          ),
                        ),
                        onPressed: () async {
                          LocationResult result = await showLocationPicker(
                            context,
                            setting.value.googleMapsKey,
                            initialCenter: LatLng(
                                deliveryAddress.value?.latitude ?? 0,
                                deliveryAddress.value?.longitude ?? 0),
                            requiredGPS: false,
                            myLocationButtonEnabled: true,
                            //resultCardAlignment: Alignment.bottomCenter,
                          );
                          _con.address.latitude = result.latLng.latitude;
                          _con.address.longitude = result.latLng.longitude;
                          print("result = $result");
                          if(result.latLng.latitude!=null &&result.latLng.longitude!=null){
                            ScaffoldMessenger.of(_con.scaffoldKey?.currentContext).showSnackBar(SnackBar(
                              content: Text(S.of(context).address_selected_successfully),
                            ));
                        }else   ScaffoldMessenger.of(_con.scaffoldKey?.currentContext).showSnackBar(SnackBar(
                            content: Text(S.of(context).address_selected_error),
                          ));
                          },
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    _con.address.longitude!=null &&_con.address.latitude!=null
                    ?Text(S.of(context).address_selected_successfully,style: TextStyle(color: Colors.green,fontSize: 20),)
                    :SizedBox(),
                    SizedBox(
                      height: 10,
                    ),
                    // Row(
                    //   children: [
                    //     Checkbox(
                    //       value: _con.isDefault,
                    //       onChanged: (value) => _con.defaultAddress(),
                    //       activeColor: Theme.of(context).accentColor,
                    //     ),
                    //     Text(S.of(context).default_,
                    //         style: TextStyle(
                    //           fontSize: 16,
                    //         )),
                    //   ],
                    // ),
                    SizedBox(height: 20),
                    SizedBox(
                      width: size.width,
                      height: size.height * 0.07,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            primary: Theme.of(context).accentColor,
                            shape: StadiumBorder(),
                            textStyle: TextStyle(
                                color: Theme.of(context).primaryColor)),
                        child: Padding(
                          padding: EdgeInsets.only(
                              right: 4, left: 4, top: 8, bottom: 8),
                          child: Text(
                            S.of(context).save,
                            style: TextStyle(
                                fontSize: 17,
                                color: Theme.of(context).primaryColor),
                          ),
                        ),
                        onPressed: () {
                          if (_con.address.latitude == null &&
                              _con.address.longitude == null) {
                            _con.scaffoldKey?.currentState
                                ?.showSnackBar(SnackBar(
                              content: Text(
                                  'There was an error your location was not specified'),
                            ));
                          } else {
                            _con.addNewAddress();
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
