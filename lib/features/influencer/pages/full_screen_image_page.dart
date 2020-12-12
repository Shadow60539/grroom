import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class FullScreenImagePreview extends StatefulWidget {
  final String img;
  final Animation<double> animation;

  const FullScreenImagePreview({Key key, this.img, this.animation})
      : super(key: key);

  @override
  _FullScreenImagePreviewState createState() => _FullScreenImagePreviewState();
}

class _FullScreenImagePreviewState extends State<FullScreenImagePreview> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pop(context);
      },
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
        ),
        backgroundColor: Colors.black,
        body: Center(
          child: Hero(
            tag: widget.img,
            child: FadeTransition(
              opacity: CurvedAnimation(
                parent: widget.animation,
                curve: Interval(0.1, 1.0),
              ),
              child: CachedNetworkImage(
                fit: BoxFit.contain,
                imageUrl: widget.img,
                width: MediaQuery.of(context).size.width * 0.99,
                placeholder: (context, url) => const Center(
                  child: SizedBox(
                      height: 15,
                      width: 15,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      )),
                ),
                errorWidget: (context, url, error) => const Icon(
                  Icons.error,
                  color: Colors.black,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
