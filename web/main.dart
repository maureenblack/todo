// ignore_for_file: unnecessary_new

import 'dart:convert';
import 'dart:html';

late DivElement doneUiList;
late InputElement todoInput;
late SelectElement priority;
late SelectElement sortBySelect;
late InputElement datepicker;
late TableSectionElement uiList;
late ButtonElement buttonClear;
late FormElement addTodoForm;
List<Todo> todoList = [];
List<Todo> todoCompleteList = [];
late JsonCodec json;
void main() async {
  json = JsonCodec();
  doneUiList = querySelector('#done') as DivElement;
  todoInput = querySelector('#todo') as InputElement;
  datepicker = querySelector('#datepicker') as InputElement;
  uiList = querySelector('#todo-list') as TableSectionElement;
  buttonClear = querySelector('#clear') as ButtonElement;
  addTodoForm = querySelector('#idp') as FormElement;
  priority = querySelector('#priority') as SelectElement;
  sortBySelect = querySelector('#sortBy') as SelectElement;

  addTodoForm.onSubmit.listen((event) {
    event.preventDefault();
    if (addTodoForm.checkValidity()) {
      addTodo();
    }
  });

  OptionElement sortByPriority = OptionElement();
  sortByPriority.value = 'Priority';
  sortByPriority.selected = true;
  sortByPriority.label = 'Priority';

  OptionElement sortByDate = OptionElement();
  sortByDate.value = 'Date';
  sortByDate.selected = false;
  sortByDate.label = 'Due Date';

  OptionElement sortByName = OptionElement();
  sortByName.value = 'Name';
  sortByName.selected = false;
  sortByName.label = 'Name';

  sortBySelect.onChange.listen((event) {
    sortBy(todoList, sortBySelect.value.toString());
  });

  sortBySelect.children.add(sortByPriority);
  sortBySelect.children.add(sortByDate);
  sortBySelect.children.add(sortByName);

  buttonClear.onClick.listen(removeAlltodos);
  String? counterJson = window.localStorage['COUNTER'];
  String counter = counterJson ??
      '0'; //EQUIVALENT TO (ternary operator): String counter = counterJson == null ? '0': counterJson;
  Todo.counter = int.parse(counter);

  final todosJson = window.localStorage['TODOS'];
  if (todosJson != null) {
    late List previousTodosJson = json.decode(todosJson);
    todoList = previousTodosJson.map((todo) => Todo.fromJson(todo)).toList();
    sortBy(todoList, null);
  }

  final completeTodosJson = window.localStorage['COMPLETED'];
  if (completeTodosJson != null) {
    late List completedTodos = json.decode(completeTodosJson);
    for (var todoJson in completedTodos) {
      Todo todo = Todo.fromJson(todoJson);
      String todoId = todo.id.toString();
      showDoneTodo(todo, 'todo-$todoId');
      todoCompleteList.add(todo);
    }
  }

  // Todo todo = Todo('Todo', '2020');
  // todo.tasks = ['no tasks', 'task x list'];
  // updateTodos(todo);
  // todoList.add(todo);
  // String todoId = todo.id.toString();
  // showTasks('todo-$todoId', 'no tasks');
  // showTasks('todo-$todoId', 'task x list');
}

void addTodo() {
  Todo todo = Todo(todoInput.value.toString(), datepicker.value.toString(),
      int.parse(priority.value.toString()));
  print(datepicker.value);
  todoList.add(todo);
  updateTodos(todo);
  todoInput.value = '';

  persist('TODOS', todoList);
}

void sortBy(List<Todo> todoList, String? sortBy) {
  switch (sortBy) {
    case 'Date':
      dateSort(todoList);
      break;
    case 'Name':
      nameSort(todoList);
      break;
    default:
      prioritySort(todoList);
  }

  todosClear();

  for (var todo in todoList) {
    String todoId = todo.id.toString();
    updateTodos(todo);

    for (var subtask in todo.tasks) {
      showTasks('todo-$todoId', subtask);
    }
  }
  // persist('SORT_BY', sortBy);
}

void prioritySort(List<Todo> todoList) {
  todoList.sort((a, b) => b.priority.compareTo(a.priority));
}

