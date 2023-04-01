import 'dart:io';
import 'dart:math';
import 'package:book_shelf/sources/data_sources.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:glassmorphism/glassmorphism.dart';

import '../pages/details_page.dart';
import './comm_utils.dart';

///

/// CarouselSwiperAuto1 util - with small dot indicator below the cards
/// <-自动->跑马灯推荐块，内嵌的是GlassmorpicCard(毛玻璃效果的card)
/// 需要修改的可变参数：
///       num - 书的数量
///       内嵌card的类型，

class CarouselSwiperAuto1 extends StatefulWidget {
  //====目前支持的contentType为"GlassmorpicCards", "pictures"====
  final String contentType;

  const CarouselSwiperAuto1({required this.contentType, super.key});

  @override
  State<CarouselSwiperAuto1> createState() => _CarouselSwiperAuto1State();
}

class _CarouselSwiperAuto1State extends State<CarouselSwiperAuto1> {
  late String _contentType;

  List<Book> recBooks = [
    Book(
      title: "The Road Ahead",
      author: "Bill Gates",
      cover: "lib/images/pop_books/Pop011.jpg",
      category: "tech",
      details: "This is a book from 1995...",
    ),
  ];
  List<GlassmorpicCard> carouselCards = []; //跑马灯卡片Widget列表
  List<String> recPictureNames = []; //推荐图片文件名列表
  List<Image> pictureImages = []; //推荐图片Image Widget列表
  List<Widget> widgetList = []; //widgetList指针，用于在加载跑马灯时，传入该指针来动态选择需展示的列表
  bool showIndicators = true; // 是否显示跑马灯下面的指示灯Indicators

  // 为了能让展示不同的Widget List有不同的展现形式，让不同的Widget List入参给如下几个参数设置不同的值，以达到目的，下面是这几个选项的初始值，
  // 在各个不同的Wdidget List的initState中，对它们做各自的修改。
  bool isAutoPlay = true;
  double viewportFraction = 0.8;

  int _current = 0;
  final CarouselController _controller = CarouselController();

