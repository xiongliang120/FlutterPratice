import 'dart:async';
import 'dart:isolate';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/Tab.dart';
import 'Search.dart';
import 'routes.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:date_format/date_format.dart' as DateFormat;


/**
 * flutter 命令：
 * flutter create 项目名  -- 创建flutter 工程
 * flutter create -t module  模块名 -- 创建flutter module
 *
 */
void main() {
  // runApp(MyApp());
  method1();
}

void method1() {
  // runApp(new Center(
  //     child:new Text(
  //         "Flutter控件",
  //         textDirection:TextDirection.ltr
  //     )
  // ));

  runApp(Custome2(text: "111"));
  // runApp(Custome3());
  // method8();
  // method9();
  method10();
}

/**
 * 优先处理微任务队列中所有微任务
 * 微任务队列处理完毕后,从事件队列获取一个任务进行处理, 循环上诉步骤.
 *
 * 事件队列, 包含外部事件,例如I/O, Timer,绘制事件等
 * 微任务队列, 包含dart内部的微任务,主要通过scheduleMicrotask来调度.
 *
 * 以微任务方式执行异步任务
 * 以事件任务方式执行异步任务
 *
 * ---------------------
 * Future 使用, 上诉通过回调函数做异步会导致回调地狱问题, 引入Future 可以解决回调地狱问题
 * Future 相对回调函数,缓解了回调地狱问题,但Future 串的任务比较多的话, 代码可读性变差;
 * Dart 进一步优化 async/await.
 * ---------------------
 * async/await, 可以以同步代码的形式写出异步代码.
 *
 */
void method8(){
   //以微任务方式执行异步任务
   scheduleMicrotask((){
      print("微任务");
   });

   //以事件任务方式执行异步任务
   Timer.run(() {
     print("事件任务");
   });

   Future((){
     print("立即在事件队列中执行");
   });

   Future.delayed(Duration(seconds: 1),(){
     print("1秒后在事件队列中执行");
   });

   Future.microtask(() =>{
      print("立即在微任务队列中执行")
   });

   Future.sync(() => { //同步执行即方法调用处执行.
     print("同步执行的Future")
   });

   Future((){
     print("事件队列执行第一个Future");
     return 1;
   }).then((value){
     print("事件队列执行第二个Future ${value}");
     return 2;
   }).then((value) {
     print("事件队列执行第三个Future ${value}");
   }).catchError((onError){ //类似try_catch
     print("任务序列处理失败");
   }).whenComplete(() => { //类似 finally
     print("最终都会执行")
   });

   print("测试异步是否执行");
}

/**
 * async/await, 以同步代码形式写异步代码
 */
void method9(){
   foo();
   print("method9 ");
}

foo() async{
  print("foo");
  String value = await bar();
  /**
   * await 修饰函数返回Future,立马结束,并且其后的代码(String  value, print("bar 返回${value}"))会被以then的方式链式放在该任务后面.
   */
  print("bar 返回 ${value}");
}

bar() async{
  print("bar");
  return "hello";
}

/**
 * 创建多线程, Isolate,Flutter 默认是Root Isolate(即主线程)
 * https://blog.csdn.net/weixin_34051201/article/details/87961959
 * https://blog.csdn.net/email_jade/article/details/88941434
 *
 * dart中Isolate 比较重量级,UI 线程和Isolate的数据传输比较复杂, flutter 为了简化代码, 封装了轻量级
 * compute 操作.
 *
 * Isolate：通过spawn获取新的Isolate对象, 两个Isolate之间使用SendPort相互发送消息,而Isolate 也存在
 * 一个与之对应的ReceivePort用来接收消息.
 *
 * compute 特点, 运行一次,返回一次结果
 * isolate 特点, 使用复杂, 使用ReceivePort 进行双向通信, 可以多次返回结果.
 *
 */
void method10() async{
  // useCompute();
  useIsolate();
}

/***
 * 使用compute 操作,并发
 */
