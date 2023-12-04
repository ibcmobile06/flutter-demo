import 'package:flutter/material.dart';

class ProductView extends StatelessWidget {
  ProductView(
      {super.key,
      required this.image,
      required this.title,
      required this.subTitle});

  String image, title, subTitle;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ListTile(
        leading: Container(
          decoration: BoxDecoration(shape: BoxShape.circle),
          child: Image.network(
            image,
            fit: BoxFit.contain,
          ),
        ),
        title: Text(title),
        subtitle: Text(subTitle),
      ),
    );
  }
}
