import 'package:flutter/material.dart';
import 'Search.dart';

class MyHomeTab extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Column(
        children: <Widget>[
          Text("home"),
          SizedBox(height: 30,),
          RaisedButton(
            color: Colors.blue,
            child: Text("button"),
            onPressed: (){ //跳转别的页面,并且传递参数
                // Navigator.push(context, MaterialPageRoute(builder: (context){
                //    return Search("跳转传参");
                // }));

                Navigator.pushNamed(context, "search_page");
            },
          )
        ],
    );
  }
}


void routeMethod1(){

}

class MyCateTab extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Text("Cate");
  }
}

class MySetTab extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Text("Set");
  }
}