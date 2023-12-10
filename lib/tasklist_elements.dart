import 'package:flutter/material.dart';

import 'main.dart';
import 'model.dart';
import 'task_elements.dart';

class TaskList extends StatefulWidget {
  const TaskList({Key? key}) : super(key: key);

  @override
  State<TaskList> createState() => _TaskListState();
}

class _TaskListState extends State<TaskList> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: StreamBuilder<List<Task>>(
        stream: objectbox.getTasks(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            // ... error handling ...
          }

          List<Task> tasks = snapshot.data ?? [];

          return DataTable(
            columns: const [
              DataColumn(label: Text('Task')),
              DataColumn(label: Text('Tag')),
              DataColumn(label: Text('State')),
              DataColumn(label: Text('Actions')),
            ],
            rows: tasks.map<DataRow>((Task task) {
              return DataRow(
                cells: [
                  DataCell(Text(task.text)),
                  DataCell(Text(task.tag.target!.name)),
                  DataCell(Text(
                    task.isFinished() ? 'Finished' : 'Created',
                    style: TextStyle(
                      color: task.isFinished() ? Colors.grey : null,
                      decoration: task.isFinished()
                          ? TextDecoration.lineThrough
                          : null,
                    ),
                  )),
                  DataCell(Row(
                    children: [
                      IconButton(
                        icon: Icon(Icons.edit),
                        onPressed: () {
                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => TaskInput(
                              taskId: task.id,
                            ),
                          ));
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () {
                          objectbox.removeTask(task.id);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Task ${task.id} deleted'),
                            ),
                          );
                        },
                      ),
                    ],
                  )),
                ],
              );
            }).toList(),
          );
        },
      ),
    );
  }
}
