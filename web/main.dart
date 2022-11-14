import 'dart:html';

late DivElement doneUiList;
late InputElement todoInput;
late DivElement uiList;
late ButtonElement buttonClear;
List<Todo> todoList = [];
List<Todo> todoCompleteList = [];
void main() async {
  doneUiList = querySelector('#done') as DivElement;
  todoInput = querySelector('#todo') as InputElement;
  uiList = querySelector('#todo-list') as DivElement;
  buttonClear = querySelector('#clear') as ButtonElement;
  todoInput.onChange.listen(addTodo);

  buttonClear.onClick.listen(removeAlltodos);

  Todo todo1 = new Todo("something");
  Todo todo2 = new Todo("something 2");

  updateTodos(todo1);
  updateTodos(todo2);

  todoList.add(todo1);
  todoList.add(todo2);
}

void addTodo(Event event) {
  Todo todo = Todo(todoInput.value.toString());
  todoList.add(todo);
  updateTodos(todo);
  todoInput.value = '';
}

void updateTodos(Todo todo) {
  Element div = Element.div();
  ButtonElement buttonRemove = ButtonElement();
  InputElement inputAddTask = InputElement();
  Element span = Element.span();
  HRElement separator = HRElement();
  Element todoTasks = Element.div();
  String todoId = todo.id.toString();
  ButtonElement doneButton = ButtonElement();
  InputElement checkbox = InputElement();
  ButtonElement buttonEdit = ButtonElement();

  checkbox.type = 'checkbox';
  checkbox.onChange.listen((event) {
    test(todo.id, event);
  });
  div.id = 'todo-$todoId';
  buttonRemove.text = 'X';
  buttonRemove.className = "fas fa-trash-alt text-danger";
  doneButton.text = 'Done';
  doneButton.className = "text-success";
  doneButton.id = todo.id.toString();
  buttonRemove.id = todo.id.toString();
  buttonEdit.text = 'Edit';
  buttonEdit.className = "pencil";
  buttonEdit.onClick.listen((event) => editTodo('todo-$todoId'));
  doneButton.onClick.listen((event) => todoDone('todo-$todoId'));
  buttonRemove.onClick.listen((event) => removeTodo('todo-$todoId'));
  inputAddTask.onChange.listen((event) {
    todo.tasks.add(inputAddTask.value.toString());
    showTasks('todo-$todoId', inputAddTask.value.toString());
    inputAddTask.value = '';
  });
  String todoText = todo.text;
  span.text = '$todoId $todoText';

  div.children.add(doneButton);
  div.children.add(buttonEdit);

  div.children.add(buttonRemove);
  div.children.add(span);

  div.children.add(todoTasks);
  div.children.add(inputAddTask);
  div.children.add(separator);

  uiList.children.add(div);
}

editTodo(String todoId) {
  Todo todo = removeTodo(todoId);
  todoInput.value = todo.text;
}

void test(int id, Event event) {}

void showTasks(String todoId, String taskName) {
  DivElement todoElement = querySelector('#$todoId') as DivElement;
  DivElement tasksList = todoElement.children[4] as DivElement;
  Element task = Element.div();
  task.text = taskName;
  tasksList.children.add(task);
}

Todo removeTodo(String todoId) {
  late String elementId = todoId.split('-')[1];
  uiList.children.removeWhere((element) => element.id == todoId);
  Todo todo =
      todoList.singleWhere((element) => element.id.toString() == elementId);

  todoList.removeWhere((element) => element.id.toString() == elementId);

  return todo;
}

void removeAlltodos(MouseEvent event) {
  uiList.children.clear();
  todoList.clear();

  // print(todoList);
}

void todoDone(String todoId) {
  Todo todo = removeTodo(todoId);
  todoCompleteList.add(todo);

  Element todoElement = Element.div();
  todoElement.className = 'row';
  todoElement.id = 'done_$todoId';

  Element todoNameElement = Element.div();
  todoNameElement.className = 'col-9';
  todoNameElement.text = todo.text;
  Element todoIdElement = Element.div();
  todoIdElement.className = 'col-2';
  todoIdElement.text = todo.id.toString();

  Element buttonDeleted = ButtonElement();
  buttonDeleted.onClick.listen((event) => removeDone('done_$todoId'));
  buttonDeleted.text = 'X';

  buttonDeleted.className = 'btn btn-danger col-1';

  todoElement.children.add(todoNameElement);
  todoElement.children.add(todoIdElement);
  todoElement.children.add(buttonDeleted);
  doneUiList.children.add(todoElement);
}

removeDone(String doneId) {
  doneUiList.children.removeWhere((element) => element.id == doneId);
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

buildDeleteEdit(String id, String date) {
  Element pEdit = Element.p();
  ButtonElement buttonEdit = ButtonElement();
  ButtonElement buttonDelete = ButtonElement();
  DivElement div_1 = DivElement();
  pEdit.className = "fas fa-pencil-alt text-danger";
  buttonEdit.className = "border-0";
  buttonEdit.children.add(pEdit);
  // create delete element

  // aDelete.onClick.listen();

  div_1.className = "d-flex flex-row justify-content-end mb-1";
  div_1.children.add(buttonEdit);
  div_1.children.add(buttonDelete);
}
