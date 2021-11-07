import 'package:flutter/material.dart';

import 'pages/home.page.dart';

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Animated Stream List example',
      home: HomePage(),
    );
  }
}
