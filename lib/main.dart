import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'core/storage/hive_service.dart';
import 'core/storage/prefs_helper.dart';
import 'core/theme/theme_cubit.dart';
import 'features/dashboard/presentation/pages/main_dashboard_page.dart';
import 'injection_container.dart' as di;

import 'features/auth/presentation/bloc/auth_bloc.dart';
import 'features/auth/presentation/bloc/auth_event.dart';
import 'features/auth/presentation/bloc/auth_state.dart';
import 'features/auth/presentation/pages/login_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await PrefsHelper.init();
  await HiveService.init();

  await di.init();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(
          create: (_) => di.sl<AuthBloc>()..add(CheckAuthStatusEvent()),
        ),
        BlocProvider<ThemeCubit>(
          create: (_) => ThemeCubit(),
        ),
      ],
      child: BlocBuilder<ThemeCubit, ThemeData>(
        builder: (context, currentTheme) {
          return MaterialApp(
            title: 'Taghyeer Tech App',
            theme: currentTheme,
            debugShowCheckedModeBanner: false,
            home: BlocBuilder<AuthBloc, AuthState>(
              buildWhen: (previous, current) {
                return current is AuthInitial ||
                    current is AuthAuthenticated ||
                    current is AuthUnauthenticated;
              },
              builder: (context, authState) {
                if (authState is AuthInitial) {
                  //ci cd added
                  return const Scaffold(
                    body: Center(child: CircularProgressIndicator()),
                  );
                } else if (authState is AuthAuthenticated) {
                  return const MainDashboardPage();
                } else {
                  return const LoginPage();
                }
              },
            ),
          );
        },
      ),
    );
  }
}
