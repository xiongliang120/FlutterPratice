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
            child: Text("跳转到Search"),
            onPressed: (){ //跳转别的页面,并且传递参数
                // Navigator.push(context, MaterialPageRoute(builder: (context){
                //    return Search("跳转传参");
                // }));

                Navigator.pushNamed(context, "search_page",arguments: {"title":"这个Search 界面的参数"});
            },
          ),
          SizedBox(height: 30,),

          RaisedButton(
            color: Colors.blue,
            child: Text("跳转到Set界面"),
            onPressed: (){ //跳转别的页面,并且传递参数
              // Navigator.push(context, MaterialPageRoute(builder: (context){
              //    return Search("跳转传参");
              // }));

              Navigator.pushNamed(context, "set_page");
            },
          )
        ],
    );
  }
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
    return MaterialApp(
       home: Scaffold(
         body: Column(
           children: <Widget>[
             RaisedButton(
               color: Colors.blue,
               child: Text("跳转到Login界面"),
               onPressed: (){
                 //路由替换, 会将当前路径替换为login_page
                 Navigator.pushReplacementNamed(context, "login_page");
               },
             )
           ],
         )
       ),
    );
  }
}