import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:todo_with_cubit/bloc/todo_cubit.dart';
import 'package:todo_with_cubit/home.dart';
import 'package:todo_with_cubit/todo_model.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // init the hive
  await Hive.initFlutter();
  // register the adapter

  Hive.registerAdapter(TodoModelAdapter());
  // open the hive
  await Hive.openBox('todosCubits');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // this Widget is the root of your app
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => TodoCubit()..getTodos(),
      child: MaterialApp(
        title: 'Todo with cubit',
        debugShowCheckedModeBanner: false,
        home: const Home(),
      ),
    );
  }
}
