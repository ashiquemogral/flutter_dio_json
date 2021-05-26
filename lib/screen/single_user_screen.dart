import 'package:dio/dio.dart';
import 'package:dio_and_json/http_service.dart';
import 'package:dio_and_json/model/single_user_response.dart';
import 'package:dio_and_json/model/user.dart';
import 'package:flutter/material.dart';

class SingleUserScreen extends StatefulWidget {
  @override
  _SingleUserScreenState createState() => _SingleUserScreenState();
}

class _SingleUserScreenState extends State<SingleUserScreen> {
  HttpService http;

  SingleUserResponse singleUserResponse;
  User user;

  bool isLoading = false;

  Future getUser() async {
    Response response;
    try {
      isLoading = true;
      print("response executing");
      response = await http.getRequest("/api/users/2");
      print("response = ${response}");
      isLoading = false;
      if (response.statusCode == 200) {
        setState(() {
          singleUserResponse = SingleUserResponse.fromJson(response.data);
          user = singleUserResponse.user;
        });
      } else {
        print("OH HOOOOOOO!!!");
      }
    } on Exception catch (e) {
      print(e);
      isLoading = false;
    }
  }

  @override
  void initState() {
    http = HttpService();
    getUser();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Get Single User"),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : user != null
              ? Container(
                  width: double.infinity,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.network(user.avatar),
                      Container(
                        height: 16.0,
                      ),
                      Text("Hello ${user.firstName} ${user.lastName}"),
                    ],
                  ),
                )
              : Center(child: Text("No user Object")),
    );
  }
}
