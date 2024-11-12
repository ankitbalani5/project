import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:project/Model/TaskModel.dart';
import '../DataBase/DatabaseHelper.dart';
import 'task_event.dart';
import 'task_state.dart';

class TaskBloc extends Bloc<TaskEvent, TaskState> {
  TaskBloc() : super(TaskInitialState()) {
    on<LoadTasksEvent>(_onLoadTasksEvent);
    on<AddTaskEvent>(_onAddTaskEvent);
    on<UpdateTaskEvent>(_onUpdateTaskEvent);
    on<DeleteTaskEvent>(_onDeleteTaskEvent);
  }

  // Event handler for loading tasks
  Future<void> _onLoadTasksEvent(LoadTasksEvent event, Emitter<TaskState> emit) async {
    try {
      final tasks = await DatabaseHelper.instance.fetchTasks();
      emit(TaskLoadedState(tasks));
    } catch (e) {
      emit(TaskErrorState('Failed to load tasks'));
    }
  }

  // Event handler for adding a task
  Future<void> _onAddTaskEvent(AddTaskEvent event, Emitter<TaskState> emit) async {
    try {
      final task = TaskModel(title: event.title);
      await DatabaseHelper.instance.insertTask(task);
      final tasks = await DatabaseHelper.instance.fetchTasks();
      emit(TaskLoadedState(tasks));
    } catch (e) {
      emit(TaskErrorState('Failed to add task'));
    }
  }

  // Event handler for updating a task
  Future<void> _onUpdateTaskEvent(UpdateTaskEvent event, Emitter<TaskState> emit) async {
    try {
      await DatabaseHelper.instance.updateTask(event.task);
      final tasks = await DatabaseHelper.instance.fetchTasks();
      emit(TaskLoadedState(tasks));
    } catch (e) {
      emit(TaskErrorState('Failed to update task'));
    }
  }

  // Event handler for deleting a task
  Future<void> _onDeleteTaskEvent(DeleteTaskEvent event, Emitter<TaskState> emit) async {
    try {
      await DatabaseHelper.instance.deleteTask(event.id);
      final tasks = await DatabaseHelper.instance.fetchTasks();
      emit(TaskLoadedState(tasks));
    } catch (e) {
      emit(TaskErrorState('Failed to delete task'));
    }
  }
}
