import 'package:flutter/material.dart';

class CustomeDialog extends Dialog{
  @override
  Widget build(BuildContext context) {
    return  Material(
      type: MaterialType.transparency,
      child: Container(
        width: 50,
        height: 50,

        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 200,
              height: 200,
              color: Colors.white,
              child: Text("自定义Dialog"),
            )

          ],
        ),
      ),
    );
  }
}