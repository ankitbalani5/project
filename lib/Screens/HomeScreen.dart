import 'package:flutter/material.dart';
import 'package:project/Bloc/task_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../Bloc/task_event.dart';
import '../Bloc/task_state.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _controller = TextEditingController();


  @override
  void initState() {
    super.initState();
    context.read<TaskBloc>().add(LoadTasksEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Todo App')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _controller,
              decoration: InputDecoration(
                labelText: 'Enter task',
                suffixIcon: IconButton(
                  icon: Icon(Icons.add),
                  onPressed: () {
                    if (_controller.text.isNotEmpty) {
                      context.read<TaskBloc>().add(AddTaskEvent(_controller.text));
                      _controller.clear();
                    }
                  },
                ),
              ),
            ),
          ),
          Expanded(
            child: BlocBuilder<TaskBloc, TaskState>(
              builder: (context, state) {
                if (state is TaskLoadedState) {
                  return ListView.builder(
                    itemCount: state.tasks.length,
                    itemBuilder: (context, index) {
                      final task = state.tasks[index];
                      return ListTile(
                        title: Text(task.title),
                        subtitle: Text(task.isCompleted ? 'Completed' : 'Pending', style: TextStyle(color: task.isCompleted ? Colors.green : Colors.orange),),
                        trailing: SizedBox(
                          width: 100,
                          child: Row(
                            children: [
                              IconButton(
                                icon: Icon(task.isCompleted ? Icons.check_circle : Icons.circle_outlined, color: task.isCompleted ? Colors.green : Colors.orange,),
                                onPressed: () {
                                  task.isCompleted = !task.isCompleted;
                                  context.read<TaskBloc>().add(UpdateTaskEvent(task));
                                },
                              ),
                              IconButton(onPressed: () {
                                context.read<TaskBloc>().add(DeleteTaskEvent(task.id!));
                              }, icon: Icon(Icons.delete, color: Colors.red,))
                            ],
                          ),
                        ),
                      );
                    },
                  );
                } else if (state is TaskErrorState) {
                  return Center(child: Text(state.message));
                }
                return SizedBox();
              },
            ),
          ),
        ],
      ),
    );
  }
}
