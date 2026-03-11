import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';

/// A customized logger that prints the class name alongside the message.
/// Usage: final log = logger(MyClass);
Logger logger(Type type) {
  return Logger(
    level: kReleaseMode ? Level.off : Level.trace,
    printer: CustomPrinter(className: type.toString()),
  );
}

/// Custom printer to format the logs beautifully in the console
class CustomPrinter extends LogPrinter {
  final String className;
  final PrettyPrinter _prettyPrinter;

  CustomPrinter({required this.className})
      : _prettyPrinter = PrettyPrinter(
    methodCount: 0,
    errorMethodCount: 5,
    lineLength: 80,
    colors: true,
    printEmojis: true,
    dateTimeFormat: DateTimeFormat.none,
  );

  @override
  List<String> log(LogEvent event) {
    final messageWithPrefix = '[$className] ${event.message}';

    final modifiedEvent = LogEvent(
      event.level,
      messageWithPrefix,
      error: event.error,
      stackTrace: event.stackTrace,
    );

    return _prettyPrinter.log(modifiedEvent);
  }
}