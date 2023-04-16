import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import 'pages/index_page.dart';
import 'utils/pull_up_list_wraper_widget.dart';

// void main() async {
//   await ScreenUtil.ensureScreenSize();
//   runApp(BookShelf());
// }

void main()  {
  // await ScreenUtil.ensureScreenSize();
  runApp(BookShelf());
}


class BookShelf extends StatelessWidget {
  const BookShelf({super.key});

  @override
  Widget build(BuildContext context) {
    //切换了ScreenUtil官网上的第一种用法，现在BottomNavigationBar可以正常使用了。 20230329
    //但还是没有从原理上搞清楚，为什么它的第二种初始化屏幕适配的方式，会导致BottomNavigationBar无法加载，有待日后再研究。

    return ScreenUtilInit(
      designSize: const Size(750, 1334),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return 
        // ChangeNotifierProvider(
        //   create:(context) => GetNewGoods(),
        //   child: 
          MaterialApp(
            // debugShowCheckedModeBanner: false,
            title: "Book Shelf",
            theme: ThemeData(
              primarySwatch: Colors.blue,
              textTheme: Typography.englishLike2018.apply(fontSizeFactor: 1.sp),
            ),
            home: child,
          
        );
      },
      child: IndexPage(title: 'Book Shelf'),
    );


//    return MaterialApp(
    // builder:(context, child) {
    //   ScreenUtil.init(context);
    //   // return Theme(
    //   //   data: ThemeData(
    //   //     primarySwatch: Colors.deepOrange,
    //   //     //这个textTheme的设置会影响全局，尤其后面的ConvexAppBar的字体会变得很大，而convexAppBar的字体修改很麻烦，需要StyleHook...
    //   //     //所以暂时不设置以下这个TextTheme了，用系统默认的。 20230329
    //   //     //textTheme: TextTheme(bodyText2: TextStyle(fontSize: 30.sp)),
    //   //   ),
    //   // );
    // },
//    );
  }
}
