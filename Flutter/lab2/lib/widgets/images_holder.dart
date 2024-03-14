import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'dart:convert';

class ImagesHolder extends StatefulWidget {
  const ImagesHolder({super.key, required this.images});

  final List<String> images;

  @override
  _ImagesHolderState createState() => _ImagesHolderState();
}

class _ImagesHolderState extends State<ImagesHolder> {
  int _current = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CarouselSlider(
          items: widget.images.map((item) {
            if (item.startsWith('data:image')) {
              return Container(
                child: Center(
                  child: Container(
                    height: 200, // Set a fixed height for the images
                    child: Image.memory(
                      base64Decode(item.split(',')[1]),
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              );
            } else {
              return Container(
                child: Center(
                  child: Container(
                    height: 200, // Set a fixed height for the images
                    child: Image.network(
                      item,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              );
            }
          }).toList(),
          options: CarouselOptions(
              height: 200.0,
              autoPlay: widget.images.length > 1, // Disable autoPlay if only one image
              enableInfiniteScroll: widget.images.length > 1, // Disable infinite scroll if only one image
              enlargeCenterPage: true,
              onPageChanged: (index, reason) {
                setState(() {
                  _current = index;
                });
              }),
        ),
        if (widget.images.length > 1) // Only show the indicator if there's more than one image
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: widget.images.map((url) {
              int index = widget.images.indexOf(url);
              return Container(
                width: 8.0,
                height: 8.0,
                margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 2.0),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _current == index
                      ? Color.fromRGBO(0, 0, 0, 0.9)
                      : Color.fromRGBO(0, 0, 0, 0.4),
                ),
              );
            }).toList(),
          ),
      ],
    );
  }
}
