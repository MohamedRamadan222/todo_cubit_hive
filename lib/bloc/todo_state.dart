
import 'package:equatable/equatable.dart';
import 'package:todo_with_cubit/todo_model.dart';

abstract class TodoState extends Equatable {
  @override
  List<Object?> get props => [];
}
 class InitialTodo extends TodoState {}
class LoadedTodo extends TodoState {
  final List<TodoModel> todos;
  LoadedTodo(this.todos);
  @override
  List<Object?> get props => [todos];
}

