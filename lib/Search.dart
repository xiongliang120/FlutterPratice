import 'package:flutter/material.dart';

class Search extends StatelessWidget{
  var title;
  Search(String title){
    this.title = title;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar( title:Text("${title}")),
      body: Column(
        children: <Widget>[
          Text("${title}"),
          SizedBox(height: 50),
          RaisedButton(
            child: Text("返回"),
            onPressed: (){
              Navigator.of(context).pop();
            },
          )
        ],
      ),

      );
  }
}