import 'package:flutter/material.dart';

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
            return MyApp();
          }));
        },
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
      )
    ]);
  }
}

/**
 * 自定义ListView
 */
class MyListView1 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // return ListView.builder(
    //   itemCount: 100,
    //   itemBuilder: (context,index){
    //      return ListTile(title: Text("title$index"));
    //   },
    // );

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
      itemCount: 100,
      scrollDirection: Axis.vertical,
    );
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
            left: 10,  //相对位置跟 alignment的值有关.
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
            alignment: Alignment(-1, -0.5), //以矩形中心点即(0.0)为坐标原点,x,y 的值从-1到1分别代表矩形左边到右边的距离和顶部到底边的距离.
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
        child: Text("第一个卡片布局",
           style: TextStyle(
             fontSize: 20,
             color: Colors.green
           ),
        ),
      ),
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
        TextField(
          autofocus: true,
          decoration:
              InputDecoration(labelText: "用户名", prefixIcon: Icon(Icons.person)),
          onChanged: (value) {
            print("输入框内容$value");
          },
        )
      ],
    );
  }
}

/**
 * 自定义组件, 添加导航栏
 */
class Custome2 extends StatelessWidget {
  /**
   * 自定义构造函数
   */
  Custome2({Key key, @required this.text, this.backgroundColor: Colors.amber})
      : super(key: key);

  String text;
  Color backgroundColor;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(appBar: AppBar(title: Text("$text")), body: MyStatck1()),
        theme: ThemeData(primaryColor: backgroundColor));
  }
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
        // This makes the visual density adapt to the platform that you run
        // the app on. For desktop platforms, the controls will be smaller and
        // closer together (more dense) than on mobile platforms.
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Invoke "debug painting" (press "p" in the console, choose the
          // "Toggle Debug Paint" action from the Flutter Inspector in Android
          // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
          // to see the wireframe for each widget.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headline4,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
