import 'dart:html';

late InputElement todoInput;
late DivElement uiList;
late ButtonElement buttonClear;

List<Todo> todoList = [];
void main() async {
  todoInput = querySelector('#todo') as InputElement;
  uiList = querySelector('#todo-list') as DivElement;
  buttonClear = querySelector('#clear') as ButtonElement;
  todoInput.onChange.listen(addTodo);

  buttonClear.onClick.listen(removeAlltodos);
  // updateTodos(new Todo('nothing'));
  // updateTodos(new Todo('nothing two'));
}

void addTodo(Event event) {
  Todo todo = Todo(todoInput.value.toString());
  todoList.add(todo);
  updateTodos(todo);
  todoInput.value = '';
}

void updateTodos(Todo todo) {
  // uiList.children.clear();
  // todoList.forEach((todo) {
  Element div = Element.div();
  ButtonElement buttonRemove = ButtonElement();
  InputElement inputAddTask = InputElement();
  Element span = Element.span();
  HRElement separator = HRElement();
  Element todoTasks = Element.div();
  String todoId = todo.id.toString();
  div.id = 'todo-$todoId';
  buttonRemove.text = 'X';
  buttonRemove.id = todo.id.toString();
  buttonRemove.onClick.listen((event) => removeTodo('todo-$todoId'));
  inputAddTask.onChange.listen((event) {
    todo.tasks.add(inputAddTask.value.toString());
    showTasks('todo-$todoId', inputAddTask.value.toString());
    inputAddTask.value = '';
  });
  String todoText = todo.text;
  span.text = '$todoId $todoText';

  div.children.add(buttonRemove);
  div.children.add(span);

  div.children.add(todoTasks);
  div.children.add(inputAddTask);
  div.children.add(separator);

  // div.children.add(div);
  uiList.children.add(div);
}
// addStorage(todoList);

void showTasks(String todoId, String taskName) {
  print(todoId);
  DivElement todoElement = querySelector('#$todoId') as DivElement;
  DivElement tasksList = todoElement.children[2] as DivElement;
  Element task = Element.div();
  task.text = taskName;
  tasksList.children.add(task);
}

void removeTodo(String todoId) {
  uiList.children.removeWhere((element) => element.id == todoId);
}

void removeAlltodos(MouseEvent event) {
  uiList.children.clear();
  todoList.clear();

  // print(todoList);
}

class Todo {
  static int counter = 0;

  int id = 0;
  final String text;
  List<String> tasks = <String>[];
  Todo(this.text) {
    counter++;
    id = counter;
  }
}