void useCompute() async{
   var time1 =  DateTime.now().millisecondsSinceEpoch;
   int count = await compute(countEvent,10000000);
   var time2 = (DateTime.now().millisecondsSinceEpoch-time1);
   print("print  耗时="+"${time2}");
}

//计算偶数的个数
int countEvent(int num){
   int count =0;
   while(num > 0){
      if(num %2 == 0){
        count++;
      }
      num--;
   }
   return count;
}

/**
 * 使用Isolate 操作并发
 */
void  useIsolate() async{
  int time1 =  DateTime.now().millisecondsSinceEpoch;
  await isolateCountEven(10000000);
  int time2 = (DateTime.now().millisecondsSinceEpoch-time1);
  print("print  耗时="+"${time2}");
}

Future<dynamic> isolateCountEven(int num) async {
  var response = ReceivePort();
  await Isolate.spawn(countEvent2, response.sendPort);
  var sendPort = await response.first;
  var answer = ReceivePort();
  sendPort.send([answer.sendPort,num]);
  return answer.first;
}

void countEvent2(SendPort port){
  var rPort = ReceivePort();
  port.send(rPort.sendPort);
  rPort.listen((message) {
     var send = message[0] as SendPort;
     var n = message[1] as int;
     send.send(countEvent(n));
  });
}

/**
 * Flutter 与 Native 之间通信
 *
 * BasicMessageChannel:  用于传递字符串和半结构化的信息,持续通信,收到消息后可以回复消息。
 * MethodChannel: 用于传递方法调用一次性通信
 * EventChannel: 用于数据流的通信,持续通信,收到消息后无法回复消息,用于手机电量变化,网络变化.
 *
 * 常用 MethodChannel, Native端的调用需要在主线程中执行.
 * flutter端创建 MethodChannle, Native 端创建的MethodChannel 与之同名.
 * 通过methodChannel.invokeMethod() 调用相应的方法并传递参数,通过await 异步获取返回结果.
 *
 */
void method11(){

}



/**
 * 自定义组件
 * 添加多个组件,通过Column包含多个组件.
 * FlatButton 通过onPressd监听点击事件, Navigator.push() 跳转到别的页面.
 *
 */
class Custome1 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Column(children: [
      new Text("Flutter控件",
          textDirection: TextDirection.rtl,
          style: new TextStyle(color: Colors.blue, fontSize: 40)),
      FlatButton(
        child: Text(
          "flatButton 点击",
          style: TextStyle(color: Colors.black, fontSize: 23.0, height: 1.6),
        ),
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
        color: Colors.red,
        highlightColor: Colors.blue[700],
        colorBrightness: Brightness.dark,
        splashColor: Colors.grey,
        onPressed: () {
          //导航到新路由
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return Search();
          }));
        },
      ),
      RaisedButton(
        child: Text("RaisedButton"),
        color: Colors.blue,
        elevation: 50,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
      Image(
        width: 100.0,
        height: 100.0,
        image: AssetImage(
          "imgs/avatar.png",
        ),
        fit: BoxFit.fill,
      ),

      SwitchAndCheckboxWidget(),

      LinearProgressIndicator(
        backgroundColor: Colors.grey,
        valueColor: AlwaysStoppedAnimation(Colors.green),
        value: .5,
      ),

      //自定义CircularProgressIndicator的大小
      SizedBox(
        height: 30.0,
        width: 30.0,
        child: CircularProgressIndicator(
          backgroundColor: Colors.grey,
          valueColor: AlwaysStoppedAnimation(Colors.green),
          value: .5,
        ),
      ),
      //弹性布局
      Flex(
        direction: Axis.horizontal,
        children: <Widget>[
          Expanded(
            flex: 1,
            child: Container(
              color: Colors.red,
              height: 30.0,
            ),
          ),
          Expanded(
            flex: 2,
            //Container 组件使用
            child: Container(
              child: Text("Container"),
              height: 50.0,
              decoration: BoxDecoration(
                  color: Colors.green,
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  border: Border.all(
                    color: Colors.grey,
                    width: 4.0,
                  )),
              padding: EdgeInsets.all(5),
              transform: Matrix4.translationValues(20, 0, 0),
              alignment: Alignment.center,
            ),
          )
        ],
      ),

      //流式布局
      Wrap(
        alignment: WrapAlignment.center,
        children: <Widget>[
          SizedBox(
            width: 100.0,
            height: 50.0,
            child: RaisedButton(
              color: Colors.green,
            ),
          ),
          SizedBox(
            width: 100.0,
            height: 50.0,
            child: RaisedButton(
              color: Colors.red,
            ),
          ),
          SizedBox(
            width: 100.0,
            height: 50.0,
            child: RaisedButton(
              color: Colors.yellow,
            ),
          ),
          SizedBox(
            width: 100.0,
            height: 50.0,
            child: RaisedButton(
              color: Colors.grey,
            ),
          )
        ],
      ),

      //层叠布局
      Stack(
        alignment: Alignment.center,
        children: <Widget>[
          Text("hello world"),
          Positioned(
            top: 60.0,
            child: Text("Positioned 111"),
          ),
          Positioned(
            left: 10.0,
            child: Text("Posotioned 222"),
          )
        ],
      ),
      //Padding 可以添加留白
      Padding(
        padding: EdgeInsets.all(16.0),
        child: FlatButton(
          color: Colors.red,
          child: Text("button"),
        ),
      ),
      CircleAvatar(
        backgroundColor: Colors.blue,
        child: Icon(Icons.person),
      )
    ]);
  }
}