void dateSort(List<Todo> todoList) {
  todoList.sort(
      (a, b) => DateTime.parse(a.dueDate).compareTo(DateTime.parse(b.dueDate)));
}

void nameSort(List<Todo> todoList) {
  todoList.sort((a, b) => a.text.compareTo(b.text));
}

void updateTodos(Todo todo) {
  Element tr = Element.tr();
  ButtonElement buttonRemove = ButtonElement();
  InputElement inputAddTask = InputElement();
  // Element td = Element.td();
  HRElement separator = HRElement();
  Element todoTasks = Element.div();
  String todoId = todo.id.toString();
  ButtonElement doneButton = ButtonElement();
  InputElement checkbox = InputElement();
  ButtonElement buttonEdit = ButtonElement();
  Element tdName = Element.td();
  Element tdDate = Element.td();
  Element tdPriority = Element.td();
  Element tdId = Element.td();
  Element tdTask = Element.td();
  Element tdActions = Element.td();

  inputAddTask.placeholder = 'Enter sub-todo';
  checkbox.type = 'checkbox';
  checkbox.onChange.listen((event) {
    test(todo.id, event);
  });
  tr.id = 'todo-$todoId';
  buttonRemove.text = 'X';
  buttonRemove.className = "btn btn-outline-primary m-3";
  doneButton.innerHtml = '&#10004;';
  doneButton.className = "btn btn-outline-primary m-3";
  doneButton.id = todo.id.toString();
  buttonRemove.id = todo.id.toString();
  buttonEdit.innerHtml = '&#9998;';
  buttonEdit.className = "btn btn-outline-primary m-3";
  buttonEdit.onClick.listen((event) => editTodo('todo-$todoId'));
  doneButton.onClick.listen((event) => todoDone('todo-$todoId'));
  buttonRemove.onClick.listen((event) {
    if (window.confirm('Are you sure you want to delete this?')) {
      removeTodo('todo-$todoId');
    }
  });
  inputAddTask.onChange.listen((event) {
    String subtask = inputAddTask.value.toString();
    todo.tasks.add(SubTask(subtask, false));
    showTasks('todo-$todoId', SubTask(subtask, false));
    inputAddTask.value = '';

    persist('TODOS', todoList);
  });
  String todoText = todo.text;
  String dueDate = todo.dueDate;
  String priorityLevel;

  switch (todo.priority) {
    case 1:
      priorityLevel = 'Low';
      break;
    case 2:
      priorityLevel = 'Medium';
      break;
    default:
      priorityLevel = 'High';
  }

  tdName.text = todoText;
  tdDate.text = dueDate;
  tdPriority.text = priorityLevel;
  tdId.text = todoId;
  tr.children.add(tdId);
  tr.children.add(tdName);
  tr.children.add(tdPriority);
  tr.children.add(tdDate);
  tr.children.add(tdTask);
  tr.children.add(tdActions);

  tdActions.children.add(doneButton);
  tdActions.children.add(buttonEdit);
  tdActions.children.add(buttonRemove);
  // tr.children.add(tdName);

  tdTask.children.add(todoTasks);
  tdTask.children.add(inputAddTask);
  // tr.children.add(separator);

  uiList.children.add(tr);
}

editTodo(String todoId) {
  Todo todo = removeTodo(todoId);
  todoInput.value = todo.text;
}

void test(int id, Event event) {}

void showTasks(String todoId, SubTask subTask) {
  TableRowElement todoElement = querySelector('#$todoId') as TableRowElement;
  TableCellElement tasksList = todoElement.children[4] as TableCellElement;
  Element task = Element.li();
  ButtonElement deleteTask = ButtonElement();
  ButtonElement markDone = ButtonElement();
  SpanElement span = SpanElement();

  deleteTask.onClick.listen((event) {
    if (window.confirm('Are you sure you want to delete this?')) {
      tasksList.children.remove(task);
      removeSubtaskFrom(todoId, subTask.text);
    }
  });

  markDone.onClick.listen((event) {
    span.style.textDecoration = subTask.done ? '' : 'line-through';
    markDone.text = subTask.done ? 'Mark Done' : 'Mark Undone';
    taskDone(todoId, subTask.text);
  });

  span.text = subTask.text;
  deleteTask.text = 'Delete';
  deleteTask.className = 'btn btn-outline-primary';
  markDone.className = 'btn btn-outline-primary m-2';
  markDone.text = subTask.done ? 'Mark Undone' : 'Mark Done';
  span.style.textDecoration = subTask.done ? 'line-through' : '';
  task.children.add(span);
  task.children.add(BRElement());

  
  task.children.add(deleteTask);
  task.children.add(markDone);
  tasksList.children.add(task);
}

