import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:easy_refresh/easy_refresh.dart';
import 'package:provider/provider.dart';

import 'home_page.dart';
import '../utils/carousel_swiper_widget.dart';
import '../utils/title_widget.dart';
import '../utils/pull_up_list_wraper_widget.dart';
import '../sources/data_sources.dart';

class HomePage extends StatefulWidget {
  final String title;
  HomePage({required this.title, super.key});
  State<HomePage> createState() => _HomePageState();
}

int numOfPullUpBooks = 0;

class _HomePageState extends State<HomePage>
    with AutomaticKeepAliveClientMixin {
  //页面状态保持的3个条件之一，mixin AutomaticKeepAliveClientMixin

  late String _title;

  // 这个变量是用于存放上拉持续加载的图书列表对应的数据，定义在这里也是经过多番尝试才定下来的，
  // 在这里定义，虽然没有让数据与UI完全抽离，但是已经可以做到，仅仅用这个变量来接收数据加载程序的返回值，和将该变量作为初值传递给上拉加载Widget,
  // 而无需在这里加载后台数据来赋给这个变量———将加载后台数据的函数抽象出去成为一个独立的函数fetchNewgoods()，放在data_sources.dart中，可作为公共函数来调用。
  List<Book> pickForYouBooks = [];
  // int currIndex = 0;

  // final List<TabItem> btmNavBarItms = [
  //   TabItem(
  //     icon: Icon(Icons.home),
  //     title: "Home",
  //   ),
  //   TabItem(icon: Icon(Icons.recommend), title: "Hot"),
  //   TabItem(icon: Icon(Icons.search), title: "Search"),
  //   TabItem(icon: Icon(Icons.man), title: "Me")
  // ];
  // final List<BottomNavigationBarItem> btmNavBarItms = [
  //   BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
  //   BottomNavigationBarItem(icon: Icon(Icons.recommend), label: "Hot"),
  //   BottomNavigationBarItem(icon: Icon(Icons.search), label: "Search"),
  //   BottomNavigationBarItem(icon: Icon(Icons.man), label: "Me")
  // ];

  // 用于上拉加载的图书列表
  // List<Book> pickBooks = [];

  //用于将页面滚动到顶
  final ScrollController _scrollController = ScrollController();

  // 页面状态保持还需要如下这两条，(3个条件的另外两条)
  // 1. override wantKeepAlive这个方法的返回值为true
  // 2. 声明一个GlobalKey<RefreshIndicatorState>的实例
  @override
  bool get wantKeepAlive => true;
  GlobalKey<RefreshIndicatorState> _easyRefreshKey =
      GlobalKey<RefreshIndicatorState>();

  @override
  void initState() {
    super.initState();
    _title = widget.title;
    // _fetchNewgoods();
    // print("重新加载HomePage数据...");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Text(
      //     _title,
      //     style: TextStyle(fontSize: 20),
      //   ),
      // ),
      body: Container(
        decoration:  BoxDecoration(
          image: DecorationImage(
            image: AssetImage("lib/images/next_door.jpg"),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
            Colors.black.withOpacity(0.8),
            BlendMode.dstATop,   ),         
          ),
        ),

        //height: MediaQuery.of(context).size.height - 500,
        child: //SizedBox(
            //child:
            EasyRefresh(
          key: _easyRefreshKey,
          // header: MaterialHeader(),
          // footer: MaterialFooter(
          header: BezierHeader(),
          footer: BezierFooter(
              // key: pullUpWraperKey,
              // backgroundColor: Colors.pink,
              // textStyle: TextStyle(
              //   color: Colors.deepOrange,
              //   fontSize: 15,
              // ),
              // showMessage: true,
              // noMoreText: '',
              //  dragText: '加载更多...',
              ),
          child: ListView(
            controller: _scrollController,
            scrollDirection: Axis.vertical,
            children: [
              // 顶部推荐书籍跑马灯
              TitleWidget(title: "New Books", titleColor: Colors.deepOrange),
              SizedBox(
                height: ScreenUtil().setHeight(300),
                child: CarouselSwiperAuto1(contentType: "carouselCards"),
              ),

              // 热门推荐或名人推介
              TitleWidget(title: "Biographies", titleColor: Colors.deepOrange),
              SizedBox(
                height: ScreenUtil().setHeight(300),
                child: CarouselSwiperAuto1(contentType: "pictures"),
              ),

              // 推介书籍列表，竖划
              TitleWidget(
                  title: "Picks for you", titleColor: Colors.deepOrange),
              // Consumer<EasyRefresh>(builder: (context, csmr, child) => PullUpListWraper(contentType: "books")),
              PullUpListWraper(
                contentType: "books",
                // 这里的参数picForYouBooks只能是采用定义在这个_HomPageState()类中了，然后在上拉加载的操作时，onLoad()回调函数中通过回调setState()来操作这个数据，并因此（setSate)
                // 引发Widget树的相应buid()方法来重绘，没办法到PullUpListWraper的相同instance中去setState()。
                pickBooks: pickForYouBooks,
              ),
            ],
          ),
          onLoad: () {
            print("开始onLoad...");
            setState(
              () {
                // 关于pickForYouBooks的说明，见前面几行的注释。
                // 此处即是利用onLoad()事件回调函数来调用setState()方法，进而在此处调用fetchNewGoods()这个抽象的数据获取函数。
                // ！！注意：这里then()中的变量bs，不需要显式声明，它是fetchNewGoods()的返回值
                fetchNewgoods().then(
                  (bs) {
                    pickForYouBooks.addAll(bs);
                    for (var b in pickForYouBooks) {
                      print('书名：${b.title}, 封面图片：${b.cover}');
                    }
                    print(
                        "===========更新后的picBooks有${pickForYouBooks.length}本书===============");
                  },
                );
              },
            );
            //PullUpListWraper().
            // GetNewGoods().fetchNewgoods();
          },
          onRefresh: () {
            print("开始onRefresh...");
          },
        ),
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
          try {
            if (_scrollController.hasClients) {
              print("我要回到Top啦!");
              _scrollController.animateTo(0.0,
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.fastOutSlowIn);
            }
            // else {
            //   print("XXXXXXXXX");
            // }
          } catch (e) {
            print("回不去Top T-T $e");
            throw ("回不去Top T-T $e");
          }
        },
      ),

      // bottomNavigationBar:
      // // StyleProvider(
      //   // style: Style(),
      //   // child:
      //   ConvexAppBar(
      //     style: TabStyle.textIn,
      //     // backgroundColor: ThemeData().canvasColor,
      //     backgroundColor: Colors.deepOrange,
      //     initialActiveIndex: currIndex,
      //     items: btmNavBarItms,
      //     onTap: (index) {
      //       setState(
      //         () {
      //           currIndex = index;
      //           Text("点击了$index");
      //           print("点击了$index");
      //         },
      //       );
      //     },
      //   ),
    );
  }

  // 此函数是上拉加载数据的关键函数，之前将其定义在PullUpListWraper类中，
  // 但那样没法在那个类的外部通过上拉来触发和设定该类的相关State，从而无法将已加载的数据重绘在该Widget上，
  // 即，无法触发该Widget的build方法来重绘。
  // 反复研究后，发现应该
  // ！！！*** 1. 将这个方法定义在PullUpListWrap的调用类里，即" _HomePageState "类中；***！！！这一点非常关键，定义在这个位置，决定了可以在该函数
  // 2. 在Easy_refresh控件的OnLoad()回调函数中，异步调用setState()，并在setState()函数中调用这个_fetchNewGoods()，达到
  // 2.1. 既能获取到新数据
  // 2.2. 又能setState()，达到加载完新数据后，触发重绘UI的目的
//   void _fetchNewgoods() {
//     print("被上拉动作触发加载新数据");

//     // var formPage = {'page': page};
//     createBookListData().then((bks) {
//       try {
//         print("=====图书数量====: ${bks.length}");
//         // 调用reccomendBooks方法，从图书列表中取出6本书作为新加载的书
//         List<Book> recBooks = recommendList(list: bks, num: 6);
//         // setState(() {
//           //为了做出上拉继续加载的效果，这里没有一次性加载所有的图书

//           pickBooks.addAll(recBooks);
//           renameBookName();

//           // page++;
//           // print("####PAGE####: $page");
//         // });

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
}
// class Style extends StyleHook {
//   @override
//   double get activeIconSize => 40;

//   @override
//   double get activeIconMargin => 10;

//   @override
//   double get iconSize => 20;

//   @override
//   TextStyle textStyleT(Color color) {
//     return TextStyle(fontSize: 20, color: color);
//   }
// }
