// ignore_for_file: depend_on_referenced_packages

import 'package:cached_network_image/cached_network_image.dart';
import 'package:file/local.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

void main() {
  testWidgets('画像が表示されるはず', (tester) async {
    await tester.runAsync(() async {
      ImageProvider? receiveImageProvider;
      await tester.pumpWidget(
        CachedNetworkImage(
          imageUrl: 'https://avatars.githubusercontent.com/u/13707135?v=4',
          cacheManager: MockCacheManager(),
          imageBuilder: (context, imageProvider) {
            receiveImageProvider = imageProvider;
            return Image(
              image: imageProvider,
            );
          },
        ),
      );
      // 画像が読み込まれるまで待つ
      await Future<void>.delayed(const Duration(seconds: 1));
      await tester.pump();
      expect(receiveImageProvider, isNotNull);
    });
  });
}

class MockCacheManager extends Mock implements DefaultCacheManager {
  static const fileSystem = LocalFileSystem();

  @override
  Stream<FileResponse> getImageFile(
    String url, {
    String? key,
    Map<String, String>? headers,
    bool withProgress = false,
    int? maxHeight,
    int? maxWidth,
  }) async* {
    yield FileInfo(
      // ローカルのファイルを読み込んで返す
      fileSystem.file('./test/assets/13707135.png'),
      FileSource.Cache,
      DateTime(2050),
      url,
    );
  }
}
