import 'dart:io';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hive_sample/Screens/widgets/add_students.dart';
import 'package:hive_sample/Screens/widgets/details.dart';
import 'package:hive_sample/Screens/widgets/search_student.dart';
import 'package:hive_sample/Screens/widgets/update_student.dart';
import '../../db/functions/db_functions.dart';
import '../../db/models/data_model.dart';

class ViewStudent extends StatefulWidget {
  const ViewStudent({super.key});

  @override
  State<ViewStudent> createState() => _ViewStudentState();
}

class _ViewStudentState extends State<ViewStudent> {
  late Box<StudentModel> studentBox;

  @override
  void initState() {
    super.initState();

    studentBox = Hive.box('student_db');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Student List'),
        centerTitle: true,
        actions: [
          IconButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const SearchStudent()));
              },
              icon: const Icon(Icons.search)),
        ],
      ),
      body: SafeArea(
        child: ValueListenableBuilder(
          valueListenable: studentListNotifier,
          builder: (BuildContext ctx, List<StudentModel> studentList,
              Widget? child) {
            return ListView.separated(
              itemBuilder: (ctx, index) {
                final data = studentList[index];
                return ListTile(
                  leading: CircleAvatar(
                    radius: 25,
                    // backgroundColor: Colors.green,
                    backgroundImage: FileImage(File(data.image)),
                  ),
                  title: Text(data.name),
                  trailing: Wrap(
                    spacing: 12,
                    children: <Widget>[
                      IconButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => UpdateStudent(index: index),
                              ),
                            );
                          },
                          icon: const Icon(Icons.edit),
                          color: Colors.blue),
                      IconButton(
                        onPressed: () {
                          deleteAlert(context, index);
                        },
                        icon: const Icon(Icons.delete),
                        color: Colors.red,
                      ),
                    ],
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (ctx) => Details(
                          passId: index,
                          passValue: data,
                        ),
                      ),
                    );
                  },
                );
              },
              separatorBuilder: (context, index) {
                return const Divider();
              },
              itemCount: studentList.length,
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => AddStudent()));
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  deleteAlert(BuildContext context, key) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        content: const Text('Delete data Permanently?'),
        actions: [
          TextButton(
              onPressed: () {
                deleteStudent(key);
                Navigator.of(context).pop(ctx);
              },
              child: const Text(
                'Delete',
                style: TextStyle(color: Colors.red),
              )),
          TextButton(
              onPressed: () {
                Navigator.of(context).pop(ctx);
              },
              child: const Text('Cancel'))
        ],
      ),
    );
  }
}
