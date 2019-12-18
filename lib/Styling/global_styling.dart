import 'package:flutter/material.dart';
Color greyColor = new Color(0xFF212121);
Color redColor = new Color(0xffef5350);
Color lightBlue = new Color(0xF88787A0);

TextStyle lobbyText = TextStyle(
    fontFamily: 'Sans',
    fontWeight: FontWeight.bold,
    color: greyColor,
    fontSize: 35);

TextStyle myTasksHeading = TextStyle(
    fontFamily: 'Sans',
    fontWeight: FontWeight.bold,
    color: greyColor,
    fontSize: 22);

TextStyle redTodoTitle = TextStyle(
    fontFamily: 'Sans',
    fontWeight: FontWeight.bold,
    color: redColor,
    fontSize: 22);

TextStyle redTerms = TextStyle(
    fontFamily: 'Sans',
    fontWeight: FontWeight.w100,
    color: redColor,
    fontSize: 20);

TextStyle welcome = TextStyle(
    fontFamily: 'Sans',
    fontWeight: FontWeight.bold,
    color: lightBlue,
    fontSize: 35);



// FloatingActionButton myButtons = FloatingActionButton(
//   backgroundColor: redColor,
//   //elevation: 5,
//   child: Text('LogOut'),
//   shape: RoundedRectangleBorder(borderRadius: new BorderRadius.circular(18.0)),
//   onPressed: () {
//     logOut();
//   },
// );
//  logOut() async{ 
//       SharedPreferences prefs= await SharedPreferences.getInstance();
//       prefs.setString('api token', "");
//   }