void taskDone(String elementId, String subTask) {
  String todoId;
  // print(elementId);
  todoList = todoList.map((todo) {
    todoId = todo.id.toString();
    if ('todo-$todoId' == elementId) {
      todo.tasks = todo.tasks.map((element) {
        element.done = element.text == subTask && !element.done;
        return element;
      }).toList();
    }
    return todo;
  }).toList();

  persist('TODOS', todoList);
}

void removeSubtaskFrom(String elementId, String subtask) {
  String todoId;
  // print(elementId);
  todoList = todoList.map((todo) {
    todoId = todo.id.toString();
    if ('todo-$todoId' == elementId) {
      todo.tasks =
          todo.tasks.where((element) => element.text != subtask).toList();
    }
    return todo;
  }).toList();

  persist('TODOS', todoList);
}

Todo removeTodo(String todoId) {
  late String elementId = todoId.split('-')[1];
  uiList.children.removeWhere((element) => element.id == todoId);
  Todo todo =
      todoList.singleWhere((element) => element.id.toString() == elementId);

  todoList.removeWhere((element) => element.id.toString() == elementId);

  persist('TODOS', todoList);

  return todo;
}

void todosClear() {
  uiList.children.clear();
}

void removeAlltodos(MouseEvent? event) {
  if (window.confirm('Are you sure you want to clear all todos?')) {
    todosClear();
    todoList.clear();

    persist('TODOS', todoList);
  }
  // print(todoList);
}

void todoDone(String todoId) {
  Todo todo = removeTodo(todoId);
  todoCompleteList.add(todo);

  showDoneTodo(todo, todoId);

  persist('TODOS', todoList);
  persist('COMPLETED', todoCompleteList);
}

void showDoneTodo(Todo todo, String todoId) {
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
  buttonDeleted.onClick.listen((event) {
    if (window.confirm('Are you sure you want to delete this?')) {
      removeDone('done_$todoId');
    }
  });
  buttonDeleted.text = 'X';

  buttonDeleted.className = 'btn btn-outline-primary col-1';
  // doneButton.classsName = 'btn btn-danger';
  todoElement.children.add(todoNameElement);
  todoElement.children.add(todoIdElement);
  todoElement.children.add(buttonDeleted);
  doneUiList.children.add(todoElement);
}

removeDone(String doneId) {
  late String elementId = doneId.split('-')[1];

  doneUiList.children.removeWhere((element) => element.id == doneId);
  todoCompleteList.removeWhere((element) => element.id.toString() == elementId);
  persist('COMPLETED', todoCompleteList);
}

void persist(String key, data) {
  window.localStorage[key] = json.encode(data);
  window.localStorage['COUNTER'] = json.encode(Todo.counter);
}

class SubTask {
  final String text;
  bool done;

  SubTask(this.text, this.done);
  SubTask.fromJson(Map<String, dynamic> json)
      : done = json['done'],
        text = json['text'];

  Map<String, dynamic> toJson() => {'done': done, 'text': text};
}

class Todo {
  static int counter = 0;
  final String dueDate;
  final int priority;
  int id = 0;
  final String text;
  List<SubTask> tasks = <SubTask>[];
  Todo(this.text, this.dueDate, this.priority) {
    counter++;
    id = counter;
  }

  Todo.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        text = json['text'],
        tasks = (json['tasks'] as List)
            .map((subtask) => SubTask.fromJson(subtask))
            .toList(),
        dueDate = json['dueDate'],
        priority = json['priority'];

  Map<String, dynamic> toJson() => {
        'id': id,
        'text': text,
        'dueDate': dueDate,
        'tasks': tasks,
        'priority': priority
      };
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
