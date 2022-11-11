import 'dart:html';

late InputElement todoInput;
late DivElement uiList;
late ButtonElement buttonClear;

List<Todo> todoList = [];

void main() async {
  todoInput = querySelector('#todo') as InputElement;
  uiList = querySelector('#todo-list') as DivElement;
  buttonClear = querySelector('#clear') as ButtonElement;
  
}

class Todo {
  int id = 0;
  final String text;
  Todo(
    this.text,
  ) {
    id++;
  }
}