/**
 * 自定义ListView
 */
class MyListView1 extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
     return _MyListView1();
  }
}

class _MyListView1 extends State<MyListView1> {
  ScrollController _scrollController = ScrollController();

  /**
   * 生命周期函数
   */
  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
         print("打印滚动位置"+"${_scrollController.offset}");
    });
  }

  /***
   * 生命周期函数
   */
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  /**
   * 生命周期函数
   */
  @override
  void didUpdateWidget(covariant MyListView1 oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

  /**
   * 生命周期函数
   */
  @override
  void setState(fn) {
    super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    Widget divider1 = Divider(color: Colors.blue);
    Widget divider2 = Divider(color: Colors.green);

    return ListView.separated(
      itemBuilder: (BuildContext context, int index) {
        return ListTile(
          leading: Icon(Icons.person),
          trailing: Icon(Icons.add),
          title: Text(
            "$index",
            textDirection: TextDirection.ltr,
          ),
        );
      },
      separatorBuilder: (BuildContext context, int index) {
        return index % 2 == 0 ? divider1 : divider2;
      },
      controller: _scrollController,
      itemCount: 100,
      scrollDirection: Axis.vertical,
    );
  }

  /**
   * 生命周期函数
   */
  @override
  void deactivate() {
    super.deactivate();
  }

  /***
   * 生命周期函数
   */
  @override
  void dispose() {
    super.dispose();
  }
}

/**
 * 自定义GridView
 */
class MyGridView1 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: EdgeInsets.all(10), //GridView 上下左右的padding 距离.
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3, //每行三列
        crossAxisSpacing: 20, //item 左右距离
        mainAxisSpacing: 20, //item 上下距离
        childAspectRatio: 2.0, //显示区域宽高相等,item宽高的比例
      ),
      itemBuilder: (context, index) {
        return Container(
          height: 200,
          color: Colors.red,
          padding: EdgeInsets.all(10),
          alignment: Alignment.center,
          child: Text("the item $index"),
        );
      },
      itemCount: 30,
    );
  }
}

/**
 * 自定义相对布局
 */
