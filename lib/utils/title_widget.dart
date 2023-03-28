import 'package:flutter/material.dart';

class TitleWidget extends StatelessWidget {
  final String title;
  final Color titleColor;
  const TitleWidget({required this.title, required this.titleColor, super.key});

  Widget _titleWidget({required String title, required Color titleColor}) {
    return Container(
      alignment: Alignment.centerLeft,
      padding: const EdgeInsets.fromLTRB(10.0, 5.0, 0, 5.0),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(
            width: 2,
            color: Colors.black12,
          ),
        ),
      ),
      child: Text(
        title,
        style: TextStyle(
          color: titleColor,
          fontSize: 15,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _titleWidget(title: title, titleColor: titleColor);
  }
}
