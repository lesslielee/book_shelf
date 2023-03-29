import 'dart:io';
import 'dart:math';
import 'package:book_shelf/sources/data_sources.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:glassmorphism/glassmorphism.dart';
import '../pages/details_page.dart';

/// 20230327 - 基本解决

// 为每一本图书做一个毛玻璃效果的卡片式展示（类似名片：左边为封面图片，右边从上至下摆放书名、作者和收藏数）
class CarouselCard extends StatelessWidget {
  final Book book;
  const CarouselCard({required this.book, super.key});

  @override
  Widget build(BuildContext context) {
    return GlassmorphicContainer(
      //毛玻璃效果
      width: ScreenUtil().setWidth(300),
      height: ScreenUtil().setHeight(170),
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
                width: ScreenUtil().setWidth(100),
                height: ScreenUtil().setHeight(160),
                fit: BoxFit.fitWidth,
              ),
            ),
            SizedBox(
              width: ScreenUtil().setWidth(170),
              height: ScreenUtil().setHeight(160),
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
                        overflow: TextOverflow.clip,
                      ),
                    ),
                    Text(
                      //作者
                      book.author,
                      style: const TextStyle(
                        fontSize: 13,
                        fontStyle: FontStyle.italic,
                        overflow: TextOverflow.clip,
                      ),
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

/// CarouselSwiperAuto util - with small dot indicator below the cards
/// <-自动->跑马灯推荐块，内嵌的是CarouselCard(毛玻璃效果的card)
/// 需要修改的可变参数：
///       num - 书的数量
///       内嵌card的类型，

class CarouselSwiperAuto1 extends StatefulWidget {
  const CarouselSwiperAuto1({super.key});

  @override
  State<CarouselSwiperAuto1> createState() => _CarouselSwiperAuto1State();
}

class _CarouselSwiperAuto1State extends State<CarouselSwiperAuto1> {
  List<Book> recBooks = [
    Book(
      title: "The Road Ahead",
      author: "Bill Gates",
      cover: "lib/images/pop_books/Pop011.jpg",
      category: "tech",
      details: "This is a book from 1995...",
    ),
  ];
  List<CarouselCard> carouselCards = [];
  int _current = 0;
  final CarouselController _controller = CarouselController();

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
            recBooks = recommendBooks(books: bks, num: 5);
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

      //Initialize CarouselCards
      for (var b in recBooks) {
        carouselCards.add(CarouselCard(book: b));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: CarouselSlider(
            items: carouselCards, //这里为嵌入的展示卡片的widget列表
            // [
            //   CarouselCard(book: recBooks[0]),
            //   CarouselCard(book: recBooks[1]),
            //   CarouselCard(book: recBooks[2]),
            //   CarouselCard(book: recBooks[3]),
            //   CarouselCard(book: recBooks[4]),
            // ],
            options: CarouselOptions(
              height: ScreenUtil().setHeight(140.0),
              aspectRatio: 16 / 9,
              viewportFraction: 0.8,
              initialPage: 0,
              enableInfiniteScroll: true,
              reverse: false,
              autoPlay: true,

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
        //这个Row里嵌入的是与上面跑马灯卡片索引对应的小点点
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: carouselCards.asMap().entries.map(
            (entry) {
              return GestureDetector(
                onTap: () => _controller.animateToPage(entry.key), //这里似乎还有些不正常，点击后，后台会报错，前台没反应 20230328 - 待研究学习
                child: Container(
                  width: 12.0,
                  height: 12.0,
                  margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: (Theme.of(context).brightness == Brightness.dark
                            ? Colors.white
                            : Colors.black)
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

// 建立一个横向滑动的ListView，用于装载指定数量的CarouselCard,传入参数为Book instance和num
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
            recBooks = recommendBooks(books: bks, num: 5);
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
            child: CarouselCard(book: recBooks[index]),
          );
        },
      ),
    );
  }
}
