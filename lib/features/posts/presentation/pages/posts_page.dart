import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/post_bloc.dart';
import '../bloc/post_event.dart';
import '../bloc/post_state.dart';

class PostsPage extends StatefulWidget {
  const PostsPage({super.key});

  @override
  State<PostsPage> createState() => _PostsPageState();
}

class _PostsPageState extends State<PostsPage> {
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    context.read<PostsBloc>().add(FetchPosts());
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_isBottom) context.read<PostsBloc>().add(FetchPosts());
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    return _scrollController.offset >= (_scrollController.position.maxScrollExtent * 0.9);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Posts')),
      body: BlocBuilder<PostsBloc, PostsState>(
        builder: (context, state) {
          if (state.status == PostsStatus.initial || (state.status == PostsStatus.loading && state.posts.isEmpty)) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state.status == PostsStatus.failure && state.posts.isEmpty) {
            return Center(child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(state.errorMessage),
                ElevatedButton(onPressed: () => context.read<PostsBloc>().add(FetchPosts()), child: const Text('Retry'))
              ],
            ));
          }
          if (state.status == PostsStatus.success && state.posts.isEmpty) {
            return const Center(child: Text('No posts available.'));
          }

          return ListView.separated(
            controller: _scrollController,
            itemCount: state.hasReachedMax ? state.posts.length : state.posts.length + 1,
            separatorBuilder: (_, _) => const Divider(),
            itemBuilder: (context, index) {
              if (index >= state.posts.length) {
                return const Padding(padding: EdgeInsets.all(24.0), child: Center(child: CircularProgressIndicator()));
              }
              final post = state.posts[index];
              return ListTile(
                title: Text(post.title, style: const TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Text(post.body, maxLines: 2, overflow: TextOverflow.ellipsis),
                onTap: () {
                },
              );
            },
          );
        },
      ),
    );
  }
}