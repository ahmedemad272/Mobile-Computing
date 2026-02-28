import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../app_theme.dart';
import '../providers/todo_provider.dart';

class AddTodoBar extends ConsumerStatefulWidget {
  const AddTodoBar({super.key});

  @override
  ConsumerState<AddTodoBar> createState() => _AddTodoBarState();
}

class _AddTodoBarState extends ConsumerState<AddTodoBar> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _handleAddTodo() {
    final notifier = ref.read(todoProvider.notifier);
    final state = ref.read(todoProvider);

    // Validates input is not empty
    if (state.inputTextState.trim().isEmpty) return;

    // Creates a new Todo item using inputTextState and appends it to goalListState
    notifier.addTodo(state.inputTextState);

    // Clears the inputTextState and TextEditingController
    _controller.clear();
    notifier.clearInput();

    // Dismiss keyboard
    _focusNode.unfocus();
  }

  @override
  Widget build(BuildContext context) {
    final notifier = ref.read(todoProvider.notifier);

    return Container(
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        top: 12,
        bottom: MediaQuery.of(context).padding.bottom + 12,
      ),
      decoration: BoxDecoration(
        color: AppTheme.background,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 12,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Row(
        children: [
          // Text input for entering new goal items (textInput)
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: AppTheme.cardBackground,
                borderRadius: BorderRadius.circular(AppTheme.inputRadius),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: TextField(
                controller: _controller,
                focusNode: _focusNode,
                // Bound to State 1: inputTextState — updates on every character change
                onChanged: (value) => notifier.updateInputText(value),
                onSubmitted: (_) => _handleAddTodo(),
                style: AppTheme.todoTextStyle.copyWith(fontSize: 14),
                textInputAction: TextInputAction.done,
                decoration: InputDecoration(
                  hintText: 'Add a new todo item',
                  hintStyle: AppTheme.hintTextStyle,
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          // + Button — triggers _handleAddTodo() to add items to goalListState
          GestureDetector(
            onTap: _handleAddTodo,
            child: Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: AppTheme.accent,
                borderRadius: BorderRadius.circular(AppTheme.buttonRadius),
                boxShadow: [
                  BoxShadow(
                    color: AppTheme.accent.withValues(alpha: 0.4),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: const Icon(
                Icons.add,
                color: Colors.white,
                size: 28,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
