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
      body:Text("${title}"));
  }
}