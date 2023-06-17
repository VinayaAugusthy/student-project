import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hive_sample/db/models/data_model.dart';

import 'Screens/home_screen.dart';


Future<void> main() async{
  WidgetsFlutterBinding.ensureInitialized();
 await Hive.initFlutter();
 if (!Hive.isAdapterRegistered(StudentModelAdapter().typeId)) {
   Hive.registerAdapter(StudentModelAdapter());
 }

 await Hive.openBox<StudentModel>('student_db');
 runApp(const myApp());
}

class myApp extends StatelessWidget {
  const myApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blueGrey),
      home: const HomeScreen(),
    );

  }
}