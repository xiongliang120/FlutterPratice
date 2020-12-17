import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'entity.dart';




class NetworkWidget extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return _NetworkWidget();
  }

}

/**
 * Flutter 自带的网络请求库
 */
class _NetworkWidget extends State<NetworkWidget>{
  var _text;
  var _loading;
  @override
  Widget build(BuildContext context) {
    return Container(
      child: RaisedButton(
        child: Text("原始库发起网络请求"),
        onPressed: () async{
          try {
            //创建一个HttpClient
            HttpClient httpClient = new HttpClient();
            //打开Http连接
            HttpClientRequest request = await httpClient.getUrl(
                Uri.parse("https://www.baidu.com"));
            //使用iPhone的UA
            request.headers.add("user-agent", "Mozilla/5.0 (iPhone; CPU iPhone OS 10_3_1 like Mac OS X) AppleWebKit/603.1.30 (KHTML, like Gecko) Version/10.0 Mobile/14E304 Safari/602.1");
            //等待连接服务器（会将请求信息发送给服务器）
            HttpClientResponse response = await request.close();
            //读取响应内容
            _text = await response.transform(utf8.decoder).join();
            //输出响应头
            print(response.headers);
            print(response.connectionInfo);
            print(response.statusCode);

            //关闭client后，通过该client发起的所有请求都会中止。
            httpClient.close();

          } catch (e) {
            _text = "请求失败：$e";
          } finally {
            setState(() {
              _loading = false;
            });
          }
        },
      ),
    );
  }
}

class DioNetworkWidget extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
     return Container(
        child: RaisedButton(
          child: Text("Dio发起网络请求"),
          onPressed: () async {
            var dio = Dio();
            Response response = await dio.get('https://baidu.com');
            print(response.data);
          },
        ),
     );
  }
}


class JsonWidget extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Container(
      child: RaisedButton(
        child: Text("json 解析"),
        onPressed: (){
           //一个JSON格式的用户列表字符串
           String jsonStr = '''{
            "firstName" : "xiong",
            "lastName" : "liang"
           }''';
          // String jsonStr='[{"name":"Jack"},{"name":"Rose"}]';
           //将JSON字符串转为Dart对象(此处是List)
           // List items=json.decode(jsonStr);
           //输出第一个用户的姓名
           // print(items[0]["name"]);

           Person data1 = Person.fromJson(json.decode(jsonStr));
           print("打印名字="+data1.firstName);
           var person = Person();
           person.firstName = "xiong";
           person.lastName = "xiongliang";
           Map<String,dynamic> map = person.toJson();
           print("打印json="+map.toString());

        },
      ),
    );
  }
}