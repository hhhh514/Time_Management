import 'package:flutter/material.dart';
import '../kit/function_menu.dart';
import 'dart:io';
import 'dart:typed_data';
import 'package:path_provider/path_provider.dart';
void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'App介紹',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: IntroductionScreen(),
    );
  }
}
class IntroductionScreen extends StatelessWidget {

  void showAlertDialog(BuildContext context,int index) {

    AlertDialog dialog = AlertDialog(
      title:Image(
        image: AssetImage('assets/images/'+index.toString()+'.gif'),
        width: 300, // 设置宽度
        height:500,
        fit: BoxFit.cover,// 设置高度
      ),
      actions: [
        ElevatedButton(
            child: Text("OK"),
            onPressed: () {
              Navigator.pop(context);
            }
        ),
      ],
    );

    // Show the dialog
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return dialog;
        }
    );

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(

        title: Text('App介紹'),
      ),
      drawer: const FunctionMenu(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(left: 50.0),
              child:  Text(
                '歡迎使用我們的App！',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(height: 16),
            Text(
              '這是一個有關於時間管理的APP。我們有以下功能',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 16),
            Row(
              children: [
                Container(
                  width: 15.0, // 設定圓點的直徑
                  height: 15.0,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.black, // 設定圓點的顏色
                  ),
                ),
                Text(
                  '行程安排:',
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(height: 16),
                ElevatedButton(
                 onPressed: () {
                    this.showAlertDialog(context,1);

                  },
                  child: Icon(
                    Icons.build,
                    size: 15,
                  ),
                ),SizedBox(height: 5,width: 5,),
              ],
            ),
            Padding(
                padding:EdgeInsets.only(left: 50.0),
              child:Column(
                children: [
                  Text(
                    '       1.規劃日後行程',
                    style: TextStyle(fontSize: 16),
                  ),
                  Text(
                    '2.明顯標註',
                    style: TextStyle(fontSize: 16),
                  ),
                  Text(
                    '3.提前通知',
                    style: TextStyle(fontSize: 16),
                  ),
                ],
              ),

            ),
            Row(
              children: [
                Container(
                  width: 15.0, // 設定圓點的直徑
                  height: 15.0,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.black, // 設定圓點的顏色
                  ),
                ),
                Text(
                  '學習時鐘(番茄鐘):',
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    this.showAlertDialog(context,2);

                  },
                  child: Icon(
                    Icons.build,
                    size: 15,
                  ),
                ),SizedBox(height: 5,width: 5,),
              ],
            ),
            Padding(
              padding:EdgeInsets.only(left: 38.0),
              child:Column(
                children: [
                  Text(
                    '1.效率學習',
                    style: TextStyle(fontSize: 16),
                  ),
                  Text(
                    '2.自訂時間',
                    style: TextStyle(fontSize: 16),
                  ),
                  Text(
                    '3.聆聽音樂',
                    style: TextStyle(fontSize: 16),
                  ),
                  Text(
                    '          4.休息/學習 提醒',
                    style: TextStyle(fontSize: 16),
                  ),
                ],
              ),

            ),
            Row(
              children: [
                Container(
                  width: 15.0, // 設定圓點的直徑
                  height: 15.0,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.black, // 設定圓點的顏色
                  ),
                ),
                Text(
                  //示範影片還需更改
                  '工作表:',
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    this.showAlertDialog(context,3);

                  },
                  child: Icon(
                    Icons.build,
                    size: 15,
                  ),
                ),SizedBox(height: 5,width: 5,),
              ],
            ),
            Padding(
              padding:EdgeInsets.only(left:45.0),
              child:Column(
                children: [
                  Text(
                    '        1.紀錄工作天數',
                    style: TextStyle(fontSize: 16),
                  ),
                  Text(
                    ' 2.明顯標註',
                    style: TextStyle(fontSize: 16),
                  ),
                ],
              ),

            ),

            Row(
              children: [
                Container(
                  width: 15.0, // 設定圓點的直徑
                  height: 15.0,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.black, // 設定圓點的顏色
                  ),
                ),
                Text(
                  '待辦事項:',
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    this.showAlertDialog(context,4);

                  },
                  child: Icon(
                    Icons.build,
                    size: 15,
                  ),
                ),SizedBox(height: 5,width: 5,),
              ],
            ),
            Padding(
              padding:EdgeInsets.only(left:35.0),
              child:Column(
                children: [
                  Text(
                    '       1.紀錄當天所需',
                    style: TextStyle(fontSize: 16),
                  ),
                  Text(
                    '           2.可分重要與普通',
                    style: TextStyle(fontSize: 16),
                  ),
                  Text(
                    '3.即時通知',
                    style: TextStyle(fontSize: 16),
                  ),
                ],
              ),

            ),
            Row(
              children: [
                Container(
                  width: 15.0, // 設定圓點的直徑
                  height: 15.0,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.black, // 設定圓點的顏色
                  ),
                ),
                Text(
                  '個人習慣:',
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(height: 16),
              ],
            ),
            Padding(
              padding:EdgeInsets.only(left:35.0),
              child:Column(
                children: [

                ],
              ),

            ),
          ],
        ),
      ),
    );
  }
}
