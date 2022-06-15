import 'package:flutter/material.dart';

import 'cached_image.dart';

void main() {
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter Demo Home Page'),
      ),
      body: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4,
          childAspectRatio: 1,
        ),
        itemBuilder: (context, index) {
          // キャッシュから取得するのかネットワークから取得するのか動きを見やすくするために
          // URL毎にキャッシュするのでクエリを付けて40種類のURLにする
          final no = index % 40;
          return Center(
            child: CachedImage(
              url:
                  'https://avatars.githubusercontent.com/u/13707135?v=4&index=${no + 1}',
              name: '${no + 1}',
            ),
          );
        },
        itemCount: 400,
      ),
    );
  }
}
