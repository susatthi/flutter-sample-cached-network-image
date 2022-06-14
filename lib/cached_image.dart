import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

class CachedImage extends StatelessWidget {
  const CachedImage({
    super.key,
    required this.url,
    this.size = 80,
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

  /// CacheManager
  CacheManager get _defaultCacheManager => CacheManager(
        Config(
          'CachedImageKey',
          stalePeriod: const Duration(days: 1),
          maxNrOfCacheObjects: 20,
        ),
      );

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      cacheManager: cacheManager ?? _defaultCacheManager,
      height: size,
      width: size,
      imageUrl: url,
      imageBuilder: (context, imageProvider) {
        return Stack(
          children: [
            Image(image: imageProvider),
            Positioned(
              right: 2,
              bottom: 2,
              child: Text(
                name ?? '',
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
        return Icon(
          Icons.error,
          size: size,
        );
      },
    );
  }
}
