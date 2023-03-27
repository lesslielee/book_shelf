import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import '../utils/carousel_swiper.dart';
import 'package:http/http.dart' as http;

class IndexPage extends StatelessWidget {
  final String title;
  const IndexPage({required this.title, super.key});

  @override
  Widget build(BuildContext context)  {
   return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Container(
        child: CarouselSwiper(),//key: key),
          
      ),
    );
  }
}


/// The CarouseSlider on the top of the page 在页面最上方的跑马灯
class TopCarouseSlider extends StatefulWidget {
  const TopCarouseSlider({super.key});

  @override
  State<TopCarouseSlider> createState() => _TopCarouseSliderState();
}

class _TopCarouseSliderState extends State<TopCarouseSlider> {

  // The Card item of the CarouseSlider
  Widget _carouseCard(index) {
    return InkWell(
      onTap: () {
        //
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          gradient: LinearGradient(
            stops: [0.02, 0.02],
            colors: [Colors.black12, Colors.white],
          ),
          borderRadius: BorderRadius.circular(15),
        ),
      ),
    );
  }
  
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}