class MyStatck1 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 500,
      height: 400,
      color: Colors.red,
      child: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          Positioned(
            left: 10, //相对位置跟 alignment的值有关.
            child: Icon(Icons.person),
          ),
          Positioned(
            bottom: 10,
            child: Icon(Icons.add),
          ),
          Positioned(
            top: 50,
            left: 50,
            child: Icon(Icons.ac_unit),
          ),
          Align(
            alignment: Alignment(-1, -0.5),
            //以矩形中心点即(0.0)为坐标原点,x,y 的值从-1到1分别代表矩形左边到右边的距离和顶部到底边的距离.
            child: Icon(Icons.access_time),
          )
        ],
      ),
    );
  }
}

/**
 * 自定义卡片布局
 */
class MyCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      shadowColor: Colors.blue,
      color: Colors.red,
      child: Container(
        height: 50,
        alignment: Alignment.center,
        child: Text(
          "第一个卡片布局",
          style: TextStyle(fontSize: 20, color: Colors.green),
        ),
      ),
    );
  }
}

/**
 * 自定义Wrap
 */
class MyWrap1 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Wrap(
      direction: Axis.horizontal,
      alignment: WrapAlignment.spaceBetween,
      runAlignment: WrapAlignment.end,
      //设置纵轴对齐方式
      spacing: 10,
      runSpacing: 10,
      children: <Widget>[
        RaisedButton(
          color: Colors.blue,
          child: Text("第一个button"),
        ),
        RaisedButton(
          color: Colors.blue,
          child: Text("第一个button"),
        ),
        RaisedButton(
          color: Colors.blue,
          child: Text("第一个button"),
        ),
        RaisedButton(
          color: Colors.blue,
          child: Text("第一个button"),
        ),
        RaisedButton(
          color: Colors.blue,
          child: Text("第一个button"),
        ),
        RaisedButton(
          color: Colors.blue,
          child: Text("第一个button"),
        ),
        RaisedButton(
          color: Colors.blue,
          child: Text("第一个button"),
        ),
      ],
    );
  }
}

/**
 * 自定义有状态组件
 */
class MyStateFulWidget extends StatefulWidget {
  var count;

  @override
  State<StatefulWidget> createState() {
    return _MyStateFulWidget();
  }
}

class _MyStateFulWidget extends State<MyStateFulWidget> {
  var count = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        SizedBox(height: 200),
        Text("${count}"),
        RaisedButton(
          child: Text("button"),
          onPressed: () {
            setState(() {
              count++;
            });
          },
        )
      ],
    );
  }
}

/**
 * 自定义单选框以及复选框
 */
class SwitchAndCheckboxWidget extends StatefulWidget {
  @override
  _SwitchAndCheckboxWidget createState() {
    return new _SwitchAndCheckboxWidget();
  }
}

class _SwitchAndCheckboxWidget extends State<SwitchAndCheckboxWidget> {
  var switchStatus = true;
  var userName = TextEditingController();
  var sex;

  @override
  void initState() {
    super.initState();
    var result = DateFormat.formatDate(DateTime.now(), [DateFormat.yyyy, '-', DateFormat.mm, '-', DateFormat.dd]);
    print(result);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Switch(
          value: switchStatus,
          onChanged: (value) {
            setState(() {
              switchStatus = value;
            });
          },
        ),
        Checkbox(
            value: switchStatus,
            activeColor: Colors.red,
            onChanged: (value) {
              setState(() {
                switchStatus = value;
              });
            }),
        Radio(
          //单选按钮
          value: 1,
          onChanged: (value) {
            setState(() {
              this.sex = value;
            });
          },
          groupValue: this.sex,
        ),
        Radio(
          value: 2,
          onChanged: (value) {
            setState(() {
              this.sex = value;
            });
          },
          groupValue: this.sex,
        ),
        //文本输入框
        TextField(
          autofocus: true,
          decoration:
              InputDecoration(labelText: "用户名", prefixIcon: Icon(Icons.person)),
          onChanged: (value) {
            setState(() {
              userName.text = value;
            });
          },
          controller: userName,
        ),

        RaisedButton(
          child: Text("获取TextFiled的值"),
          onPressed: () {
            print("${userName.text}");
          },
        )
      ],
    );
  }
}

