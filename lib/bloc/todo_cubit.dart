import 'package:bloc/bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:todo_with_cubit/bloc/todo_state.dart';
import 'package:todo_with_cubit/todo_model.dart';
import 'package:uuid/v8.dart';

class TodoCubit extends Cubit<TodoState> {
  TodoCubit() : super(InitialTodo());

  final Box _box = Hive.box('todosCubits');

  void getTodos() {
    final todos = _box.values.cast<TodoModel>().toList();
    emit(LoadedTodo(todos));
  }

  void addTodo(String title) {
    if (title.isEmpty) return;
    final todo = TodoModel(
      id: const UuidV8().generate(),
      title: title,
      isDone: false,
    );
    _box.add(todo);
    getTodos();
  }

  void toggleTodo(int index) {
    final todo = _box.getAt(index) as TodoModel;
    final updateTodo = TodoModel(
      id: todo.id,
      title: todo.title,
      isDone: !todo.isDone,
    );
    _box.putAt(index, updateTodo);
    getTodos();
  }
  // me
  void editTodoName(int index, String title){
    final todo = _box.getAt(index) as TodoModel;
    final editedTodo = TodoModel(
      id: todo.id,
      title: title,
      isDone: todo.isDone
    );
    _box.putAt(index, editedTodo);
    getTodos();
  }

  void deleteTodo(int index) {
    _box.deleteAt(index);
    getTodos();
  }
}
