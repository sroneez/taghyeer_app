
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;

import 'core/network/api_client.dart';


// Create a global instance of GetIt. 'sl' stands for Service Locator.
final sl = GetIt.instance;

Future<void> init() async {
  // ===========================================================================
  // FEATURES
  // ===========================================================================

  // --- Auth Feature ---
  // We will add AuthBloc, AuthUseCase, AuthRepository, and AuthDataSource here next!

  // --- Products Feature ---

  // --- Posts Feature ---

  // --- Settings / Theme Feature ---


  // ===========================================================================
  // CORE
  // ===========================================================================

  // Register ApiClient as a lazy singleton so only one instance is ever created
  sl.registerLazySingleton<ApiClient>(
        () => ApiClient(client: sl()),
  );

  // Note: PrefsHelper and HiveService are accessed via static methods
  // and initialized in main.dart, so they don't need to be registered here.

  // ===========================================================================
  // EXTERNAL
  // ===========================================================================

  // Register the standard HTTP client
  sl.registerLazySingleton(() => http.Client());
}