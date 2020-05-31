import 'package:get_it/get_it.dart';

import 'NavigationService.dart';

final locator = GetIt.I;
void setupLocator() {
  locator.registerLazySingleton(() => NavigationService());
}
