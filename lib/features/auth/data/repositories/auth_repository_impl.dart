import 'package:dartz/dartz.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_local_datasource.dart';
import '../../../../core/storage/prefs_helper.dart';
import '../../../../core/utils/constants.dart';
import '../datasources/auth_remote_datasource.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final AuthLocalDataSource localDataSource;

  AuthRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<Either<Failure, User>> login(String username, String password) async {
    try {
      final userModel = await remoteDataSource.login(username, password);

      await localDataSource.cacheUser(userModel);

      await PrefsHelper.setString(AppConstants.bearerToken, userModel.token);

      return Right(userModel);
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, User>> getCachedUser() async {
    try {
      final localUser = await localDataSource.getCachedUser();
      return Right(localUser);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, void>> logout() async {
    try {
      await localDataSource.clearCache();
      await PrefsHelper.remove(AppConstants.bearerToken);
      return const Right(null);
    } catch (e) {
      return Left(CacheFailure('Failed to clear session'));
    }
  }
}