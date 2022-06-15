// ignore_for_file: depend_on_referenced_packages

import 'package:file/local.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_sample_cached_network_image/cached_image.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

void main() {
  group('CachedImage', () {
    testWidgets('画像が表示出来るはず', (tester) async {
      await tester.runAsync(() async {
        await tester.pumpWidget(
          MaterialApp(
            home: CachedImage(
              url: 'https://avatars.githubusercontent.com/u/13707135?v=4',
              name: '13707135',
              cacheManager: MockCacheManager(),
            ),
          ),
        );

        final state = tester.state<CachedImageState>(find.byType(CachedImage));

        // CachedImageが表示出来ているはず
        expect(find.byType(CachedImage), findsOneWidget);

        // プログレスバーが表示しているはず
        expect(find.byType(CircularProgressIndicator), findsOneWidget);

        // 画像は表示されていないはず
        expect(find.byKey(state.imageKey), findsNothing);

        // 画像が読み込まれるまで待つ
        await Future.doWhile(() async {
          await Future<void>.delayed(Duration.zero);
          await tester.pump();
          return state.error == null && state.imageProvider == null;
        });

        // 画像が表示されているはず
        expect(find.byKey(state.imageKey), findsOneWidget);
      });
    });
    testWidgets('エラーが表示されるはず', (tester) async {
      await tester.runAsync(() async {
        await tester.pumpWidget(
          MaterialApp(
            home: CachedImage(
              url: 'hoge',
              name: 'hoge',
              cacheManager: MockCacheManager(),
            ),
          ),
        );

        final state = tester.state<CachedImageState>(find.byType(CachedImage));

        // エラーは表示されていないはず
        expect(find.byIcon(Icons.error), findsNothing);

        // エラーになるまで待つ
        await Future.doWhile(() async {
          await Future<void>.delayed(Duration.zero);
          await tester.pump();
          return state.error == null && state.imageProvider == null;
        });

        // エラーが表示されているはず
        expect(find.byIcon(Icons.error), findsOneWidget);
      });
    });
  });
}

/// モック版のCacheManager
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
    if (url == 'https://avatars.githubusercontent.com/u/13707135?v=4') {
      yield FileInfo(
        fileSystem.file('./test/assets/13707135.png'),
        FileSource.Cache,
        DateTime(2050),
        url,
      );
      return;
    }
    throw Exception('Not found');
  }
}
