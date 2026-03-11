import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:taghyeer_app/features/posts/presentation/bloc/post_event.dart';
import 'package:taghyeer_app/features/posts/presentation/bloc/post_state.dart';
import '../../domain/usecases/get_post_usecase.dart';

class PostsBloc extends Bloc<PostsEvent, PostsState> {
  final GetPostsUseCase getPostsUseCase;
  static const int _limit = 10;

  PostsBloc({required this.getPostsUseCase}) : super(const PostsState()) {
    on<FetchPosts>((event, emit) async {
      if (state.hasReachedMax) return;

      try {
        if (state.status == PostsStatus.initial) {
          emit(state.copyWith(status: PostsStatus.loading));
          final result = await getPostsUseCase(
            GetPostsParams(skip: 0, limit: _limit),
          );
          result.fold(
            (failure) => emit(
              state.copyWith(
                status: PostsStatus.failure,
                errorMessage: failure.message,
              ),
            ),
            (posts) => emit(
              state.copyWith(
                status: PostsStatus.success,
                posts: posts,
                hasReachedMax: posts.length < _limit,
                skip: _limit,
              ),
            ),
          );
          return;
        }

        final result = await getPostsUseCase(
          GetPostsParams(skip: state.skip, limit: _limit),
        );
        result.fold(
          (failure) => emit(
            state.copyWith(
              status: PostsStatus.failure,
              errorMessage: failure.message,
            ),
          ),
          (posts) => emit(
            posts.isEmpty
                ? state.copyWith(hasReachedMax: true)
                : state.copyWith(
                    status: PostsStatus.success,
                    posts: List.of(state.posts)..addAll(posts),
                    hasReachedMax: posts.length < _limit,
                    skip: state.skip + _limit,
                  ),
          ),
        );
      } catch (_) {
        emit(
          state.copyWith(
            status: PostsStatus.failure,
            errorMessage: 'An unexpected error occurred.',
          ),
        );
      }
    });
  }
}