  @override
  void initState() {
    super.initState();
    // get the contentType of the StatefulWidget
    // 根据给定的contentType，来决定用Carousel_Slider展示什么内容，initState方法中也对应初始化不同的数据列表，作为展示内容的数据源
    _contentType = widget.contentType;
    if (_contentType == "carouselCards") {
      //要展示的内容为carouselCard，即前面carourselCard类创建的毛玻璃卡片式的图书展示方式
      createBookListData().then((bks) {
        try {
          print("=====图书数量====: ${bks.length}");
          setState(
            () {
              // 调用reccomendBooks方法，从图书列表中取出5本书作为推荐图书
              recBooks = recommendList(list: bks, num: 5);
              for (var b in recBooks) {
                print('书名：${b.title}, 封面图片：${b.cover}');
              }
            },
          );
        } catch (e) {
          print("====>生成推荐图书失败！<=====");
          throw ("推荐图书失败: Error $e");
        }
        print(recBooks.length);

        //Initialize GlassmorpicCards
        for (var b in recBooks) {
          carouselCards.add(GlassmorpicCard(book: b));
        }
        // 以下为各个展示列表各自的个性化设置，前面也给出了默认值
        isAutoPlay = true;
        viewportFraction = 0.8;
        widgetList = carouselCards;
        showIndicators = true;
      });
    } else if (_contentType == "pictures") {
      //要展示的内容为pictures，即要展示一些图片列表
      createPictureList().then((pictures) {
        try {
          print("====图片数量====: ${pictures.length}");
          setState(() {
            recPictureNames = recommendList(list: pictures, num: 6);

            for (var p in recPictureNames) {
              pictureImages.add(
                Image.asset(p,
                    width: ScreenUtil().setWidth(750),
                    height: ScreenUtil().setHeight(300),
                    fit: BoxFit.fitWidth),
              );
              print('图片: ${p}');
            }
            // 以下为各个展示列表各自的个性化设置，前面也给出了默认值
            isAutoPlay = false;
            viewportFraction = 1.0;
            widgetList = pictureImages;
            showIndicators = false;
          });
        } catch (e) {
          print("====>生成推荐图片列表失败！<=====");
          throw ("推荐图片列表失败: Error $e");
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // 为了避免这个Exception "Another exception was thrown: LateInitializationError: Field 'widgetList' has not been initialized."
    // 但似乎还是因为异步获取数据延迟的原因，并没有解决这个问题 20230329
    if (carouselCards.isNotEmpty || pictureImages.isNotEmpty) {
      widgetList = _contentType == "carouselCards" ? carouselCards : pictureImages;
    }
    return Column(
      children: [
        Expanded(
          child: CarouselSlider(
            //items: carouselCards, //这里为嵌入的展示卡片的widget列表
            items: _contentType == "carouselCards"
                ? carouselCards
                : pictureImages, //这里为嵌入的展示卡片或者图片的widget列表 20230328 修改为可以支持两种不同类型Widget列表的传入参数，作为展示
            // [
            //   GlassmorpicCard(book: recBooks[0]),
            //   GlassmorpicCard(book: recBooks[1]),
            //   GlassmorpicCard(book: recBooks[2]),
            //   GlassmorpicCard(book: recBooks[3]),
            //   GlassmorpicCard(book: recBooks[4]),
            // ],
            options: CarouselOptions(
              height: ScreenUtil().setHeight(300.0),
              aspectRatio: 16 / 9,
              viewportFraction: viewportFraction,
              initialPage: 0,
              enableInfiniteScroll: true,
              reverse: false,
              autoPlay: isAutoPlay,
              autoPlayInterval: Duration(seconds: 3),
              autoPlayAnimationDuration: Duration(microseconds: 800),
              autoPlayCurve: Curves.bounceIn,
              enlargeCenterPage: true,
              enlargeFactor: 0.3,
              onPageChanged: (index, reason) {
                setState(
                  () {
                    _current = index;
                  },
                );
              },
              scrollDirection: Axis.horizontal,
            ),
          ),
        ),
        // 这个Row()里嵌入的是与上面跑马灯卡片索引对应的小点点(Indicators)
        // 这里用一个三目运算符来决定是否显示跑马灯下面的Indicators,
        // ！！！SizeBox.shrink()是一个占用空间size为0的“占位Widget”，刚好用来做这个三目运算符的一个处理选项！！！
        !showIndicators
            ? const SizedBox.shrink()
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                // 这里
                // children: carouselCards.asMap().entries.map(
                children: widgetList.isEmpty? []: widgetList.asMap().entries.map(
                  (entry) {
                    return GestureDetector(
                      onTap: () => _controller.animateToPage(entry
                          .key), //这里似乎还有些不正常，点击后，后台会报错，前台没反应 20230328 - 待研究学习
                      child: Container(
                        width: 12.0,
                        height: 12.0,
                        margin: EdgeInsets.symmetric(
                            vertical: 8.0, horizontal: 4.0),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: (Theme.of(context).brightness ==
                                      Brightness.dark
                                  ? Colors.white
                                  : Colors.deepOrange)
                              .withOpacity(_current == entry.key ? 0.9 : 0.4),
                        ),
                      ),
                    );
                  },
                ).toList(),
              ),
      ],
    );
  }
}

// 建立一个横向滑动的ListView，用于装载指定数量的GlassmorpicCard,传入参数为Book instance和num
class CarouselSwiper extends StatefulWidget {
  const CarouselSwiper({super.key});

  @override
  State<CarouselSwiper> createState() => _CarouselSwiperState();
}

class _CarouselSwiperState extends State<CarouselSwiper> {
  List<Book> recBooks = [
    Book(
      title: "The Road Ahead",
      author: "Bill Gates",
      cover: "lib/images/pop_books/Pop011.jpg",
      category: "tech",
      details: "This is a book from 1995...",
    ),
  ];
  @override
  void initState() {
    //List<Book> bks =
    super.initState();
    createBookListData().then((bks) {
      try {
        print("=====图书数量====: ${bks.length}");
        setState(
          () {
            // 调用reccomendBooks方法，从图书列表中取出5本书作为推荐图书
            recBooks = recommendList(list: bks, num: 5);
            for (var b in recBooks) {
              print('书名：${b.title}, 封面图片：${b.cover}');
            }
          },
        );
      } catch (e) {
        print("====>生成推荐图书失败！<=====");
        throw ("推荐图书失败: Error $e");
      }
    });
    print(recBooks.length);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 180,
      padding: EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 8.0),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: recBooks.length,
        itemBuilder: (context, index) {
          Book bk = recBooks[index];
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DetailsView(bk: bk),
                ),
              );
            },
            child: GlassmorpicCard(book: recBooks[index]),
          );
        },
      ),
    );
  }
}
