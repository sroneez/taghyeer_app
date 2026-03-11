import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/post.dart';
import '../repositories/post_repository.dart';

class GetPostsParams {
  final int skip;
  final int limit;
  GetPostsParams({required this.skip, required this.limit});
}

class GetPostsUseCase implements UseCase<List<Post>, GetPostsParams> {
  final PostRepository repository;
  GetPostsUseCase(this.repository);

  @override
  Future<Either<Failure, List<Post>>> call(GetPostsParams params) async {
    return await repository.getPosts(skip: params.skip, limit: params.limit);
  }
}