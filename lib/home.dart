import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_with_cubit/bloc/todo_cubit.dart';
import 'package:todo_with_cubit/bloc/todo_state.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final TextEditingController _controller = TextEditingController();

  void _showAddTodoDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Todo'),
        content: TextField(
          controller: _controller,
          decoration: const InputDecoration(hintText: 'Enter Todo Title'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              context.read<TodoCubit>().addTodo(_controller.text);
              _controller.clear();
              Navigator.pop(context);
            },
            child: const Text('Add it Please'),
          ),
        ],
      ),
    );
  }

  // أضف index هنا كباراميتر
  void _showEditTodoDialog(BuildContext context, int index, String currentTitle) {
    _controller.text = currentTitle;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Todo'),
        content: TextField(
          controller: _controller,
          decoration: const InputDecoration(hintText: 'Enter New Todo Title'),
        ),
        actions: [
          TextButton(
            onPressed: () {
              _controller.clear();
              Navigator.pop(context);
            },
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              context.read<TodoCubit>().editTodoName(index, _controller.text);
              _controller.clear();
              Navigator.pop(context);
            },
            child: const Text('Edit it Please'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Todo Cubit & Hive'), centerTitle: true),
      body: BlocBuilder<TodoCubit, TodoState>(
        builder: (context, state) {
          if (state is InitialTodo) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is LoadedTodo) {
            final todos = state.todos;
            if (todos.isEmpty) {
              return const Center(child: Text('No Todos Yet!'));
            }
            return ListView.builder(
              itemCount: todos.length,
              itemBuilder: (context, index) {
                final todo = todos[index];
                return InkWell(
                  onTap: () => _showEditTodoDialog(context, index, todo.title),

                  child: ListTile(
                    leading: Checkbox(
                      value: todo.isDone,
                      onChanged: (_) {
                        context.read<TodoCubit>().toggleTodo(index);
                      },
                    ),
                    title: Text(
                      todo.title,
                      style: TextStyle(
                        decoration: todo.isDone
                            ? TextDecoration.lineThrough
                            : TextDecoration.none,
                      ),
                    ),
                    trailing: IconButton(
                      onPressed: () {
                        context.read<TodoCubit>().deleteTodo(index);
                      },
                      icon: const Icon(Icons.delete, color: Colors.red),
                    ),
                  ),
                );
              },
            );
          }
          return const Center(child: Text('Unknown state'));
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddTodoDialog(context),
        child: const Icon(Icons.add),
      ),
    );
  }
}
