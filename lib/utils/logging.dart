import 'package:logger/logger.dart';

class Logging {
  static final Logger log = Logger(
      printer: PrettyPrinter(
        methodCount: 2,
        errorMethodCount: 8,
        lineLength: 120,
        colors: true,
        printEmojis: true,
      ),
      output: ConsoleOutput());
}
