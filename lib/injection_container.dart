import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;

import 'core/network/api_client.dart';
import 'features/auth/data/datasources/auth_local_datasource.dart';
import 'features/auth/data/datasources/auth_remote_datasource.dart';
import 'features/auth/data/repositories/auth_repository_impl.dart';
import 'features/auth/domain/repositories/auth_repository.dart';
import 'features/auth/domain/usecases/auth_usecases.dart';
import 'features/auth/presentation/bloc/auth_bloc.dart';
import 'features/posts/data/datasources/post_remote_data_source.dart';
import 'features/posts/data/repositories/post_repository_impl.dart';
import 'features/posts/domain/repositories/post_repository.dart';
import 'features/posts/domain/usecases/get_post_usecase.dart';
import 'features/posts/presentation/bloc/post_bloc.dart';
import 'features/products/data/datasources/product_remote_data_source.dart';
import 'features/products/data/respsitories/product_repository_impl.dart';
import 'features/products/domain/repositories/product_repository.dart';
import 'features/products/domain/usecases/get_product_usecases.dart';
import 'features/products/presentation/bloc/products_bloc.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // ===========================================================================
  // FEATURES
  // ===========================================================================

  // --- Auth Feature ---
  // Bloc
  sl.registerFactory(
    () => AuthBloc(
      loginUseCase: sl(),
      getCachedUserUseCase: sl(),
      logoutUseCase: sl(),
    ),
  );

  // Use Cases
  sl.registerLazySingleton(() => LoginUseCase(sl()));
  sl.registerLazySingleton(() => GetCachedUserUseCase(sl()));
  sl.registerLazySingleton(() => LogoutUseCase(sl()));

  // Repository
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(remoteDataSource: sl(), localDataSource: sl()),
  );

  // Data Sources
  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(apiClient: sl()),
  );
  sl.registerLazySingleton<AuthLocalDataSource>(
    () => AuthLocalDataSourceImpl(),
  );

  // --- Products Feature ---
  sl.registerFactory(() => ProductsBloc(getProductsUseCase: sl()));
  sl.registerLazySingleton(() => GetProductsUseCase(sl()));
  sl.registerLazySingleton<ProductRepository>(
    () => ProductRepositoryImpl(remoteDataSource: sl()),
  );
  sl.registerLazySingleton<ProductRemoteDataSource>(
    () => ProductRemoteDataSourceImpl(apiClient: sl()),
  );

  // --- Posts Feature ---
  sl.registerFactory(() => PostsBloc(getPostsUseCase: sl()));
  sl.registerLazySingleton(() => GetPostsUseCase(sl()));
  sl.registerLazySingleton<PostRepository>(() => PostRepositoryImpl(remoteDataSource: sl()));
  sl.registerLazySingleton<PostRemoteDataSource>(() => PostRemoteDataSourceImpl(apiClient: sl()));

  // --- Settings / Theme Feature ---

  // ===========================================================================
  // CORE
  // ===========================================================================

  sl.registerLazySingleton<ApiClient>(() => ApiClient(client: sl()));



  // ===========================================================================
  // EXTERNAL
  // ===========================================================================

  // Register the standard HTTP client
  sl.registerLazySingleton(() => http.Client());
}
