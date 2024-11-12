import 'package:equatable/equatable.dart';
import 'package:project/Model/TaskModel.dart';

abstract class TaskState extends Equatable {
  @override
  List<Object?> get props => [];
}

class TaskInitialState extends TaskState {}

class TaskLoadedState extends TaskState {
  final List<TaskModel> tasks;

  TaskLoadedState(this.tasks);

  @override
  List<Object?> get props => [tasks];
}

class TaskErrorState extends TaskState {
  final String message;
  TaskErrorState(this.message);

  @override
  List<Object?> get props => [message];
}
