import 'package:flutter/material.dart';

class Search extends StatelessWidget {
  var title;
  Map arguments;
  Search({String title, Map arguments}) {
    print("1111");
    this.title = title;
    this.arguments = arguments;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("${title}"),
        leading: Icon(Icons.person),
      ),
      body: Column(
        children: <Widget>[
          Text("${arguments["title"]}"),
          SizedBox(height: 50),
          RaisedButton(
            child: Text("返回"),
            onPressed: () {
              //返回上一页
              Navigator.of(context).pop();
            },
          )
        ],
      ),
    );
  }
}
