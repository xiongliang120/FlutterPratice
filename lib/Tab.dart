import 'package:flutter/material.dart';
import 'package:date_format/date_format.dart' as DateFormat;
import 'package:flutter_app/network.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'CustomeDialog.dart';
import 'package:toast/toast.dart';
import 'Animation.dart';

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
        SizedBox(height: 30),
        NetworkWidget(),
        SizedBox(height: 30,),
        DioNetworkWidget(),
        SizedBox(height: 30,),
        JsonWidget()
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
            MyListView1()
          ],
        ),
      ),
    );
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

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      print("打印滚动位置"+"${_scrollController.offset}");
    });
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

}


/***
 * 通过TabController 自定义顶部导航 实现方式之二
 * 采用 TabController实现
 */
class MyCateTabControllerTab extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    print("打印 createState");
    return _MyCateTabControllerTab1();
  }
}

/**
 * 继承 SingleTickerProviderStateMixin, 用于Controller 所需的参数.
 *
 * Dart 为了支持多重继承,引入mixin关键字, 特殊之处是,mixin 定义的类不能有构造方法,
 *这样可以避免继承多个类而产生的父类构造方法冲突。
 * (mixi类与abstract类似,不能实例化, 相同的方法会被覆盖, 并且with后面的回覆盖前面的,mixin类与with 结合使用)
 */
class _MyCateTabControllerTab1 extends State<MyCateTabControllerTab>
    with SingleTickerProviderStateMixin {
  GlobalKey globalKey = GlobalKey();

  TabController tabController;
  var images = ["imgs/avatar.png", "imgs/avatar1.png", "imgs/avatar2.png"];
  var tabName = "initName";

  /**
   * 生命周期函数
   */
  @override
  void initState() {
    super.initState();
    print("打印 initState");
    tabController = new TabController(length: 3, vsync: this);
    tabController.addListener(() {
      print(tabController.index);
    });
  }

  /***
   * 生命周期函数
   */
  @override
  void didChangeDependencies() {
    print("打印 didChangeDependencies");
    super.didChangeDependencies();
  }


  /***
   * 生命周期函数
   */
  @override
  void didUpdateWidget(covariant MyCateTabControllerTab oldWidget) {
    super.didUpdateWidget(oldWidget);
    print("打印 didUpdateWidget");
  }

  /**
   * 生命周期函数
   */
  @override
  void setState(fn) {
    super.setState(fn);
    print("打印 setState");
  }

  /**
   * 生命周期函数
   */
  @override
  void deactivate() {
    super.deactivate();
    print("打印 deactivate");
  }

  /***
   * 生命周期函数
   */
  @override
  void dispose() {
    super.dispose();
    print("打印 dispose");
  }

  /***
   * 获取控件的大小和布局
   */
  void getRenderObjectSize(){
     RenderBox renderBox = globalKey.currentContext.findRenderObject();
     if(renderBox != null){
       print(renderBox.size);

       print(renderBox.localToGlobal(Offset.zero));//获取控件坐标

       //触发布局, 触发绘制
       renderBox.markNeedsLayout();
       renderBox.markNeedsPaint();
     }
  }


  @override
  Widget build(BuildContext context) {
    print("打印 build");
    context.findRenderObject();
    context.widget;

    Future.delayed(Duration(seconds: 2),(){
      getRenderObjectSize();
    });

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: <Widget>[
            Expanded(
              child: TabBar(
                controller: tabController,
                tabs: <Widget>[
                  Tab(text: "第一个",key: globalKey ),
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
          Container(
            child: Column(
              children: [
                Text("第一个"),
              ],
            ),
          ),
          Container(
            height: 300,
            width: 300,
            // child: Listener( //解决滑动冲突, 通过Listener解决
            //   onPointerDown: (details){
            //       print("打印down");
            //   },
            //
            //   onPointerUp: (details){
            //      print("打印up");
            //   },
            //
            //   onPointerMove: (details){
            //     print("打印move ${details.orientation} 滑动距离 ${details.delta}");
            //   },

              child:   GestureDetector(
                child : Column(
                  children: [
                    Text(
                        "$tabName"
                    ),

                    RaisedButton(
                        child: Text("更新文本"),
                        onPressed: (){
                          setState(() {
                            tabName = "更新文本内容";
                          });
                        }),
                  ],
                ),
                // onPanDown: (DragDownDetails drag){  //手指按下时触发回调
                //   print("手指按下时触发回调 ${drag.localPosition}");
                // },
                // onPanUpdate: (DragUpdateDetails  drag){ //手指滑动时触发回调
                //   print("手指滑动时触发回调 ${drag.localPosition}");
                // },
                // onPanEnd: (DragEndDetails drag){ //手指滑动结束时触发回调
                //   print("手指滑动结束时触发回调 ${drag.velocity}");
                // },
                // // onHorizontalDragUpdate: (DragUpdateDetails drag){ //手指水平方向滑动时触发回调
                // //   print("手指水平方向滑动时触发回调 ${drag.localPosition}");
                // // },
                // onVerticalDragUpdate: (DragUpdateDetails drag){
                //   print("手指垂直滑动");
                // },
              ),
            // )
          ),
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
          ),
          CustomeAnimationStateWidget()
        ],
      )),
    );
  }
}
