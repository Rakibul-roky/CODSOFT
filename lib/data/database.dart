import 'package:hive/hive.dart';

class ToDoDatabase{
  List toDoList=[];
  final _myBox=Hive.box('mybox');

  void createInitialData(){
    toDoList=[
      ["Reading book",false],
      ["Playing card",false]
    ];
  }


  void loadData(){
    toDoList=_myBox.get("TODOLIST");

  }

  void updateDataBase(){
    _myBox.put("TODOLIST", toDoList);
  }
}