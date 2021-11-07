import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_widgets/flutter_widgets.dart';

import 'todo.dart';
import 'controller.dart';

class AnimatedStreamListDemoPage extends StatefulWidget {
  const AnimatedStreamListDemoPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _AnimatedStreamListDemoPageState();
}

class _AnimatedStreamListDemoPageState extends State<AnimatedStreamListDemoPage> {
  int _lastId = 0;
  final _todoBloc = TodoListController();

  @override
  void dispose() {
    _todoBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Animated Stream List"),
      ),
      body: SafeArea(
        child: AnimatedStreamList<Todo>(
          streamList: _todoBloc.stream,
          itemBuilder: (_, todo, index, animation) => _buildItem(todo, index, animation),
          itemRemovedBuilder: (_, todo, index, animation) =>
              _buildItem(todo, index, animation, true),
          equals: (todo1, todo2) => todo1.changedAt == todo2.changedAt,
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _lastId++;
          _todoBloc.add(Todo(title: 'Title $_lastId', content: 'Content $_lastId'));
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildItem(Todo todo, int index, Animation<double> animation, [bool isRemoved = false]) {
    TextStyle? textStyle =
        todo.done ? const TextStyle(decoration: TextDecoration.lineThrough) : null;
    Widget trailing = isRemoved
        ? const Icon(Icons.delete)
        : IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () => _todoBloc.remove(index),
          );

    return SizeTransition(
      axis: Axis.vertical,
      sizeFactor: animation,
      child: Card(
        child: ListTile(
          leading: Checkbox(
            value: todo.done,
            onChanged: isRemoved ? null : (_) => _todoBloc.toggle(index),
          ),
          title: Text(todo.title, style: textStyle),
          subtitle: Text(todo.content, style: textStyle),
          trailing: trailing,
        ),
      ),
    );
  }
}
