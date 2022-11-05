import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

class PhotoFullScreenView extends StatefulWidget {
  const PhotoFullScreenView({super.key, required this.image});

  final String? image;

  @override
  State<PhotoFullScreenView> createState() => _PhotoFullScreenViewState();
}

class _PhotoFullScreenViewState extends State<PhotoFullScreenView> {
  static final customCacheManager = CacheManager(
    Config(
      'customCacheKey',
      maxNrOfCacheObjects: 200,
      stalePeriod: const Duration(days: 2),
    ),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
      ),
      body: PhotoView(
        imageProvider: CachedNetworkImageProvider(
          widget.image.toString(),
          cacheManager: customCacheManager,
        ),
      ),
    );
  }
}
