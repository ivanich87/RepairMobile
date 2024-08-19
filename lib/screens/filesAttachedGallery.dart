import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

typedef PageChanged = void Function(int index);

class scrFilesAttachedGallery extends StatefulWidget {
  final List imageItems; // Picture List
  final int defaultIndex; //
  //final PageChanged pageChanged; // Switch the picture to call back
  final Axis direction; // Picture View direction

  scrFilesAttachedGallery(
      {required this.imageItems,
        required this.defaultIndex,
        //required this.pageChanged,
        this.direction = Axis.horizontal})
      : assert(imageItems != null);
  @override
  _scrFilesAttachedGalleryState createState() => _scrFilesAttachedGalleryState();
}

class _scrFilesAttachedGalleryState extends State<scrFilesAttachedGallery> {
  int currentIndex=1;

  @override
  void initState() {
    super.initState();
    // TODO: implement initState
    currentIndex = widget.defaultIndex;
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Stack(
        children: [
          Container(
              child: PhotoViewGallery.builder(
                  scrollPhysics: const BouncingScrollPhysics(),
                  builder: (BuildContext context, int index) {
                    return PhotoViewGalleryPageOptions(
                      imageProvider: NetworkImage(widget.imageItems[index]),
                      initialScale: PhotoViewComputedScale.contained,
                      minScale: PhotoViewComputedScale.contained * 0.8,
                      maxScale: PhotoViewComputedScale.covered * 2,
                      heroAttributes: PhotoViewHeroAttributes(tag: widget.imageItems[index]),
                    );
                  },
                  scrollDirection: widget.direction,
                  itemCount: widget.imageItems.length,
                  backgroundDecoration: BoxDecoration(color: Colors.black),
                  pageController: PageController(initialPage: widget.defaultIndex),
                  onPageChanged: (index) => setState(() {
                    currentIndex = index;
                    // if (widget.pageChanged != null) {
                    //   widget.pageChanged(index);
                    // }
                  }))),
          Positioned(
            bottom: 20,
            child: Container(
                alignment: Alignment.center,
                width: MediaQuery.of(context).size.width,
                child: Text("${currentIndex + 1}/${widget.imageItems.length}",
                    style: TextStyle(
                      decoration: TextDecoration.none,
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      shadows: [
                        Shadow(color: Colors.black, offset: Offset(1, 1)),
                      ],
                    ))),
          ),
          Positioned (// Close in the upper right corner
            top: 40,
            right: 40,
            child: Container(
              alignment: Alignment.centerLeft,
              width: 20,
              child: GestureDetector(
                onTap: () {
                  // Hidden preview
                  Navigator.pop(context);
                },
                child: Icon(Icons.close_rounded, color: Colors.white),
              ),
            ),
          ),
          Positioned (// quantity display
            right: 20,
            top: 20,
            child: Text(
              '${currentIndex + 1}/${widget.imageItems.length}',
              style: TextStyle(color: Colors.black),
            ),
          )
        ],
      ),
    );
  }
}