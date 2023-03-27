import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'pages/index_page.dart';

void main() async {
  await ScreenUtil.ensureScreenSize();
  runApp(BookShelf());
}

class BookShelf extends StatelessWidget {
  const BookShelf({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      builder:(context, child) {
        ScreenUtil.init(context);
        return Theme(
          data: ThemeData(
            primarySwatch: Colors.deepOrange,
            textTheme: TextTheme(bodyText2: TextStyle(fontSize: 30.sp)),
          ),
          child: IndexPage(title: 'Book Shelf'),
        );
      },
    );
  }
}