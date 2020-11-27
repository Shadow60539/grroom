import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

class ImageHolder extends StatefulWidget {
  @override
  _ImageHolderState createState() => _ImageHolderState();
}

class _ImageHolderState extends State<ImageHolder> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: CarouselSlider.builder(
        options: CarouselOptions(
          viewportFraction: 0.95,
          height: MediaQuery.of(context).size.height * 0.7,
        ),
        itemCount: 2,
        itemBuilder: (BuildContext context, int itemIndex) =>
          Container(
            padding: EdgeInsets.all(10.0),
            child: itemIndex == 0 ? Image.asset('assets/designer.jpg') : Image.asset("assets/designer-men.jpg")
          ),
      )
    );
  }
}