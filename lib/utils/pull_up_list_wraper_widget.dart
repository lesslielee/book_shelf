import 'package:book_shelf/pages/home_page.dart';
import 'package:flutter/material.dart';
import 'package:easy_refresh/easy_refresh.dart';
import 'package:provider/provider.dart';

import '../sources/data_sources.dart';
import '../utils/comm_utils.dart';
import '../pages/index_page.dart';

///用于上拉持续加载的控件 20230330
///

// class GetNewGoods with ChangeNotifier {
//   void fetchNewgoods() {
//     print("被上拉动作触发加载新数据");

//     // var formPage = {'page': page};
//     createBookListData().then((bks) {
//       try {
//         print("=====图书数量====: ${bks.length}");
//         // 调用reccomendBooks方法，从图书列表中取出6本书作为新加载的书
//         List<Book> recBooks = recommendList(list: bks, num: 6);
//         //为了做出上拉继续加载的效果，这里没有一次性加载所有的图书
//         pickBooks.addAll(recBooks);
//         renameBookName();
//         // page++;
//         // print("####PAGE####: $page");
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

//       notifyListeners();
//     });
//   }
// }

class PullUpListWraper extends StatefulWidget {
  final String contentType;
  List<Book> pickBooks = [];
  // final bool pullup;
  PullUpListWraper(
      {required this.contentType, required this.pickBooks, Key? key})
      : super(key: key);

  @override
  State<PullUpListWraper> createState() => _PullUpListWraperState();
}

// List<Book> pickBooks = [];

// void renameBookName() {
//   for (int i = 0; i < pickBooks.length; i++) {
//     if (!pickBooks[i].title.contains('_')) {
//     pickBooks[i].title = "${i}_${pickBooks[i].title}";
//     }
//   }
// }

class _PullUpListWraperState extends State<PullUpListWraper> {
  List<CommonCard1> bookCards = [];
  int page = 1;
  late String _contentType;
  List<Book> _pickBooks = [];
  // bool _pullup = false;

  // void trigerToGetNewGoods() {
  //   Consumer<GetNewGoods> (builder: (context, value, child) {

  //   },);
  // }

  // GlobalKey<_PullUpListWraperState> pullUpWraperKey = GlobalKey<_PullUpListWraperState>();

  // void _getNewGoods() {
  //   var formPage = {'page': page};
  //   createBookListData().then(
  //     (bks) {
  //       try {
  //         print("=====图书数量====: ${bks.length}");
  //         setState(
  //           () {
  //             // 调用reccomendBooks方法，从图书列表中取出6本书作为新加载的书
  //             List<Book> recBooks = recommendList(list: bks, num: 6);
  //             //为了做出上拉继续加载的效果，这里没有一次性加载所有的图书
  //             _pickBooks.addAll(recBooks);
  //             // renameBookName(); //修改一下book title，方便在UI上看到提取到的书本数量
  //             page++;
  //             print("####PAGE####: $page");
  //             for (var b in _pickBooks) {
  //               print('书名：${b.title}, 封面图片：${b.cover}');
  //             }
  //           },
  //         );
  //       } catch (e) {
  //         print("====>生成推荐图书失败！<=====");
  //         throw ("推荐图书失败: Error $e");
  //       }
  //       print(_pickBooks.length);
  //     },
  //   );
  // }

  @override
  void initState() {
    super.initState();
    //Future<List<Book>> bs;
    _contentType = widget.contentType;
    _pickBooks = widget.pickBooks;
    List<Book> tmpBooks = [];
    print("重新加载HomePage数据...");
    createBookListData().then((bs) {
        try {
          print("=====图书数量====: ${bs.length}");
          setState(
            () {
              // 调用reccomendBooks方法，从图书列表中取出5本书作为推荐图书
              tmpBooks = recommendList(list: bs, num: 6);
              tmpBooks = renameBookName(tmpBooks);
              for (var b in tmpBooks) {
                print('书名：${b.title}, 封面图片：${b.cover}');
              }
            },
          );
        } catch (e) {
          print("====>生成推荐图书失败！<=====");
          throw ("推荐图书失败: Error $e");
        }
        _pickBooks.addAll(tmpBooks);
        // print('_pickBooks.length: ${pickBooks.length}\npickBooks.length: ${pickBooks.length}');
 
    });
    //  () async {

    // setState(() {
    //   fetchNewgoods();
    //   print("setState了");
    //   print("pickBooks.length = ${pickBooks.length}");
    //   print("_pickBooks.length = ${_pickBooks.length}");
    // });
    // };
  }

  // if (_contentType == "books") {
  //   _getNewGoods();
  //   //   createBookListData().then(
  //   //     (bks) {
  //   //       try {
  //   //         print("=====图书数量====: ${bks.length}");
  //   //         setState(
  //   //           () {
  //   //             // 调用reccomendBooks方法，从图书列表中取出6本书作为新加载的书
  //   //             List<Book> recBooks = recommendList(list: bks, num: 6);
  //   //             //为了做出上拉继续加载的效果，这里没有一次性加载所有的图书
  //   //             pickBooks.addAll(recBooks);
  //   //             for (var b in pickBooks) {
  //   //               print('书名：${b.title}, 封面图片：${b.cover}');
  //   //             }
  //   //           },
  //   //         );
  //   //       } catch (e) {
  //   //         print("====>生成推荐图书失败！<=====");
  //   //         throw ("推荐图书失败: Error $e");
  //   //       }
  //   //       print(pickBooks.length);
  //   //     },
  //   //   );
  //   // } else {
  //   //   //如果将来需要展示其他类型的数据，可以在这里添加
  //   //   Placeholder;
  // }

  @override
  Widget build(BuildContext context) {
    // print("它俩相同吗？_pickBooks = pickBooks? : ${identical(_pickBooks, pickBooks)}");
    return Wrap(
      spacing: 2,
      // children: _contentType=="books"? _wrapList(pickBooks): xxx,
      children: _wrapList(_pickBooks),
    );
  }

  ///返回一个_wrapList，用于
  List<Widget> _wrapList<T>(List<T> inputList) {
    List<Widget> listWidget = [];

    if (inputList.isNotEmpty) {
      if (T == Book) {
        //传入Book类型元素，生成CommonCard1类型的Widget列表用于展示
        for (Book bk in inputList as List<Book>) {
          CommonCard1 card = CommonCard1(book: bk);
          listWidget.add(card);
        }
      } else {
        //如果将来想实现Book以外的其他类型元素列表展示，可以在这里实现
        Placeholder;
      }
      return listWidget;
    } else {
      print("Error: Empty inputList");
      return listWidget;
    }
  }
}
