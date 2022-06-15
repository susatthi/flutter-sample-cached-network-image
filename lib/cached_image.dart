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
    this.useCache = true,
  });

  /// 画像のURL
  final String url;

  /// サイズ
  final double size;

  /// 名前
  final String? name;

  /// CacheManager
  final CacheManager? cacheManager;

  /// キャッシュを使うかどうか
  final bool useCache;

  @override
  CachedImageState createState() => CachedImageState();
}

@visibleForTesting
class CachedImageState extends State<CachedImage> {
  final imageKey = GlobalKey(debugLabel: 'CachedImage');

  ImageProvider<Object>? get imageProvider => _imageProvider;
  ImageProvider<Object>? _imageProvider;

  dynamic get error => _error;
  dynamic _error;

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
    if (!widget.useCache) {
      return Stack(
        children: [
          Image(
            key: imageKey,
            image: NetworkImage(widget.url),
            // loadingBuilder: (context, child, progress) {
            //   if (progress == null) {
            //     return child;
            //   }
            //   return const Center(
            //     child: CircularProgressIndicator(),
            //   );
            // },
          ),
          _ImageName(name: widget.name),
        ],
      );
    }
    return CachedNetworkImage(
      cacheManager: widget.cacheManager ?? _defaultCacheManager,
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
            _ImageName(name: widget.name),
          ],
        );
      },
      // placeholder: (context, url) => const Center(
      //   child: CircularProgressIndicator(),
      // ),
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

class _ImageName extends StatelessWidget {
  const _ImageName({this.name});

  final String? name;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      right: 2,
      bottom: 2,
      child: Text(
        name ?? '',
        style: const TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
