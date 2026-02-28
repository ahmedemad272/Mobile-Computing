import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../app_theme.dart';
import '../models/todo.dart';
import '../providers/todo_provider.dart';

class TodoTile extends ConsumerWidget {
  final Todo todo;
  final Animation<double> animation;

  const TodoTile({
    super.key,
    required this.todo,
    required this.animation,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifier = ref.read(todoProvider.notifier);

    return SizeTransition(
      sizeFactor: animation,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        child: Container(
          decoration: AppTheme.cardDecoration,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            child: Row(
              children: [
                // Checkbox
                Checkbox(
                  value: todo.isCompleted,
                  onChanged: (_) => notifier.toggleTodo(todo.id),
                ),
                // Title
                Expanded(
                  child: Text(
                    todo.title,
                    style: todo.isCompleted
                        ? AppTheme.todoCompletedTextStyle
                        : AppTheme.todoTextStyle,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(width: 8),
                // Delete button
                GestureDetector(
                  onTap: () => notifier.deleteTodo(todo.id),
                  child: Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: AppTheme.danger,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(
                      Icons.delete_outline,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
