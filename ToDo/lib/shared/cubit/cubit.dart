import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mm/shared/cubit/states.dart';
import 'package:sqflite/sqflite.dart';

import '../../modules/archived_tasks/archived_tasks.dart';
import '../../modules/done_tasks/done_tasks.dart';
import '../../modules/new_tasks/new_tasks.dart';

class AppCubit extends Cubit<AppStates> {
  AppCubit() : super(AppInitialState());

  static AppCubit get(context) =>
      BlocProvider.of(context); // object from AppCubit class

  int currentIndex = 0;
  List<Widget> classes = [
    NewTasks(),
    DoneTasks(),
    ArchivedTasks(),
  ];

  List<String> titles = ['New Tasks', 'Done Tasks', 'Archived Tasks'];

  void changeIndex(int index) {
    currentIndex = index;
    emit(AppChangeBottomNavBarState());
  }

  late Database database;
  List<Map> newTasks = [];
  List<Map> doneTasks = [];
  List<Map> archivedTasks = [];

  void createDatabase() {
    openDatabase('todo.db', version: 1, onCreate: (database, version) {
      print('database created');

      database
          .execute(
              'CREATE TABLE tasks (id INTEGER PRIMARY KEY, title TEXT, date TEXT, time TEXT, status TEXT )')
          .then((value) {
        print('table created');
      }).catchError((error) {
        print('error happen when table create ${error.toString()}');
      });
    }, onOpen: (database) {
      getDatabase(database);
    }).then((value) {
      database = value;
      emit(AppCreateDatabase());
    });
  }

  void insertDatabase({
    required String title,
    required String date,
    required String time,
  }) async {
    await database.transaction((txn) async {
      await txn
          .rawInsert(
              'INSERT INTO tasks(title, date, time, status) VALUES("$title", "$date", "$time","new")')
          .then((value) {
        print('$value inserted successfully');
        emit(AppInsertDatabase());

        getDatabase(database);
      }).catchError((error) {
        print('error happen when inserting new record ${error.toString()}');
      });
      return null;
    });
  }

  void getDatabase(database) async {

    newTasks=[];
    doneTasks=[];
    archivedTasks=[];
    emit(AppGetDatabaseLoadingState());

    database.rawQuery('SELECT * FROM tasks').then((value) {
      emit(AppGetDatabase());

      value.forEach((element){
       if(element['status'] == 'new'){
         newTasks.add(element);
       }else if(element['status'] == 'done'){
         doneTasks.add(element);
       }else{
         archivedTasks.add(element);
       }

      });
    });
  }

  void updateData({
    required String status,
    required int id,
  }) async {
   database.rawUpdate(
      'UPDATE tasks SET status = ? WHERE id =?',
      ['$status', id],
    ).then((value) {
      getDatabase(database);
      emit(AppUpdateDatabase());
   });
  }

  void deleteData({
    required int id,
  }) async {
    database.rawUpdate(
      'DELETE FROM tasks WHERE id = ?',
      [id],
    ).then((value) {
      getDatabase(database);
      emit(AppDeleteDatabase());
    });
  }


  bool isShow = false;
  IconData flotIcon = Icons.edit;

  void changeBottomSheet({
    required bool visability,
    required IconData iconData,
  }) {
    isShow = visability;
    flotIcon = iconData;

    emit(AppChangeBottomSheetState());
  }
}
