import 'package:flutter/material.dart';
import 'package:flutter_app/main.dart';

class MyLoginTab extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
          appBar: AppBar(
            title: Text("Login 界面"),
          ),
          body: Column(
            children: <Widget>[
              RaisedButton(
                child: Text("返回首页"),
                onPressed: (){
                   //跳转到首页,将中间页面直接移除
                   Navigator.pushNamedAndRemoveUntil(context, "home_page", (route) =>  route == null);
                },
              )
            ],
          )
      ),
    );
  }
}