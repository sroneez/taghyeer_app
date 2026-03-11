import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/user.dart';
import '../repositories/auth_repository.dart';

class LoginParams {
  final String username;
  final String password;
  LoginParams({required this.username, required this.password});
}

class LoginUseCase implements UseCase<User, LoginParams> {
  final AuthRepository repository;
  LoginUseCase(this.repository);

  @override
  Future<Either<Failure, User>> call(LoginParams params) async {
    return await repository.login(params.username, params.password);
  }
}

class GetCachedUserUseCase implements UseCase<User, NoParams> {
  final AuthRepository repository;
  GetCachedUserUseCase(this.repository);

  @override
  Future<Either<Failure, User>> call(NoParams params) async {
    return await repository.getCachedUser();
  }
}

class LogoutUseCase implements UseCase<void, NoParams> {
  final AuthRepository repository;
  LogoutUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(NoParams params) async {
    return await repository.logout();
  }
}