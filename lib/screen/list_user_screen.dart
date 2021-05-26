import 'package:dio/dio.dart';
import 'package:dio_and_json/http_service.dart';
import 'package:dio_and_json/model/list_user_response.dart';
import 'package:dio_and_json/model/user.dart';
import 'package:flutter/material.dart';

class ListUserScreen extends StatefulWidget {
  @override
  _ListUserScreenState createState() => _ListUserScreenState();
}

class _ListUserScreenState extends State<ListUserScreen> {
  bool isLoading = false;

  HttpService http;

  ListUserResponse listUserResponse;

  List<User> users;

  Future getListUser() async {
    Response response;
    try {
      isLoading = true;
      print("response executing");
      response = await http.getRequest("/api/users?page=2");
      print("response = ${response}");
      isLoading = false;
      if (response.statusCode == 200) {
        setState(() {
          listUserResponse = ListUserResponse.fromJson(response.data);
          users = listUserResponse.users;
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

    getListUser();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Get Multi User"),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : users != null
              ? ListView.builder(
                  itemBuilder: (context, index) {
                    final user = users[index];
                    return ListTile(
                      title: Text(user.firstName),
                      leading: Image.network(user.avatar),
                      subtitle: Text(user.email),
                    );
                  },
                  itemCount: users.length,
                )
              : Center(child: Text("No user object")),
    );
  }
}
