import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/usecases/usecase.dart';
import '../../domain/usecases/auth_usecases.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final LoginUseCase loginUseCase;
  final GetCachedUserUseCase getCachedUserUseCase;
  final LogoutUseCase logoutUseCase;

  AuthBloc({
    required this.loginUseCase,
    required this.getCachedUserUseCase,
    required this.logoutUseCase,
  }) : super(AuthInitial()) {

    on<CheckAuthStatusEvent>((event, emit) async {
      final result = await getCachedUserUseCase(NoParams());
      result.fold(
            (failure) => emit(AuthUnauthenticated()),
            (user) => emit(AuthAuthenticated(user)),
      );
    });

    on<LoginEvent>((event, emit) async {
      emit(AuthLoading());
      final result = await loginUseCase(
        LoginParams(username: event.username, password: event.password),
      );
      result.fold(
            (failure) => emit(AuthError(failure.message)),
            (user) => emit(AuthAuthenticated(user)),
      );
    });

    on<LogoutEvent>((event, emit) async {
      emit(AuthLoading());
      await logoutUseCase(NoParams());
      emit(AuthUnauthenticated());
    });
  }
}