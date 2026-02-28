import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../app_theme.dart';
import '../providers/todo_provider.dart';
import '../widgets/search_bar_widget.dart';
import '../widgets/todo_tile.dart';
import '../widgets/add_todo_bar.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final todoState = ref.watch(todoProvider);
    final filteredTodos = todoState.filteredTodos;
    final isSearching = todoState.searchQuery.trim().isNotEmpty;
    final isEmpty = todoState.goalListState.isEmpty;
    final noResults = isSearching && filteredTodos.isEmpty;

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: AppTheme.background,
        // Custom AppBar
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: const Padding(
            padding: EdgeInsets.only(left: 8),
            child: Icon(Icons.menu, color: AppTheme.textPrimary, size: 28),
          ),
          actions: const [
            Padding(
              padding: EdgeInsets.only(right: 16),
              child: CircleAvatar(
                radius: 18,
                backgroundColor: Color(0xFFDDDDEE),
                child: Icon(Icons.person, color: AppTheme.iconGrey, size: 22),
              ),
            ),
          ],
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Search Bar
            const SearchBarWidget(),
            const SizedBox(height: 20),
            // Section title — "All ToDos"
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text('All ToDos', style: AppTheme.titleStyle),
            ),
            const SizedBox(height: 12),
            // Todo List — ListView.builder (FlatList equivalent)
            Expanded(
              child: isEmpty
                  ? _buildEmptyState()
                  : noResults
                      ? _buildNoResults()
                      : _buildTodoList(filteredTodos),
            ),
          ],
        ),
        // Bottom input bar — pinned to bottom
        bottomNavigationBar: Consumer(
          builder: (context, ref, _) {
            // Listen to goalListState changes to scroll to bottom when item added
            ref.listen<TodoState>(todoProvider, (previous, next) {
              if ((previous?.goalListState.length ?? 0) <
                  next.goalListState.length) {
                _scrollToBottom();
              }
            });
            return const AddTodoBar();
          },
        ),
      ),
    );
  }

  Widget _buildTodoList(List filteredTodos) {
    return ListView.builder(
      controller: _scrollController,
      key: _listKey,
      padding: const EdgeInsets.only(bottom: 8),
      itemCount: filteredTodos.length,
      itemBuilder: (context, index) {
        final todo = filteredTodos[index];
        return AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          child: _AnimatedTodoTile(
            key: ValueKey(todo.id),
            todo: todo,
          ),
        );
      },
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.check_circle_outline,
            size: 72,
            color: AppTheme.textMuted.withValues(alpha: 0.4),
          ),
          const SizedBox(height: 16),
          Text(
            'No todos yet.\nAdd one below!',
            textAlign: TextAlign.center,
            style: AppTheme.emptyStateTextStyle,
          ),
        ],
      ),
    );
  }

  Widget _buildNoResults() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search_off,
            size: 72,
            color: AppTheme.textMuted.withValues(alpha: 0.4),
          ),
          const SizedBox(height: 16),
          Text(
            'No results found',
            style: AppTheme.emptyStateTextStyle,
          ),
        ],
      ),
    );
  }
}

// Animated wrapper for smooth appear/disappear
class _AnimatedTodoTile extends StatefulWidget {
  final dynamic todo;

  const _AnimatedTodoTile({super.key, required this.todo});

  @override
  State<_AnimatedTodoTile> createState() => _AnimatedTodoTileState();
}

class _AnimatedTodoTileState extends State<_AnimatedTodoTile>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    );
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TodoTile(todo: widget.todo, animation: _animation);
  }
}