/**
 * 自定义BottomBar 组件
 */
class MyBottomBar1 extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MyBottomBar();
  }
}

class _MyBottomBar extends State<MyBottomBar1> {
  var selectTab = 0;

  List list1 = [
    MyHomeTab(),
    MyCateTab(),
    MyCateTabControllerTab()
    // MySetTab(),
  ];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text("title"),
        ),
        bottomNavigationBar: BottomNavigationBar(
          //自定义底部导航
          onTap: changeTab, //点击事件
          currentIndex: selectTab, //当前选中
          fixedColor: Colors.blue, //tab 选中颜色
          items: [
            BottomNavigationBarItem(
                icon: Icon(Icons.person), title: Text("bottom1")),
            BottomNavigationBarItem(
                icon: Icon(Icons.access_time), title: Text("bottom2")),
            BottomNavigationBarItem(
                icon: Icon(Icons.add), title: Text("bottom3")),
          ],
        ),
        body: list1[selectTab],
        drawer: MyDrawer(),
        floatingActionButton: Container(
            margin: EdgeInsets.only(top: 10),
            height: 50,
            width: 50,
            child: FloatingActionButton(
              child: Icon(
                Icons.add,
                size: 30,
              ),
              backgroundColor: Colors.yellow,
            )),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      ),
      // routes: {  //路由命名 -- 无参
      //     "search_page": (context)=> Search("11"),
      // },
      onGenerateRoute: generateRoute,
      theme: ThemeData(primaryColor: Colors.blue),
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate, // 指定本地化的字符串和一些其他的值
        GlobalCupertinoLocalizations.delegate, // 对应的Cupertino风格
        GlobalWidgetsLocalizations.delegate // 指定默认的文本排列方向, 由左到右或由右到左
      ],
      supportedLocales: [
        Locale("zh","CH")
      ],
    );
  }

  void changeTab(int position) {
    setState(() {
      selectTab = position;
    });
  }
}

/**
 *
 */
class Custome2 extends StatelessWidget {
  /**
   * 自定义构造函数
   */
  Custome2({Key key, @required this.text, this.backgroundColor: Colors.amber})
      : super(key: key);

  String text;
  Color backgroundColor;
  var selectTab = 0;

  @override
  Widget build(BuildContext context) {
    return MyBottomBar1();
  }
}

/**
 * 测试各类组件
 */
class Custome3 extends StatelessWidget {
  /**
   * 自定义构造函数
   */
  Custome3({Key key, @required this.text, this.backgroundColor: Colors.amber})
      : super(key: key);

  String text;
  Color backgroundColor;
  var selectTab = 0;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
            appBar: AppBar(
              title: Text("$text"),
            ),
            floatingActionButton: FloatingActionButton(
              child: Icon(
                Icons.add,
                size: 30,
              ),
              backgroundColor: Colors.yellow,
            ),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerFloat,
            body: Custome1()),
        theme: ThemeData(primaryColor: backgroundColor));
  }
}

/**
 *  自定义侧滑菜单, Navigator.pushNamed 必须在Stateless 中跳转才行
 */
class MyDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Expanded(
                child: DrawerHeader(
                  decoration: BoxDecoration(
                    color: Colors.blue,
                  ),
                  child: Text("drawer head"),
                ),
              ),
            ],
          ),
          ListTile(
            title: Text("drawer item1"),
          ),
          ListTile(
            title: Text("drawer item2"),
          ),
          ListTile(
            title: Text("drawer item3"),
            onTap: () {
              Navigator.of(context).pop(); //隐藏侧边栏
              Navigator.pushNamed(context, "search_page",
                  arguments: {"title": "这个Search 界面的参数"});
            },
          ),
        ],
      ),
    );
  }
}
