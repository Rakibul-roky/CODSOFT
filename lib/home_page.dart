
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:newtodo/data/database.dart';
import 'package:newtodo/util/dialog_box.dart';
import 'package:newtodo/util/todo_tile.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {

  final _myBox=Hive.box('mybox');
  ToDoDatabase db=ToDoDatabase();
  @override
  void initState() {
    if(_myBox.get("TODOLIST")==null){
      db.createInitialData();
    }else{
      db.loadData();
    }
    super.initState();
  }

  final _controller=TextEditingController();


  //list of todo list
  //checkbox checked
  void checkBoxChanged(bool? value,int index){
    setState(() {
      db.toDoList[index][1]=!db.toDoList[index][1];
    });
    db.updateDataBase();
  }

  void saveNewTask(){
    setState(() {
      db.toDoList.add([_controller.text,false]);
      _controller.clear();
    });
    Navigator.of(context).pop();
    db.updateDataBase();
  }

  //create a new task
  void createNewTask(){
    showDialog(context: context, builder: (context){
      return DialogBox(
        controller:_controller ,
        onSave: saveNewTask,
        onCancel: ()=>Navigator.of(context).pop(),
      );

    });
  }

  void deleteTask(int index){
    setState(() {
      db.toDoList.removeAt(index);
    });
    db.updateDataBase();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.tealAccent[200],
      appBar: AppBar(
        title: Text("To Do"),
        elevation: 0,


      ),

      floatingActionButton: FloatingActionButton(
        onPressed: createNewTask,
        child: Icon(Icons.add),

      ),


      body: ListView.builder(
        itemCount: db.toDoList.length,
        itemBuilder: (context,index){
          return ToDoTile(
            taskName: db.toDoList[index][0],
            taskCompleted: db.toDoList[index][1],
            onChanged: (value)=>checkBoxChanged(value, index),
            deleteFunction: (context)=>deleteTask(index),
          );
        },

      ),

      );
  }
}
