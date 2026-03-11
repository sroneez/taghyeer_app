import 'package:equatable/equatable.dart';

import '../../domain/entities/post.dart';

enum PostsStatus { initial, loading, success, failure }

class PostsState extends Equatable {
  final PostsStatus status;
  final List<Post> posts;
  final bool hasReachedMax;
  final String errorMessage;
  final int skip;

  const PostsState({
    this.status = PostsStatus.initial,
    this.posts = const <Post>[],
    this.hasReachedMax = false,
    this.errorMessage = '',
    this.skip = 0,
  });

  PostsState copyWith({
    PostsStatus? status, List<Post>? posts, bool? hasReachedMax, String? errorMessage, int? skip,
  }) {
    return PostsState(
      status: status ?? this.status, posts: posts ?? this.posts,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      errorMessage: errorMessage ?? this.errorMessage, skip: skip ?? this.skip,
    );
  }
  @override
  List<Object> get props => [status, posts, hasReachedMax, errorMessage, skip];
}