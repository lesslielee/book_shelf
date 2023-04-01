import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:easy_refresh/easy_refresh.dart';
import 'package:provider/provider.dart';


import '../utils/carousel_swiper_widget.dart';
import '../utils/title_widget.dart';
import '../utils/pull_up_list_wraper_widget.dart';
import '../sources/data_sources.dart';
import 'home_page.dart';
import 'hotbook_page.dart';
import 'search_page.dart';
import 'member_page.dart';
import 'details_page.dart';

class IndexPage extends StatefulWidget {
  final String title;
  IndexPage({required this.title, super.key});
  State<IndexPage> createState() => _IndexPageState();
}

class _IndexPageState extends State<IndexPage> {
  late String _title;
  int currIndex = 0;

  final List<TabItem> btmNavBarItms = [
    TabItem(
      icon: Icon(Icons.home),
      title: "Home",
    ),
    TabItem(icon: Icon(Icons.recommend), title: "Hot"),
    TabItem(icon: Icon(Icons.search), title: "Search"),
    TabItem(icon: Icon(Icons.man), title: "Me")
  ];
  // final List<BottomNavigationBarItem> btmNavBarItms = [
  //   BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
  //   BottomNavigationBarItem(icon: Icon(Icons.recommend), label: "Hot"),
  //   BottomNavigationBarItem(icon: Icon(Icons.search), label: "Search"),
  //   BottomNavigationBarItem(icon: Icon(Icons.man), label: "Me")
  // ];

  final List<Widget> pages = <Widget>[
    HomePage(title: "Home"),
    HotBookPage(),
    SearchPage(),
    MemberPage(),

  ];

  // 用于上拉加载的图书列表
  // List<Book> pickBooks = [];

  //用于将页面滚动到顶
  final ScrollController _scrollController = ScrollController();
  //指定当前页
  var currPage;



  @override
  void initState() {
    super.initState();
    _title = widget.title;
    currPage = pages[0];
    //_fetchNewgoods();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          _title,
          style: TextStyle(fontSize: 20),
        ),
      ),
      body: IndexedStack(
        index: currIndex,
        // decoration: const BoxDecoration(
        //   image: DecorationImage(
        //       image: AssetImage("lib/images/book.jpg"), fit: BoxFit.cover),
        // ),
        children: pages,
        //height: MediaQuery.of(context).size.height - 500,
        // child: SizedBox(
        //   child: EasyRefresh(
        //     header: PhoenixHeader(),
        //     footer: PhoenixFooter(
        //       // key: pullUpWraperKey,
        //       // backgroundColor: Colors.pink,
        //       // textStyle: TextStyle(
        //       //   color: Colors.deepOrange,
        //       //   fontSize: 15,
        //       // ),
        //       // showMessage: true,
        //       // noMoreText: '',
        //       // dragText: '加载更多...',
        //     ),
        //     child: ListView(
        //       controller: _scrollController,
        //       children: [
        //         // 顶部推荐书籍跑马灯
        //         TitleWidget(title: "New Books", titleColor: Colors.deepOrange),
        //         SizedBox(
        //           height: ScreenUtil().setHeight(300),
        //           child: CarouselSwiperAuto1(contentType: "carouselCards"),
        //         ),

        //         // 热门推荐或名人推介
        //         TitleWidget(
        //             title: "Biographies", titleColor: Colors.deepOrange),
        //         SizedBox(
        //           height: ScreenUtil().setHeight(300),
        //           child: CarouselSwiperAuto1(contentType: "pictures"),
        //         ),

        //         // 推介书籍列表，竖划
        //         TitleWidget(
        //             title: "Picks for you", titleColor: Colors.deepOrange),
        //         // Consumer<EasyRefresh>(builder: (context, csmr, child) => PullUpListWraper(contentType: "books")),
        //         PullUpListWraper(
        //           contentType: "books",
        //           pickBooks: pickBooks,
        //         ),
        //       ],
        //     ),
        //     onLoad: () async {
        //       print("开始onLoad...");
        //       setState(
        //         () {
        //           _fetchNewgoods();
        //         },
        //       );
        //       //PullUpListWraper().
        //       // GetNewGoods().fetchNewgoods();
        //     },
        //     onRefresh: () {
        //       print("开始onRefresh...");
        //     },
        //   ),
        // ),
      ),

      // bottomNavigationBar: // ConvexAppBar(
      //     BottomNavigationBar(
      //   // disableDefaultTabController: true,
      //   // style: TabStyle.react,
      //   items: btmNavBarItms,
      //   fixedColor: Colors.red,
      //   unselectedItemColor: Colors.blue,
      //   backgroundColor: Colors.green,
      //   //currentIndex: currIndex,
      //   //type: BottomNavigationBarType.fixed,
      //   onTap: (index) {
      //     setState(() {
      //       currIndex = index;
      //       //currPage = pages[currIndex];
      //     });
      //   },
      // ),

      floatingActionButton: FloatingActionButton(
        tooltip: 'Back to Top',
        child: const Icon(Icons.vertical_align_top),
        onPressed: () {
          print("点击了Back to Top");
          _scrollController.animateTo(0.0, 
          duration: Duration(milliseconds: 500), 
          curve: Curves.elasticInOut);
        },

      ),

      bottomNavigationBar: 
      // StyleProvider(
        // style: Style(),
        // child: 
        ConvexAppBar(
          style: TabStyle.textIn,
          // backgroundColor: ThemeData().canvasColor,
          backgroundColor: Colors.deepOrange,
          initialActiveIndex: currIndex,
          items: btmNavBarItms,
          onTap: (index) {
            setState(
              () {
                currIndex = index;
                currPage = pages[currIndex];
                // Text("点击了$index");
                print("点击了$index");
              },
            );
          },
        ),
      



    );
  }
}
//   // 此函数是上拉加载数据的关键函数，之前将其定义在PullUpListWraper类中，
//   // 但那样没法在那个类的外部通过上拉来触发和设定该类的相关State，从而无法将已加载的数据重绘在该Widget上，
//   // 即，无法触发该Widget的build方法来重绘。
//   // 反复研究后，发现应该
//   // 1. 将这个方法定义在PullUpListWrap的调用类里，即_IndexPageState类中；
//   // 2. 在Easy_refresh控件的OnLoad()回调函数中，异步调用setState()，并在setState()函数中调用这个_fetchNewGoods()，达到
//   // 2.1. 既能获取到新数据
//   // 2.2. 又能setState()，达到加载完新数据后，触发重绘UI的目的
//   void _fetchNewgoods() {
//     print("被上拉动作触发加载新数据");

