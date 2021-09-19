import 'dart:async';
import 'package:flutter/material.dart';
import 'package:sendbird_sdk/sendbird_sdk.dart';
import 'package:uuid/uuid.dart';


class LoginView extends StatefulWidget {
  @override
  LoginViewState createState() => LoginViewState();
}

class LoginViewState extends State<LoginView> {
  final _appIdController =
      TextEditingController(text: "");
  final _userIdController = TextEditingController();
  bool _enableSignInButton = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: body(context),
    );
  }

  Widget navigationBar() {
    return AppBar(
      toolbarHeight: 65,
      elevation: 0,
      backgroundColor: Colors.white,
      automaticallyImplyLeading: true,
      title: Text('Chat demo sendbird', style: TextStyle(color: Colors.black)),
      actions: [],
      centerTitle: true,
    );
  }

  Widget body(BuildContext context) {
    return Container(
        padding: EdgeInsets.only(left: 20, right: 20, top: 100),
        child: Column(
          children: [
            const SizedBox(height: 20),
            Text('Chat demo sendbird',
                style: Theme.of(context).textTheme.headline6),
            const SizedBox(height: 40),
            TextField(
              controller: _appIdController,
              onChanged: (value) {
                setState(() {
                  _enableSignInButton = _shouldEnableSignInButton();
                });
              },
              decoration: InputDecoration(
                  border: InputBorder.none,
                  labelText: 'App Id',
                  filled: true,
                  fillColor: Colors.grey[200],
                  suffixIcon: IconButton(
                    onPressed: () {
                      _appIdController.clear();
                    },
                    icon: Icon(Icons.clear),
                  )),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _userIdController,
              onChanged: (value) {
                setState(() {
                  _enableSignInButton = _shouldEnableSignInButton();
                });
              },
              decoration: InputDecoration(
                  border: InputBorder.none,
                  labelText: 'Your nickname',
                  filled: true,
                  fillColor: Colors.grey[200],
                  suffixIcon: IconButton(
                    onPressed: () {
                      _userIdController.clear();
                    },
                    icon: Icon(Icons.clear),
                  )),
            ),
            const SizedBox(height: 30),
            FractionallySizedBox(
              widthFactor: 1,
              child: _signInButton(context, _enableSignInButton),
            )
          ],
        ));
  }

  bool _shouldEnableSignInButton() {
    if (_appIdController.text.isEmpty) {
      return false;
    }
    if (_userIdController.text.isEmpty) {
      return false;
    }
    return true;
  }

  Widget _signInButton(BuildContext context, bool enabled) {
    if (enabled == false) {
      // Disable the sign in button if required data not entered
      return TextButton(
        style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all<Color>(Colors.grey),
            foregroundColor:
                MaterialStateProperty.all<Color>(Colors.grey.shade300)),
        onPressed: () {},
        child: Text(
          "Sign In",
          style: TextStyle(fontSize: 20.0),
        ),
      );
    }
    return TextButton(
      style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all<Color>(Color(0xff742DDD)),
          foregroundColor: MaterialStateProperty.all<Color>(Colors.white)),
      onPressed: () {
        // Login with Sendbird
        connect(_appIdController.text, _userIdController.text).then((user) {
          Navigator.pushNamed(context, '/channel_list');
        }).catchError((error) {
          print('login_view: _signInButton: ERROR: $error');
        });
      },
      child: Text(
        "Sign In",
        style: TextStyle(fontSize: 20.0),
      ),
    );
  }

  Future<User> connect(String appId, String userId) async {
    // Init Sendbird SDK and connect with current user id
    try {
      final sendbird =
          SendbirdSdk(appId: appId);
      final user = await sendbird.connect(
      Uuid().v4(), nickname: userId);
      return user;
    } catch (e) {
      print('login_view: connect: ERROR: $e');
      throw e;
    }
  }
}
