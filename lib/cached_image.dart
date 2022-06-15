import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

class CachedImage extends StatefulWidget {
  const CachedImage({
    super.key,
    required this.url,
    this.size = 100,
    this.name,
    this.cacheManager,
  });

  /// 画像のURL
  final String url;

  /// サイズ
  final double size;

  /// 名前
  final String? name;

  /// CacheManager
  final CacheManager? cacheManager;

  @override
  CachedImageState createState() => CachedImageState();
}

@visibleForTesting
class CachedImageState extends State<CachedImage> {
  @visibleForTesting
  final imageKey = GlobalKey(debugLabel: 'CachedImage');

  @visibleForTesting
  ImageProvider<Object>? get imageProvider => _imageProvider;
  ImageProvider<Object>? _imageProvider;

  @visibleForTesting
  dynamic get error => _error;
  dynamic _error;

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      cacheManager: widget.cacheManager,
      height: widget.size,
      width: widget.size,
      imageUrl: widget.url,
      imageBuilder: (context, imageProvider) {
        _imageProvider = imageProvider;
        return Stack(
          children: [
            Image(
              key: imageKey,
              image: imageProvider,
            ),
            Positioned(
              right: 2,
              bottom: 2,
              child: Text(
                widget.name ?? '',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        );
      },
      placeholder: (context, url) {
        return Row(
          children: const [
            Spacer(),
            CircularProgressIndicator(),
            Spacer(),
          ],
        );
      },
      errorWidget: (context, url, dynamic error) {
        _error = error;
        return Icon(
          Icons.error,
          size: widget.size,
        );
      },
    );
  }
}
