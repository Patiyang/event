import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:todo_app/Interfaces/taskTiles.dart';
import 'package:todo_app/Models/Tasks.dart';
import 'package:todo_app/Styling/global_styling.dart';
import 'package:todo_app/bloc/blocs/blocs.dart';
import 'package:todo_app/bloc/resources/repository.dart';

class HomeTab extends StatefulWidget {
  final String apiKey;
  HomeTab({Key key, /*this.title,*/ this.apiKey}) : super(key: key);
  // final String title;

  @override
  _HomeTab createState() => _HomeTab();
}

class _HomeTab extends State<HomeTab> {
  List<dynamic> taskList = []; //CHANGED HERE FROM
  TaskBloc taskBloc;
  String apiKey;

  TextEditingController taskNameCont = new TextEditingController();
  TextEditingController noteCont = new TextEditingController();

  Repository _repository = Repository();

  @override
  void initState() {
    taskBloc = TaskBloc(widget.apiKey);

    super.initState(); // PAY ATTTENTION TO THIS !!!!!!
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: greyColor,
      child: StreamBuilder(
        stream: taskBloc.tasks, //pass the getter of the stream here
        initialData: [], //List<Task>() the initial data
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          taskList = snapshot.data;

          if (snapshot.hasData && snapshot != null) {
            if (snapshot.data.length > 0) {
              return _simpleReorderable(context, taskList);
            } else if (snapshot.data.length == 0) {
              return Center(
                child: Text(
                  'NO TASKS YET',
                  style: TextStyle(color: Colors.white),
                ),
              );
            }
          }
          return CircularProgressIndicator();
        },
      ),
    );
  }

  Widget _buildListTile(BuildContext context, Task item) {
    return ListTile(
        key: Key(item.taskid.toString()),
        title: GestureDetector(
            key: Key(item.taskid.toString()),
            child: Todo(
              title: item.title,
              note: item.note,
              id: item.taskid,
            ),
            onTap: () {
              taskNameCont.text = item.title;
              noteCont.text = item.note;

              _showEditDialog(item.taskid, item.title, item.note);
              // _showDelDialog(item.taskid);
              print('task ID is: ' + item.taskid.toString());
              print('the title is ' + item.title);
            }));
  }

  Widget _simpleReorderable(BuildContext context, List<Task> taskList) {
    return Theme(
      data: ThemeData(
          canvasColor: Colors.transparent, dialogBackgroundColor: greyColor),
      child: ReorderableListView(
        padding: EdgeInsets.only(top: 300.0),
        children:
            taskList.map((Task item) => _buildListTile(context, item)).toList(),
        onReorder: (oldIndex, newIndex) {
          setState(() {
            Task item = taskList[oldIndex];
            taskList.remove(item);
            taskList.insert(newIndex, item);
          });
          // physics: BouncingScrollPhysics()
        },
      ),
    );
  }

  void _onReorder(int oldIndex, int newIndex) {
    setState(() {
      if (newIndex > oldIndex) {
        newIndex -= 1;
      }
      final Task item = taskList.removeAt(oldIndex);
      taskList.insert(newIndex, item);
    });
  }

  void _showEditDialog(int taskId, String title, String note) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20.0))),
          content: Container(
            height: 270,
            width: 340,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Center(
                    child: Text(
                  'Edit task',
                  style: taskHeading,
                )),
                Container(
                  child: new Theme(
                    data: new ThemeData(hintColor: Colors.white70),
                    child: TextField(
                      controller: taskNameCont,
                      style: TextStyle(color: Colors.white, fontFamily: 'Sans'),
                      textInputAction: TextInputAction.next,
                      textCapitalization: TextCapitalization.sentences,
                      textAlign: TextAlign.center,
                      decoration: InputDecoration(
                        hintText: 'Update Task Name',
                        enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.white70)),
                      ),
                    ),
                  ),
                ),
                Container(
                  child: Theme(
                    data: new ThemeData(hintColor: Colors.white70),
                    child: TextField(
                      controller: noteCont,
                      style: TextStyle(color: Colors.white, fontFamily: 'Sans'),
                      textInputAction: TextInputAction.done,
                      textAlign: TextAlign.start,
                      decoration: InputDecoration(
                        hintText: 'Update note',
                        enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.white70)),
                      ),
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(right: 20, left: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      RaisedButton(
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(7))),
                          child: Text('Submit', style: taskHeading),
                          color: redColor,
                          onPressed: () {
                            if (taskNameCont.text == '') {
                              Fluttertoast.showToast(
                                  msg: "enter a viable title",
                                  toastLength: Toast.LENGTH_LONG,
                                  gravity: ToastGravity.CENTER,
                                  // backgroundColor: Colors.white,
                                  textColor: Colors.black,
                                  fontSize: 13.0);
                            } else if (noteCont.text == '') {
                              Fluttertoast.showToast(
                                  toastLength: Toast.LENGTH_SHORT,
                                  msg: 'enter a viable note',
                                  gravity: ToastGravity.CENTER,
                                  fontSize: 7);
                            } else if (taskNameCont.text != null &&
                                noteCont.text != null) {
                              editTask(
                                  taskNameCont.text, noteCont.text, taskId);
                              Fluttertoast.showToast(
                                  msg: "task successfuly edited",
                                  toastLength: Toast.LENGTH_LONG,
                                  gravity: ToastGravity.BOTTOM,
                                  // timeInSecForIos: 1,
                                  // backgroundColor: Colors.white,
                                  textColor: Colors.black,
                                  fontSize: 10.0);
                              Navigator.pop(context);
                            }
                          }),
                      RaisedButton(
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(7))),
                          child: Text('Cancel', style: taskHeading),
                          color: redColor,
                          onPressed: () {
                            Navigator.pop(context);
                          })
                    ],
                  ),
                ),
                Container(
                  child: Center(
                    child: GestureDetector(
                        child: Icon(
                          Icons.delete,
                          color: Colors.white70,
                        ),
                        onTap: () {
                          _showDelDialog(taskId);
                          // deleteTask(taskId);
                          // Navigator.pop(context);
                        }),
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }

  void _showDelDialog(int taskId) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(20.0))),
            content: Container(
              height: 100,
              width: 300,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Center(
                      child: Text(
                    'are you sure?',
                    style: taskHeading,
                  )),
                  Container(
                    padding: EdgeInsets.only(right: 20, left: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        GestureDetector(
                          child: Icon(Icons.cancel, color: Colors.white70),
                          onTap: () {
                            Navigator.pop(context);
                          },
                        ),
                        GestureDetector(
                          child: Icon(Icons.done, color: Colors.white70),
                          onTap: () {
                            deleteTask(taskId);
                            Navigator.pop(context);
                            // print(taskId);
                          },
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          );
        });
  }

  void editTask(String taskName, String note, int taskId) async {
    await _repository.editUserTask(apiKey, taskId, taskName, note);
  }

  void deleteTask(int taskId) async {
    await _repository.deleteUserTask(apiKey, taskId);
  }

  // Future<List<Task>> fetchTasks() async {
  //   List<Task> tasks = await taskBloc.addTask(widget.apiKey);
  //   print(tasks[0].title);
  //   return tasks;
  // }
}
