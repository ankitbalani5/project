import 'package:project/Model/TaskModel.dart';

abstract class TaskEvent {}

class LoadTasksEvent extends TaskEvent {}

class AddTaskEvent extends TaskEvent {
  final String title;
  AddTaskEvent(this.title);
}

class UpdateTaskEvent extends TaskEvent {
  final TaskModel task;
  UpdateTaskEvent(this.task);
}

class DeleteTaskEvent extends TaskEvent {
  final int id;
  DeleteTaskEvent(this.id);
}
