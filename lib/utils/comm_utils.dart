import 'dart:math';
import 'package:flutter/material.dart';
import 'package:glassmorphism/glassmorphism.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import "../sources/data_sources.dart";

// generate a Random name String ("FirstName LastName")
String generateRandomString(int fNameLength, int lNameLength) {
  var random = Random();
  const charset = 'abcdefghijklmnopqrstuvwxyz';
  String fName =
      List.generate(fNameLength, (_) => charset[random.nextInt(charset.length)])
          .join();
  String lName =
      List.generate(lNameLength, (_) => charset[random.nextInt(charset.length)])
          .join();
  fName = fName.replaceFirst(fName[0], fName[0].toUpperCase());
  lName = lName.replaceFirst(lName[0], lName[0].toUpperCase());
  //print('$fName $lName');
  return '$fName $lName';
}

/// 描述：为每一本图书做一个毛玻璃效果的卡片式展示（类似名片：左边为封面图片，右边从上至下摆放书名、作者和收藏数）
/// 入参(必选): Book 类型的数据
/// 返回数据类型：StatelessWidget
/// 样式如下
/// +--------------------------+
/// | +-------+                |
/// | |       |  BookName...   |
/// | | Cover |  Author ...    |
/// | |       |  Favor 12345   |
/// | +-------+                |
/// +--------------------------+
class GlassmorpicCard extends StatelessWidget {
  final Book book;
  const GlassmorpicCard({required this.book, super.key});

  @override
  Widget build(BuildContext context) {
    return GlassmorphicContainer(
      //毛玻璃效果
      width: ScreenUtil().setWidth(600),
      height: ScreenUtil().setHeight(400),
      borderRadius: 10,
      blur: 10,
      alignment: Alignment.topLeft,
      border: 2,
      linearGradient: LinearGradient(
        begin: Alignment.centerLeft,
        end: Alignment.bottomRight,
        colors: [
          Color(0xFFffffff).withOpacity(0.1),
          Color(0xFFFFFFFF).withOpacity(0.05),
        ],
        stops: [
          0.1,
          1,
        ],
      ),
      borderGradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          Color(0xFFffffff).withOpacity(0.5),
          Color((0xFFFFFFFF)).withOpacity(0.5),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          mainAxisSize: MainAxisSize.max,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10.0),
              child: Image.asset(
                //书封面图片
                book.cover,
                width: ScreenUtil().setWidth(220),
                height: ScreenUtil().setHeight(300),
                fit: BoxFit.fitWidth,
              ),
            ),
            SizedBox(
              width: ScreenUtil().setWidth(300),
              height: ScreenUtil().setHeight(260),
              child: Padding(
                padding: const EdgeInsets.only(left: 5.0, top: 18.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(
                      //书名
                      book.title,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        // 设置超出宽度的显示方式为省略号
                        overflow: TextOverflow.ellipsis,
                      ),
                      // 设置最大显示行数为1行
                      maxLines: 1,
                    ),
                    Text(
                      //作者
                      book.author,
                      style: const TextStyle(
                        fontSize: 13,
                        fontStyle: FontStyle.italic,
                        overflow: TextOverflow.ellipsis,
                      ),
                      maxLines: 1,
                    ),
                    Row(
                      children: [
                        const Icon(
                          Icons.favorite,
                          color: Colors.red,
                        ),
                        Text(
                          (Random().nextInt(9999) + 400).toString(),
                          style: TextStyle(
                            fontSize: 15,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}



/// 描述：Widget CommonCard1样式类型
/// 入参(必选): Book 类型的数据
/// 返回数据类型：StatelessWidget
/// 样式如下
/// +-----------+
/// | +-------+ |
/// | |       | |
/// | | Cover | |
/// | |       | |
/// | +-------+ |
/// | BookName  |
/// | Author    |
/// | Favor 1234|
/// +-----------+
///
class CommonCard1 extends StatelessWidget {
  final Book book;
  CommonCard1({required this.book, super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap:() {
        print("Clicked a 'picks for you book'");
      },
      child: Container(
        width: ScreenUtil().setWidth(370),
        height: ScreenUtil().setHeight(400),
        padding: EdgeInsets.all(0.8),
        margin: EdgeInsets.all(0.5),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.pink, width: 1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //书封面图片
            Image.asset(
              book.cover,
              width: ScreenUtil().setWidth(350),
              height: ScreenUtil().setHeight(280),
            ),
            Text(
              //书名
              book.title,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                // 设置超出宽度的显示方式为省略号
                overflow: TextOverflow.ellipsis,
              ),
              // 设置最大显示行数为1行
              maxLines: 1,
            ),
            Text(
              //作者
              book.author,
              style: const TextStyle(
                fontSize: 13,
                fontStyle: FontStyle.italic,
                overflow: TextOverflow.ellipsis,
              ),
              maxLines: 1,
            ),
            Row(
              children: [
                const Icon(
                  Icons.favorite,
                  color: Colors.red,
                ),
                Text(
                  (Random().nextInt(9999) + 400).toString(),
                  style: TextStyle(
                    fontSize: 15,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
