import 'dart:async';

import 'todo.dart';

class TodoListController {
  final List<Todo> _list = [];
  final _controller = StreamController<List<Todo>>();

  TodoListController() {
    _controller.add(_list);
  }

  Stream<List<Todo>> get stream => _controller.stream;

  void add(Todo todo) {
    _list.add(todo);
    _list.sort();
    _controller.add(_list);
  }

  void remove(int index) {
    _list.removeAt(index);
    _controller.add(_list);
  }

  void toggle(int index) {
    _list[index].done = !_list[index].done;
    _controller.add(_list);
  }

  void dispose() {
    _controller.close();
  }
}
