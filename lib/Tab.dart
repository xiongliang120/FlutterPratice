import 'package:flutter/material.dart';
import 'package:date_format/date_format.dart' as DateFormat;
import 'package:flutter_swiper/flutter_swiper.dart';
import 'CustomeDialog.dart';
import 'package:toast/toast.dart';

class MyHomeTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Text("home"),
        SizedBox(
          height: 30,
        ),
        RaisedButton(
          color: Colors.blue,
          child: Text("跳转到Search"),
          onPressed: () {
            //跳转别的页面,并且传递参数
            // Navigator.push(context, MaterialPageRoute(builder: (context){
            //    return Search("跳转传参");
            // }));

            Navigator.pushNamed(context, "search_page",
                arguments: {"title": "这个Search 界面的参数"});
          },
        ),
        SizedBox(
          height: 30,
        ),
        RaisedButton(
          color: Colors.blue,
          child: Text("跳转到Set界面"),
          onPressed: () {
            //跳转别的页面,并且传递参数
            // Navigator.push(context, MaterialPageRoute(builder: (context){
            //    return Search("跳转传参");
            // }));

            Navigator.pushNamed(context, "set_page");
          },
        ),
        SizedBox(
          height: 40,
        ),
        RaisedButton(
          child: Text("打开日期选择"),
          onPressed: () {
            _showDatePicker(context);
          },
        ),
        SizedBox(
          height: 30,
        ),
        RaisedButton(
            child: Text("AlertDialog"),
            onPressed: () {
              // _showAlertDialog(context);
              // _showSimpleDialog(context);
              _showCustomeDialog(context);
            }),
        SizedBox(height: 30,),
        //Toast
        RaisedButton(
          onPressed: () {
            showToast(context,"Show Long Toast", duration: Toast.LENGTH_LONG);
          },
          child: Text("Flutter Toast Context"),
        ),
      ],
    );
  }
}

void _showDatePicker(BuildContext context) async {
  var result = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      locale: Locale("zh"),
      firstDate: DateTime(1970),
      lastDate: DateTime(2100));

  print(DateFormat.formatDate(
      result, [DateFormat.yyyy, '-', DateFormat.MM, '-', DateFormat.DD]));
}

/**
 * 显示AlertDialog
 */
void _showAlertDialog(BuildContext context) {
  showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("提示"),
          content: Text("您确定要删除当前文件吗?"),
          actions: <Widget>[
            FlatButton(
              child: Text("取消"),
              onPressed: () => Navigator.of(context).pop(), //关闭对话框
            ),
            FlatButton(
              child: Text("删除"),
              onPressed: () {
                Navigator.of(context).pop(true); //关闭对话框
              },
            ),
          ],
        );
      });
}

/**
 * 显示SimpleDialog
 */
void _showSimpleDialog(BuildContext context){
  showDialog(
      context: context,
      builder: (BuildContext context) {
        return SimpleDialog(
          title: const Text('请选择语言'),
          children: <Widget>[
            SimpleDialogOption(
              onPressed: () {
                // 返回1
                Navigator.pop(context, 1);
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 6),
                child: const Text('中文简体'),
              ),
            ),
            SimpleDialogOption(
              onPressed: () {
                // 返回2
                Navigator.pop(context, 2);
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 6),
                child: const Text('美国英语'),
              ),
            ),
          ],
        );
      });
}

/***
 * 显示自定义Dialog
 */
void _showCustomeDialog(BuildContext context){
   showDialog(context: context,builder:(BuildContext context){
        return CustomeDialog();
   });
}

/**
 * 显示Toast
 */
void showToast(BuildContext context,String msg, {int duration, int gravity}) {
  Toast.show(msg, context, duration: duration, gravity: gravity);
}



/**
 * 自定义顶部导航 实现方式之一, 采用 DefaultTabController 实现
 */
class MyCateTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Row(
            //自定义AppBar 放在title 而非 bottom 减少顶部的空白
            children: <Widget>[
              Expanded(
                child: TabBar(
                  tabs: <Widget>[
                    Tab(
                      text: "第一个",
                    ),
                    Tab(
                      text: "第二个",
                    ),
                    Tab(
                      text: "第三个",
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: <Widget>[
            ListView(
              children: <Widget>[
                Text("第一个item"),
                Text("第一个item"),
                Text("第一个item"),
                Text("第一个item")
              ],
            ),
            ListView(
              children: <Widget>[
                Text("第二个item"),
                Text("第二个item"),
                Text("第二个item"),
                Text("第二个item")
              ],
            ),
            ListView(
              children: <Widget>[
                Text("第三个item"),
                Text("第三个item"),
                Text("第三个item"),
                Text("第三个item")
              ],
            )
          ],
        ),
      ),
    );
  }
}

/***
 * 通过TabController 自定义顶部导航 实现方式之二
 * 采用 TabController实现
 */
class MyCateTabControllerTab extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MyCateTabControllerTab1();
  }
}

class _MyCateTabControllerTab1 extends State<MyCateTabControllerTab>
    with SingleTickerProviderStateMixin {
  TabController tabController;
  var images = ["imgs/avatar.png", "imgs/avatar1.png", "imgs/avatar2.png"];

  @override
  void dispose() {
    //组件销毁
    super.dispose();
    tabController.dispose();
  }

  @override
  void initState() {
    super.initState();
    tabController = new TabController(length: 3, vsync: this);
    tabController.addListener(() {
      print(tabController.index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: <Widget>[
            Expanded(
              child: TabBar(
                controller: tabController,
                tabs: <Widget>[
                  Tab(text: "第一个"),
                  Tab(text: "第二个"),
                  Tab(text: "第三个"),
                ],
              ),
            )
          ],
        ),
      ),
      body: TabBarView(
        controller: tabController,
        children: <Widget>[
          Center(child: Text("第一个")),
          Center(child: Text("第二个")),
          Container(
            height: 200,
            child: AspectRatio(
              aspectRatio: 16 / 9,
              child: Swiper(
                itemBuilder: (BuildContext context, int index) {
                  return new Image.asset(
                    images[index],
                    fit: BoxFit.fill,
                  );
                },
                itemCount: images.length,
                autoplay: true,
                pagination: SwiperPagination(),
                control: SwiperControl(),
              ),
            ),
          )
        ],
      ),
    );
  }
}

class MySetTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
          body: Column(
        children: <Widget>[
          RaisedButton(
            color: Colors.blue,
            child: Text("跳转到Login界面"),
            onPressed: () {
              //路由替换, 会将当前路径替换为login_page
              Navigator.pushReplacementNamed(context, "login_page");
            },
          )
        ],
      )),
    );
  }
}
