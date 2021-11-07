import 'package:flutter/material.dart';

import 'animated_stream_list/animated_stream_list.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter Widgets'),
      ),
      body: ListView(
        children: [
          ListTile(
            title: const Text('Animated Stream List Demo'),
            onTap: () {
              show(context, const AnimatedStreamListDemoPage());
            },
          ),
        ],
      ),
    );
  }

  void show(BuildContext context, Widget page) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => page),
    );
  }
}
