import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../models/todo.dart';

const _uuid = Uuid();

class TodoState {
  // State 1 — tracks current text input value
  final String inputTextState;
  // State 2 — tracks the list of added goal items
  final List<Todo> goalListState;
  final String searchQuery;

  const TodoState({
    this.inputTextState = '',
    this.goalListState = const [],
    this.searchQuery = '',
  });

  List<Todo> get filteredTodos {
    if (searchQuery.trim().isEmpty) return goalListState;
    final query = searchQuery.toLowerCase();
    return goalListState
        .where((todo) => todo.title.toLowerCase().contains(query))
        .toList();
  }

  TodoState copyWith({
    String? inputTextState,
    List<Todo>? goalListState,
    String? searchQuery,
  }) {
    return TodoState(
      inputTextState: inputTextState ?? this.inputTextState,
      goalListState: goalListState ?? this.goalListState,
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }
}

class TodoNotifier extends StateNotifier<TodoState> {
  TodoNotifier() : super(const TodoState());

  void updateInputText(String value) {
    state = state.copyWith(inputTextState: value);
  }

  void addTodo(String title) {
    if (title.trim().isEmpty) return;
    final newTodo = Todo(
      id: _uuid.v4(),
      title: title.trim(),
    );
    state = state.copyWith(
      goalListState: [...state.goalListState, newTodo],
      inputTextState: '',
    );
  }

  void toggleTodo(String id) {
    state = state.copyWith(
      goalListState: state.goalListState.map((todo) {
        if (todo.id == id) {
          return todo.copyWith(isCompleted: !todo.isCompleted);
        }
        return todo;
      }).toList(),
    );
  }

  void deleteTodo(String id) {
    state = state.copyWith(
      goalListState:
          state.goalListState.where((todo) => todo.id != id).toList(),
    );
  }

  void searchTodos(String query) {
    state = state.copyWith(searchQuery: query);
  }

  void clearInput() {
    state = state.copyWith(inputTextState: '');
  }
}

final todoProvider = StateNotifierProvider<TodoNotifier, TodoState>(
  (ref) => TodoNotifier(),
);