//     // var formPage = {'page': page};
//     createBookListData().then((bks) {
//       try {
//         print("=====图书数量====: ${bks.length}");
//         // 调用reccomendBooks方法，从图书列表中取出6本书作为新加载的书
//         List<Book> recBooks = recommendList(list: bks, num: 6);
//         setState(() {
//           //为了做出上拉继续加载的效果，这里没有一次性加载所有的图书
//           pickBooks.addAll(recBooks);
//           renameBookName();
//           // page++;
//           // print("####PAGE####: $page");
//         });

//         for (var b in pickBooks) {
//           print('书名：${b.title}, 封面图片：${b.cover}');
//         }
//         print("===========更新后的picBooks有${pickBooks.length}本书===============");
//       } catch (e) {
//         print("====>生成推荐图书失败！<=====");
//         throw ("推荐图书失败: Error $e");
//       }
//       print(pickBooks.length);
//       //_PullUpListWraperState();

//       // final pullUpWraperKey = GlobalKey<_PullUpListWraperState>();

//       // _PullUpListWraperState? state = pullUpWraperKey.currentState;
//       // print("来到setState()之前了...");
//       // if (state != null) {
//       //   _PullUpListWraperState()._getNewGoods();
//       // state.setState(() {
//       //   print("<<<<从外部调用了 setState() ${pickBooks.length}>>>>");
//       // });
//       // } else {
//       //   print("state 现在还是null");
//       // }

//       // notifyListeners();
//     });
//   }

//   // 为获取到的图书列表pickBooks里的图书title改名，在每隔title前加上"number_"
//   // 此函数没什么实用价值，主要是因为现在用的假数据，title是遗传乱乱的字符，不方便统计和查看已经在UI上加载和展示了多少数据
//   // 所以用这个函数将书名改一下，以便在界面上查看数据量
//   void renameBookName() {
//     for (int i = 0; i < pickBooks.length; i++) {
//       if (!pickBooks[i].title.contains('_')) {
//         pickBooks[i].title = "${i}_${pickBooks[i].title}";
//       }
//     }
//   }
// }

// // class Style extends StyleHook {
// //   @override 
// //   double get activeIconSize => 40;

// //   @override
// //   double get activeIconMargin => 10;

// //   @override
// //   double get iconSize => 20;

// //   @override
// //   TextStyle textStyleT(Color color) {
// //     return TextStyle(fontSize: 20, color: color);
// //   }
// // }