import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/post.dart';

abstract class PostRepository {
  Future<Either<Failure, List<Post>>> getPosts({required int skip, required int limit});
}