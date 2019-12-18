import 'dart:async';
import 'package:http/http.dart' show Client;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:todo_app/Models/Classes/registerUser.dart';

//here we get the Api built with flask for registering a new user

class RegisterApi{
  Client client = Client();
   final _apiKey = 'http://10.0.2.2:5000/api/register';
  Future<User> registerUser(
    String username, String firstname, String lastname, 
    String email,String password) async{
    print('you are in ');
    final response = await client
    .post(_apiKey, 
     body: jsonEncode({  	
            "username":username,
            "first_name": firstname,
            "last_name":lastname,
            "email":email,
            "password":password
          }
      )
    );
    print(response.body.toString());
    final Map result = json.decode(response.body);
    if (response.statusCode == 201){
      saveApiKey(result['data']['api_key'] );
      return User.fromJson(json.decode(response.body));
    }else{
      throw Exception('failed to register');
    }
  }
 saveApiKey(String apiKey) async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('API_Token', apiKey);
  }

Future signInUser(
    String username, String password) async{
    print('you are in ');
    final response = await client
    .post('http://10.0.2.2:5000/api/SignIn&username', 
     body: jsonEncode({  	
            "username":username,
            "password":password
          }
      )
    );
    print(response.body.toString());
    final Map result = json.decode(response.body);
    if (response.statusCode == 201){
      saveApiKey(result['data']['api_key'] );
    }else{
      throw Exception('failed to register');
    }
  }

}