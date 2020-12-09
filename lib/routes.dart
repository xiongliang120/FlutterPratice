import 'package:flutter/material.dart';
import 'Search.dart';
import 'Tab.dart';

var routes = {
  "search_page": (context,{arguments}) => Search(arguments:arguments), //添加可选参数
  "set_page": (context) => MySetTab()
};

/**
 * 路由统一封装,命名路由,带参数
 */
Route generateRoute(RouteSettings settings) {
  String name = settings.name;
  Function pageContentBuilder = routes[name];
  if (pageContentBuilder != null) {
    if (settings.arguments != null) {
      Route route = MaterialPageRoute(
          builder: (context) =>
              pageContentBuilder(context, arguments: settings.arguments));
      return route;
    } else {
      Route route =
          MaterialPageRoute(builder: (context) => pageContentBuilder(context));
      return route;
    }
  }
}
